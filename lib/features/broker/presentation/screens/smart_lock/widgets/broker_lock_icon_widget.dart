import 'package:flutter/material.dart';

class BrokerLockIconWidget extends StatelessWidget {
  final bool isInRange;

  const BrokerLockIconWidget({
    super.key,
    required this.isInRange,
  });

  @override
  Widget build(BuildContext context) {
    final color = isInRange ? const Color(0xFFC49F45) : const Color(0xFFE57373);
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          isInRange ? Icons.lock_open : Icons.lock_outline,
          color: color,
          size: 36,
        ),
      ),
    );
  }
}
