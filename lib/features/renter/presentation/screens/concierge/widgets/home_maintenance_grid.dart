import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';

class HomeMaintenanceGrid extends StatelessWidget {
  final Function(String) onRequest;

  const HomeMaintenanceGrid({
    super.key,
    required this.onRequest,
  });

  static const List<Map<String, dynamic>> _services = [
    {'icon': Icons.cleaning_services, 'label': 'Cleaning'},
    {'icon': Icons.bolt, 'label': 'Electrical'},
    {'icon': Icons.plumbing, 'label': 'Plumbing'},
    {'icon': Icons.window, 'label': 'Roller Shutter'},
    {'icon': Icons.local_fire_department, 'label': 'Gas & Stove'},
    {'icon': Icons.security, 'label': 'Security Check'},
    {'icon': Icons.ac_unit, 'label': 'AC & Cooling'},
    {'icon': Icons.beach_access, 'label': 'Beach Access'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Home & Maintenance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.navy,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 16),

        // 4-column grid
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          // إزالة الـ padding الافتراضي
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85, // تعديل النسبة لتقليل الارتفاع الزيادة
          ),
          itemCount: _services.length,
          itemBuilder: (context, index) {
            return _ServiceTile(
              icon: _services[index]['icon'],
              label: _services[index]['label'],
              onTap: () =>
                  _showServiceSheet(context, _services[index]['label']),
            );
          },
        ),
      ],
    );
  }

  void _showServiceSheet(BuildContext context, String serviceName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                serviceName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'DM Sans',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Service details and booking options will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary,
                  fontFamily: 'DM Sans',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onRequest(serviceName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Request Service',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Icon tile
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                icon,
                size: 24,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Label
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.dark,
              fontFamily: 'DM Sans',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
