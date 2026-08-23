import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BrokerLockInfoText extends StatelessWidget {
  final bool isInRange;

  const BrokerLockInfoText({
    super.key,
    required this.isInRange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline,
              color: Color(0xFFC49F45),
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isInRange
                  ? 'Revealed because you\'re within 2 km of the property. Enter it on the door keypad — it won\'t change until you check out.'
                  : 'The code appears automatically once you\'re within 2 km of the property. Head over — it won\'t change until you check out.',
              style: AppTheme.dm(
                size: 13,
                color: const Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
