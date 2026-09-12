import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/bookings/data/models/booking_model.dart';
import 'package:sahely/features/properties/data/models/property_model.dart';
import 'package:sahely/features/shared/notifications/data/notifications_api_data_source.dart';

/// Parses payloads captured from the **live** Sahely backend.
///
/// The written API guide turned out to disagree with the deployed server in
/// several places (camelCase vs snake_case, rows nested under module-specific
/// keys, piastres vs EGP). These fixtures are verbatim captures, so if the
/// backend changes shape again these tests fail instead of the app silently
/// rendering blanks and zeroes.
void main() {
  final dir = Directory('test/fixtures/live_api');

  Map<String, dynamic> load(String name) {
    final file = File('${dir.path}/$name.json');
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  setUpAll(() {
    expect(
      dir.existsSync(),
      isTrue,
      reason: 'live API fixtures are missing from ${dir.path}',
    );
  });

  group('envelope', () {
    test('finds rows nested under a module-specific key', () {
      // /broker/commissions nests under "commissions", /reviews/pending under
      // "pending", /mawsem/levels under "levels" - not the documented shape.
      expect(
        asListOfMaps({
          'commissions': [
            {'booking_id': '1'},
            {'booking_id': '2'},
          ],
        }).length,
        2,
      );
      expect(
        asListOfMaps({
          'pending': [
            {'id': '1'},
          ],
        }).length,
        1,
      );
    });

    test('refuses to guess when a payload holds several lists', () {
      // /auth/verification/status has both `steps` and
      // `complete_later_in_profile` - picking one would be a coin flip.
      expect(
        asListOfMaps({
          'steps': [
            {'step': 'email'},
          ],
          'complete_later_in_profile': ['payment_card'],
        }),
        isEmpty,
      );
    });
  });

  group('properties', () {
    test('parses a live /properties/featured row', () {
      final rows = asListOfMaps(unwrapData(load('properties_featured')));
      expect(rows, isNotEmpty);

      final property = PropertyModel.fromJson(rows.first);
      expect(property.id, isNotEmpty);
      expect(property.title, isNotEmpty);
      // Prices are piastres on the wire and must survive as piastres.
      expect(property.pricePerNight, greaterThan(0));
      expect(property.toEntity().priceInEgp, property.pricePerNight / 100);
      // Coordinates arrive as strings; a naive `as num?` cast yielded 0.
      expect(property.latitude, isNot(0.0));
      expect(property.longitude, isNot(0.0));
      expect(property.propertyType, isNotEmpty);
      expect(property.capacity, greaterThan(0));
    });
  });

  group('bookings', () {
    test('parses a live /bookings/my row', () {
      final rows = asListOfMaps(unwrapData(load('bookings_my')));
      expect(rows, isNotEmpty);

      final booking = BookingModel.fromJson(rows.first);
      expect(booking.id, isNotEmpty);
      expect(booking.propertyId, isNotEmpty);
    });

    test('every row carries the camelCase date fields the mapper needs', () {
      final rows = asListOfMaps(unwrapData(load('bookings_my')));
      for (final row in rows.take(5)) {
        expect(
          pick(row, 'check_in'),
          isNotNull,
          reason: 'booking ${row['id']} has no check-in date',
        );
        expect(pick(row, 'number_of_guests'), isNotNull);
        expect(row['reference'], isNotNull);
      }
    });
  });

  group('notifications', () {
    test('reads the camelCase preference switches', () {
      final prefs = NotificationPreferences.fromJson(
        asMap(unwrapData(load('notifications_preferences'))),
      );
      // The live payload sends emailEnabled/smsEnabled/pushEnabled, so every
      // switch must resolve to a real boolean rather than null.
      expect(prefs.emailEnabled, isNotNull);
      expect(prefs.smsEnabled, isNotNull);
      expect(prefs.pushEnabled, isNotNull);
      // The promotional toggle is named marketingEnabled on the wire.
      expect(prefs.promotional, isNotNull);
    });

    test('sends the promotional switch back under its wire name', () {
      const prefs = NotificationPreferences(promotional: false);
      expect(prefs.toJson(), containsPair('marketing_enabled', false));
      expect(prefs.toJson(), isNot(contains('promotional')));
    });
  });

  group('users', () {
    test('the profile payload is camelCase, so raw snake reads return null',
        () {
      final user = asMap(unwrapData(load('users_me')));
      // Guards the assumption every profile mapper now relies on.
      expect(user['first_name'], isNull);
      expect(user['firstName'], isNotNull);
      expect(pick(user, 'first_name'), isNotNull);
      expect(pick(user, 'about_you'), isNotNull);
      expect(pick(user, 'avatar_url'), isNotNull);
      expect(pick(user, 'referral_code'), isNotNull);
    });
  });

  group('verification status', () {
    test('reports steps, not flat booleans', () {
      final data = asMap(unwrapData(load('verification_status')));
      expect(data['email_verified'], isNull);
      expect(data['emailVerified'], isNull);

      final steps = asListOfMaps(data['steps']);
      expect(steps, isNotEmpty);
      expect(
        steps.map((s) => s['step']),
        containsAll(<String>['email', 'phone', 'identity', 'payment_card']),
      );
    });
  });

  group('broker', () {
    test('dashboard counts progress in properties, not stars', () {
      final data = asMap(unwrapData(load('broker_dashboard')));
      expect(data['stars'], isNull);
      expect(data['tier'], isNull);
      expect(data['current_tier'], isNotNull);
      expect(data['approved_properties'], isNotNull);
      expect(data['properties_to_next_tier'], isNotNull);
      expect(data['available_commission_piastres'], isNotNull);
    });

    test('commission rows use commission_piastres and check_in', () {
      final rows = asListOfMaps(unwrapData(load('broker_commissions')));
      expect(rows, isNotEmpty);
      for (final row in rows) {
        expect(row['amount_piastres'], isNull);
        expect(row['commission_piastres'], isNotNull);
        expect(row['check_in'], isNotNull);
      }
    });
  });
}
