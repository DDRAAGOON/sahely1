import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/providers/safe_notifier.dart';
import 'package:sahely/features/shared/profile/data/datasources/profile_remote_datasource.dart';

/// Single source of truth for the signed-in user's profile & loyalty state.
/// Values start empty and are populated from the backend
/// (GET /users/me · GET /mawsem/me · GET /reviews?userId=).
class ProfileProvider extends ChangeNotifier with SafeNotifier {
  final ApiClient _api = ApiClient();
  bool _loaded = false;
  bool _loading = false;

  String _id = '';
  String _name = '';
  String _email = '';
  String _phone = '';
  String _bio = '';
  String? _instagram;
  String? _tiktok;
  String? _facebook;
  String? _avatarPath;

  int _reviewsGiven = 0;
  int _reviewsReceived = 0;

  // AL MAWSEM loyalty state (live from GET /mawsem/me)
  int _stars = 0;

  String _referralCode = '';

  /// Identity check state from `/users/me` (`kycStatus`).
  bool _identityVerified = false;

  /// This season's levels (`GET /mawsem/levels`), in order. Names and
  /// thresholds belong to the season, so they are never hard-coded here; the
  /// icon and colour are the app's own, matched by position.
  List<Map<String, dynamic>> _levels = const [];

  /// The perks the account has right now (`GET /mawsem/perks`). The endpoint
  /// only answers for the account's own level, so no other level can show
  /// its perks.
  List<String> _perks = const [];

  /// The running season (`GET /mawsem/season/current`), when there is one.
  String _seasonName = '';
  DateTime? _seasonEndsAt;

  /// The level the backend puts the account at (`GET /mawsem/me`).
  int _level = 1;
  int _nextThreshold = 0;
  int _starsToNext = 0;

  static const _levelIcons = [
    Icons.directions_walk,
    Icons.explore,
    Icons.waves,
    Icons.anchor,
    Icons.workspace_premium,
    Icons.diamond,
    Icons.emoji_events,
  ];

  static const _levelColors = [
    Color(0xFF717171),
    Color(0xFF2D9B9B),
    Color(0xFF2D9B9B),
    Color(0xFFBC9B43),
    Color(0xFFBC9B43),
    Color(0xFF6B4D8A),
    Color(0xFF6B4D8A),
  ];

  /// The signed-in user's id (`/users/me`).
  String get id => _id;

  String get name => _name;

  String get email => _email;

  String get phone => _phone;

  String get bio => _bio;

  String? get instagram => _instagram;

  String? get tiktok => _tiktok;

  String? get facebook => _facebook;

  String? get avatarPath => _avatarPath;

  int get reviewsGiven => _reviewsGiven;

  int get reviewsReceived => _reviewsReceived;

  int get stars => _stars;

  String get referralCode => _referralCode;

  /// True once the account has passed the identity check.
  bool get identityVerified => _identityVerified;

  /// Every level of the season, for the levels list.
  List<Map<String, dynamic>> get levels => _levels;

  /// What the account's current level unlocks.
  List<String> get perks => _perks;

  String get seasonName => _seasonName;
  DateTime? get seasonEndsAt => _seasonEndsAt;

