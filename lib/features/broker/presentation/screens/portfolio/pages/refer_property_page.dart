import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/cream_background.dart';
import '../../../../../../core/widgets/kit.dart';
import '../../../../../../core/widgets/ui.dart';

class ReferPropertyPage extends StatefulWidget {
  const ReferPropertyPage({super.key});

  @override
  State<ReferPropertyPage> createState() => _ReferPropertyPageState();
}

class _ReferPropertyPageState extends State<ReferPropertyPage> {
  final _ownerController = TextEditingController();
  final _phoneController = TextEditingController();
  final _propertyController = TextEditingController();
  String? _selectedArea;

  @override
  void dispose() {
    _ownerController.dispose();
    _phoneController.dispose();
    _propertyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 16),
            children: [
              const Align(alignment: Alignment.centerLeft, child: BackChip()),
              const SizedBox(height: 16),
              Text('Refer a Property',
                  style: AppTheme.dm(
                      size: 22,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 6),
              Text(
                  'Refer a property owner and earn commissions on every booking',
                  style: AppTheme.dm(size: 14, color: AppColors.muted)),
              const SizedBox(height: 20),
              FieldGroup(
                  label: 'Owner Name',
                  child: AppTextField(
                      controller: _ownerController,
                      hintText: 'Full name',
                      height: 50)),
              const SizedBox(height: 14),
              FieldGroup(
                  label: 'Phone',
                  child: AppTextField(
                      controller: _phoneController,
                      hintText: '+20 ...',
                      height: 50,
                      keyboardType: TextInputType.phone)),
              const SizedBox(height: 14),
              FieldGroup(
                  label: 'Property Name',
                  child: AppTextField(
                      controller: _propertyController,
                      hintText: 'Property name',
                      height: 50)),
              const SizedBox(height: 14),
              FieldGroup(
                label: 'Location Area',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedArea,
                      hint: Text('Select area',
                          style: AppTheme.dm(size: 14, color: AppColors.faint)),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          size: 18, color: AppColors.muted),
                      items: [
                        'Marassi',
                        'Hacienda Bay',
                        'Telal',
                        'Amwaj',
                        'Seashell'
                      ]
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, style: AppTheme.dm(size: 14))))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedArea = v),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Referral link copied to clipboard')),
                  );
                },
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppColors.gold, width: 1.5),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.link, size: 18, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Text('Copy My Referral Link',
                        style: AppTheme.dm(
                            size: 15,
                            weight: FontWeight.w700,
                            color: AppColors.gold)),
                  ])),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: NavyButton(
              label: 'Submit Referral',
              onTap: () => Navigator.maybePop(context)),
        ),
      ]),
    );
  }
}
