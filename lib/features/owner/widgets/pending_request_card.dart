import 'package:flutter/material.dart';

import 'package:sahely/core/di/service_locator.dart' show sl;
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/core/widgets/bouncy_button.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/features/owner/domain/entities/owner_booking_request.dart';
import 'package:sahely/features/owner/domain/repositories/owner_repository.dart';

import '../../../core/navigation/app_navigation.dart';
import 'approved_request_sheet.dart';

/// The owner's next booking request still waiting for an answer
/// (`GET /bookings/owner/requests`), with Approve / Decline. Says so when
/// nothing is waiting.
class PendingRequestCard extends StatefulWidget {
  const PendingRequestCard({super.key, this.onChanged});

  /// Called after the request was approved or declined.
  final VoidCallback? onChanged;

  @override
  State<PendingRequestCard> createState() => _PendingRequestCardState();
}

class _PendingRequestCardState extends State<PendingRequestCard> {
  OwnerBookingRequest? _request;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final requests = await sl<OwnerRepository>().getBookingRequests();
      final pending = requests
          .where((r) => r.state == RequestState.pending)
          .toList()
        ..sort((a, b) => a.checkIn.compareTo(b.checkIn));
      if (mounted) {
        setState(() => _request = pending.isEmpty ? null : pending.first);
      }
    } catch (_) {
      // No card rather than a broken one.
    }
  }

  void _changed() {
    widget.onChanged?.call();
    _load();
  }

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
  static String _dates(OwnerBookingRequest r) {
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

  static String _unit(OwnerBookingRequest r) =>
      r.property?.name ?? 'Listing unavailable';

  static String _guests(OwnerBookingRequest r) =>
      r.guests == 1 ? '1 guest' : '${r.guests} guests';

  static String _nights(OwnerBookingRequest r) =>
      '${r.nights} ${r.nights == 1 ? 'night' : 'nights'}';

  Future<void> _approve(OwnerBookingRequest r) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await sl<OwnerRepository>().approveRequest(r.id);
      if (!mounted) return;
      await showApprovedRequestSheet(
        context,
        guestName: r.guestName,
        propertyName: _unit(r),
        dates: _dates(r),
        payoutDisplay: CurrencyFormatter.format(r.payoutEgp.round()),
      );
      _changed();
    } catch (_) {
      messenger.showSnackBar(const SnackBar(
          content: Text('Could not approve the request. Please try again.')));
    }
  }

  void _showDeclineBottomSheet(OwnerBookingRequest r) {
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
              Text('Decline Request',
                  style: AppTheme.dm(
                      size: 20,
                      weight: FontWeight.w700,
                      color: AppColors.navy)),
              const SizedBox(height: 8),
              Text(
                  'Please provide a reason for declining ${r.guestName}\'s request.',
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
                label: 'Confirm Decline',
                onTap: () async {
                  Navigator.pop(ctx);
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await sl<OwnerRepository>().declineRequest(r.id);
                    messenger.showSnackBar(SnackBar(
                        content: Text('Request for ${r.guestName} declined')));
                    _changed();
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

  @override
  Widget build(BuildContext context) {
    final r = _request;
    if (r == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text('No requests waiting for you.',
            style: AppTheme.dm(size: 13, color: AppColors.muted)),
      );
    }

    return BouncyButton(
      onTap: () => AppNavigation.goToOwnerRequestDetail(context, extra: {
        'id': r.id,
        'reference': r.reference,
        'guestName': r.guestName,
        'rating': '—',
        'verified': false,
        'propertyName': _unit(r),
        'stays': _nights(r),
        'dates': _dates(r),
        'total': _grouped(r.payoutEgp.round()),
        'guests': _guests(r),
        'status': 'Pending',
        'onChanged': _changed,
      }),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Column(children: [
          Row(children: [
            const AvatarCircle(
              size: 48,
              colors: [Color(0xFFD8B98A), Color(0xFF7D5A2C)],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.guestName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.dm(
                          size: 15,
                          weight: FontWeight.w700,
                          color: AppColors.navy)),
                  const SizedBox(height: 2),
                  Text('${_unit(r)} · ${_dates(r)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.dm(size: 12, color: AppColors.muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: AppColors.faint),
          ]),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 8, children: [
            Pill(_guests(r),
                bg: const Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
            Pill(_nights(r),
                bg: const Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
            Pill(CurrencyFormatter.format(r.payoutEgp.round()),
                bg: const Color(0xFFF5F0E8), fg: AppColors.navy, radius: 10),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: WideButton(
                label: 'Approve',
                color: const Color(0xFF1B6B3A),
                height: 48,
                radius: 12,
                onTap: () => _approve(r),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: WideButton(
                label: 'Decline',
                color: const Color(0xFFB3261E),
                textColor: const Color(0xFFB3261E),
                outline: true,
                height: 48,
                radius: 12,
                onTap: () => _showDeclineBottomSheet(r),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
