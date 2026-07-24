import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/common.dart';
import 'package:sahely/core/widgets/floating_nav.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/data/sample_data.dart';

class OwnerRequestsScreen extends StatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen> {
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Stack(children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          children: [
            const Text('Requests',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy)),
            const SizedBox(height: 12),
            SizedBox(
                height: 32,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  _chip('Pending', 0),
                  const SizedBox(width: 8),
                  _chip('Approved', 1),
                  const SizedBox(width: 8),
                  _chip('Declined', 2),
                ])),
            const SizedBox(height: 16),
            if (tab == 0) ...[
              _RequestCard(
                  name: 'Omar Khalil',
                  rating: '★ 4.9',
                  meta: 'Azure Beach Villa · 12 stays',
                  chips: const ['Jun 21–25', '4 guests · 2A 2C', 'EGP 18,000'],
                  ai: 'Strong guest — 5★ history, no violations. Low risk.',
                  onTap: () => AppNavigation.goToOwnerRequestDetail(context,
                      extra: Sample.azure)),
              const SizedBox(height: 12),
              _RequestCard(
                  name: 'Sara Mansour',
                  rating: '★ 4.6',
                  meta: 'Golden Dunes · 3 stays',
                  chips: const ['Jul 2–6', '2 guests', 'EGP 15,200'],
                  onTap: () => AppNavigation.goToOwnerRequestDetail(context,
                      extra: Sample.dunes)),
            ] else if (tab == 1) ...[
              const _StatusReqRow(
                  'Nour Adel',
                  '★ 5.0',
                  'Azure Villa · Jun 14–18',
                  'Active',
                  BadgeKind.green,
                  ['4 guests · 2A 2C', 'EGP 22,400', 'Checked in']),
              const _StatusReqRow(
                  'Omar Khalil',
                  '★ 4.9',
                  'Golden Dunes · Jun 21–25',
                  'Upcoming',
                  BadgeKind.navy,
                  ['2 guests', 'EGP 18,000', 'Pays on check-in']),
              const _StatusReqRow(
                  'Hana Tarek',
                  '★ 4.8',
                  'Golden Dunes · Jun 8–11',
                  'Done',
                  BadgeKind.gray,
                  ['2 guests', 'EGP 11,400']),
            ] else ...[
              const _StatusReqRow(
                  'Tarek Sami',
                  '★ 3.4',
                  'Azure Villa · Jul 2–6',
                  'Declined',
                  BadgeKind.red,
                  ['6 guests', 'EGP 27,000'],
                  reason: 'Reason: exceeded max guests & low guest rating.'),
              const _StatusReqRow(
                  'Mariam Saad',
                  '★ —',
                  'Golden Dunes · Aug 1–3',
                  'Declined',
                  BadgeKind.red,
                  ['2 guests', 'EGP 9,600'],
                  reason: 'Reason: dates no longer available.'),
            ],
          ],
        ),
        FloatingNav(
            active: 2,
            items: FloatingNav.ownerTabs,
            onTap: (i, _) {
              final routes = [
                '/owner/home',
                '/owner/wishlist',
                '/owner/bookings',
                '/owner/services',
                '/owner/profile'
              ];
              if (i == 0) {
                AppNavigation.safeGo(context, routes[0]);
              } else {
                AppNavigation.safeGo(context, routes[i]);
              }
            }),
      ]),
    );
  }

  Widget _chip(String label, int i) => GestureDetector(
        onTap: () => setState(() => tab = i),
        behavior: HitTestBehavior.opaque,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: tab == i ? AppColors.navy : AppColors.white,
                border: tab == i ? null : Border.all(color: AppColors.navy),
                borderRadius: BorderRadius.circular(18)),
            child: Text(label,
                style: AppTheme.dm(
                    size: 12,
                    weight: FontWeight.w600,
                    color: tab == i ? Colors.white : AppColors.navy))),
      );
}

class _RequestCard extends StatelessWidget {
  const _RequestCard(
      {required this.name,
      required this.rating,
      required this.meta,
      required this.chips,
      this.ai,
      this.onTap});

