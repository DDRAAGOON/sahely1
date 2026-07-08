import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import '../widgets/notification_section_header.dart';
import '../widgets/notification_toggle_row.dart';
import '../widgets/notification_channel_row.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Booking notifications
  bool _bookingUpdates = true;
  bool _checkInAccess = true;
  bool _messagesSupport = true;

  // MAWSEM notifications
  bool _starsLevelUps = true;
  bool _promotions = false;

  // Channels
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsWhatsApp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.chevron_left,
              color: AppColors.navy,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BOOKINGS Section
              const NotificationSectionHeader(title: 'BOOKINGS'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    NotificationToggleRow(
                      title: 'Booking updates',
                      subtitle: 'Confirmations, reminders, changes',
                      value: _bookingUpdates,
                      onChanged: (value) {
                        setState(() => _bookingUpdates = value);
                      },
                    ),
                    _Divider(),
                    NotificationToggleRow(
                      title: 'Check-in & door access',
                      subtitle: 'Passcode & arrival alerts',
                      value: _checkInAccess,
                      onChanged: (value) {
                        setState(() => _checkInAccess = value);
                      },
                    ),
                    _Divider(),
                    NotificationToggleRow(
                      title: 'Messages & support',
                      subtitle: 'Replies from Sahely & hosts',
                      value: _messagesSupport,
                      onChanged: (value) {
                        setState(() => _messagesSupport = value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AL MAWSEM & OFFERS Section
              const NotificationSectionHeader(title: 'AL MAWSEM & OFFERS'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    NotificationToggleRow(
                      title: 'Stars & level-ups',
                      subtitle: 'When you earn stars or level up',
                      value: _starsLevelUps,
                      onChanged: (value) {
                        setState(() => _starsLevelUps = value);
                      },
                    ),
                    _Divider(),
                    NotificationToggleRow(
                      title: 'Promotions',
                      subtitle: 'Seasonal deals & discounts',
                      value: _promotions,
                      onChanged: (value) {
                        setState(() => _promotions = value);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CHANNELS Section
              const NotificationSectionHeader(title: 'CHANNELS'),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    NotificationChannelRow(
                      icon: Icons.notifications_outlined,
                      title: 'Push notifications',
                      subtitle: 'On this device',
                      value: _pushNotifications,
                      onChanged: (value) {
                        setState(() => _pushNotifications = value);
                      },
                    ),
                    _Divider(),
                    NotificationChannelRow(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: 'mariam@example.com',
                      value: _emailNotifications,
                      onChanged: (value) {
                        setState(() => _emailNotifications = value);
                      },
                    ),
                    _Divider(),
                    NotificationChannelRow(
                      icon: Icons.sms_outlined,
                      title: 'SMS / WhatsApp',
                      subtitle: '+20 100 ••42',
                      value: _smsWhatsApp,
                      onChanged: (value) {
                        setState(() => _smsWhatsApp = value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      color: AppColors.border,
      indent: 0,
      endIndent: 0,
    );
  }
}
