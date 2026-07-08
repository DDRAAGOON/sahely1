import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../widgets/cards/sahely_card.dart';
import '../../widgets/buttons/sahely_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildActionCard(),
            const SizedBox(height: 16),
            _buildSettingsList(context),
            const SizedBox(height: 32),
            SahelyButton(
              label: 'Log Out',
              variant: ButtonVariant.outline,
              onTap: () {},
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: AppColors.gold,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person, size: 40, color: AppColors.navy),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sahely User', style: AppTheme.dm(size: 20, weight: FontWeight.w700)),
            Text('user@sahely.app', style: AppTheme.dm(size: 14, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard() {
    return SahelyCard(
      color: AppColors.navy,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loyalty Points', style: AppTheme.dm(size: 12, color: Colors.white70)),
              Text('450 ★', style: AppTheme.dm(size: 18, weight: FontWeight.w700, color: AppColors.gold)),
            ],
          ),
          const Icon(Icons.chevron_right, color: AppColors.gold),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return SahelyCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSettingsTile(Icons.person_outline, 'Personal Information'),
          const Divider(height: 1),
          _buildSettingsTile(Icons.notifications_none, 'Notifications'),
          const Divider(height: 1),
          _buildSettingsTile(Icons.security, 'Security'),
          const Divider(height: 1),
          _buildSettingsTile(Icons.language, 'Language', trailing: 'English'),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {String? trailing}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.navy, size: 22),
      title: Text(title, style: AppTheme.dm(size: 14, weight: FontWeight.w600)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) 
            Text(trailing, style: AppTheme.dm(size: 13, color: AppColors.textSecondary)),
          const Icon(Icons.chevron_right, size: 18, color: AppColors.borderDefault),
        ],
      ),
      onTap: () {},
    );
  }
}
