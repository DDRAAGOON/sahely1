import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:sahely/features/shared/widgets/mawsem/earn_star_row.dart';

class HowToEarnSection extends StatelessWidget {
  const HowToEarnSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Text(
          'How to Earn Stars',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Do more, climb faster. Stars reset every season.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.secondary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 16),

        // Earn Rows Container
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _buildRow(
                context,
                icon: Icons.verified_user_outlined,
                title: 'Verify your identity',
                subtitle: 'One-time · ID + live selfie',
                stars: '+5',
                color: const Color(0xFF1B6B3A),
                bgColor: const Color(0xFFE8F5E9),
              ),
              _buildRow(
                context,
                icon: Icons.calendar_today_outlined,
                title: 'Complete first booking',
                subtitle: 'One-time · must check in',
                stars: '+10',
                color: const Color(0xFF1565C0),
                bgColor: const Color(0xFFE3F2FD),
              ),
              _buildRow(
                context,
                icon: Icons.person_add_outlined,
                title: 'Refer a friend who stays',
                subtitle: 'Per friend · must complete a stay',
                stars: '+15',
                color: const Color(0xFFBC9B43),
                bgColor: const Color(0xFFFFF8E1),
              ),
              _buildRow(
                context,
                icon: Icons.check_circle_outline,
                title: 'Complete arrival checklist',
                subtitle: 'Per stay',
                stars: '+5',
                color: const Color(0xFF1B6B3A),
                bgColor: const Color(0xFFE8F5E9),
              ),
              _buildRow(
                context,
                icon: Icons.star_border,
                title: 'Review with text + photo',
                subtitle: 'Per stay · both required',
                stars: '+5',
                color: const Color(0xFFBC9B43),
                bgColor: const Color(0xFFFFF8E1),
              ),
              // INSTAGRAM ROW WITH LINK
              _buildRow(
                context,
                icon: Icons.camera_alt_outlined,
                isInstagram: true,
                title: 'Share on IG Stories ',
                subtitle: 'Per stay · keep up 24h+',
                stars: '+5',
                color: const Color(0xFFC2185B),
                bgColor: const Color(0xFFFCE4EC),
              ),
              _buildRow(
                context,
                icon: Icons.notifications_none,
                title: 'Book a concierge service',
                subtitle: 'Per service',
                stars: '+3',
                color: const Color(0xFF1565C0),
                bgColor: const Color(0xFFE3F2FD),
              ),
              _buildRow(
                context,
                icon: Icons.arrow_upward,
                title: 'Stay 3+ nights · or book off-peak',
                subtitle: 'Bonus per stay (each)',
                stars: '+5',
                color: const Color(0xFF1B6B3A),
                bgColor: const Color(0xFFE8F5E9),
              ),
              _buildRow(
                context,
                icon: Icons.history,
                title: 'Come back · 2nd / 3rd+ booking',
                subtitle: 'Loyalty bonus',
                stars: '+10–15',
                color: const Color(0xFFBC9B43),
                bgColor: const Color(0xFFFFF8E1),
              ),
              _buildRow(
                context,
                icon: Icons.home_outlined,
                title: 'Refer an owner who lists',
                subtitle: 'Huge · one-time',
                stars: '+50',
                color: const Color(0xFF9A7A22),
                bgColor: const Color(0xFFBC9B43),
                rowBgColor: const Color(0xFFFBF3DE),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(16)),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String stars,
    required Color color,
    required Color bgColor,
    Color? rowBgColor,
    BorderRadius? borderRadius,
    bool isLast = false,
    bool isInstagram = false,
  }) {
    Widget titleWidget;

    if (isInstagram) {
      titleWidget = Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: 'Share on IG Stories '),
            TextSpan(
              text: '@sahelyeg',
              style: const TextStyle(
                color: Color(0xFFC2185B),
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri url =
                      Uri.parse('https://www.instagram.com/sahelyeg/');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
            ),
          ],
        ),
      );
    } else {
      titleWidget = Text(title);
    }

    return EarnStarRow(
      icon: icon,
      title: titleWidget,
      subtitle: subtitle,
      stars: stars,
      iconColor: color,
      iconBgColor: bgColor,
      rowBgColor: rowBgColor,
      borderRadius: borderRadius,
      showDivider: !isLast && rowBgColor == null,
      titleColor: rowBgColor != null ? color : null,
    );
  }
}
