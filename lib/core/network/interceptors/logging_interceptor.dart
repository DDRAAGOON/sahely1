import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:sahely/core/errors/api_error.dart';

/// Sahely-branded debug logging interceptor.
///
/// Active ONLY when kDebugMode == true (never in production).
/// Logs every request/response in the prescribed format and masks all
/// sensitive fields so secrets never leak to the console.
class SahelyLoggingInterceptor extends Interceptor {
  /// Fields whose values are replaced with "***masked***" in logs.
  static const _sensitiveRequestFields = {
    'password',
    'new_password',
    'old_password',
    'confirm_password',
    'otp',
    'code',
    'card_number',
    'cvv',
    'national_id',
    'pin',
  };

  /// Response fields to mask (tokens, secrets).
  static const _sensitiveResponseFields = {
    'accessToken',
    'refreshToken',
    'token',
    'secret',
  };

  // Tracks per-request start time for duration calculation.
  final _requestTimes = <String, DateTime>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(options);

    final key = _requestKey(options);
    _requestTimes[key] = DateTime.now();

    final maskedHeaders = _maskHeaders(options.headers);
    final maskedBody = options.data != null ? _maskBody(options.data) : null;

    debugPrint('\n╔══════════════════════════════════════════════════════');
    debugPrint(
        '║ [SAHELY-API] → ${options.method.toUpperCase()} ${options.path}');
    debugPrint('║   Timestamp: ${DateTime.now().toUtc().toIso8601String()}');
    debugPrint('║   Headers: $maskedHeaders');
    if (maskedBody != null) {
      debugPrint('║   Body: ${_prettyJson(maskedBody)}');
    }
    if (options.queryParameters.isNotEmpty) {
      debugPrint('║   Query: ${options.queryParameters}');
    }
    debugPrint('╚══════════════════════════════════════════════════════\n');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(response);

    final durationMs = _elapsedMs(response.requestOptions);
    final maskedBody = _maskResponseBody(response.data);

