import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';

class BrokerCollectionMembersActions extends StatelessWidget {
  final List<String> memberNames;
  final VoidCallback onChatTap;
  final VoidCallback onShareTap;
  final VoidCallback onCompareTap;

  const BrokerCollectionMembersActions({
    super.key,
    required this.memberNames,
    required this.onChatTap,
    required this.onShareTap,
    required this.onCompareTap,
  });

  Color _getAvatarColor(int index) {
    final colors = [
      AppColors.navy,
      AppColors.mawsemTeal,
      AppColors.gold,
      AppColors.red,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        children: [
          // Members avatar stack
          Row(
            children: [
              // Avatar stack
              SizedBox(
                width: 104, // (3 * 24) + 32
                height: 32,
                child: Stack(
                  children: [
                    for (int i = 0; i < 3 && i < memberNames.length; i++)
                      Positioned(
                        left: i * 24.0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _getAvatarColor(i),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.cream, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              memberNames[i][0],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                    // +1 more
                    if (memberNames.length > 3)
                      Positioned(
                        left: 72.0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.navy,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.cream, width: 2),
                          ),
                          child: const Center(
                            child: Text(
                              '+1',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'DM Sans',
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You, ${memberNames.take(2).join(', ')}${memberNames.length > 2 ? ' & ${memberNames.length - 2} more' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              // Chat button
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: onChatTap,
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Share button
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: onShareTap,
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Compare button
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton.icon(
                    onPressed: onCompareTap,
                    icon: const Icon(Icons.compare_arrows, size: 18),
                    label: const Text(
                      'Compare',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'DM Sans',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.navy,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: AppColors.navy, width: 1),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