  final String name, rating, meta;
  final List<String> chips;
  final String? ai;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const AvatarCircle(
                    size: 40, colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
                const SizedBox(width: 12),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        Text(name,
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        const SizedBox(width: 6),
                        Text(rating,
                            style:
                                AppTheme.dm(size: 12, color: AppColors.muted)),
                        const SizedBox(width: 6),
                        const StatusBadge('ID ✓', kind: BadgeKind.greenSoft)
                      ]),
                      Text(meta,
                          style: AppTheme.dm(size: 12, color: AppColors.muted)),
                    ])),
                const Icon(Icons.chevron_right,
                    size: 16, color: AppColors.faint),
              ]),
              const SizedBox(height: 10),
              Wrap(spacing: 7, runSpacing: 7, children: [
                for (final c in chips)
                  Pill(c,
                      bg: const Color(0xFFF5F0E8),
                      fg: AppColors.navy,
                      radius: 10)
              ]),
              if (ai != null) ...[
                const SizedBox(height: 10),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFBF3DE),
                        border: Border.all(color: const Color(0xFFEAD9A8)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      const Icon(Icons.auto_awesome,
                          size: 16, color: AppColors.gold),
                      const SizedBox(width: 8),
                      Expanded(
                          child: RichText(
                              text: TextSpan(
                                  style: AppTheme.dm(
                                      size: 11, color: const Color(0xFF8A6A1E)),
                                  children: [
                            const TextSpan(
                                text: 'Sahely AI: ',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            TextSpan(text: ai!)
                          ])))
                    ])),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
              child: WideButton(
                  label: 'Approve',
                  color: AppColors.success,
                  height: 42,
                  onTap: () => showApprovedSheet(context))),
          const SizedBox(width: 8),
          Expanded(
              child: WideButton(
                  label: 'Decline',
                  color: const Color(0xFFB22222),
                  outline: true,
                  height: 42,
                  onTap: () => showDeclineSheet(context))),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => showBlockDialog(context, name),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.block, size: 18, color: AppColors.muted),
            ),
          ),
        ]),
      ]),
    );
  }
}

Future<void> showBlockDialog(BuildContext context, String name) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Block Guest',
          style: AppTheme.dm(
              size: 18, weight: FontWeight.w700, color: AppColors.navy)),
      content: Text(
          'Are you sure you want to block $name? They won\'t be able to book your properties anymore.',
          style: AppTheme.dm(size: 14, color: AppColors.muted)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('No',
              style: AppTheme.dm(
                  size: 14, weight: FontWeight.w600, color: AppColors.muted)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Ok',
              style: AppTheme.dm(
                  size: 14,
                  weight: FontWeight.w700,
                  color: const Color(0xFFB22222))),
        ),
      ],
    ),
  );

  if (result == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('$name has been blocked'),
          backgroundColor: AppColors.navy),
    );
  }
}

void showDeclineSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x731B2744),
    builder: (ctx) => Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.of(ctx).viewInsets.bottom + 30),
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SheetHandle(),
              const SizedBox(height: 12),
              Text('Decline Request',
                  style: AppTheme.dm(
                      size: 18,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 6),
              Text('Please select a reason for declining this booking.',
                  style: AppTheme.dm(size: 14, color: AppColors.muted)),
              const SizedBox(height: 20),
              _reasonRow(context, 'Dates no longer available'),
              _reasonRow(context, 'Exceeded maximum guests'),
              _reasonRow(context, 'Guest has low ratings'),
              _reasonRow(context, 'Other / Safety concerns'),
              const SizedBox(height: 20),
              WideButton(
                label: 'Confirm Decline',
                color: const Color(0xFFB22222),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Request declined successfully'),
                        backgroundColor: Color(0xFFB22222)),
                  );
                },
              ),
            ]),
      ),
    ),
  );
}

Widget _reasonRow(BuildContext context, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {}, // Would select in real app
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
          child: Row(children: [
            Expanded(child: Text(text, style: AppTheme.dm(size: 13))),
            const Icon(Icons.radio_button_unchecked,
                size: 18, color: AppColors.muted),
          ]),
        ),
      ),
    );

void showApprovedSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x731B2744),
    builder: (_) => Container(
      decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SheetHandle(),
        const SizedBox(height: 12),
        const SuccessCheck(size: 88),
        const SizedBox(height: 16),
        const Text('Booking Approved',
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: AppColors.navy)),
        const SizedBox(height: 8),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style:
                    AppTheme.dm(size: 14, color: AppColors.muted, height: 1.4),
                children: const [
                  TextSpan(text: 'Omar Khalil is confirmed for '),
                  TextSpan(
                      text: 'Azure Beach Villa',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, color: AppColors.ink)),
                  TextSpan(text: ' · Jun 21–25')
                ])),
        const SizedBox(height: 16),
        WhiteCard(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('Payout on check-in',
                        style: AppTheme.dm(size: 12, color: AppColors.muted)),
                    Text('EGP 18,000',
                        style: AppTheme.dm(
                            size: 16,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                  ])),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('+5 ★',
                      style: AppTheme.dm(
                          size: 12,
                          weight: FontWeight.w700,
                          color: AppColors.navy))),
            ])),
        const SizedBox(height: 16),
        GestureDetector(
            onTap: () => Navigator.pop(context),
            behavior: HitTestBehavior.opaque,
            child: Text('Done',
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: AppColors.gold))),
      ]),
    ),
  );
}

