import 'package:flutter/material.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/price.dart';
import 'package:sahely/core/widgets/ratings.dart';
import 'package:sahely/core/widgets/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/core/di/service_locator.dart';
import 'package:sahely/features/broker/domain/entities/broker_portfolio.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/bloc/broker_portfolio_cubit.dart';
import 'package:sahely/features/broker/presentation/screens/portfolio/bloc/broker_portfolio_state.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

class BrokerPortfolioPage extends StatelessWidget {
  const BrokerPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BrokerPortfolioCubit>()..loadPortfolio(),
      child: const _BrokerPortfolioView(),
    );
  }
}

class _BrokerPortfolioView extends StatefulWidget {
  const _BrokerPortfolioView();

  @override
  State<_BrokerPortfolioView> createState() => _BrokerPortfolioViewState();
}

class _BrokerPortfolioViewState extends State<_BrokerPortfolioView> {
  int _selectedTab = 0; // 0: All, 1: Active, 2: Not listed

  /// Tab 0 shows everything, tab 1 only live listings, tab 2 the rest.
  List<Property> _visible(List<Property> all) {
    return switch (_selectedTab) {
      1 => all.where((p) => p.status == PropertyStatus.active).toList(),
      2 => all.where((p) => p.status != PropertyStatus.active).toList(),
      _ => all,
    };
  }

  /// The chips a card shows, built from the fields the API actually returns.
  List<String> _tags(Property p) => [
        p.type,
        '${p.guests} Guests',
        if (p.beds > 0) '${p.beds} Beds',
        if (p.minutesToBeach != null) '${p.minutesToBeach} min to beach',
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: BlocBuilder<BrokerPortfolioCubit, BrokerPortfolioState>(
          builder: (context, state) {
            final portfolio = state is BrokerPortfolioLoaded
                ? state.portfolio
                : const BrokerPortfolio(
                    totalCount: 0,
                    activeCount: 0,
                    notListedCount: 0,
                    properties: [],
                  );
            final visible = _visible(portfolio.properties);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              children: [
                TopBar(
                  title: 'Referred Properties',
                  subtitle: '${portfolio.activeCount} accepted · guest-ready',
                  onBack: () => Navigator.pop(context),
                ),
                const SizedBox(height: 12),
                Text(
                    'Only properties accepted by Sahely and live for guests appear here — with the details renters see.',
                    style: AppTheme.dm(size: 12, color: AppColors.muted)),
                const SizedBox(height: 16),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ChoiceChipPill(
                        'All ${portfolio.totalCount}',
                        selected: _selectedTab == 0,
                        height: 38,
                        onTap: () => setState(() => _selectedTab = 0),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChipPill(
                        'Active ${portfolio.activeCount}',
                        selected: _selectedTab == 1,
                        height: 38,
                        onTap: () => setState(() => _selectedTab = 1),
                      ),
                      const SizedBox(width: 8),
                      ChoiceChipPill(
                        'Not listed ${portfolio.notListedCount}',
                        selected: _selectedTab == 2,
                        height: 38,
                        onTap: () => setState(() => _selectedTab = 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (state is BrokerPortfolioLoading ||
                    state is BrokerPortfolioInitial)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    ),
                  )
                else if (state is BrokerPortfolioError)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(state.message,
                          textAlign: TextAlign.center,
                          style: AppTheme.dm(color: AppColors.muted)),
                    ),
                  )
                else
                  for (final p in visible) ...[
                    _refCard(
                      context,
                      p,
                      p.image,
                      p.name,
                      p.area,
                      p.rating,
                      p.reviews,
                      p.price,
                      _tags(p),
                      isLive: p.status == PropertyStatus.active,
                    ),
                    const SizedBox(height: 16),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _refCard(
          BuildContext context,
          Property property,
          String img,
          String name,
          String area,
          double rating,
          int reviews,
          int price,
          List<String> tags,
          {bool isLive = true}) =>
      GestureDetector(
        onTap: () =>
            AppNavigation.goToBrokerReferredDetail(context, extra: property),
        behavior: HitTestBehavior.opaque,
        child: WhiteCard(
          padding: EdgeInsets.zero,
          radius: 18,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Stack(fit: StackFit.expand, children: [
                    AppNetworkImage(
                        url: img,
                        errorWidget: (_, __, ___) =>
                            const ColoredBox(color: AppColors.cardWarm)),
                    DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6)
                        ]))),
                    Positioned(
                        top: 12,
                        right: 12,
                        child: StatusBadge(
                            isLive ? 'Accepted · Live' : 'Review Pending',
                            kind: isLive ? BadgeKind.green : BadgeKind.orange,
                            dot: isLive)),
                    Positioned(
                        left: 14,
                        bottom: 12,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name,
                                  style: AppTheme.dm(
                                      size: 16,
                                      weight: FontWeight.w700,
                                      color: Colors.white)),
                              Text(area,
                                  style: AppTheme.dm(
                                      size: 11, color: Colors.white70)),
                            ])),
                  ])),
              Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child:
                                    RatingRow(rating: rating, reviews: reviews),
                              ),
                              const SizedBox(width: 8),
                              PriceTag(price: price)
                            ]),
                        const SizedBox(height: 12),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          for (final t in tags)
                            Pill(t,
                                border: AppColors.border, fg: AppColors.muted)
                        ]),
                      ])),
            ]),
          ),
        ),
      );
}
