import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/property_card.dart';
import 'package:sahely/data/sample_data.dart';

class OwnerAllTrendingScreen extends StatelessWidget {
  const OwnerAllTrendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: TopBar(
              title: 'Trending Now', subtitle: 'Top 20 most viewed this week'),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: Sample.allTrending.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (ctx, i) => PropertyCard(
              property: Sample.allTrending[i],
              onTap: () => ctx.push('/property', extra: Sample.allTrending[i]),
            ),
          ),
        ),
      ]),
    );
  }
}
