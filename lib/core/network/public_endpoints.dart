/// Endpoints that authenticate the caller *themselves* rather than relying on
/// a session token.
///
/// Two rules follow from that, enforced by the Dio interceptors:
///  * no `Authorization` header is attached - a stale token has no business
///    on a login or registration call;
///  * a `401` from them is never treated as an expired session. It means
///    wrong credentials, a bad OTP or an invalid refresh token, and refreshing
///    then retrying produces the same `401` again - an infinite loop.
///
/// Verified against the live server: every path below answers without a
/// token (`400` validation error on an empty body, never `401`).
class PublicEndpoints {
  PublicEndpoints._();

  static const Set<String> _exact = {
    '/auth/login',
    '/auth/logout',
    '/auth/refresh',
    '/auth/google/mobile',
    '/auth/send-otp-on-phone-number',
    '/auth/verify-otp-on-phone-number',
    '/referrals/resolve',
  };

  static const List<String> _prefixes = [
    // Registration steps 1-4 run before any account exists.
    '/auth/register/',
    // Covers both /auth/password/reset and /auth/password/reset-request.
    '/auth/password/reset',
    // KYC is driven by the registration session_token, not a login token.
    '/verification/',
  ];

  /// Whether [path] (relative to the API base, or a full URL) is public.
  static bool isPublic(String path) {
    var normalised = Uri.tryParse(path)?.path ?? path;
    // Tolerate a base URL that already carries /api/v1.
    final apiIndex = normalised.indexOf('/api/v1/');
    if (apiIndex >= 0) normalised = normalised.substring(apiIndex + 7);
    if (normalised.length > 1 && normalised.endsWith('/')) {
      normalised = normalised.substring(0, normalised.length - 1);
    }

    if (_exact.contains(normalised)) return true;
    return _prefixes.any(normalised.startsWith);
  }
}
