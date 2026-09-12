import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/features/shared/notifications/data/notifications_api_data_source.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/l10n/app_localizations.dart';

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

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen>
    with WidgetsBindingObserver {
  /// The account switches (`GET /notifications/preferences`).
  bool _promotions = false;
  bool _pushNotifications = false;
  bool _emailNotifications = false;
  bool _smsWhatsApp = false;

  /// Whether the phone itself lets Sahely post notifications. Push can be on
  /// for the account and still be silenced by the system.
  bool _systemAllowed = false;
  bool _loading = true;

  NotificationsApiDataSource get _api => sl<NotificationsApiDataSource>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Coming back from the system settings can mean the answer changed.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refreshSystemPermission();
  }

  Future<void> _load() async {
    await _refreshSystemPermission();
    try {
      final prefs = await _api.fetchPreferences();
      if (!mounted) return;
      setState(() {
        _pushNotifications = prefs.pushEnabled ?? false;
        _emailNotifications = prefs.emailEnabled ?? false;
        _smsWhatsApp = prefs.smsEnabled ?? false;
        _promotions = prefs.promotional ?? false;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refreshSystemPermission() async {
    final status = await Permission.notification.status;
    if (mounted) setState(() => _systemAllowed = status.isGranted);
  }

  /// Saves one switch; puts it back when the server refuses.
  Future<void> _save(
    NotificationPreferences change,
    VoidCallback revert,
  ) async {
    try {
      await _api.updatePreferences(change);
    } catch (_) {
      if (!mounted) return;
      setState(revert);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save that setting')),
      );
    }
  }

  /// Turning push on asks the device first: with no permission from the
  /// system nothing can be delivered, however the account is set.
  Future<void> _setPush(bool wanted) async {
    if (wanted && !_systemAllowed) {
      final status = await Permission.notification.request();
      if (!mounted) return;
      setState(() => _systemAllowed = status.isGranted);
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifications are turned off for Sahely'),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: openAppSettings,
            ),
          ),
        );
        return;
      }
    }
    setState(() => _pushNotifications = wanted);
    await _save(
      NotificationPreferences(pushEnabled: wanted),
      () => _pushNotifications = !wanted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();
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
                Text(AppLocalizations.of(context).notificationsTitle,
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
                _sectionLabel(AppLocalizations.of(context).sectionBookings),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    // Transactional: the backend always sends these and has
                    // no switch for them. Only the channels below decide how
                    // they reach you.
                    children: [
                      _alwaysOnRow(
                        title: AppLocalizations.of(context).bookingUpdates,
                        subtitle:
                            AppLocalizations.of(context).bookingUpdatesSub,
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _alwaysOnRow(
                        title: AppLocalizations.of(context).checkinAccess,
                        subtitle: AppLocalizations.of(context).checkinAccessSub,
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _alwaysOnRow(
                        title: AppLocalizations.of(context).messagesSupport,
                        subtitle:
                            AppLocalizations.of(context).messagesSupportSub,
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
                      _alwaysOnRow(
                        title: AppLocalizations.of(context).starsLevelUps,
                        subtitle: AppLocalizations.of(context).starsLevelUpsSub,
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: AppLocalizations.of(context).promotions,
                        subtitle: AppLocalizations.of(context).promotionsSub,
                        value: _promotions,
                        onChanged: (v) {
                          setState(() => _promotions = v);
                          _save(
                            NotificationPreferences(promotional: v),
                            () => _promotions = !v,
                          );
                        },
                        last: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // CHANNELS Section
                _sectionLabel(AppLocalizations.of(context).sectionChannels),
                const SizedBox(height: 8),
                WhiteCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      _toggleRow(
                        title: AppLocalizations.of(context).pushNotifications,
                        subtitle: _systemAllowed
                            ? 'On this device'
                            : 'Blocked in the phone settings',
                        value: _pushNotifications && _systemAllowed,
                        onChanged: _loading ? null : _setPush,
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: AppLocalizations.of(context).emailChannel,
                        subtitle: profile.email.isEmpty ? '—' : profile.email,
                        value: _emailNotifications,
                        onChanged: _loading
                            ? null
                            : (v) {
                                setState(() => _emailNotifications = v);
                                _save(
                                  NotificationPreferences(emailEnabled: v),
                                  () => _emailNotifications = !v,
                                );
                              },
                      ),
                      const Divider(height: 1, indent: 16, endIndent: 16),
                      _toggleRow(
                        title: 'SMS / WhatsApp',
                        subtitle: profile.phone.isEmpty ? '—' : profile.phone,
                        value: _smsWhatsApp,
                        onChanged: _loading
                            ? null
                            : (v) {
                                setState(() => _smsWhatsApp = v);
                                _save(
                                  NotificationPreferences(smsEnabled: v),
                                  () => _smsWhatsApp = !v,
                                );
                              },
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

  /// A notification the backend always sends and cannot switch off.
  Widget _alwaysOnRow({required String title, required String subtitle}) {
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('Always on',
                style: AppTheme.dm(
                    size: 11, weight: FontWeight.w600, color: AppColors.muted)),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
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
