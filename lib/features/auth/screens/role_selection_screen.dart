import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/ui.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});
  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final roles = [
      (
        'Renter',
        'Discover & book luxury properties',
        Icons.person_outline,
      ),
      (
        'Property Owner',
        'List your properties',
        Icons.apartment_outlined,
      ),
      (
        'Broker',
        'Earn commissions on referrals',
        Icons.handshake_outlined,
      ),
    ];
    return PhoneScaffold(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 40),
        child: Column(
          children: [
            const Align(alignment: Alignment.centerLeft, child: BackChip()),
            const SizedBox(height: 14),
            Text('How will you use Sahely?',
                textAlign: TextAlign.center,
                style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            Text('You can always access everything from your account',
                textAlign: TextAlign.center, style: AppTheme.dm(size: 14, color: AppColors.muted)),
            const SizedBox(height: 28),
            for (var i = 0; i < roles.length; i++) ...[
              _RoleCard(
                title: roles[i].$1,
                subtitle: roles[i].$2,
                iconData: roles[i].$3,
                selected: i == selected,
                onTap: () => setState(() => selected = i),
              ),
              if (i < roles.length - 1) const SizedBox(height: 14),
            ],
            const Spacer(),
            NavyButton(
              label: 'Continue',
              onTap: () => Navigator.pushNamed(
                context,
                '/create',
                arguments: roles[selected].$1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final IconData iconData;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: selected ? AppColors.goldSoft : AppColors.white,
              border: Border.all(
                  color: selected ? AppColors.gold : AppColors.border, width: selected ? 2 : 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.navy : AppColors.cardWarm,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    iconData,
                    color: selected ? AppColors.gold : AppColors.navy,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.dm(size: 16, weight: FontWeight.w700, color: AppColors.navy),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.dm(size: 12, color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (selected)
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 13, color: AppColors.white),
              ),
            ),
        ],
      ),
    );
  }
}
