class VerificationState {
  final bool emailVerified;
  final bool phoneVerified;
  final bool idVerified;
  final bool cardAdded;

  const VerificationState({
    required this.emailVerified,
    required this.phoneVerified,
    required this.idVerified,
    required this.cardAdded,
  });

  bool get isComplete =>
      emailVerified && phoneVerified && idVerified && cardAdded;

  int get completedSteps => [
        emailVerified,
        phoneVerified,
        idVerified,
        cardAdded,
      ].where((step) => step).length;

  VerificationState copyWith({
    bool? emailVerified,
    bool? phoneVerified,
    bool? idVerified,
    bool? cardAdded,
  }) {
    return VerificationState(
      emailVerified: emailVerified ?? this.emailVerified,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      idVerified: idVerified ?? this.idVerified,
      cardAdded: cardAdded ?? this.cardAdded,
    );
  }

  @override
  String toString() {
    return 'VerificationState(email: $emailVerified, phone: $phoneVerified, '
        'id: $idVerified, card: $cardAdded, complete: $isComplete)';
  }
}
