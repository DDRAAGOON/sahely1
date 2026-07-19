import 'package:flutter/material.dart';

// TODO: Integrate with backend API for real profile and loyalty data.
class ProfileProvider extends ChangeNotifier {
  String _name = 'Mariam Hassan';
  String _email = 'mariam@example.com';
  String _phone = '+20 100 123 4567';
  String _bio = 'Sun-chaser & North Coast regular. Always hunting the next great beachfront escape 🏖️';
  String? _instagram = '@mariam.h';
  String? _tiktok;
  String? _facebook;
  String? _avatarPath;

  final int _reviewsGiven = 8;
  final int _reviewsReceived = 6;
  
  // AL MAWSEM Loyalty State
  int _stars = 47;
  String _referralCode = 'MARIAM-50';
  
  final List<Map<String, dynamic>> _levelThresholds = [
    {'level': 1, 'name': 'Coastal Regular', 'stars': 0, 'icon': Icons.directions_walk, 'color': const Color(0xFF717171)},
    {'level': 2, 'name': 'Sand VIP', 'stars': 28, 'icon': Icons.explore, 'color': const Color(0xFF2D9B9B)},
    {'level': 3, 'name': 'Wave Rider', 'stars': 47, 'icon': Icons.waves, 'color': const Color(0xFF2D9B9B)},
    {'level': 4, 'name': 'Gold Elite', 'stars': 80, 'icon': Icons.anchor, 'color': const Color(0xFFBC9B43)},
    {'level': 5, 'name': 'Platinum', 'stars': 150, 'icon': Icons.diamond, 'color': const Color(0xFF6B4D8A)},
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

  /// Fetches profile and loyalty data from the API.
  Future<void> fetchProfileData() async {
    // TODO: Implement API call to fetch:
    // 1. Basic info (name, email, bio)
    // 2. Loyalty stars and tier status
    // 3. Review counts
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