class _StatusReqRow extends StatelessWidget {
  const _StatusReqRow(
      this.name, this.rating, this.meta, this.badge, this.kind, this.chips,
      {this.reason});

  final String name, rating, meta, badge;
  final BadgeKind kind;
  final List<String> chips;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: WhiteCard(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const AvatarCircle(
                size: 38, colors: [Color(0xFF7FA8BF), Color(0xFF2C5066)]),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Text(name,
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.navy)),
                    const SizedBox(width: 6),
                    Text(rating,
                        style: AppTheme.dm(size: 12, color: AppColors.muted))
                  ]),
                  Text(meta,
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ])),
            StatusBadge(badge, kind: kind, dot: kind == BadgeKind.green),
          ]),
          const SizedBox(height: 10),
          Wrap(spacing: 7, runSpacing: 7, children: [
            for (final c in chips)
              Pill(c,
                  bg: const Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10)
          ]),
          if (reason != null) ...[
            const SizedBox(height: 8),
            Text(reason!,
                style: AppTheme.dm(size: 12, color: const Color(0xFFB22222)))
          ],
        ]),
      ),
    );
  }
}

class OwnerRequestDetailScreen extends StatelessWidget {
  const OwnerRequestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    final prop = extra is Property
        ? extra
        : extra is Map
            ? Property.fromMap(Map<String, dynamic>.from(extra))
            : Sample.azure;

    return PhoneScaffold(
      child: Column(children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            children: [
              const TopBar(title: 'Booking Request'),
              const SizedBox(height: 16),
              WhiteCard(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  const AvatarCircle(
                      size: 72, colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
                  const SizedBox(height: 10),
                  Text('Omar Khalil',
                      style: AppTheme.dm(
                          size: 18,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                  Text('★ 4.9 · 12 stays · 8 reviews',
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  const SizedBox(height: 8),
                  const StatusBadge('ID Verified', kind: BadgeKind.greenSoft),
                  const SizedBox(height: 12),
                  const WideButton(
                      label: 'View full profile & reviews',
                      color: AppColors.navy,
                      outline: true,
                      height: 44),
                ]),
              ),
              const SizedBox(height: 14),
              WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(children: [
                    KeyValueRow('Property', prop.name),
                    const KeyValueRow('Dates', 'Jun 21 – 25 · 4 nights'),
                    const KeyValueRow('Guests', '4 · 2 adults, 2 children'),
                    const KeyValueRow('Children ages', '9 & 6'),
                    const KeyValueRow('Order no.', 'SHLY-8842'),
                    const KeyValueRow('Payout', 'EGP 18,000',
                        valueColor: AppColors.success,
                        bold: true,
                        topBorder: true),
                  ])),
              const SizedBox(height: 14),
              Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFDF9F4),
                      border: Border.all(color: const Color(0xFFE7D9A8)),
                      borderRadius: BorderRadius.circular(12)),
                  child: RichText(
                      text: TextSpan(
                          style: AppTheme.dm(
                              size: 13, color: AppColors.ink, height: 1.4),
                          children: const [
                        TextSpan(text: 'Note from guest: '),
                        TextSpan(
                            text:
                                'Traveling with two kids, would love an early check-in if possible. Thank you!',
                            style: TextStyle(fontWeight: FontWeight.w700))
                      ]))),
              const SizedBox(height: 16),
              const SectionLabel('WHAT HOSTS SAY ABOUT OMAR'),
              const SizedBox(height: 8),
              WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          for (var i = 0; i < 5; i++)
                            const Icon(Icons.star,
                                size: 13, color: AppColors.gold),
                          const SizedBox(width: 8),
                          Text('Layla M.',
                              style: AppTheme.dm(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy))
                        ]),
                        const SizedBox(height: 8),
                        const Text(
                            'Spotless and respectful guest. Highly recommend.',
                            style:
                                TextStyle(fontSize: 13, color: AppColors.ink)),
                      ])),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
                child: WideButton(
                    label: 'Decline',
                    color: const Color(0xFFB22222),
                    outline: true,
                    height: 50,
                    radius: 12,
                    onTap: () => showDeclineSheet(context))),
            const SizedBox(width: 10),
            Expanded(
                flex: 2,
                child: WideButton(
                    label: 'Approve Booking',
                    color: AppColors.success,
                    height: 50,
                    radius: 12,
                    onTap: () => showApprovedSheet(context))),
          ]),
        ),
      ]),
    );
  }
}
