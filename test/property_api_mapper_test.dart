import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/shared/properties/data/property_api_mapper.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

/// Pins [PropertyApiMapper] - shared by the owner, broker and renter screens -
/// to a payload captured from the live backend.
void main() {
  late List<Map<String, dynamic>> rows;

  setUpAll(() {
    final raw = File('test/fixtures/live_api/properties_featured.json')
        .readAsStringSync();
    rows = asListOfMaps(unwrapData(jsonDecode(raw)));
  });

  test('prices come out in EGP, not piastres', () {
    final row = rows.first;
    final property = PropertyApiMapper.fromJson(row);

    // The wire carries the same price twice: nightlyRate "3750.00" (EGP) and
    // basePricePerNight 375000 (piastres). Reading the piastre field as EGP
    // would show every price 100x too high.
    final egp = asNum(row['nightlyRate'])!.toDouble();
    expect(property.price, egp.round());
    expect(
      property.price,
      (asNum(row['basePricePerNight'])! / 100).round(),
    );
  });

  test('falls back to piastres / 100 when nightlyRate is absent', () {
    final property = PropertyApiMapper.fromJson({'basePricePerNight': 500000});
    expect(property.price, 5000);
  });

  test('maps the camelCase entity fields the backend actually sends', () {
    final property = PropertyApiMapper.fromJson(rows.first);
    expect(property.id, isNotEmpty);
    expect(property.name, isNotEmpty);
    expect(property.guests, greaterThan(0));
    expect(property.beds, greaterThan(0));
    expect(property.type, isNotEmpty);
  });

  test('beach distance becomes walking minutes, absent stays null', () {
    expect(
      PropertyApiMapper.fromJson({'beachDistanceMeters': 500}).minutesToBeach,
      6,
    );
    expect(PropertyApiMapper.fromJson({}).minutesToBeach, isNull);
  });

  test('backend statuses map onto the four UI states', () {
    expect(PropertyApiMapper.status('active'), PropertyStatus.active);
    expect(
      PropertyApiMapper.status('pending_review'),
      PropertyStatus.underReview,
    );
    expect(PropertyApiMapper.status('draft'), PropertyStatus.draft);
    expect(PropertyApiMapper.status('inactive'), PropertyStatus.paused);
  });
}
