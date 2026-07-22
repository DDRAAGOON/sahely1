import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';

class TeamReviewScreen extends StatelessWidget {
  const TeamReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        children: [
          const TopBar(
              title: 'Review result', subtitle: 'Palm Shores · reviewed in 3h'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: const Color(0xFFFEF4E8),
                borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFFD2760A),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.image_outlined, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Almost there — 2 changes',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    Text("Make these and we'll publish within the hour",
                        style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  ])),
            ]),
          ),
          const SizedBox(height: 16),
          Text('What the team needs',
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w700, color: AppColors.navy)),
          const SizedBox(height: 8),
          _needRow(
              'Brighter daytime photos',
              'The living-room shots are dark — reshoot in morning light, vertical.',
              const Color(0xFFD2760A)),
          const SizedBox(height: 8),
          _needRow('Add the compound name',
              'Location is missing the gated-compound field.', AppColors.navy),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF2A3A64), AppColors.navy]),
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.bar_chart, color: AppColors.gold, size: 18),
                const SizedBox(width: 8),
                Text('Price recommendation',
                    style: AppTheme.dm(
                        size: 14, weight: FontWeight.w700, color: Colors.white))
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Text('EGP 5,500',
                    style: AppTheme.dm(size: 14, color: Colors.white54)
                        .copyWith(decoration: TextDecoration.lineThrough)),
                const SizedBox(width: 10),
                Text('EGP 6,800',
                    style: AppTheme.dm(
                        size: 20,
                        weight: FontWeight.w700,
                        color: AppColors.gold)),
                const SizedBox(width: 8),
                Text('+24%',
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w700,
                        color: const Color(0xFF7BE0A0))),
              ]),
              const SizedBox(height: 8),
              Text(
                  'Similar 3-bed villas in Marassi with a pool rent at EGP 6,500–7,200 this season. You can keep your price — this is a suggestion.',
                  style: AppTheme.dm(
                      size: 11, color: Colors.white70, height: 1.5)),
              const SizedBox(height: 12),
              const Row(children: [
                Expanded(
                    child: WideButton(
                        label: 'Use 6,800',
                        color: AppColors.gold,
                        textColor: AppColors.navy,
                        height: 42)),
                SizedBox(width: 10),
                Expanded(
                    child: WideButton(
                        label: 'Keep mine', color: Colors.white24, height: 42)),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => AppNavigation.goToOwnerAiChat(context),
            behavior: HitTestBehavior.opaque,
            child: WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Row(children: [
                  Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              colors: [Color(0xFF46B7A8), Color(0xFF226F66)]),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text('🌊',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Chat with your reviewer',
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        Text('Mariam from the Sahely team · online',
                            style:
                                AppTheme.dm(size: 11, color: AppColors.muted)),
                      ])),
                  const Icon(Icons.chat_bubble_outline, color: AppColors.navy),
                ])),
          ),
          const SizedBox(height: 16),
          NavyButton(
              label: 'Make changes & resubmit',
              radius: 999,
              onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _needRow(String title, String body, Color color) => WhiteCard(
        padding: const EdgeInsets.all(12),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                  color == AppColors.navy
                      ? Icons.location_on_outlined
                      : Icons.image_outlined,
                  size: 18,
                  color: color)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: AppTheme.dm(
                        size: 13,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
                Text(body,
                    style: AppTheme.dm(
                        size: 12, color: AppColors.muted, height: 1.4)),
              ])),
        ]),
      );
}