  /// Days left in the season, or null when no season is running.
  int? get seasonDaysLeft {
    final ends = _seasonEndsAt;
    if (ends == null) return null;
    final days = ends.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  int get currentLevel => _level;

  /// Stars still needed for the next level (`GET /mawsem/me`).
  int get starsToNext => _starsToNext;

  /// The star count the next level starts at.
  int get nextThreshold => _nextThreshold;

  /// The account's level. Blank until `/mawsem/levels` has answered, so a
  /// screen shows nothing rather than a level the account is not on.
  Map<String, dynamic> get levelData =>
      _levels.firstWhere((l) => l['level'] == _level, orElse: _unknownLevel);

  Map<String, dynamic>? get nextLevelData {
    for (final level in _levels) {
      if (level['level'] == _level + 1) return level;
    }
    return null;
  }

  Map<String, dynamic> _unknownLevel() => {
        'level': _level,
        'name': '',
        'stars': 0,
        'icon': _levelIcons.first,
        'color': _levelColors.first,
      };

  bool get isLoaded => _loaded;
  bool get isLoading => _loading;

  /// Pulls the real profile, loyalty stars and review counters.
  /// Safe to call multiple times — silently no-ops when the call fails so a
  /// flaky network never blanks an already-rendered screen.
  Future<void> fetchProfileData({bool force = false}) async {
    if (_loading) return;
    if (_loaded && !force) return;
    _loading = true;
    notifyListeners();

    try {
      // 1) Identity — GET /users/me
      final meRes = await _api.get(ApiEndpoints.me);
      final me = asMap(unwrapData(meRes.data));
      _id = '${pick(me, 'id') ?? ''}';
      _name = [
        pick(me, 'first_name'),
        pick(me, 'last_name'),
      ].where((e) => e != null).join(' ').trim();
      _email = '${pick(me, 'email') ?? ''}';
      _phone = '${pick(me, 'phone') ?? ''}';
      _bio = '${pick(me, 'about_you') ?? ''}';
      _instagram = _handle(pick(me, 'instagram_url'));
      _tiktok = _handle(pick(me, 'tiktok_url'));
      _facebook = pick(me, 'facebook_url') as String?;
      _avatarPath = pick(me, 'avatar_url') as String?;
      _referralCode = '${pick(me, 'referral_code') ?? ''}';
      _identityVerified =
          '${pick(me, 'kyc_status') ?? ''}'.toUpperCase() == 'APPROVED';

      // 2) Loyalty — GET /mawsem/levels is the season's ladder,
      //    GET /mawsem/me is where this account stands on it.
      try {
        final lRes = await _api.get(ApiEndpoints.mawsemLevels);
        final rows = asListOfMaps(unwrapData(lRes.data));
        _levels = [
          for (var i = 0; i < rows.length; i++)
            {
              'level': asNum(rows[i]['level'])?.toInt() ?? i + 1,
              'name': '${rows[i]['name'] ?? ''}',
              'stars': asNum(pick(rows[i], 'threshold'))?.toInt() ??
                  asNum(pick(rows[i], 'required_stars'))?.toInt() ??
                  0,
              'icon': _levelIcons[i % _levelIcons.length],
              'color': _levelColors[i % _levelColors.length],
            },
        ];
      } catch (_) {}

      try {
        final mRes = await _api.get(ApiEndpoints.mawsemMe);
        final m = asMap(unwrapData(mRes.data));
        _stars = asNum(m['stars'])?.toInt() ?? 0;
        _level = asNum(m['level'])?.toInt() ?? _levelForStars();
        _nextThreshold = asNum(pick(m, 'next_threshold'))?.toInt() ?? 0;
        _starsToNext = asNum(pick(m, 'stars_to_next'))?.toInt() ??
            (_nextThreshold - _stars).clamp(0, 1 << 30);
      } catch (_) {}

      try {
        final pRes = await _api.get(ApiEndpoints.mawsemPerks);
        _perks = asStringList(asMap(unwrapData(pRes.data))['perks']);
      } catch (_) {}

      try {
        final sRes = await _api.get(ApiEndpoints.mawsemCurrentSeason);
        final season = asMap(unwrapData(sRes.data));
        _seasonName = '${season['name'] ?? ''}';
        _seasonEndsAt =
            asDate(pick(season, 'ends_at')) ?? asDate(pick(season, 'end_date'));
      } catch (_) {}

      // 3) Reviews — GET /reviews?userId=: those I wrote and those written
      //    about me. The query takes the real id; the literal "me" fails.
      if (_id.isNotEmpty) {
        try {
          final rRes = await _api.get(ApiEndpoints.reviews,
              queryParameters: {'userId': _id, 'page': 1, 'limit': 100});
          final rows = asListOfMaps(unwrapData(rRes.data));
          _reviewsGiven = rows
              .where((r) => '${pick(r, 'reviewer_id') ?? ''}' == _id)
              .length;
          _reviewsReceived = rows.length - _reviewsGiven;
        } catch (_) {}
      }

      _loaded = true;
    } catch (_) {
      // keep whatever we already had; screens show fallback text
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// `https://instagram.com/layla` -> `@layla`; null when there is no
  /// account linked, so an empty handle never shows as a lone "@".
  static String? _handle(dynamic url) {
    if (url == null) return null;
    final name = '$url'.split('/').where((p) => p.isNotEmpty).lastOrNull ?? '';
    if (name.isEmpty || name.contains('.')) return null;
    return name.startsWith('@') ? name : '@$name';
  }

  /// Saves the profile to the backend (`PUT /users/me`), uploading a newly
  /// picked photo first. Returns false when the server refused it, so the
  /// screen can say so instead of pretending it saved.
  Future<bool> saveProfile({
    String? bio,
    String? instagram,
    String? tiktok,
    String? facebook,
    String? avatarLocalPath,
  }) async {
    try {
      if (avatarLocalPath != null && !avatarLocalPath.startsWith('http')) {
        await sl<ProfileRemoteDataSource>().uploadProfileImage(avatarLocalPath);
      }
      await _api.put(ApiEndpoints.me, data: {
        if (bio != null) 'about_you': bio,
        if (instagram != null)
          'instagram_url': _profileUrl('instagram.com', instagram),
        if (tiktok != null) 'tiktok_url': _profileUrl('tiktok.com', tiktok),
        if (facebook != null)
          'facebook_url': _profileUrl('facebook.com', facebook),
      });
      updateProfile(
        bio: bio,
        instagram: instagram,
        tiktok: tiktok,
        facebook: facebook,
        avatarPath: avatarLocalPath,
      );
      await fetchProfileData(force: true);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// `@layla` -> `https://instagram.com/layla`; an empty handle clears it.
  static String _profileUrl(String host, String handle) {
    final name = handle.trim().replaceAll('@', '');
    return name.isEmpty ? '' : 'https://$host/$name';
  }

  /// Which level the star count falls in, if the backend did not say.
  int _levelForStars() {
    var level = 1;
    for (final entry in _levels) {
      if (_stars >= (entry['stars'] as int)) level = entry['level'] as int;
    }
    return level;
  }

  /// Clears everything on logout.
  void reset() {
    _id = '';
    _name = '';
    _email = '';
    _phone = '';
    _bio = '';
    _instagram = null;
    _tiktok = null;
    _facebook = null;
    _avatarPath = null;
    _stars = 0;
    _level = 1;
    _nextThreshold = 0;
    _starsToNext = 0;
    _levels = const [];
    _perks = const [];
    _seasonName = '';
    _seasonEndsAt = null;
    _reviewsGiven = 0;
    _reviewsReceived = 0;
    _referralCode = '';
    _identityVerified = false;
    _loaded = false;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? instagram,
    String? tiktok,
    String? facebook,
    String? avatarPath,
  }) {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (phone != null) _phone = phone;
    if (bio != null) _bio = bio;
    _instagram = instagram;
    _tiktok = tiktok;
    _facebook = facebook;
    if (avatarPath != null) _avatarPath = avatarPath;

    notifyListeners();
  }

  int? addStars(int amount) {
    int oldLevel = currentLevel;
    _stars += amount;
    notifyListeners();

    int newLevel = currentLevel;
    if (newLevel > oldLevel) {
      return newLevel;
    }
    return null;
  }
}
