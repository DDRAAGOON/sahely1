import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/providers/profile_provider.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../widgets/account_verification_section.dart';
import '../widgets/bio_card.dart';
import '../widgets/logout_button.dart';
import '../widgets/mawsem_level_badge.dart';
import '../widgets/mawsem_season_pass_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_list_rows.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    return BlocBuilder<VerificationCubit, VerificationCubitState>(
      builder: (context, state) {
        final verificationData =
            context.read<VerificationCubit>().currentDataState;

        return Container(
          color: AppColors.cream,
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                // Profile Header
                SliverToBoxAdapter(
                  child: ProfileHeader(
                    name: profile.name,
                    email: profile.email,
                    localAvatarPath: profile.avatarPath,
                    isVerified: verificationData.isComplete,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Bio Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BioCard(
                      bio: profile.bio,
                      instagramHandle: profile.instagram,
                      tiktokHandle: profile.tiktok,
                      facebookHandle: profile.facebook,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // MAWSEM Level Badge
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MawsemLevelBadge(
                      levelName: profile.levelData['name'],
                      levelNumber: profile.currentLevel,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // AL MAWSEM Season Pass Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: MawsemSeasonPassCard(
                      levelName: profile.levelData['name'],
                      starsCount: profile.stars,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // Account Verification Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AccountVerificationSection(
                      emailConfirmed: verificationData.emailVerified,
                      phoneVerified: verificationData.phoneVerified,
                      identityVerified: verificationData.idVerified,
                      paymentCardAdded: verificationData.cardAdded,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Profile List Rows
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ProfileListRows(
                      walletBalance: 250,
                      reviewsGiven: profile.reviewsGiven,
                      reviewsReceived: profile.reviewsReceived,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 16)),

                // Logout Button
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LogoutButton(),
                  ),
                ),

                // Bottom spacing for nav
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        );
      },
    );
  }
}
