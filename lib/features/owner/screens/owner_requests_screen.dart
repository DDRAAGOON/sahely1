import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';
import 'package:sahely/features/owner/widgets/approved_request_sheet.dart';
import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/features/owner/domain/entities/owner_booking_request.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';

class OwnerRequestsScreen extends StatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen> {
  int _activeTab = 0; // 0: Pending, 1: Approved, 2: Declined
  late Future<List<OwnerBookingRequest>> _requests = _load();

  Future<List<OwnerBookingRequest>> _load() =>
      sl<OwnerRepository>().getBookingRequests();

  void _reload() {
    if (mounted) setState(() => _requests = _load());
  }

  void _showDeclineBottomSheet(OwnerBookingRequest request) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SingleChildScrollView(
        child: Container(
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
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 8),
              Text(
                  'Please provide a reason for declining ${request.guestName}\'s request.',
                  style: AppTheme.dm(size: 14, color: AppColors.muted)),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                onTap: () async {
                  Navigator.pop(ctx);
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await sl<OwnerRepository>().declineRequest(request.id);
                    messenger.showSnackBar(SnackBar(
                        content:
                            Text('Request for ${request.guestName} declined')));
                    _reload();
                  } catch (_) {
                    messenger.showSnackBar(const SnackBar(
                        content: Text(
                            'Could not decline the request. Please try again.')));
                  }
                },
              ),
            ],
          ),
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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Blocking guests is not available yet.')));
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
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
              child: FutureBuilder<List<OwnerBookingRequest>>(
                key: ValueKey<int>(_activeTab),
                future: _requests,
                builder: (context, snapshot) => ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  children: _buildContent(snapshot),
                ),
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

  List<Widget> _buildContent(
      AsyncSnapshot<List<OwnerBookingRequest>> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child:
              Center(child: CircularProgressIndicator(color: AppColors.gold)),
        ),
      ];
    }
    if (snapshot.hasError) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(children: [
            Text('Could not load your requests.',
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
            TextButton(
              onPressed: _reload,
              child: Text(AppLocalizations.of(context).retry,
                  style: AppTheme.dm(
                      size: 14,
                      weight: FontWeight.w600,
                      color: AppColors.gold)),
            ),
          ]),
        ),
      ];
    }

    final state = RequestState.values[_activeTab];
    final requests = snapshot.data!.where((r) => r.state == state).toList();
    if (requests.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
                switch (state) {
                  RequestState.pending => 'No pending requests right now.',
                  RequestState.approved => 'No approved requests yet.',
                  RequestState.declined => 'No declined requests.',
                },
                style: AppTheme.dm(size: 14, color: AppColors.muted)),
          ),
        ),
      ];
    }
    return [
      for (final request in requests) ...[
        switch (state) {
          RequestState.pending => _pendingItem(request),
          RequestState.approved => _approvedItem(request),
          RequestState.declined => _declinedItem(request),
        },
        const SizedBox(height: 16),
      ],
    ];
  }

  String _unit(OwnerBookingRequest r) =>
      r.property?.name ?? 'Listing unavailable';

  String _guests(OwnerBookingRequest r) =>
      r.guests == 1 ? '1 guest' : '${r.guests} guests';

  String _nights(OwnerBookingRequest r) =>
      '${r.nights} ${r.nights == 1 ? 'night' : 'nights'}';

  String _price(OwnerBookingRequest r) => _grouped(r.payoutEgp.round());

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// `Jun 21–25`, or `Jun 29 – Jul 3` across months.
  String _dates(OwnerBookingRequest r) {
    final start = '${_months[r.checkIn.month - 1]} ${r.checkIn.day}';
    if (r.checkIn.month == r.checkOut.month) return '$start–${r.checkOut.day}';
    return '$start – ${_months[r.checkOut.month - 1]} ${r.checkOut.day}';
  }

  /// `18000` -> `18,000`.
  static String _grouped(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// What the detail screen shows; `onChanged` refreshes this list after an
  /// approve / decline made there.
  Map<String, dynamic> _detail(OwnerBookingRequest r, String status,
          {String? statusNote, String? reason}) =>
      {
        'id': r.id,
        'reference': r.reference,
        'guestName': r.guestName,
        'rating': '—',
        'verified': false,
        'propertyName': _unit(r),
        'stays': _nights(r),
        'dates': _dates(r),
        'total': _price(r),
        'guests': _guests(r),
        'status': status,
        'statusNote': statusNote,
        'reason': reason,
        'onChanged': _reload,
      };

  Future<void> _approve(OwnerBookingRequest r) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await sl<OwnerRepository>().approveRequest(r.id);
      if (!mounted) return;
      _reload();
      await showApprovedRequestSheet(
        context,
        guestName: r.guestName,
        propertyName: _unit(r),
        dates: _dates(r),
        payoutDisplay: 'EGP ${_price(r)}',
      );
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Could not approve the request. Please try again.')));
    }
  }

  Widget _pendingItem(OwnerBookingRequest r) {
    return BouncyButton(
      onTap: () => AppNavigation.goToOwnerRequestDetail(context,
          extra: _detail(r, 'Pending')),
      child: _PendingRequestCard(
        name: r.guestName,
        aiInsight: null,
        verified: false,
        rating: '—',
        unit: _unit(r),
        stays: _nights(r),
        dates: _dates(r),
        guests: _guests(r),
        price: _price(r),
        onApprove: () => _approve(r),
        onDecline: () => _showDeclineBottomSheet(r),
        onBlock: () => _showBlockConfirmation(r.guestName),
      ),
    );
  }

  Widget _approvedItem(OwnerBookingRequest r) {
    final inHouse = r.checkedIn && !r.isPast;
    final status = inHouse ? 'Active' : (r.isPast ? 'Done' : 'Upcoming');
    final note = inHouse ? 'Checked in' : null;
    return BouncyButton(
      onTap: () => AppNavigation.goToOwnerRequestDetail(context,
          extra: _detail(r, status, statusNote: note)),
      child: _ApprovedRequestCard(
        name: r.guestName,
        verified: false,
        rating: '—',
        unit: _unit(r),
        dates: _dates(r),
        guests: _guests(r),
        price: _price(r),
        status: status,
        statusNote: note,
      ),
    );
  }

  Widget _declinedItem(OwnerBookingRequest r) {
    final reason = 'Reason: ${r.reason ?? 'Declined.'}';
    return BouncyButton(
      onTap: () => AppNavigation.goToOwnerRequestDetail(context,
          extra: _detail(r, 'Declined', reason: reason)),
      child: _DeclinedRequestCard(
        name: r.guestName,
        rating: null,
        verified: false,
        unit: _unit(r),
        dates: _dates(r),
        guests: _guests(r),
        price: _price(r),
        reason: reason,
      ),
    );
  }
}

