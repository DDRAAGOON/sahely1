import 'package:flutter/material.dart';

import 'package:sahely/core/network/api_client.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/core/network/api_endpoints.dart';

/// Single source of truth for the signed-in user's profile & loyalty state.
/// Values start empty and are populated from the backend
/// (GET /users/me · GET /mawsem/me · GET /reviews?user_id=).
class ProfileProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  bool _loaded = false;
  bool _loading = false;

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

  final List<Map<String, dynamic>> _levelThresholds = [
    {
      'level': 1,
      'name': 'Coastal Regular',
      'stars': 0,
      'icon': Icons.directions_walk,
      'color': const Color(0xFF717171)
    },
    {
      'level': 2,
      'name': 'Sand VIP',
      'stars': 28,
      'icon': Icons.explore,
      'color': const Color(0xFF2D9B9B)
    },
    {
      'level': 3,
      'name': 'Wave Rider',
      'stars': 47,
      'icon': Icons.waves,
      'color': const Color(0xFF2D9B9B)
    },
    {
      'level': 4,
      'name': 'Gold Elite',
      'stars': 80,
      'icon': Icons.anchor,
      'color': const Color(0xFFBC9B43)
    },
    {
      'level': 5,
      'name': 'Platinum',
      'stars': 150,
      'icon': Icons.diamond,
      'color': const Color(0xFF6B4D8A)
    },
  ];

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

  int get currentLevel {
    for (int i = _levelThresholds.length - 1; i >= 0; i--) {
      if (_stars >= _levelThresholds[i]['stars']) {
        return _levelThresholds[i]['level'];
      }
    }
    return 1;
  }

  Map<String, dynamic> get levelData => _levelThresholds[currentLevel - 1];

  Map<String, dynamic>? get nextLevelData {
    if (currentLevel < _levelThresholds.length) {
      return _levelThresholds[currentLevel];
    }
    return null;
  }

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
      _name = [
        me['first_name'],
        me['last_name'],
      ].where((e) => e != null).join(' ').trim();
      _email = '${me['email'] ?? ''}';
      _phone = '${me['phone'] ?? ''}';
      _bio = '${me['about_you'] ?? ''}';
      _instagram = me['instagram_url'] == null
          ? null
          : '@${me['instagram_url'].toString().split('/').last}';
      _tiktok = me['tiktok_url'] == null
          ? null
          : '@${me['tiktok_url'].toString().split('/').last}';
      _facebook = me['facebook_url'] as String?;
      _avatarPath = me['avatar_url'] as String?;
      _referralCode = '${me['referral_code'] ?? ''}';

      // 2) Loyalty — GET /mawsem/me → { level, stars, ... }
      try {
        final mRes = await _api.get('/mawsem/me');
        final m = asMap(unwrapData(mRes.data));
        _stars = m['stars'] as int? ?? 0;
      } catch (_) {}

      // 3) Reviews given — count of reviews authored by me
      try {
        final rRes = await _api.get(ApiEndpoints.reviews,
            queryParameters: {'user_id': 'me', 'page': 1});
        final rd = unwrapData(rRes.data);
        final list = rd is List ? rd : ((rd?['reviews'] ?? []) as List);
        _reviewsGiven = list.length;
      } catch (_) {}

      _loaded = true;
    } catch (_) {
      // keep whatever we already had; screens show fallback text
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Clears everything on logout.
  void reset() {
    _name = '';
    _email = '';
    _phone = '';
    _bio = '';
    _instagram = null;
    _tiktok = null;
    _facebook = null;
    _avatarPath = null;
    _stars = 0;
    _reviewsGiven = 0;
    _reviewsReceived = 0;
    _referralCode = '';
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

