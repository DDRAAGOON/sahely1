import 'package:sahely/data/models.dart';

/// Request model for registration step 1 - role selection
class RegisterStep1RequestModel {
  final Role role;

  RegisterStep1RequestModel({required this.role});

  Map<String, dynamic> toJson() => {
        'role': role.name,
      };
}

/// Request model for registration step 2 - account details
class RegisterStep2RequestModel {
  final String sessionId;
  final String fullName;
  final String email;
  final String phone;
  final String dateOfBirth;
  final String password;
  final String confirmPassword;
  final bool termsAccepted;
  final String? referralCode;

  RegisterStep2RequestModel({
    required this.sessionId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.password,
    required this.confirmPassword,
    required this.termsAccepted,
    this.referralCode,
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'date_of_birth': dateOfBirth,
        'password': password,
        'confirm_password': confirmPassword,
        'terms_accepted': termsAccepted,
        if (referralCode != null && referralCode!.isNotEmpty)
          'referral_code': referralCode,
      };
}

/// Request model for registration step 3 - email OTP verification
class RegisterStep3RequestModel {
  final String sessionId;
  final String otp;

  RegisterStep3RequestModel({
    required this.sessionId,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'otp': otp,
        'sessionId': sessionId,
      };
}

/// Request model for registration step 4 - phone OTP verification
class RegisterStep4RequestModel {
  final String sessionId;
  final String otp;

  RegisterStep4RequestModel({
    required this.sessionId,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'otp': otp,
        'sessionId': sessionId,
      };
}
