import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sahely/l10n/app_localizations.dart';

/// Opens the listing's real position in Maps. Hidden for a listing the
/// backend has no coordinates for.
class MapTeaser extends StatelessWidget {
  const MapTeaser({super.key, this.latitude, this.longitude, this.label = ''});

  final double? latitude;
  final double? longitude;

  /// Falls back to a place search when only a name is known.
  final String label;

  @override
  Widget build(BuildContext context) {
    final lat = latitude;
    final lng = longitude;
    final hasPoint = lat != null && lng != null && (lat != 0 || lng != 0);
    if (!hasPoint && label.trim().isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).locationTitle,
              style: AppTheme.dm(
                size: 16,
                weight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final query =
                    hasPoint ? '$lat,$lng' : Uri.encodeComponent(label);
                final Uri url = Uri.parse(
                  'https://www.google.com/maps/search/?api=1&query=$query',
                );
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFB8D4E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Stack(
                  children: [
                    Center(
                      child: Icon(Icons.location_on,
                          color: AppColors.red, size: 40),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Icon(Icons.open_in_new,
                          color: AppColors.navy, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