class OwnerRequestDetailScreen extends StatelessWidget {
  final Map<String, dynamic>? data;
  const OwnerRequestDetailScreen({super.key, this.data});

  /// Approves or declines the request shown, then refreshes the list it was
  /// opened from (`onChanged`) and closes.
  Future<void> _act(BuildContext context, Map<String, dynamic> data,
      {required bool approve}) async {
    final id = '${data['id'] ?? ''}';
    if (id.isEmpty) {
      Navigator.pop(context);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    try {
      final repository = sl<OwnerRepository>();
      await (approve
          ? repository.approveRequest(id)
          : repository.declineRequest(id));
      (data['onChanged'] as VoidCallback?)?.call();
      messenger.showSnackBar(SnackBar(
          content: Text(approve ? 'Request approved' : 'Request declined')));
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      messenger.showSnackBar(SnackBar(
          content: Text(approve
              ? 'Could not approve the request. Please try again.'
              : 'Could not decline the request. Please try again.')));
    }
  }

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

    final Map<String, dynamic> effectiveData = rawData;

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
                                  Text(
                                      AppLocalizations.of(context)
                                          .verifiedBadge,
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
                          color:
                              const Color(0xFFE4C56A).withValues(alpha: 0.3)),
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
                      onTap: () => _act(context, effectiveData, approve: true)),
                  const SizedBox(height: 12),
                  NavyButton(
                    label: AppLocalizations.of(context).declineRequest,
                    outline: true,
                    onTap: () => _act(context, effectiveData, approve: false),
                  ),
                  const SizedBox(height: 24),
                  BouncyButton(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Blocking guests is not available yet.'))),
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
                        Flexible(
                          child: Text(name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.dm(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _pill(dates),
              _pill(guests),
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
                    size: 10,
                    weight: FontWeight.bold,
                    color: AppColors.success)),
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
                        Flexible(
                          child: Text(name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.dm(
                                  size: 15,
                                  weight: FontWeight.w700,
                                  color: AppColors.navy)),
                        ),
                        const SizedBox(width: 6),
                        if (rating != null) ...[
                          const Icon(Icons.star,
                              size: 12, color: AppColors.gold),
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
                  size: 12,
                  color: const Color(0xFFB3261E),
                  weight: FontWeight.w500),
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
                    size: 10,
                    weight: FontWeight.bold,
                    color: AppColors.success)),
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
