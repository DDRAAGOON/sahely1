import 'package:flutter/material.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/listing_issue_header.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/issue_alert_card.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/property_info_card.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/what_team_needs_section.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/sahely_ai_suggestion.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/why_not_listed_section.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/status_cards_row.dart';
import 'package:sahely/features/broker/presentation/screens/listing_issue/widgets/contact_owner_card.dart';

class ListingIssueScreen extends StatelessWidget {
  const ListingIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final issueData = {
      'title': 'Needs better photos',
      'flaggedBy': 'Flagged by review team',
      'propertyName': 'Marina Loft',
      'propertyType': 'Apartment',
      'location': 'Marina',
      'referralCode': 'KARIM-4821',
      'propertyImage': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=400',
      'teamNeeds': [
        'Daylight photos of the living room',
        'Balcony & sea-view shot',
        'Compound layout with unit marked',
      ],
      'aiSuggestion':
      'Reach out to Tarek — a quick morning re-shoot usually clears this within a day.',
      'whyNotListed':
      'The review team paused this listing because the current photos don\'t meet Sahely\'s quality bar — they\'re low-light and don\'t show the full space, so guests can\'t see what they\'re booking. The listing stays offline until the items above are added and it passes a re-review (about 24h). No commission is earned while a referred property is offline.',
      'status': 'Offline',
      'reReviewTime': '~24h',
      'ownerName': 'Tarek S.',
    };

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              const ListingIssueHeader(
                title: 'Listing Issue',
              ),

              const SizedBox(height: 16),

              // Issue Alert Card
              IssueAlertCard(
                title: issueData['title']?.toString() ?? '',
                flaggedBy: issueData['flaggedBy']?.toString() ?? '',
                flaggedDate: issueData['flaggedDate']?.toString() ?? '',
              ),

              const SizedBox(height: 16),

              // Property Info Card
              PropertyInfoCard(
                propertyName: issueData['propertyName']?.toString() ?? '',
                propertyType: issueData['propertyType']?.toString() ?? '',
                location: issueData['location']?.toString() ?? '',
                referralCode: issueData['referralCode']?.toString() ?? '',
                imageUrl: issueData['propertyImage']?.toString() ?? '',
              ),

              const SizedBox(height: 24),

              // What the team needs
              WhatTeamNeedsSection(
                needs: List<String>.from(issueData['teamNeeds'] as List),
              ),

              const SizedBox(height: 16),

              // Sahely AI Suggestion
              SahelyAiSuggestion(
                suggestion: issueData['aiSuggestion']?.toString() ?? '',
              ),

              const SizedBox(height: 24),

              // Why it isn't listed yet
              WhyNotListedSection(
                explanation: issueData['whyNotListed']?.toString() ?? '',
              ),

              const SizedBox(height: 24),

              // Status Cards Row
              StatusCardsRow(
                status: issueData['status']?.toString() ?? '',
                flaggedDate: issueData['flaggedDate']?.toString() ?? '',
                reReviewTime: issueData['reReviewTime']?.toString() ?? '',
              ),

              const SizedBox(height: 16),

              // Contact Owner Card
              ContactOwnerCard(
                ownerName: issueData['ownerName']?.toString() ?? '',
                onTap: () {
                  // Contact owner (call/message)
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
