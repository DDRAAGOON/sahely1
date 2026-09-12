import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/sheet_handle.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/broker/data/datasources/broker_api_data_source.dart';
import 'package:sahely/features/shared/referrals/data/referrals_api_data_source.dart';

class ShareEarnScreen extends StatelessWidget {
  const ShareEarnScreen({super.key});

  /// Shares the account's invite link from the API: a broker's owner-referral
  /// link (`POST /broker/referral-link`) or everyone else's referral link
  /// (`GET /referrals/code`). Opening it lands on `/join?ref=CODE`.
  Future<void> _shareInvite(BuildContext context, Role role) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final data = role == Role.broker
          ? await sl<BrokerApiDataSource>().createReferralLink()
          : await sl<ReferralsApiDataSource>().fetchCode();
      final url = '${data['share_url'] ?? data['referral_url'] ?? ''}';
      if (url.isEmpty) throw StateError('The API returned no invite link.');
      await SharePlus.instance
          .share(ShareParams(text: 'Join me on Sahely: $url'));
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content:
              Text('Could not create your invite link. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<RoleState>().currentRole;

    String title = "Invite & Earn 🎉";
    String subtitle =
        "Share Sahely with your network and earn exclusive rewards.";
    String rewardText = "Earn +15 Sahel Stars";
    String buttonText = "Share Referral Link";
    IconData icon = Icons.share_outlined;
    List<Color> gradientColors = [
      const Color(0xFFFEDA77),
      const Color(0xFFF58529),
      const Color(0xFFDD2A7B),
      const Color(0xFF8134AF)
    ];

    if (role == Role.broker) {
      title = "Refer an Owner 🏠";
      subtitle =
          "Earn stars for every property listed and approved through you.";
      rewardText = "Earn +50 Sahel Stars";
      buttonText = "Share Broker Code";
      icon = Icons.home_work_outlined;
    } else if (role == Role.owner) {
      title = "Refer a Host 🤝";
      subtitle = "Know someone with a great property? Invite them to Sahely.";
      rewardText = "Earn +100 Sahel Stars";
      buttonText = "Invite Another Owner";
      icon = Icons.handshake_outlined;
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 26),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    const SheetHandle(),
                    const SizedBox(height: 16),
                    Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(20)),
                        child: Icon(icon, color: Colors.white, size: 32)),
                    const SizedBox(height: 16),
                    Text(title,
                        textAlign: TextAlign.center,
                        style: AppTheme.dm(
                            size: 20,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: AppTheme.dm(
                            size: 14, color: AppColors.muted, height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFBF3DE),
                            border: Border.all(color: const Color(0xFFEAD9A8)),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.star,
                              size: 16, color: AppColors.gold),
                          const SizedBox(width: 6),
                          Text(rewardText,
                              style: AppTheme.dm(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFF9A7A22)))
                        ])),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () => _shareInvite(context, role),
                      child: Container(
                          height: 52,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                gradientColors[1],
                                gradientColors[2],
                                gradientColors[3],
                              ]),
                              borderRadius: BorderRadius.circular(12)),
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.share,
                                    size: 18, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(buttonText,
                                    style: AppTheme.dm(
                                        size: 15,
                                        weight: FontWeight.w700,
                                        color: Colors.white))
                              ])),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Text(AppLocalizations.of(context).maybeLater,
                            style:
                                AppTheme.dm(size: 13, color: AppColors.muted))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