    debugPrint('\n╔══════════════════════════════════════════════════════');
    debugPrint('║ [SAHELY-API] ← ${response.statusCode} OK  (${durationMs}ms)');
    debugPrint(
        '║   ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.path}');
    debugPrint('║   Body: ${_prettyJson(maskedBody)}');
    debugPrint('╚══════════════════════════════════════════════════════\n');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!kDebugMode) return handler.next(err);

    final durationMs = _elapsedMs(err.requestOptions);
    final statusCode = err.response?.statusCode ?? 0;
    final apiError = ApiError.tryParse(err.response?.data);

    debugPrint('\n╔══════════════════════════════════════════════════════');
    debugPrint(
        '║ [SAHELY-API] ✗ $statusCode ${apiError?.code ?? err.type.name}  (${durationMs}ms)');
    debugPrint(
        '║   ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.path}');

    if (apiError != null) {
      debugPrint('║   Error Code: ${apiError.code}');
      debugPrint('║   Message: ${apiError.message}');
      if (apiError.field != null) {
        debugPrint('║   Field: ${apiError.field}');
      }
      // Log error translations in all 7 languages for developer insight
      _logErrorTranslations(apiError.code, apiError.metadata);
    } else {
      debugPrint('║   Message: ${err.message}');
    }
    debugPrint('╚══════════════════════════════════════════════════════\n');

    handler.next(err);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _requestKey(RequestOptions options) =>
      '${options.method}:${options.path}:${options.hashCode}';

  int _elapsedMs(RequestOptions options) {
    final key = _requestKey(options);
    final start = _requestTimes.remove(key);
    if (start == null) return 0;
    return DateTime.now().difference(start).inMilliseconds;
  }

  Map<String, dynamic> _maskHeaders(Map<String, dynamic> headers) {
    final masked = Map<String, dynamic>.from(headers);
    if (masked.containsKey('Authorization')) {
      final auth = masked['Authorization'] as String? ?? '';
      if (auth.length > 17) {
        // Keep "Bearer " prefix + first 10 chars of token
        masked['Authorization'] = '${auth.substring(0, 17)}***masked***';
      } else {
        masked['Authorization'] = '***masked***';
      }
    }
    return masked;
  }

  dynamic _maskBody(dynamic data) {
    if (data is Map) {
      final masked = Map<String, dynamic>.from(data as Map<String, dynamic>);
      for (final key in _sensitiveRequestFields) {
        if (masked.containsKey(key)) masked[key] = '***masked***';
      }
      // Mask phone numbers (keep last 4 digits)
      if (masked.containsKey('phone')) {
        final phone = masked['phone']?.toString() ?? '';
        if (phone.length > 4) {
          masked['phone'] = '***${phone.substring(phone.length - 4)}';
        }
      }
      // Mask national ID
      if (masked.containsKey('national_id') ||
          masked.containsKey('nationalId')) {
        masked['national_id'] = '***masked***';
        masked['nationalId'] = '***masked***';
      }
      return masked;
    }
    return data;
  }

  dynamic _maskResponseBody(dynamic data) {
    if (data is Map) {
      final masked = Map<String, dynamic>.from(data as Map<String, dynamic>);
      // Mask tokens in data payload
      if (masked['data'] is Map) {
        final dataMap =
            Map<String, dynamic>.from(masked['data'] as Map<String, dynamic>);
        for (final key in _sensitiveResponseFields) {
          if (dataMap.containsKey(key)) {
            final val = dataMap[key]?.toString() ?? '';
            dataMap[key] = val.length > 10
                ? '${val.substring(0, 10)}***masked***'
                : '***masked***';
          }
        }
        masked['data'] = dataMap;
      }
      return masked;
    }
    return data;
  }

  String _prettyJson(dynamic data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  /// Hard-coded translations for developer-console visibility.
  /// These are NOT used in the UI (the i18n system handles that).
  static const _errorTranslations = <String, Map<String, String>>{
    'ERR_AUTH_INVALID_CREDENTIALS': {
      'en': 'Invalid email or password',
      'ar': 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
      'fr': 'Email ou mot de passe invalide',
      'de': 'Ungültige E-Mail oder Passwort',
      'es': 'Correo electrónico o contraseña no válidos',
      'it': 'Email o password non validi',
      'ru': 'Неверный email или пароль',
    },
    'ERR_AUTH_EMAIL_NOT_VERIFIED': {
      'en': 'Please verify your email before signing in',
      'ar': 'يرجى التحقق من بريدك الإلكتروني قبل تسجيل الدخول',
      'fr': 'Veuillez vérifier votre email avant de vous connecter',
      'de': 'Bitte bestätigen Sie Ihre E-Mail-Adresse',
      'es': 'Por favor, verifica tu correo antes de iniciar sesión',
      'it': 'Verifica la tua email prima di accedere',
      'ru': 'Подтвердите email перед входом',
    },
    'ERR_AUTH_ACCOUNT_SUSPENDED': {
      'en': 'Your account is suspended',
      'ar': 'تم تعليق حسابك',
      'fr': 'Votre compte est suspendu',
      'de': 'Ihr Konto ist gesperrt',
      'es': 'Tu cuenta está suspendida',
      'it': 'Il tuo account è sospeso',
      'ru': 'Ваш аккаунт заблокирован',
    },
    'ERR_AUTH_ACCOUNT_BANNED': {
      'en': 'Account permanently banned',
      'ar': 'تم حظر الحساب بشكل دائم',
      'fr': 'Compte définitivement banni',
      'de': 'Konto dauerhaft gesperrt',
      'es': 'Cuenta bloqueada permanentemente',
      'it': 'Account bannato definitivamente',
      'ru': 'Аккаунт заблокирован навсегда',
    },
    'ERR_OTP_INVALID': {
      'en': 'Incorrect OTP code',
      'ar': 'رمز التحقق غير صحيح',
      'fr': 'Code OTP incorrect',
      'de': 'Falscher OTP-Code',
      'es': 'Código OTP incorrecto',
      'it': 'Codice OTP errato',
      'ru': 'Неверный код OTP',
    },
    'ERR_OTP_EXPIRED': {
      'en': 'OTP code expired',
      'ar': 'انتهت صلاحية رمز التحقق',
      'fr': 'Code OTP expiré',
      'de': 'OTP-Code abgelaufen',
      'es': 'Código OTP caducado',
      'it': 'Codice OTP scaduto',
      'ru': 'Код OTP истёк',
    },
    'ERR_NETWORK_OFFLINE': {
      'en': 'No internet connection',
      'ar': 'لا يوجد اتصال بالإنترنت',
      'fr': 'Pas de connexion internet',
      'de': 'Keine Internetverbindung',
      'es': 'Sin conexión a internet',
      'it': 'Nessuna connessione internet',
      'ru': 'Нет подключения к интернету',
    },
    'ERR_SERVER_INTERNAL': {
      'en': 'Something went wrong on our end',
      'ar': 'حدث خطأ من جهتنا',
      'fr': "Une erreur s'est produite",
      'de': 'Bei uns ist ein Fehler aufgetreten',
      'es': 'Algo salió mal de nuestro lado',
      'it': 'Si è verificato un errore da parte nostra',
      'ru': 'На нашей стороне что-то пошло не так',
    },
  };

  void _logErrorTranslations(String errorCode, Map<String, dynamic>? metadata) {
    final translations = _errorTranslations[errorCode];
    if (translations == null) return;

    for (final entry in translations.entries) {
      debugPrint('║   Translated (${entry.key}): "${entry.value}"');
    }
  }
}
