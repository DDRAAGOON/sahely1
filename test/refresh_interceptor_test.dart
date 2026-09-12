import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sahely/core/auth/auth_token_keys.dart';
import 'package:sahely/core/network/dio_interceptors.dart';
import 'package:sahely/core/network/interceptors/refresh_interceptor.dart';
import 'package:sahely/core/network/public_endpoints.dart';

/// A scripted backend: per path, a queue of (status, body) replies. Records
/// every request so tests can count calls and inspect headers.
class _FakeBackend implements HttpClientAdapter {
  final Map<String, List<(int, Map<String, dynamic>)>> replies;
  final List<RequestOptions> requests = [];

  _FakeBackend(this.replies);

  int calls(String path) => requests.where((r) => r.path == path).length;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final queue = replies[options.path];
    if (queue == null || queue.isEmpty) {
      throw StateError('Unexpected request ${options.path}');
    }
    // The last reply repeats forever, like a server that keeps refusing.
    final (status, body) = queue.length > 1 ? queue.removeAt(0) : queue.first;
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> _error(String code, String message) => {
      'success': false,
      'error': {'code': code, 'message': message},
    };

const _tokens = {
  'success': true,
  'data': {'access_token': 'fresh-access', 'refresh_token': 'fresh-refresh'},
};

(Dio, _FakeBackend) _client(Map<String, List<(int, Map<String, dynamic>)>> r) {
  final backend = _FakeBackend(r);
  const storage = FlutterSecureStorage();
  final dio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
    ..httpClientAdapter = backend;
  final refreshDio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
    ..httpClientAdapter = backend;
  dio.interceptors.addAll([
    AuthInterceptor(storage: storage),
    AutoRefreshInterceptor(dio: dio, storage: storage, refreshDio: refreshDio),
  ]);
  return (dio, backend);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      AuthTokenKeys.accessToken: 'stale-access',
      AuthTokenKeys.refreshToken: 'stored-refresh',
    });
  });

  test('a failed login is reported once - no refresh, no retry loop', () async {
    final (dio, backend) = _client({
      '/auth/login': [(401, _error('ERR_UNAUTHORIZED', 'Invalid credentials'))],
      '/auth/refresh': [(200, _tokens)],
    });

    await expectLater(
      dio.post('/auth/login', data: {'email': 'a@b.c', 'password': 'x'}),
      throwsA(isA<DioException>()
          .having((e) => e.response?.statusCode, 'status', 401)),
    );

    expect(backend.calls('/auth/login'), 1);
    expect(backend.calls('/auth/refresh'), 0);
  });

  test('login goes out without a stale Authorization header', () async {
    final (dio, backend) = _client({
      '/auth/login': [(201, {'success': true, 'data': <String, dynamic>{}})],
    });

    await dio.post('/auth/login', data: const <String, dynamic>{});

    expect(backend.requests.single.headers.containsKey('Authorization'), false);
  });

  test('a protected 401 refreshes once and retries with the new token',
      () async {
    final (dio, backend) = _client({
      '/users/me': [
        (401, _error('TOKEN_MALFORMED', 'Access token is malformed')),
        (200, {'success': true, 'data': {'id': 'u1'}}),
      ],
      '/auth/refresh': [(200, _tokens)],
    });

    final response = await dio.get('/users/me');

    expect(response.data['data']['id'], 'u1');
    expect(backend.calls('/auth/refresh'), 1);
    expect(backend.calls('/users/me'), 2);
    expect(
      backend.requests.last.headers['Authorization'],
      'Bearer fresh-access',
    );
  });

  test('a request that still 401s after one refresh stops - no loop',
      () async {
    final (dio, backend) = _client({
      '/users/me': [(401, _error('TOKEN_MALFORMED', 'still rejected'))],
      '/auth/refresh': [(200, _tokens)],
    });

    await expectLater(dio.get('/users/me'), throwsA(isA<DioException>()));

    expect(backend.calls('/users/me'), 2, reason: 'original + one retry');
    expect(backend.calls('/auth/refresh'), 1);
  });

  test('an invalid refresh token signs the user out instead of looping',
      () async {
    final (dio, backend) = _client({
      '/users/me': [(401, _error('TOKEN_MALFORMED', 'expired'))],
      '/auth/refresh': [(401, _error('ERR_UNAUTHORIZED', 'Invalid refresh token'))],
    });

    await expectLater(
      dio.get('/users/me'),
      throwsA(isA<DioException>().having(
          (e) => e.error, 'error', isA<RefreshTokenInvalidException>())),
    );
    expect(backend.calls('/auth/refresh'), 1);
    expect(backend.calls('/users/me'), 1);
  });

  test('public endpoint list matches the paths the server leaves open', () {
    for (final p in [
      '/auth/login',
      '/auth/refresh',
      '/auth/logout',
      '/auth/register/step4/verify-phone',
      '/auth/password/reset-request',
      '/verification/start',
      'https://apisahely.staysahely.com/api/v1/auth/login',
    ]) {
      expect(PublicEndpoints.isPublic(p), true, reason: p);
    }
    for (final p in [
      '/auth/logout/all',
      '/auth/otp/send',
      '/auth/password/change',
      '/auth/verification/status',
      '/users/me',
    ]) {
      expect(PublicEndpoints.isPublic(p), false, reason: p);
    }
  });
}
