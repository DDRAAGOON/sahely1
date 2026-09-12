import 'package:flutter_test/flutter_test.dart';
import 'package:sahely/core/config/app_config.dart';
import 'package:sahely/core/errors/exceptions.dart';
import 'package:sahely/core/network/api_endpoints.dart';
import 'package:sahely/core/network/api_envelope.dart';
import 'package:sahely/features/properties/data/models/property_model.dart';

/// Guards the wiring between the app and the documented mobile API.
///
/// These are pure unit tests - no network, no plugins - so they run in CI and
/// catch the classes of mistake that broke the integration before: endpoint
/// paths drifting from the docs, envelope handling reading the wrong level of
/// the payload, and admin routes sneaking into the client.
void main() {
  group('API base URL', () {
    test('targets /api/v1, which is what the server actually serves', () {
      final uri = Uri.parse(AppConfig.config.apiBaseUrl);
      // Verified live: /api/... answers 404, /api/v1/... answers 200.
      expect(uri.path, '/api/v1');
      // A trailing slash on the host used to produce '//api' and 404 every call.
      expect(uri.path, isNot(startsWith('//')));
    });
  });

  group('Endpoint registry', () {
    test('uses the singular /broker prefix the API documents', () {
      expect(ApiEndpoints.brokerDashboard, '/broker/dashboard');
      expect(ApiEndpoints.brokerCommissions, '/broker/commissions');
    });

    test('checklists are nested under their booking', () {
      // The written guide shows top-level /arrival/renter; the live server
      // 404s that and serves the nested form.
      expect(
        ApiEndpoints.arrivalRenter('b1'),
        '/bookings/b1/checklist/arrival/renter',
      );
      expect(
        ApiEndpoints.departureOwner('b1'),
        '/bookings/b1/checklist/departure/owner',
      );
      expect(
        ApiEndpoints.preListingChecklist('p1'),
        '/properties/p1/checklist/pre-listing',
      );
    });

    test('property lifecycle paths match the docs', () {
      expect(ApiEndpoints.propertyCreate, '/properties/addProperty');
      expect(ApiEndpoints.featuredProperties, '/properties/featured');
      expect(ApiEndpoints.propertySubmit('p1'), '/properties/p1/submit');
      expect(ApiEndpoints.propertyUnlist('p1'), '/properties/p1/unlist');
    });

    test('verification is split between the auth and session flows', () {
      expect(ApiEndpoints.verificationStatus, '/auth/verification/status');
      expect(ApiEndpoints.kycStart, '/verification/start');
      expect(ApiEndpoints.kycStatus('s1'), '/verification/status/s1');
    });

    test('the wallet exposes both the user and owner surfaces', () {
      expect(ApiEndpoints.wallet, '/wallet/');
      expect(ApiEndpoints.myWalletDashboard, '/wallets/me/dashboard');
    });

    test('no admin or server-only route is reachable from the app', () {
      const forbidden = [
        '/admin',
        '/admin-auth',
        '/internal/test',
        '/payments/webhook',
        '/payments/callback',
        '/locks/tuya',
        '/locks/hardware-callback',
      ];
      final paths = <String>[
        ApiEndpoints.login,
        ApiEndpoints.bookings,
        ApiEndpoints.properties,
        ApiEndpoints.paymentIntents,
        ApiEndpoints.chatConversations,
        ApiEndpoints.mawsemMe,
        ApiEndpoints.brokerDashboard,
        ApiEndpoints.wishlists,
        ApiEndpoints.notifications,
        ApiEndpoints.uploadRequestUrl,
      ];
      for (final path in paths) {
        for (final prefix in forbidden) {
          expect(
            path.startsWith(prefix),
            isFalse,
            reason: '$path must not target the admin/server-only API',
          );
        }
      }
    });
  });

  group('Response envelope', () {
    test('returns the data payload, never the envelope itself', () {
      final payload = unwrapData({
        'success': true,
        'data': {'id': '42'},
      });
      expect(asMap(payload)['id'], '42');
    });

    test('surfaces error.code and error.field on a failed envelope', () {
      expect(
        () => unwrapData({
          'success': false,
          'error': {
            'code': 'ERR_KYC_REQUIRED',
            'message': 'Verify your identity first',
            'field': 'id_front',
          },
        }),
        throwsA(
          isA<ServerException>()
              .having((e) => e.code, 'code', 'ERR_KYC_REQUIRED')
              .having((e) => e.field, 'field', 'id_front')
              .having(
                  (e) => e.message, 'message', 'Verify your identity first'),
        ),
      );
    });

    test('reads list payloads whether bare or wrapped in items/results', () {
      expect(
          asListOfMaps([
            {'id': '1'},
          ]).length,
          1);
      expect(
        asListOfMaps({
          'items': [
            {'id': '1'},
            {'id': '2'},
          ],
        }).length,
        2,
      );
      expect(asListOfMaps(null), isEmpty);
    });

    test('parses numbers the backend may send as decimal strings', () {
      expect(asNum('4000.50'), 4000.50);
      expect(asNum(12), 12);
      expect(asNum('not a number'), isNull);
    });

    test('pagination clamps limit to the documented maximum of 100', () {
      expect(pageQuery(page: 2, limit: 500)['limit'], 100);
      expect(pageQuery(page: 0)['page'], 1);
      expect(
        pageQuery(extra: {'status': null, 'type': 'card'}),
        isNot(contains('status')),
      );
    });

    test('reports whether another page is available', () {
      final meta = PaginationMeta.fromJson({
        'page': 1,
        'limit': 20,
        'total': 45,
      });
      expect(meta.totalPages, 3);
      expect(meta.hasNextPage, isTrue);
    });

    test('reads the flat pagination shape the server really returns', () {
      // Live shape: { data: [...], total, page, limit, totalPages, hasNextPage }
      final payload = {
        'data': [
          {'id': '1'},
        ],
        'total': 42,
        'page': 2,
        'limit': 20,
        'totalPages': 3,
        'hasNextPage': true,
      };
      expect(asListOfMaps(payload).length, 1);
      final meta = extractPagination(payload);
      expect(meta, isNotNull);
      expect(meta!.page, 2);
      expect(meta.totalPages, 3);
      expect(meta.hasNextPage, isTrue);
    });
  });

  group('camelCase responses', () {
    // The written spec says snake_case, but the deployed backend serialises
    // its entities camelCase. Responses must parse either way.
    test('pick() reads a field under both spellings', () {
      expect(pick({'base_price_per_night': 1}, 'base_price_per_night'), 1);
      expect(pick({'basePricePerNight': 2}, 'base_price_per_night'), 2);
      expect(pick({'bedrooms': 3}, 'bedrooms'), 3);
      expect(pick(<String, dynamic>{}, 'missing_field'), isNull);
    });

    test('parses a real /properties/featured row', () {
      // Trimmed copy of an actual live response row.
      final property = PropertyModel.fromJson({
        'id': 'aba815f7',
        'title': 'Updated Title',
        'status': 'active',
        'deletedAt': null,
        'propertyType': 'villa',
        'basePricePerNight': 375000,
        'nightlyRate': '3750.00',
        'maxGuests': 8,
        'bedrooms': 4,
        'bathrooms': 3,
        'areaSqm': '120.50',
        'city': 'Marassi',
        'governorate': 'Matrouh',
        'latitude': '30.0697820',
        'longitude': '31.2053350',
        'averageRating': '0.00',
        'totalReviews': 0,
        'createdAt': '2026-07-12T14:31:10.459Z',
      });

      expect(property.id, 'aba815f7');
      expect(property.title, 'Updated Title');
      expect(property.location, 'Matrouh');
      expect(property.propertyType, 'villa');
      // Price stays in piastres; 375000 piastres == 3750 EGP.
      expect(property.pricePerNight, 375000);
      expect(property.toEntity().priceInEgp, 3750.0);
      expect(property.capacity, 8);
      expect(property.bedrooms, 4);
      expect(property.area, 121);
      // Decimals arrive as strings and must still parse.
      expect(property.latitude, closeTo(30.069782, 0.000001));
      expect(property.longitude, closeTo(31.205335, 0.000001));
      expect(property.rating, 0.0);
      expect(property.isAvailable, isTrue);
      expect(property.createdAt.year, 2026);
    });

    test('a soft-deleted or inactive listing is not bookable', () {
      PropertyModel build(Map<String, dynamic> overrides) =>
          PropertyModel.fromJson({
            'id': '1',
            'status': 'active',
            'deletedAt': null,
            ...overrides,
          });

      expect(build({}).isAvailable, isTrue);
      expect(build({'status': 'paused'}).isAvailable, isFalse);
      expect(
        build({'deletedAt': '2026-01-01T00:00:00Z'}).isAvailable,
        isFalse,
      );
    });
  });
}
