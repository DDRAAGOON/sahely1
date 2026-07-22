import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/widgets/buttons.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Row(
                children: [
                  const BackChip(),
                  const SizedBox(width: 16),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            
            // Settings List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: [
                  _sectionHeader('BOOKINGS'),
                  const SizedBox(height: 12),
                  _buildSectionCard([
                    _toggleRow(
                      'Booking updates',
                      'Confirmations, reminders, changes',
                      _bookingUpdates,
                      (val) => setState(() => _bookingUpdates = val),
                    ),
                    _divider(),
                    _toggleRow(
                      'Check-in & door access',
                      'Passcode & arrival alerts',
                      _checkInAccess,
                      (val) => setState(() => _checkInAccess = val),
                    ),
                    _divider(),
                    _toggleRow(
                      'Messages & support',
                      'Replies from Sahely & hosts',
                      _messagesSupport,
                      (val) => setState(() => _messagesSupport = val),
                    ),
                  ]),
                  
                  const SizedBox(height: 24),
                  
                  _sectionHeader('AL MAWSEM & OFFERS'),
                  const SizedBox(height: 12),
                  _buildSectionCard([
                    _toggleRow(
                      'Stars & level-ups',
                      'When you earn stars or level up',
                      _starsLevelUps,
                      (val) => setState(() => _starsLevelUps = val),
                    ),
                    _divider(),
                    _toggleRow(
                      'Promotions',
                      'Seasonal deals & discounts',
                      _promotions,
                      (val) => setState(() => _promotions = val),
                    ),
                  ]),
                  
                  const SizedBox(height: 24),
                  
                  _sectionHeader('CHANNELS'),
                  const SizedBox(height: 12),
                  _buildSectionCard([
                    _toggleRow(
                      'Push notifications',
                      'On this device',
                      _pushNotifications,
                      (val) => setState(() => _pushNotifications = val),
                    ),
                    _divider(),
                    _toggleRow(
                      'Email',
                      'mariam@example.com',
                      _emailNotifications,
                      (val) => setState(() => _emailNotifications = val),
                    ),
                    _divider(),
                    _toggleRow(
                      'SMS / WhatsApp',
                      '+20 100 ••42',
                      _smsWhatsApp,
                      (val) => setState(() => _smsWhatsApp = val),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary,
        letterSpacing: 1.1,
        fontFamily: 'Cairo',
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _toggleRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.green,
            inactiveTrackColor: const Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.border,
      indent: 16,
      endIndent: 16,
    );
  }
}
