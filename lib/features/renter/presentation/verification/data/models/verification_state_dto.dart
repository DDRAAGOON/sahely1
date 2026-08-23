import 'package:equatable/equatable.dart';
import '../../domain/models/verification_state.dart';

class VerificationStateDto extends Equatable {
  final bool emailVerified;
  final bool phoneVerified;
  final bool idVerified;
  final bool cardAdded;

  const VerificationStateDto({
    required this.emailVerified,
    required this.phoneVerified,
    required this.idVerified,
    required this.cardAdded,
  });

  factory VerificationStateDto.fromJson(Map<String, dynamic> json) {
    return VerificationStateDto(
      emailVerified: json['emailVerified'] as bool? ?? false,
      phoneVerified: json['phoneVerified'] as bool? ?? false,
      idVerified: json['idVerified'] as bool? ?? false,
      cardAdded: json['cardAdded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'idVerified': idVerified,
      'cardAdded': cardAdded,
    };
  }

  VerificationState toEntity() {
    return VerificationState(
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      idVerified: idVerified,
      cardAdded: cardAdded,
    );
  }

  factory VerificationStateDto.fromEntity(VerificationState entity) {
    return VerificationStateDto(
      emailVerified: entity.emailVerified,
      phoneVerified: entity.phoneVerified,
      idVerified: entity.idVerified,
      cardAdded: entity.cardAdded,
    );
  }

  @override
  List<Object?> get props => [
        emailVerified,
        phoneVerified,
        idVerified,
        cardAdded,
      ];
}
