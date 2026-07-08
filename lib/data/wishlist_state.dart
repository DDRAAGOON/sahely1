import 'package:flutter/material.dart';
import 'models.dart';
import 'sample_data.dart';

class WishlistState extends ChangeNotifier {
  static final WishlistState _instance = WishlistState._internal();
  factory WishlistState() => _instance;
  WishlistState._internal();

  final Set<String> _savedPropertyNames = {};

  bool isSaved(Property property) => _savedPropertyNames.contains(property.name);

  void toggleSave(Property property) {
    if (_savedPropertyNames.contains(property.name)) {
      _savedPropertyNames.remove(property.name);
    } else {
      _savedPropertyNames.add(property.name);
    }
    notifyListeners();
  }

  List<Property> get savedProperties {
    // Search through all known samples
    final all = [...Sample.trending, ...Sample.allTrending];
    return all.where((p) => _savedPropertyNames.contains(p.name)).toList();
  }
}
