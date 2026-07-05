import 'package:flutter/material.dart';

class PasscodeDisplay extends StatelessWidget {
  final String passcode;
  final bool isInRange;
  final VoidCallback? onCopyTap;

  const PasscodeDisplay({
    super.key,
    required this.passcode,
    required this.isInRange,
    this.onCopyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFC49F45).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'ACCESS PASSCODE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC49F45),
              fontFamily: 'DM Sans',
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              String digit = (isInRange && index < passcode.length) ? passcode[index] : '•';
              return Container(
                width: 42,
                height: 58,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    digit,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isInRange ? Colors.white : Colors.white.withValues(alpha: 0.2),
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: isInRange ? onCopyTap : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.copy_rounded,
                    size: 14,
                    color: Color(0xFFC49F45),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isInRange ? 'Copy code' : 'Locked until in range',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isInRange ? Colors.white : const Color(0xFFE57373),
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
