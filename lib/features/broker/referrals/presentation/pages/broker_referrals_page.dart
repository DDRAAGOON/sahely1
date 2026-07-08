import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/inputs/sahely_text_field.dart';
import '../../../../shared/widgets/inputs/field_group.dart';
import '../../../../shared/widgets/buttons/sahely_button.dart';

class BrokerReferralsPage extends StatelessWidget {
  const BrokerReferralsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Refer a Property', style: AppTheme.dm(size: 20, weight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Earn stars and commission for every property you refer that gets listed.',
              style: AppTheme.dm(size: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            const FieldGroup(
              label: 'Owner Full Name',
              child: SahelyTextField(hintText: 'Enter owner name'),
            ),
            const SizedBox(height: 20),
            const FieldGroup(
              label: 'Owner Phone Number',
              child: SahelyTextField(hintText: '+20 1XX XXX XXXX'),
            ),
            const SizedBox(height: 20),
            const FieldGroup(
              label: 'Property Area',
              child: SahelyTextField(hintText: 'e.g., Marassi, Hacienda...'),
            ),
            const SizedBox(height: 32),
            SahelyButton(
              label: 'Submit Referral',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
