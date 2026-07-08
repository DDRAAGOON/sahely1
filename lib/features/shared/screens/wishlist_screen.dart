import 'package:flutter/material.dart';
import '../../../data/wishlist_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/floating_nav.dart';
import '../../../core/widgets/property_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(
        children: [
          ListenableBuilder(
            listenable: WishlistState(),
            builder: (context, _) {
              final savedOnes = WishlistState().savedProperties;

              if (savedOnes.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Wishlist', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                            Text('0 places saved', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                          ]),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite_border, size: 72, color: AppColors.faint.withValues(alpha: 0.2)),
                            const SizedBox(height: 20),
                            Text('No places saved yet',
                                style: AppTheme.dm(size: 17, weight: FontWeight.w600, color: AppColors.muted)),
                            const SizedBox(height: 8),
                            Text('Tap the heart icon on any property to save it here.',
                                textAlign: TextAlign.center, style: AppTheme.dm(size: 14, color: AppColors.faint)),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Saved', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                        Text('${savedOnes.length} places saved', style: AppTheme.dm(size: 13, color: AppColors.muted)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 24),
                  for (final p in savedOnes) ...[
                    PropertyCard(property: p, onTap: () => Navigator.pushNamed(context, '/property', arguments: p)),
                    const SizedBox(height: 16),
                  ],
                ],
              );
            },
          ),
          const FloatingNav(active: 1),
        ],
      ),
    );
  }
}
