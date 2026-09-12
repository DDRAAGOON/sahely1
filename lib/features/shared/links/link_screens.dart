import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/navigation/app_routes.dart';
import 'package:sahely/core/providers/auth_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/data/models.dart';
import 'package:sahely/data/role_state.dart';
import 'package:sahely/features/renter/data/datasources/wishlist_api_data_source.dart';
import 'package:sahely/features/renter/domain/repositories/renter_repository.dart';
import 'package:sahely/features/renter/presentation/screens/wishlist/presentation/bloc/wishlist_cubit.dart';
import 'package:sahely/features/shared/links/referral_code_store.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/features/shared/screens/property_detail_screen.dart';

// Screens behind the links people share. Android App Links, iOS universal
// links and `sahely://app/...` all hand the link's path to go_router, which
// routes it here. A signed-out user is sent to sign-in first and brought
// back to the link afterwards (see the `from` redirect in app_router.dart).

/// `/properties/:id` - a shared listing: loads it, then shows the regular
/// property page.
class PropertyLinkScreen extends StatefulWidget {
  const PropertyLinkScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<PropertyLinkScreen> createState() => _PropertyLinkScreenState();
}

class _PropertyLinkScreenState extends State<PropertyLinkScreen> {
  late Future<Property> _property = _load();

  Future<Property> _load() =>
      sl<RenterRepository>().getProperty(widget.propertyId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Property>(
      future: _property,
      builder: (context, snapshot) {
        final property = snapshot.data;
        if (property != null) {
          return PropertyDetailScreen(
            propertyId: property.id,
            propertyName: property.name,
            propertyImage: property.image,
            location: property.area,
            rating: property.rating,
            reviewCount: property.reviews,
            pricePerNight: property.price,
          );
        }
        if (snapshot.hasError) {
          return _LinkMessage(
            message: 'This listing is no longer available.',
            onRetry: () => setState(() => _property = _load()),
          );
        }
        return const _LinkLoading();
      },
    );
  }
}

/// `/wishlists/join/:token` - an invite to a shared collection: joins it,
/// then opens the wishlist tab where the collection now appears.
class JoinCollectionScreen extends StatefulWidget {
  const JoinCollectionScreen({super.key, required this.token});

  final String token;

  @override
  State<JoinCollectionScreen> createState() => _JoinCollectionScreenState();
}

class _JoinCollectionScreenState extends State<JoinCollectionScreen> {
  late Future<String> _join = _joinCollection();
  bool _opened = false;

  /// Joins and returns the collection's name.
  Future<String> _joinCollection() async {
    final data = await sl<WishlistApiDataSource>().join(widget.token);
    final wishlist = data['wishlist'] is Map
        ? Map<String, dynamic>.from(data['wishlist'] as Map)
        : data;
    return '${wishlist['name'] ?? ''}';
  }

  void _openWishlist(String name) {
    if (_opened) return;
    _opened = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<WishlistCubit>().loadCollections();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(name.isEmpty
            ? 'You joined the collection.'
            : 'You joined "$name".'),
      ));
      context.go(switch (context.read<RoleState>().currentRole) {
        Role.owner => AppRoutes.ownerWishlist,
        Role.broker => AppRoutes.brokerWishlist,
        _ => AppRoutes.renterWishlist,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _join,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _LinkMessage(
            message: 'This invite link is invalid or has expired.',
            onRetry: () => setState(() => _join = _joinCollection()),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          _openWishlist(snapshot.data ?? '');
        }
        return const _LinkLoading();
      },
    );
  }
}

/// `/join?ref=CODE` - an invite to Sahely: keeps the code for registration,
/// then continues to the welcome screen (or home when already signed in).
class ReferralLinkScreen extends StatefulWidget {
  const ReferralLinkScreen({super.key, required this.code});

  final String code;

  @override
  State<ReferralLinkScreen> createState() => _ReferralLinkScreenState();
}

class _ReferralLinkScreenState extends State<ReferralLinkScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _continue());
  }

  Future<void> _continue() async {
    await ReferralCodeStore.save(widget.code);
    if (!mounted) return;
    final signedIn = context.read<AuthProvider>().isAuthenticated;
    context.go(signedIn ? '/' : AppRoutes.welcome);
  }

  @override
  Widget build(BuildContext context) => const _LinkLoading();
}

class _LinkLoading extends StatelessWidget {
  const _LinkLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(child: CircularProgressIndicator(color: AppColors.gold)),
    );
  }
}

class _LinkMessage extends StatelessWidget {
  const _LinkMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppTheme.dm(size: 15, color: AppColors.muted)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                child: Text('Try again',
                    style: AppTheme.dm(
                        size: 14,
                        weight: FontWeight.w600,
                        color: AppColors.gold)),
              ),
              TextButton(
                onPressed: () => context.go('/'),
                child: Text('Go to home',
                    style: AppTheme.dm(size: 14, color: AppColors.navy)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
