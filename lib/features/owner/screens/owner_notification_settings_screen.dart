import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';

class OwnerNotificationSettingsScreen extends StatefulWidget {
  const OwnerNotificationSettingsScreen({super.key});

  @override
  State<OwnerNotificationSettingsScreen> createState() =>
      _OwnerNotificationSettingsScreenState();
}

class _OwnerNotificationSettingsScreenState
    extends State<OwnerNotificationSettingsScreen> {
  // State for toggles
  bool bookingUpdates = true;
  bool checkInAlerts = true;
  bool messagesSupport = true;
  bool starsLevelUps = true;
  bool promotions = false;
  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsWhatsapp = false;

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                const BackChip(),
                const SizedBox(width: 12),
                Text('Notifications',
                    style: AppTheme.dm(
                        size: 20,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _sectionLabel('BOOKINGS'),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _toggleRow(
                        title: 'Booking updates',
                        subtitle: 'Confirmations, reminders, changes',
                        value: bookingUpdates,
                        onChanged: (v) => setState(() => bookingUpdates = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Check-in & door access',
                        subtitle: 'Passcode & arrival alerts',
                        value: checkInAlerts,
                        onChanged: (v) => setState(() => checkInAlerts = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Messages & support',
                        subtitle: 'Replies from Sahely & hosts',
                        value: messagesSupport,
                        onChanged: (v) => setState(() => messagesSupport = v),
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _sectionLabel('AL MAWSEM & OFFERS'),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _toggleRow(
                        title: 'Stars & level-ups',
                        subtitle: 'When you earn stars or level up',
                        value: starsLevelUps,
                        onChanged: (v) => setState(() => starsLevelUps = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Promotions',
                        subtitle: 'Seasonal deals & discounts',
                        value: promotions,
                        onChanged: (v) => setState(() => promotions = v),
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _sectionLabel('CHANNELS'),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _toggleRow(
                        title: 'Push notifications',
                        subtitle: 'On this device',
                        value: pushNotifications,
                        onChanged: (v) => setState(() => pushNotifications = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Email',
                        subtitle: 'mariam@example.com',
                        value: emailNotifications,
                        onChanged: (v) =>
                            setState(() => emailNotifications = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'SMS / WhatsApp',
                        subtitle: '+20 100 ••42',
                        value: smsWhatsapp,
                        onChanged: (v) => setState(() => smsWhatsapp = v),
                        last: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(label,
            style: AppTheme.dm(
                size: 12,
                weight: FontWeight.w700,
                color: AppColors.muted,
                letterSpacing: 0.5)),
      );

  Widget _toggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool last = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: AppTheme.dm(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTheme.dm(size: 12, color: AppColors.muted)),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.success,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
