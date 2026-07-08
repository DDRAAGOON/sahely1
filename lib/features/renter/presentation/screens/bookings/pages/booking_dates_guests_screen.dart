import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/bloc/verification_cubit.dart';
import 'package:sahely/features/renter/presentation/verification/presentation/widgets/blocked_action_gate.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/features/renter/presentation/verification/pages/add_payment_card_screen.dart';
import '../widgets/booking_property_card.dart';
import '../widgets/booking_calendar.dart';
import '../widgets/guest_counter_row.dart';
import '../widgets/guest_summary_note.dart';
import '../widgets/price_breakdown.dart';
import '../widgets/confirm_pay_button.dart';
import 'booking_confirmed_screen.dart';

class BookingDatesGuestsScreen extends StatefulWidget {
  final String propertyName;
  final String propertyImage;
  final int pricePerNight; // in piastres
  final int cleaningFee; // in piastres
  final int maxGuests;

  const BookingDatesGuestsScreen({
    super.key,
    required this.propertyName,
    required this.propertyImage,
    required this.pricePerNight,
    required this.cleaningFee,
    this.maxGuests = 16,
  });

  @override
  State<BookingDatesGuestsScreen> createState() => _BookingDatesGuestsScreenState();
}

class _BookingDatesGuestsScreenState extends State<BookingDatesGuestsScreen> {
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  int _adults = 2; // Default to 2 adults as in image
  int _children = 1; // Default to 1 child as in image
  int _infants = 0;

  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _focusedDay = _selectedDay;
  }

  int get _nights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final start = DateTime(_checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
    final end = DateTime(_checkOutDate!.year, _checkOutDate!.month, _checkOutDate!.day);
    return end.difference(start).inDays;
  }

  int get _totalGuests => _adults + _children + _infants;

  int get _subtotal => _nights * widget.pricePerNight;
  int get _vat => (_subtotal * 0.14).round();
  int get _total => _subtotal > 0 ? (_subtotal + widget.cleaningFee + _vat) : 0;

  bool _localIsSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;

      if (_checkInDate == null ||
          (_checkInDate != null && _checkOutDate != null)) {
        _checkInDate = selectedDay;
        _checkOutDate = null;
      } else if (_checkInDate != null && selectedDay.isAfter(_checkInDate!)) {
        _checkOutDate = selectedDay;
      } else if (selectedDay.isBefore(_checkInDate!)) {
        _checkInDate = selectedDay;
        _checkOutDate = null;
      } else if (_localIsSameDay(selectedDay, _checkInDate)) {
        _checkInDate = null;
        _checkOutDate = null;
      }
    });
  }

  void _incrementAdults() => _totalGuests < widget.maxGuests ? setState(() => _adults++) : null;
  void _decrementAdults() => _adults > 1 ? setState(() => _adults--) : null;
  void _incrementChildren() => _totalGuests < widget.maxGuests ? setState(() => _children++) : null;
  void _decrementChildren() => _children > 0 ? setState(() => _children--) : null;
  void _incrementInfants() => _totalGuests < widget.maxGuests ? setState(() => _infants++) : null;
  void _decrementInfants() => _infants > 0 ? setState(() => _infants--) : null;

  Future<void> _confirmAndPay() async {
    if (_checkInDate == null || _checkOutDate == null) return;
    
    final verificationCubit = context.read<VerificationCubit>();
    if (!verificationCubit.canPerformAction()) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          final dataState = verificationCubit.currentDataState;
          return BlockedActionGate(
            emailVerified: dataState.emailVerified,
            phoneVerified: dataState.phoneVerified,
            idVerified: dataState.idVerified,
            cardAdded: dataState.cardAdded,
            onCompleteSetup: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPaymentCardScreen()),
              );
            },
            onNotNow: () {
              Navigator.pop(context);
            },
          );
        },
      );
      return;
    }

    setState(() => _isConfirming = true);
    
    // Mock processing delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      final bookingsProvider = context.read<BookingsProvider>();
      final newBooking = Booking(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        propertyName: widget.propertyName,
        location: 'Marassi · North Coast', // Mock
        orderNumber: 'SHLY-${(1000 + (DateTime.now().millisecond % 9000))}',
        dates: '${_formatDate(_checkInDate!)} – ${_formatDate(_checkOutDate!)} · $_nights nights',
        guests: '$_adults adults${_children > 0 ? ', $_children child' : ''}',
        imageUrl: widget.propertyImage,
        checkIn: _checkInDate!,
        checkOut: _checkOutDate!,
        totalPaid: _total,
      );
      
      bookingsProvider.addBooking(newBooking);
      
      setState(() => _isConfirming = false);
      
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmedScreen(
            propertyName: widget.propertyName,
            checkIn: _checkInDate!,
            checkOut: _checkOutDate!,
            adults: _adults,
            unitInfo: 'Unit 8-214 · Floor 2', // Mock info
            bookingRef: newBooking.orderNumber,
            totalPaid: _total,
            starsEarned: (_total / 100000).round(), // 1 star per 1000 EGP
          ),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BookingPropertyCard(
                      propertyName: widget.propertyName,
                      propertyImage: widget.propertyImage,
                      pricePerNight: widget.pricePerNight,
                    ),
                    const SizedBox(height: 16),
                    BookingCalendar(
                      selectedDay: _selectedDay,
                      focusedDay: _focusedDay,
                      checkInDate: _checkInDate,
                      checkOutDate: _checkOutDate,
                      onDaySelected: _onDaySelected,
                    ),
                    const SizedBox(height: 12),
                    // Selected Dates Display
                    Row(
                      children: [
                        _buildDateInfo('Check-in', _checkInDate),
                        const SizedBox(width: 24),
                        _buildDateInfo('Check-out', _checkOutDate),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Guest Counter Card
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          GuestCounterRow(
                            label: 'Adults',
                            subtitle: 'Ages 18+',
                            value: _adults,
                            onIncrement: _incrementAdults,
                            onDecrement: _decrementAdults,
                            canDecrement: _adults > 1,
                          ),
                          const Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 16),
                          GuestCounterRow(
                            label: 'Children',
                            subtitle: 'Ages 2-17',
                            value: _children,
                            onIncrement: _incrementChildren,
                            onDecrement: _decrementChildren,
                            canDecrement: _children > 0,
                          ),
                          const Divider(height: 1, color: AppColors.border, indent: 16, endIndent: 16),
                          GuestCounterRow(
                            label: 'Infants',
                            subtitle: 'Under 2',
                            value: _infants,
                            onIncrement: _incrementInfants,
                            onDecrement: _decrementInfants,
                            canDecrement: _infants > 0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GuestSummaryNote(
                      totalGuests: _totalGuests,
                      adults: _adults,
                      children: _children,
                    ),
                    const SizedBox(height: 24),
                    PriceBreakdown(
                      nights: _nights,
                      totalGuests: _totalGuests,
                      pricePerNight: widget.pricePerNight,
                      cleaningFee: widget.cleaningFee,
                      vat: _vat,
                      total: _total,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Bottom Button - Removed white container and shadow as per request
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: ConfirmPayButton(
                isLoading: _isConfirming,
                total: _total,
                onPressed: _total > 0 ? _confirmAndPay : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime? date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.secondary, fontFamily: 'DM Sans'),
        ),
        const SizedBox(height: 4),
        Text(
          date != null ? _formatDate(date) : 'Select',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans'),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: AppColors.cream,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.chevron_left, color: AppColors.navy, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Plan Your Stay',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans'),
          ),
        ],
      ),
    );
  }
}
