import 'package:flutter/material.dart';
import '../../../data/sample_data.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/property_card.dart';

class OwnerAllTrendingScreen extends StatelessWidget {
  const OwnerAllTrendingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: TopBar(title: 'Trending Now', subtitle: 'Top 20 most viewed this week'),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: Sample.allTrending.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (ctx, i) => PropertyCard(
              property: Sample.allTrending[i],
              onTap: () => Navigator.pushNamed(ctx, '/property', arguments: Sample.allTrending[i]),
            ),
          ),
        ),
      ]),
    );
  }
}
