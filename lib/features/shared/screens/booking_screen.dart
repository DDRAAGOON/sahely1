import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahely/core/navigation/app_navigation.dart';
import 'package:sahely/features/shared/properties/domain/entities/property.dart';
import 'package:sahely/core/providers/bookings_provider.dart';
import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/core/widgets/kit.dart';
import 'package:sahely/core/widgets/ui.dart';
import 'package:sahely/core/widgets/entrance_faded.dart';
import 'package:sahely/core/utils/currency_formatter.dart';
import 'package:sahely/features/shared/widgets/booking_screen_widgets.dart';
import 'package:sahely/l10n/app_localizations.dart';

class BookingScreen extends StatefulWidget {
  final Property? property;

  const BookingScreen({super.key, this.property});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _adults = 2;
  int _children = 1;
  int _infants = 0;
  int _nights = 0;
  DateTime? _checkIn;
  DateTime? _checkOut;
  final int _cleaningFee = 500;

  void _updateDates(DateTime? checkIn, DateTime? checkOut) {
    setState(() {
      _checkIn = checkIn;
      _checkOut = checkOut;
      if (checkIn != null && checkOut != null) {
        _nights = checkOut.difference(checkIn).inDays;
      } else {
        _nights = 0;
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return AppLocalizations.of(context).selectDate;
    final months = [
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
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final pName = property?.name ?? 'Azure Beach Villa';
    final pPrice = property?.price ?? 4500;

    final subtotal = pPrice * _nights;
    final vat = (subtotal + (subtotal > 0 ? _cleaningFee : 0)) * 0.14;
    final total = subtotal + (subtotal > 0 ? _cleaningFee : 0) + vat;

    return PhoneScaffold(
      child: EntranceFaded(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                children: [
                  TopBar(title: AppLocalizations.of(context).planYourStay),
                  const SizedBox(height: 14),
                  WhiteCard(
                    padding: const EdgeInsets.all(12),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SahelyImage(
                            imageUrl: property?.image ?? '',
                            width: 48,
                            height: 48,
                            enableViewer: false),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pName,
                                style: AppTheme.dm(
                                    size: 14,
                                    weight: FontWeight.w600,
                                    color: AppColors.navy)),
                            const SizedBox(height: 2),
                            Text('${CurrencyFormatter.format(pPrice)} / night',
                                style: AppTheme.dm(
                                    size: 12, color: AppColors.muted)),
                          ],
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16),
                  BookingCalendarCard(onDatesChanged: _updateDates),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                        child: BookingCheckCol(
                            AppLocalizations.of(context).checkInLabel,
                            _formatDate(_checkIn))),
                    Expanded(
                        child: BookingCheckCol(
                            AppLocalizations.of(context).checkOutLabel,
                            _formatDate(_checkOut))),
                  ]),
                  const SizedBox(height: 16),
                  WhiteCard(
                    child: Column(children: [
                      BookingGuestRow(
                        AppLocalizations.of(context).adults,
                        AppLocalizations.of(context).adultsAges,
                        _adults,
                        onMinus: _adults > 1
                            ? () => setState(() => _adults--)
                            : null,
                        onPlus: () => setState(() => _adults++),
                      ),
                      const Divider(height: 1, color: Color(0xFFF4EFE7)),
                      BookingGuestRow(
                        AppLocalizations.of(context).childrenLabel,
                        'Ages 2–17',
                        _children,
                        onMinus: _children > 0
                            ? () => setState(() => _children--)
                            : null,
                        onPlus: () => setState(() => _children++),
                      ),
                      const Divider(height: 1, color: Color(0xFFF4EFE7)),
                      BookingGuestRow(
                        AppLocalizations.of(context).infants,
                        AppLocalizations.of(context).infantsAges,
                        _infants,
                        onMinus: _infants > 0
                            ? () => setState(() => _infants--)
                            : null,
                        onPlus: () => setState(() => _infants++),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 12),
                  InfoNote(
                      text:
                          '${_adults + _children + _infants} guests · $_adults adults, $_children child${_children != 1 ? "ren" : ""} — the host is notified of your party size',
                      icon: Icons.people_outline),
                  const SizedBox(height: 16),
                  WhiteCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              '$_nights nights · ${_adults + _children} guests',
                              style: AppTheme.dm(
                                  size: 13, color: AppColors.muted))),
                      const SizedBox(height: 8),
                      KeyValueRow(
                          '${CurrencyFormatter.format(pPrice)} × $_nights',
                          CurrencyFormatter.formatNumber(subtotal)),
                      KeyValueRow(AppLocalizations.of(context).cleaningFee,
                          CurrencyFormatter.formatNumber(_cleaningFee)),
                      KeyValueRow(AppLocalizations.of(context).vatLabel,
                          CurrencyFormatter.formatNumber(vat)),
                      KeyValueRow(AppLocalizations.of(context).totalLabel,
                          CurrencyFormatter.format(total.toInt()),
                          bold: true, topBorder: true),
                    ]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SafeArea(
                top: false,
                child: NavyButton(
                  label: AppLocalizations.of(context).confirmPay,
                  onTap: () {
                    if (_checkIn == null || _checkOut == null) return;

                    final bookingsProvider = context.read<BookingsProvider>();
                    final newBooking = Booking(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      propertyName: pName,
                      location: property?.area ?? 'North Coast',
                      orderNumber:
                          'SHLY-${(1000 + (DateTime.now().millisecond % 9000))}',
                      dates:
                          '${_formatDate(_checkIn)} – ${_formatDate(_checkOut)} · $_nights nights',
                      guests:
                          '$_adults adults${_children > 0 ? ', $_children children' : ''}',
                      imageUrl: property?.image ?? '',
                      checkIn: _checkIn!,
                      checkOut: _checkOut!,
                      totalPaid: total.toInt(),
                    );
                    bookingsProvider.addBooking(newBooking);

                    AppNavigation.goToBookingConfirmed(context, extra: {
                      'propertyName': pName,
                      'property': property,
                      'total': total,
                      'guests': _adults + _children,
                      'checkIn': _checkIn,
                      'checkOut': _checkOut,
                      'bookingRef': newBooking.orderNumber,
                      'starsEarned': (total / 1000).round(),
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
