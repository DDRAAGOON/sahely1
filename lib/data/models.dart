import 'package:flutter/material.dart';

/// App-level role. Drives badge colour/label across the app.
enum Role { renter, owner, broker }

extension RoleX on Role {
  String get label => switch (this) {
        Role.renter => 'Renter',
        Role.owner => 'Property Owner',
        Role.broker => 'Broker',
      };

  String get shortLabel => switch (this) {
        Role.renter => 'Renter',
        Role.owner => 'Owner',
        Role.broker => 'Broker',
      };
}

class ServiceItem {
  const ServiceItem(this.name, this.fromPrice, this.gradient);

  final String name;
  final String fromPrice;
  final List<Color> gradient;
}
