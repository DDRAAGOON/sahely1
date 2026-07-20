import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class EditProfileForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final DateTime? selectedDob;
  final ValueChanged<DateTime> onDobSelected;

  const EditProfileForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.selectedDob,
    required this.onDobSelected,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDob ?? DateTime(now.year - 18),
      firstDate: DateTime(1950),
      lastDate: now.subtract(const Duration(days: 365 * 13)),
      // Min 13 years
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.navy,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.dark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDobSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First Name
        _buildTextField(
          controller: firstNameController,
          label: 'First Name',
          hintText: 'Enter your first name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'First name is required';
            }
            if (value.trim().length < 2) {
              return 'First name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Last Name
        _buildTextField(
          controller: lastNameController,
          label: 'Last Name',
          hintText: 'Enter your last name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Last name is required';
            }
            if (value.trim().length < 2) {
              return 'Last name must be at least 2 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Date of Birth
        _buildDateOfBirthField(context),
        const SizedBox(height: 8),
        const Text(
          'For birthday surprises 🎁',
          style: TextStyle(
            fontSize: 11,
            color: AppColors.secondary,
            fontFamily: 'DM Sans',
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.placeholder,
              fontFamily: 'DM Sans',
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.gold, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
          ),
          validator: validator,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.dark,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedDob != null ? AppColors.gold : AppColors.border,
                width: selectedDob != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.gold,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedDob != null
                        ? _formatDate(selectedDob!)
                        : 'Select your date of birth',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDob != null
                          ? AppColors.dark
                          : AppColors.placeholder,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
