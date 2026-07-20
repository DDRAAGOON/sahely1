import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/collection_strip.dart';
import '../widgets/compare_header.dart';
import '../widgets/compare_input_bar.dart';
import '../widgets/property_comparison_bar.dart';

class CollectionCompareScreen extends StatelessWidget {
  final String collectionName;
  final List<String> participantNames;

  const CollectionCompareScreen({
    super.key,
    required this.collectionName,
    required this.participantNames,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            CompareHeader(
              collectionName: collectionName,
              participantNames: participantNames,
              onBackTap: () => Navigator.pop(context),
            ),

            const SizedBox(height: 12),

            // VS Comparison Bar
            const PropertyComparisonBar(
              property1: PropertyCompareData(
                name: 'Azure',
                rating: 4.8,
                price: 4500,
                imageUrl:
                    'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=400',
              ),
              property2: PropertyCompareData(
                name: 'Lagoon',
                rating: 4.9,
                price: 6200,
                imageUrl:
                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
              ),
            ),

            const SizedBox(height: 16),

            // Chat Thread
            const Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Omar's message
                    ChatMessageBubble(
                      userName: 'Omar',
                      avatarColor: AppColors.gold,
                      message:
                          'Azure has the better pool but Lagoon is closer to the water.',
                      isAI: false,
                    ),
                    SizedBox(height: 12),
                    // Nour's message
                    ChatMessageBubble(
                      userName: 'Nour',
                      avatarColor: AppColors.navy,
                      message:
                          'Agreed — and Lagoon sleeps one more. Worth the extra?',
                      isAI: false,
                    ),
                    SizedBox(height: 12),
                    // Sahely AI message
                    ChatMessageBubble(
                      userName: 'Sahely AI',
                      avatarColor: AppColors.gold,
                      message:
                          'Quick compare: Lagoon — +0.1★, sleeps 8, 3 min to beach. Azure — private pool, -EGP 1,700/night. For a beach-first group, Lagoon wins.',
                      isAI: true,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Collection Strip
            const CollectionStrip(
              collectionName: 'collection',
              propertyThumbnails: [
                'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=200',
                'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=200',
                'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=200',
              ],
            ),

            // Input Bar
            CompareInputBar(
              onSendMessage: (message) {
                // Handle message
              },
              onAskAI: (question) {
                // Handle AI question
              },
            ),
          ],
        ),
      ),
    );
  }
}
