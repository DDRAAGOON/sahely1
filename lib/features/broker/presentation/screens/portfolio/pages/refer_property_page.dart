import 'package:flutter/material.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/widgets/refer_property_header.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/widgets/refer_property_input.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/widgets/refer_property_dropdown.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/widgets/copy_referral_link_button.dart';

class ReferPropertyPage extends StatefulWidget {
  const ReferPropertyPage({super.key});

  @override
  State<ReferPropertyPage> createState() => _ReferPropertyPageState();
}

class _ReferPropertyPageState extends State<ReferPropertyPage> {
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _propertyNameController = TextEditingController();
  String? _selectedArea;

  final List<String> _areas = [
    'Marassi',
    'Hacienda Bay',
    'Hacienda White',
    'Seashell',
    'Amwaj',
    'Telal',
    'Marina',
  ];

  @override
  void dispose() {
    _ownerNameController.dispose();
    _phoneController.dispose();
    _propertyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              children: [
                const TopBar(title: ''),
                const SizedBox(height: 8),
                const ReferPropertyHeader(),
                const SizedBox(height: 24),
                
                ReferPropertyInput(
                  label: 'Owner Name',
                  hint: 'Full name',
                  controller: _ownerNameController,
                ),
                const SizedBox(height: 16),
                
                ReferPropertyInput(
                  label: 'Phone',
                  hint: '+20 ...',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                
                ReferPropertyInput(
                  label: 'Property Name',
                  hint: 'Property name',
                  controller: _propertyNameController,
                ),
                const SizedBox(height: 16),
                
                ReferPropertyDropdown(
                  label: 'Location Area',
                  value: _selectedArea,
                  items: _areas,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedArea = newValue;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                CopyReferralLinkButton(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral link copied to clipboard')),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: NavyButton(
              label: 'Submit Referral',
              onTap: () {
                // Handle submission
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
