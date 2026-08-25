import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';

class OwnerRequestsScreen extends StatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen> {
  int _activeTab = 0; // 0: Pending, 1: Approved, 2: Declined

  void _showDeclineBottomSheet(String name) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: AppColors.borderDefault,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context).declineRequest,
                style: AppTheme.dm(
                    size: 20, weight: FontWeight.w700, color: AppColors.navy)),
            const SizedBox(height: 8),
            Text('Please provide a reason for declining $name\'s request.',
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'e.g. Unit is undergoing maintenance...',
                  border: InputBorder.none,
                ),
                style: AppTheme.dm(size: 14),
              ),
            ),
            const SizedBox(height: 24),
            NavyButton(
              label: AppLocalizations.of(context).confirmDecline,
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request for $name declined')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(AppLocalizations.of(context).blockRenter,
            style: AppTheme.dm(
                size: 18, weight: FontWeight.w700, color: AppColors.navy)),
        content: Text(
            'Are you sure you want to block $name? They won\'t be able to request your properties anymore.',
            style: AppTheme.dm(size: 14, color: AppColors.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).cancel,
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w600, color: AppColors.muted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name has been blocked')),
              );
            },
            child: Text(AppLocalizations.of(context).blockLabel,
                style: AppTheme.dm(
                    size: 14, weight: FontWeight.w700, color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PhoneScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TopBar(
              title: AppLocalizations.of(context).requestsTitle,
              onBack: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _tab(0, 'Pending'),
                const SizedBox(width: 10),
                _tab(1, 'Approved'),
                const SizedBox(width: 10),
                _tab(2, 'Declined'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: ListView(
                key: ValueKey<int>(_activeTab),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                children: _buildContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(int i, String label) {
    final active = _activeTab == i;
    return BouncyButton(
      onTap: () => setState(() => _activeTab = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.navy : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: active ? null : Border.all(color: AppColors.borderDefault),
        ),
        child: Text(label,
            style: AppTheme.dm(
                size: 13,
                weight: FontWeight.w600,
                color: active ? Colors.white : AppColors.navy)),
      ),
    );
  }

  List<Widget> _buildContent() {
    if (_activeTab == 0) return _buildPending();
    if (_activeTab == 1) return _buildApproved();
    return _buildDeclined();
  }

  Widget _pendingItem(String name, String rating, bool verified, String unit,
      String stays, String dates, String guests, String price,
      {String? aiInsight}) {
    return BouncyButton(
      onTap: () => AppNavigation.goToOwnerRequestDetail(context, extra: {
        'guestName': name,
        'rating': rating,
        'verified': verified,
        'propertyName': unit,
        'stays': stays,
        'dates': dates,
        'total': price,
        'guests': guests,
        'aiInsight': aiInsight,
        'status': 'Pending',
      }),
      child: _PendingRequestCard(
        name: name,
        rating: rating,
        verified: verified,
        unit: unit,
        stays: stays,
        dates: dates,
        guests: guests,
        price: price,
        aiInsight: aiInsight,
        onApprove: () => ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Request approved'))),
        onDecline: () => _showDeclineBottomSheet(name),
        onBlock: () => _showBlockConfirmation(name),
      ),
    );
  }

  List<Widget> _buildPending() {
    return [
      _pendingItem(
        'Omar Khalil',
        '4.9',
        true,
        'Azure Beach Villa',
        '12 stays',
        'Jun 21–25',
        '4 guests · 2A 2C',
        '18,000',
        aiInsight: 'Strong guest — 5★ history, no violations. Low risk.',
      ),
      const SizedBox(height: 16),
      _pendingItem(
        'Sara Mansour',
        '4.6',
        false,
        'Golden Dunes',
        '3 stays',
        'Jul 2–6',
        '2 guests',
        '15,200',
      ),
    ];
  }

  Widget _approvedItem(String name, String rating, bool verified, String unit,
      String dates, String guests, String price, String status,
      {String? statusNote}) {
    return BouncyButton(
      onTap: () => AppNavigation.goToOwnerRequestDetail(context, extra: {
        'guestName': name,
        'rating': rating,
        'verified': verified,
        'propertyName': unit,
        'dates': dates,
        'total': price,
        'guests': guests,
        'status': status,
        'statusNote': statusNote,
      }),
      child: _ApprovedRequestCard(
        name: name,
        rating: rating,
        verified: verified,
        unit: unit,
        dates: dates,
        guests: guests,
        price: price,
        status: status,
        statusNote: statusNote,
      ),
    );
  }

  List<Widget> _buildApproved() {
    return [
      _approvedItem(
        'Nour Adel',
        '5.0',
        true,
        'Azure Villa',
        'Jun 14–18',
        '4 guests · 2A 2C',
        '22,400',
        'Active',
        statusNote: 'Checked in',
      ),
      const SizedBox(height: 16),
      _approvedItem(
        'Omar Khalil',
        '4.9',
        true,
        'Golden Dunes',
        'Jun 21–25',
        '2 guests',
        '18,000',
        'Upcoming',
        statusNote: 'Pays on check-in',
      ),
      const SizedBox(height: 16),
      _approvedItem(
        'Hana Tarek',
        '4.8',
        true,
        'Golden Dunes',
        'Jun 8–11',
        '2 guests',
        '11,400',
        'Done',
      ),
    ];
  }

  Widget _declinedItem(String name, String? rating, bool verified, String unit,
      String dates, String guests, String price, String reason) {
    return BouncyButton(
      onTap: () => AppNavigation.goToOwnerRequestDetail(context, extra: {
        'guestName': name,
        'rating': rating,
        'verified': verified,
        'propertyName': unit,
        'dates': dates,
        'total': price,
        'guests': guests,
        'status': 'Declined',
        'reason': reason,
      }),
      child: _DeclinedRequestCard(
        name: name,
        rating: rating,
        verified: verified,
        unit: unit,
        dates: dates,
        guests: guests,
        price: price,
        reason: reason,
      ),
    );
  }

  List<Widget> _buildDeclined() {
    return [
      _declinedItem(
        'Tarek Sami',
        '3.4',
        true,
        'Azure Villa',
        'Jul 2–6',
        '6 guests',
        '27,000',
        'Reason: exceeded max guests & low guest rating.',
      ),
      const SizedBox(height: 16),
      _declinedItem(
        'Mariam Saad',
        null,
        true,
        'Golden Dunes',
        'Aug 1–3',
        '2 guests',
        '9,600',
        'Reason: dates no longer available.',
      ),
    ];
  }
}

class OwnerRequestDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const OwnerRequestDetailScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    // 1. Determine data from either constructor or context extra
    Map<String, dynamic> rawData = {};
    if (data != null && data!.isNotEmpty) {
      rawData = data!;
    } else {
      try {
        final state = GoRouterState.of(context);
        if (state.extra is Map<String, dynamic>) {
          rawData = state.extra as Map<String, dynamic>;
        }
      } catch (_) {}
    }

    // 2. Fallback to mock data ONLY if everything is empty
    final bool isEmpty = rawData.isEmpty;
    final Map<String, dynamic> effectiveData = isEmpty
        ? {
            'guestName': 'Omar Khalil',
            'rating': '4.9',
            'verified': true,
            'propertyName': 'Azure Beach Villa',
            'stays': '12 stays',
            'dates': 'Jun 21–25',
            'total': '18,000',
            'guests': '4 guests · 2A 2C',
            'status': 'Pending',
            'aiInsight': 'Strong guest — 5★ history, no violations. Low risk.',
          }
        : rawData;

    final name = effectiveData['guestName'] ?? 'Guest';
    final property = effectiveData['propertyName'] ?? 'Property';
    final dates = effectiveData['dates'] ?? 'N/A';
    final total = effectiveData['total'] ?? '0';
    final guests = effectiveData['guests'] ?? 'N/A';
    final rating = (effectiveData['rating'] ?? '—').toString();
    final verified = effectiveData['verified'] ?? false;
    final status = effectiveData['status'] ?? 'Pending';
    final aiInsight = effectiveData['aiInsight'];

    return PhoneScaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TopBar(
              title: AppLocalizations.of(context).requestDetails,
              onBack: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              children: [
                // Guest Header
                WhiteCard(
                  padding: const EdgeInsets.all(20),
                  radius: 20,
                  child: Column(
                    children: [
                      const AvatarCircle(
                          size: 72,
                          colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)]),
                      const SizedBox(height: 16),
                      Text(name,
                          style: AppTheme.dm(
                              size: 20,
                              weight: FontWeight.w800,
                              color: AppColors.navy)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: AppColors.gold),
                          const SizedBox(width: 4),
                          Text(rating,
                              style: AppTheme.dm(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: AppColors.gold)),
                          if (verified) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD7EEDD),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Row(
                                children: [
                                  Text(AppLocalizations.of(context).verifiedBadge,
                                      style: AppTheme.dm(
                                          size: 10,
                                          weight: FontWeight.w900,
                                          color: AppColors.success)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.check,
                                      size: 12, color: AppColors.success),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Booking Info
                Text(AppLocalizations.of(context).bookingInfo,
                    style: AppTheme.dm(
                        size: 15,
                        weight: FontWeight.w700,
                        color: AppColors.navy)),
                const SizedBox(height: 12),
                WhiteCard(
                  padding: const EdgeInsets.all(20),
                  radius: 20,
                  child: Column(
                    children: [
                      _infoRow('Property', property, Icons.home_work_outlined),
                      const Divider(height: 32),
                      _infoRow('Dates', dates, Icons.calendar_today_outlined),
                      const Divider(height: 32),
                      _infoRow('Guests', guests, Icons.people_outline),
                      const Divider(height: 32),
                      _infoRow('Total Payout', 'EGP $total',
                          Icons.monetization_on_outlined,
                          valueColor: AppColors.navy),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // AI Insight if Pending
                if (status == 'Pending' && aiInsight != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF3DE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFE4C56A).withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.auto_awesome,
                            size: 20, color: Color(0xFFD8B95D)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context).aiInsight,
                                  style: AppTheme.dm(
                                      size: 13,
                                      weight: FontWeight.w700,
                                      color: const Color(0xFF8A6A1E))),
                              const SizedBox(height: 4),
                              Text(aiInsight,
                                  style: AppTheme.dm(
                                      size: 13,
                                      color: const Color(0xFF8A6A1E),
                                      height: 1.4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Actions if Pending
                if (status == 'Pending') ...[
                  NavyButton(
                      label: AppLocalizations.of(context).approveRequest,
                      onTap: () => Navigator.pop(context)),
                  const SizedBox(height: 12),
                  NavyButton(
                    label: AppLocalizations.of(context).declineRequest,
                    outline: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 24),
                  BouncyButton(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.block,
                            size: 16, color: AppColors.error),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context).blockThisRenter,
                            style: AppTheme.dm(
                                size: 14,
                                weight: FontWeight.w600,
                                color: AppColors.error)),
                      ],
                    ),
                  ),
                ] else ...[
                  // Status badge for non-pending
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: status == 'Declined'
                            ? const Color(0xFFFDECEC)
                            : AppColors.navy.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w800,
                            color: status == 'Declined'
                                ? AppColors.error
                                : AppColors.navy),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, IconData icon,
      {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.gold),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTheme.dm(size: 12, color: AppColors.muted)),
              Text(value,
                  style: AppTheme.dm(
                      size: 15,
                      weight: FontWeight.w600,
                      color: valueColor ?? AppColors.navy)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PendingRequestCard extends StatelessWidget {
  final String name, rating, unit, stays, dates, guests, price;
  final bool verified;
  final String? aiInsight;
  final VoidCallback onApprove, onDecline, onBlock;

  const _PendingRequestCard({
    required this.name,
    required this.rating,
    required this.unit,
    required this.stays,
    required this.dates,
    required this.guests,
    required this.price,
    this.verified = false,
    this.aiInsight,
    required this.onApprove,
    required this.onDecline,
    required this.onBlock,
  });

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: const EdgeInsets.all(16),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AvatarCircle(
                  size: 44, colors: [Color(0xFF657086), Color(0xFF1B2744)]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name,
                            style: AppTheme.dm(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        const SizedBox(width: 6),
                        const Icon(Icons.star, size: 12, color: AppColors.gold),
                        Text(' $rating',
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w700,
                                color: AppColors.gold)),
                        if (verified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: const Color(0xFFD7EEDD),
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              children: [
                                Text('ID',
                                    style: AppTheme.dm(
                                        size: 10,
                                        weight: FontWeight.bold,
                                        color: AppColors.success)),
                                const SizedBox(width: 2),
                                const Icon(Icons.check,
                                    size: 10, color: AppColors.success),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text('$unit · $stays',
                        style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _pill(dates),
              const SizedBox(width: 8),
              _pill(guests),
              const SizedBox(width: 8),
              _pill('EGP $price'),
            ],
          ),
          if (aiInsight != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBF3DE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFE4C56A).withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                        color: Color(0xFFD8B95D), shape: BoxShape.circle),
                    child: const Icon(Icons.add, size: 12, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Sahely AI: $aiInsight',
                      style: AppTheme.dm(
                          size: 12,
                          color: const Color(0xFF8A6A1E),
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: BouncyButton(
                  onTap: onApprove,
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color(0xFF1B6B3A),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text('Approve',
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: BouncyButton(
                  onTap: onDecline,
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFB3261E)),
                    ),
                    child: Text('Decline',
                        style: AppTheme.dm(
                            size: 14,
                            weight: FontWeight.w700,
                            color: const Color(0xFFB3261E))),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              BouncyButton(
                onTap: onBlock,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child:
                      const Icon(Icons.block, size: 20, color: AppColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Tap ∅ to ban this renter from your properties',
              style: AppTheme.dm(size: 11, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F0E8),
            borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: AppTheme.dm(
                size: 11, weight: FontWeight.w600, color: AppColors.navy)),
      );
}

class _ApprovedRequestCard extends StatelessWidget {
  final String name, rating, unit, dates, guests, price, status;
  final String? statusNote;
  final bool verified;

  const _ApprovedRequestCard({
    required this.name,
    required this.rating,
    required this.unit,
    required this.dates,
    required this.guests,
    required this.price,
    required this.status,
    this.statusNote,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.navy;
    if (status == 'Active') statusColor = const Color(0xFF1B6B3A);
    if (status == 'Done') statusColor = const Color(0xFF9A7A22);

    return WhiteCard(
      padding: const EdgeInsets.all(16),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AvatarCircle(
                  size: 44, colors: [Color(0xFF5B926C), Color(0xFF1B6B3A)]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            style: AppTheme.dm(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AppColors.navy),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.star, size: 12, color: AppColors.gold),
                        Text(' $rating',
                            style: AppTheme.dm(
                                size: 13,
                                weight: FontWeight.w700,
                                color: AppColors.gold)),
                        if (verified) ...[
                          const SizedBox(width: 6),
                          _idBadge(),
                        ],
                        const SizedBox(width: 4),
                        const Spacer(),
                        _statusBadge(status, statusColor),
                      ],
                    ),
                    Text('$unit · $dates',
                        style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _pill(guests),
              const SizedBox(width: 8),
              _pill('EGP $price'),
              if (statusNote != null) ...[
                const SizedBox(width: 8),
                _pill(statusNote!),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _idBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: const Color(0xFFD7EEDD),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Text('ID',
                style: AppTheme.dm(
                    size: 10, weight: FontWeight.bold, color: AppColors.success)),
            const SizedBox(width: 2),
            const Icon(Icons.check, size: 10, color: AppColors.success),
          ],
        ),
      );

  Widget _statusBadge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(label,
            style: AppTheme.dm(
                size: 10, weight: FontWeight.w800, color: Colors.white)),
      );

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F0E8),
            borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: AppTheme.dm(
                size: 11, weight: FontWeight.w600, color: AppColors.navy)),
      );
}

class _DeclinedRequestCard extends StatelessWidget {
  final String name, unit, dates, guests, price, reason;
  final String? rating;
  final bool verified;

  const _DeclinedRequestCard({
    required this.name,
    this.rating,
    required this.unit,
    required this.dates,
    required this.guests,
    required this.price,
    required this.reason,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: const EdgeInsets.all(16),
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AvatarCircle(
                  size: 44, colors: [Color(0xFF946B6B), Color(0xFF4A1B1B)]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name,
                            style: AppTheme.dm(
                                size: 15,
                                weight: FontWeight.w700,
                                color: AppColors.navy)),
                        const SizedBox(width: 6),
                        if (rating != null) ...[
                          const Icon(Icons.star, size: 12, color: AppColors.gold),
                          Text(' $rating',
                              style: AppTheme.dm(
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: AppColors.gold)),
                        ] else
                          Text('—',
                              style: AppTheme.dm(
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: AppColors.gold)),
                        if (verified) ...[
                          const SizedBox(width: 6),
                          _idBadge(),
                        ],
                        const Spacer(),
                        _statusBadge('Declined', const Color(0xFFB3261E)),
                      ],
                    ),
                    Text('$unit · $dates',
                        style: AppTheme.dm(size: 12, color: AppColors.muted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _pill(guests),
              const SizedBox(width: 8),
              _pill('EGP $price'),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFDECEC),
                borderRadius: BorderRadius.circular(12)),
            child: Text(
              reason,
              style: AppTheme.dm(
                  size: 12, color: const Color(0xFFB3261E), weight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _idBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: const Color(0xFFD7EEDD),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Text('ID',
                style: AppTheme.dm(
                    size: 10, weight: FontWeight.bold, color: AppColors.success)),
            const SizedBox(width: 2),
            const Icon(Icons.check, size: 10, color: AppColors.success),
          ],
        ),
      );

  Widget _statusBadge(String label, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(label,
            style: AppTheme.dm(
                size: 10, weight: FontWeight.w800, color: Colors.white)),
      );

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F0E8),
            borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: AppTheme.dm(
                size: 11, weight: FontWeight.w600, color: AppColors.navy)),
      );
}
