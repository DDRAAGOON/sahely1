/// The single source of truth for the secure-storage keys that hold the
/// session tokens.
///
/// Every interceptor, repository and use case reads/writes through these
/// constants. Hard-coding the strings caused the access token written by the
/// refresh interceptor to be invisible to the auth interceptor, which left the
/// app in a permanent 401 loop after the first token expiry.
class AuthTokenKeys {
  AuthTokenKeys._();

  static const String accessToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
}
