import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/avatars.dart';

class CollectionChatScreen extends StatelessWidget {
  const CollectionChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEAE1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(bottom: BorderSide(color: AppColors.border))),
              child: Row(children: [
                GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child:
                        const Icon(Icons.chevron_left, color: AppColors.navy)),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Beach Trip 2026',
                          style: AppTheme.dm(
                              size: 15,
                              weight: FontWeight.w700,
                              color: AppColors.navy)),
                      Text('You, Omar, Nour, Sara',
                          style: AppTheme.dm(size: 11, color: AppColors.muted)),
                    ])),
                const AvatarCircle(
                    size: 26, colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
              ]),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: AppColors.white,
              child: Row(children: [
                Expanded(child: _vsCard('Azure', '4.8 · 4,500')),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('VS',
                        style: AppTheme.dm(
                            size: 12,
                            weight: FontWeight.w700,
                            color: AppColors.faint))),
                Expanded(child: _vsCard('Lagoon', '4.9 · 6,200')),
              ]),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  _msg('Omar', const [Color(0xFFD8B98A), Color(0xFF7D5A2C)],
                      'Azure has the better pool but Lagoon is closer to the water.'),
                  _msg('Nour', const [Color(0xFF7FA8BF), Color(0xFF2C5066)],
                      'Agreed — and Lagoon sleeps one more. Worth the extra?'),
                  _aiMsg(
                      'Quick compare: Lagoon — +0.1★, sleeps 8, 3 min to beach. Azure — private pool, −EGP 1,700/night. For a beach-first group, Lagoon wins.'),
                ],
              ),
            ),
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(children: [
                Expanded(
                    child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(22)),
                        alignment: Alignment.centerLeft,
                        child: Text('Message or ask AI to compare…',
                            style: AppTheme.dm(
                                size: 13,
                                color:
                                    AppColors.navy.withValues(alpha: 0.5))))),
                const SizedBox(width: 8),
                Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                        color: AppColors.gold, shape: BoxShape.circle),
                    child: const Icon(Icons.auto_awesome,
                        size: 18, color: AppColors.navy)),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vsCard(String name, String meta) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name,
              style: AppTheme.dm(
                  size: 13, weight: FontWeight.w700, color: AppColors.navy)),
          Text(meta, style: AppTheme.dm(size: 11, color: AppColors.muted)),
        ]),
      );

  Widget _msg(String name, List<Color> avatar, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          AvatarCircle(size: 28, colors: avatar),
          const SizedBox(width: 8),
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(14),
                          bottomLeft: Radius.circular(14),
                          bottomRight: Radius.circular(14))),
                  child: Text(text,
                      style: AppTheme.dm(
                          size: 13, color: AppColors.ink, height: 1.4)))),
        ]),
      );

  Widget _aiMsg(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.goldBright, AppColors.gold]),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.auto_awesome,
                  size: 15, color: AppColors.navy)),
          const SizedBox(width: 8),
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFBF3DE),
                      border: Border.all(color: const Color(0xFFEAD9A8)),
                      borderRadius: BorderRadius.circular(12)),
                  child: RichText(
                      text: TextSpan(
                          style: AppTheme.dm(
                              size: 13, color: AppColors.ink, height: 1.4),
                          children: [
                        const TextSpan(
                            text: 'Quick compare: ',
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: text.substring(15))
                      ])))),
        ]),
      );
}
