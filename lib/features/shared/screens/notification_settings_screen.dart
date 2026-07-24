import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/buttons.dart';
import 'package:sahely/core/widgets/kit.dart';

/// Enum for user role to customize notification settings screen.
enum NotificationRole { renter, owner, broker }

/// Unified Notification Settings Screen shared across all 3 roles.
class NotificationSettingsScreen extends StatefulWidget {
  final NotificationRole role;

  const NotificationSettingsScreen({
    super.key,
    this.role = NotificationRole.renter,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // BOOKINGS
  bool _bookingUpdates = true;
  bool _checkInAccess = true;
  bool _messagesSupport = true;

  // AL MAWSEM & OFFERS
  bool _starsLevelUps = true;
  bool _promotions = false;

  // CHANNELS
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsWhatsApp = false;


  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(
        children: [
          // Header
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

          // Settings List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                // BOOKINGS Section
                _sectionLabel('BOOKINGS'),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _toggleRow(
                        title: 'Booking updates',
                        subtitle: 'Confirmations, reminders, changes',
                        value: _bookingUpdates,
                        onChanged: (v) => setState(() => _bookingUpdates = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Check-in & door access',
                        subtitle: 'Passcode & arrival alerts',
                        value: _checkInAccess,
                        onChanged: (v) => setState(() => _checkInAccess = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Messages & support',
                        subtitle: 'Replies from Sahely & hosts',
                        value: _messagesSupport,
                        onChanged: (v) => setState(() => _messagesSupport = v),
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // AL MAWSEM & OFFERS Section
                _sectionLabel('AL MAWSEM & OFFERS'),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _toggleRow(
                        title: 'Stars & level-ups',
                        subtitle: 'When you earn stars or level up',
                        value: _starsLevelUps,
                        onChanged: (v) => setState(() => _starsLevelUps = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Promotions',
                        subtitle: 'Seasonal deals & discounts',
                        value: _promotions,
                        onChanged: (v) => setState(() => _promotions = v),
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // CHANNELS Section
                _sectionLabel('CHANNELS'),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _toggleRow(
                        title: 'Push notifications',
                        subtitle: 'On this device',
                        value: _pushNotifications,
                        onChanged: (v) =>
                            setState(() => _pushNotifications = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'Email',
                        subtitle: 'mariam@example.com',
                        value: _emailNotifications,
                        onChanged: (v) =>
                            setState(() => _emailNotifications = v),
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'SMS / WhatsApp',
                        subtitle: '+20 100 ••42',
                        value: _smsWhatsApp,
                        onChanged: (v) => setState(() => _smsWhatsApp = v),
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
