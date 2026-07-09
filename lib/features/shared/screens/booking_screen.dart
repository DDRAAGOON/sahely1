import 'package:flutter/material.dart';
import '../../../data/models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/cream_background.dart';
import '../../../core/widgets/kit.dart';
import '../../../core/widgets/ui.dart';
import '../widgets/booking_screen_widgets.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

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
    if (date == null) return 'Select';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)?.settings.arguments as Property?;
    final pName = property?.name ?? 'Azure Beach Villa';
    final pPrice = property?.price ?? 4500;
    
    final subtotal = pPrice * _nights;
    final vat = (subtotal + (subtotal > 0 ? _cleaningFee : 0)) * 0.14;
    final total = subtotal + (subtotal > 0 ? _cleaningFee : 0) + vat;

    String format(num n) => n.toStringAsFixed(0).replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},");

    return PhoneScaffold(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              children: [
                Text('Plan Your Stay', style: AppTheme.dm(size: 22, weight: FontWeight.w700, color: AppColors.navy)),
                const SizedBox(height: 14),
                WhiteCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SahelyImage(imageUrl: property?.image ?? '', width: 48, height: 48, enableViewer: false),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pName, style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.navy)),
                          const SizedBox(height: 2),
                          Text('EGP ${format(pPrice)} / night', style: AppTheme.dm(size: 12, color: AppColors.muted)),
                        ],
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
                BookingCalendarCard(onDatesChanged: _updateDates),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(child: BookingCheckCol('Check-in', _formatDate(_checkIn))),
                  Expanded(child: BookingCheckCol('Check-out', _formatDate(_checkOut))),
                ]),
                const SizedBox(height: 16),
                WhiteCard(
                  child: Column(children: [
                    BookingGuestRow('Adults', 'Ages 18+', _adults, 
                      onMinus: _adults > 1 ? () => setState(() => _adults--) : null,
                      onPlus: () => setState(() => _adults++),
                    ),
                    const Divider(height: 1, color: Color(0xFFF4EFE7)),
                    BookingGuestRow('Children', 'Ages 2–17', _children,
                      onMinus: _children > 0 ? () => setState(() => _children--) : null,
                      onPlus: () => setState(() => _children++),
                    ),
                    const Divider(height: 1, color: Color(0xFFF4EFE7)),
                    BookingGuestRow('Infants', 'Under 2', _infants,
                      onMinus: _infants > 0 ? () => setState(() => _infants--) : null,
                      onPlus: () => setState(() => _infants++),
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                InfoNote(text: '${_adults + _children + _infants} guests · $_adults adults, $_children child${_children != 1 ? "ren" : ""} — the host is notified of your party size', icon: Icons.people_outline),
                const SizedBox(height: 16),
                WhiteCard(
                  padding: const EdgeInsets.all(14),
                  child: Column(children: [
                    Align(alignment: Alignment.centerLeft, child: Text('$_nights nights · ${_adults + _children} guests', style: AppTheme.dm(size: 13, color: AppColors.muted))),
                    const SizedBox(height: 8),
                    KeyValueRow('EGP ${format(pPrice)} × $_nights', format(subtotal)),
                    KeyValueRow('Cleaning fee', format(_cleaningFee)),
                    KeyValueRow('VAT 14%', format(vat)),
                    KeyValueRow('Total', 'EGP ${format(total)}', bold: true, topBorder: true),
                  ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SafeArea(top: false, child: NavyButton(label: 'Confirm & Pay', onTap: () => Navigator.pushNamed(context, '/booking-confirmed', arguments: {
              'property': property,
              'total': total,
              'guests': _adults + _children,
            }))),
          ),
        ],
      ),
    );
  }
}
