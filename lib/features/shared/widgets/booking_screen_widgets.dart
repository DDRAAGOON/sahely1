import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';
import 'package:sahely/l10n/app_localizations.dart';

class BookingCalendarCard extends StatefulWidget {
  final Function(DateTime? checkIn, DateTime? checkOut)? onDatesChanged;

  const BookingCalendarCard({super.key, this.onDatesChanged});

  @override
  State<BookingCalendarCard> createState() => _BookingCalendarCardState();
}

class _BookingCalendarCardState extends State<BookingCalendarCard> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  /// Midnight of today — days before this are not bookable.
  late final DateTime _today = _dateOnly(DateTime.now());

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDisabled(DateTime day) =>
      day.isBefore(DateTime.utc(_today.year, _today.month, _today.day));

  bool _isInRange(DateTime day) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return day.isAfter(_rangeStart!) && day.isBefore(_rangeEnd!);
  }

  void _selectDay(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_rangeStart == null ||
          (_rangeStart != null && _rangeEnd != null)) {
        // First pick (or re-start after a complete range).
        _rangeStart = selectedDay;
        _rangeEnd = null;
      } else if (selectedDay.isAfter(_rangeStart!)) {
        // Complete the range.
        _rangeEnd = selectedDay;
      } else {
        // Picked a day before the current start → it becomes the new start.
        _rangeStart = selectedDay;
        _rangeEnd = null;
      }
    });
    widget.onDatesChanged?.call(_rangeStart, _rangeEnd);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
            focusedDay: _focusedDay,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                  fontFamily: 'DM Sans'),
              leftChevronIcon:
                  Icon(Icons.chevron_left, color: AppColors.navy, size: 20),
              rightChevronIcon:
                  Icon(Icons.chevron_right, color: AppColors.navy, size: 20),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                  fontSize: 11, color: AppColors.secondary, fontFamily: 'DM Sans'),
              weekendStyle: TextStyle(
                  fontSize: 11, color: AppColors.secondary, fontFamily: 'DM Sans'),
            ),
            calendarBuilders: CalendarBuilders(
              prioritizedBuilder: (context, day, focusedDay) {
                final isStart = _isSameDay(day, _rangeStart);
                final isEnd = _isSameDay(day, _rangeEnd);
                final isInRange = _isInRange(day);
                final isOutside = day.month != focusedDay.month;
                final disabled = _isDisabled(day);

                Color? bg;
                Color fg;
                FontWeight? weight;
                if (disabled) {
                  fg = AppColors.secondary.withValues(alpha: 0.35);
                } else if (isStart || isEnd) {
                  bg = AppColors.navy;
                  fg = Colors.white;
                  weight = FontWeight.w700;
                } else if (isInRange) {
                  bg = AppColors.gold.withValues(alpha: 0.3);
                  fg = AppColors.navy;
                } else {
                  fg = isOutside
                      ? AppColors.secondary.withValues(alpha: 0.4)
                      : AppColors.dark;
                }

                return Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text('${day.day}',
                      style: TextStyle(
                          fontSize: 13, color: fg, fontWeight: weight)),
                );
              },
            ),
            onDaySelected: _selectDay,
            onDisabledDayTapped: (_) {
              ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context).selectFutureDate),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const _LegendDot(color: AppColors.navy),
              const SizedBox(width: 5),
              Text(AppLocalizations.of(context).checkInLabel,
                  style: AppTheme.dm(size: 10, color: AppColors.secondary)),
              const SizedBox(width: 12),
              _LegendDot(color: AppColors.gold.withValues(alpha: 0.45)),
              const SizedBox(width: 5),
              Text(AppLocalizations.of(context).selectedDatesLabel,
                  style: AppTheme.dm(size: 10, color: AppColors.secondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class BookingCheckCol extends StatelessWidget {
  const BookingCheckCol(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.dm(size: 11, color: AppColors.muted)),
        Text(value,
            style: AppTheme.dm(
                size: 14, weight: FontWeight.w600, color: AppColors.navy)),
      ],
    );
  }
}

class BookingGuestRow extends StatelessWidget {
  const BookingGuestRow(this.title, this.sub, this.value,
      {super.key, this.onMinus, this.onPlus});

  final String title;
  final String sub;
  final int value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.dm(size: 14)),
              Text(sub, style: AppTheme.dm(size: 11, color: AppColors.muted)),
            ],
          ),
          Row(
            children: [
              _circleBtn(Icons.remove,
                  filled: false, enabled: onMinus != null, onTap: onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('$value',
                    style: AppTheme.dm(size: 15, weight: FontWeight.w700)),
              ),
              _circleBtn(Icons.add, filled: true, onTap: onPlus),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon,
          {required bool filled, bool enabled = true, VoidCallback? onTap}) =>
      GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? AppColors.navy : Colors.transparent,
            border: filled
                ? null
                : Border.all(color: AppColors.borderDefault),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              size: 18,
              color: filled
                  ? AppColors.white
                  : (enabled ? AppColors.navy : const Color(0xFFBBBBBB))),
        ),
      );
}
