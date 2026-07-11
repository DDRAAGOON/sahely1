import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../widgets/collab_card.dart';

const _azure = 'https://images.unsplash.com/photo-1776762893024-890728937eab?w=800&q=72&auto=format&fit=crop';
const _lagoon = 'https://images.unsplash.com/photo-1707075108813-edefd7b3308d?w=800&q=72&auto=format&fit=crop';

class CollectionInsideScreen extends StatelessWidget {
  const CollectionInsideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
        children: [
          const TopBar(title: 'Beach Trip 2026', subtitle: '5 places · shared with 3'),
          const SizedBox(height: 12),
          Row(children: [
            SizedBox(
              width: 92,
              height: 28,
              child: Stack(children: [
                for (var i = 0; i < 3; i++)
                  Positioned(
                      left: i * 18.0,
                      child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              gradient: LinearGradient(colors: [
                                const [Color(0xFF7FA8BF), Color(0xFFD8B98A), Color(0xFFC9A84C)][i],
                                const Color(0xFF2C5066)
                              ])))),
                Positioned(
                    left: 54,
                    child: Container(
                        width: 26,
                        height: 26,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.navy,
                            border: Border.all(color: Colors.white, width: 2)),
                        child: Text('+1', style: AppTheme.dm(size: 9, weight: FontWeight.w700, color: Colors.white)))),
              ]),
            ),
            const SizedBox(width: 8),
            Text('You, Omar, Nour & 1 more', style: AppTheme.dm(size: 12, color: AppColors.muted)),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: WideButton(
                    label: 'Chat',
                    icon: Icons.chat_bubble_outline,
                    color: AppColors.navy,
                    height: 42,
                    onTap: () => Navigator.pushNamed(context, '/collection-chat'))),
            const SizedBox(width: 8),
            Expanded(
                child: WideButton(
                    label: 'Share',
                    icon: Icons.link,
                    color: AppColors.gold,
                    textColor: AppColors.navy,
                    height: 42,
                    onTap: () => Navigator.pushNamed(context, '/share-collection'))),
            const SizedBox(width: 8),
            Expanded(
                child: WideButton(
                    label: 'Compare',
                    icon: Icons.bar_chart,
                    color: AppColors.navy,
                    outline: true,
                    height: 42,
                    onTap: () => Navigator.pushNamed(context, '/compare'))),
          ]),
          const SizedBox(height: 16),
          const CollabCard(
              image: _azure,
              name: 'Azure Beach Villa',
              loc: 'Hacienda Bay, North Coast',
              tags: ['Villa', '4 beds', 'Pool'],
              pet: '🐾 Pets',
              petOk: true,
              rating: '4.8',
              reviews: '124',
              price: 'EGP 4,500',
              comment: 'Omar: pricey but the pool 😍'),
          const SizedBox(height: 12),
          const CollabCard(
              image: _lagoon,
              name: 'Lagoon Retreat',
              loc: 'Marassi, North Coast',
              tags: ['Chalet', '3 beds', 'Sea view'],
              pet: 'No pets',
              petOk: false,
              rating: '4.9',
              reviews: '86',
              price: 'EGP 6,200',
              comment: 'Nour: 3 min to the beach!'),
        ],
      ),
    );
  }
}
