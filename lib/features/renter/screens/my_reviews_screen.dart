import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/cream_background.dart';
import '../../../widgets/kit.dart';

const _lagoon = 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=400&q=70&auto=format&fit=crop';
const _dunes = 'https://images.unsplash.com/photo-1776619316276-b1b461af9f15?w=400&q=70&auto=format&fit=crop';

class MyReviewsScreen extends StatefulWidget {
  const MyReviewsScreen({super.key});
  @override
  State<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends State<MyReviewsScreen> {
  int tab = 0;
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        children: [
          const TopBar(title: 'Reviews'),
          const SizedBox(height: 14),
          SegmentTabs(tabs: const ['Reviews I gave', 'About me'], active: tab, onTap: (i) => setState(() => tab = i)),
          const SizedBox(height: 16),
          if (tab == 0) ...[
            const SectionLabel('REVIEWS I GAVE · 8'),
            const SizedBox(height: 10),
            _given(_lagoon, 'Lagoon Retreat', 5, 'Jun 2026',
                'Unreal pool and the smart-lock check-in was effortless. Would book again in a heartbeat.'),
            const SizedBox(height: 10),
            _given(_dunes, 'Golden Dunes', 4, 'May 2026',
                'Beautiful villa, quiet area. Beach was a little busy on the weekend but loved it overall.'),
          ] else ...[
            const SectionLabel('WHAT HOSTS SAY ABOUT ME · 6'),
            const SizedBox(height: 10),
            _about('Layla M.', Role.owner, 5,
                'Wonderful guest — left the villa spotless and communicated clearly. Welcome any time!',
                const [Color(0xFF7FA8BF), Color(0xFF2C5066)]),
            const SizedBox(height: 10),
            _about('Karim A.', Role.broker, 5, 'Respectful, on-time check-out, easy to coordinate with. A 5-star guest.',
                const [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
          ],
        ],
      ),
    );
  }

  Widget _stars(int n) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [for (var i = 0; i < 5; i++) Icon(Icons.star, size: 13, color: i < n ? AppColors.gold : AppColors.border)]);

  Widget _given(String img, String name, int stars, String date, String body) => WhiteCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(img,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 40, height: 40, color: AppColors.cardWarm))),
            const SizedBox(width: 10),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
              Row(children: [_stars(stars), const SizedBox(width: 6), Text(date, style: AppTheme.dm(size: 11, color: AppColors.faint))]),
            ])),
          ]),
          const SizedBox(height: 10),
          Text(body, style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5)),
        ]),
      );

  Widget _about(String name, Role role, int stars, String body, List<Color> avatar) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFFDF9F4),
            border: Border.all(color: const Color(0xFFE7D9A8)),
            borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            AvatarCircle(size: 38, colors: avatar),
            const SizedBox(width: 10),
            Expanded(
                child: Row(children: [
              Text(name, style: AppTheme.dm(size: 14, weight: FontWeight.w700, color: AppColors.navy)),
              const SizedBox(width: 8),
              StatusBadge(role.shortLabel, kind: role == Role.owner ? BadgeKind.greenSoft : BadgeKind.gold),
            ])),
            _stars(stars),
          ]),
          const SizedBox(height: 10),
          Text(body, style: AppTheme.dm(size: 13, color: AppColors.ink, height: 1.5)),
        ]),
      );
}
