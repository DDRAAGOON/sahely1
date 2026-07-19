import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import 'package:table_calendar/table_calendar.dart';


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

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isInRange(DateTime day) {
    if (_rangeStart == null || _rangeEnd == null) return false;
    return day.isAfter(_rangeStart!) && day.isBefore(_rangeEnd!);
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
      child: TableCalendar(
        firstDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
        focusedDay: _focusedDay,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.navy, fontFamily: 'DM Sans'),
          leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.navy, size: 20),
          rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.navy, size: 20),
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(fontSize: 11, color: AppColors.secondary, fontFamily: 'DM Sans'),
          weekendStyle: TextStyle(fontSize: 11, color: AppColors.secondary, fontFamily: 'DM Sans'),
        ),
        calendarBuilders: CalendarBuilders(
          prioritizedBuilder: (context, day, focusedDay) {
            final isStart = _isSameDay(day, _rangeStart);
            final isEnd = _isSameDay(day, _rangeEnd);
            final isInRange = _isInRange(day);
            final isOutside = day.month != focusedDay.month;

            return Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: (isStart || isEnd)
                    ? AppColors.navy
                    : isInRange
                        ? AppColors.gold.withValues(alpha: 0.3)
                        : null,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isOutside
                        ? AppColors.secondary.withValues(alpha: 0.4)
                        : (isStart || isEnd)
                            ? Colors.white
                            : isInRange
                                ? AppColors.navy
                                : AppColors.dark,
                    fontWeight: (isStart || isEnd) ? FontWeight.w700 : null,
                  ),
                ),
              ),
            );
          },
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
            if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
              _rangeStart = selectedDay;
              _rangeEnd = null;
            } else if (selectedDay.isAfter(_rangeStart!)) {
              _rangeEnd = selectedDay;
            } else {
              _rangeStart = selectedDay;
              _rangeEnd = null;
            }
          });
          widget.onDatesChanged?.call(_rangeStart, _rangeEnd);
        },
      ),
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
        Text(value, style: AppTheme.dm(size: 14, weight: FontWeight.w600, color: AppColors.navy)),
      ],
    );
  }
}

class BookingGuestRow extends StatelessWidget {
  const BookingGuestRow(this.title, this.sub, this.value, {super.key, this.onMinus, this.onPlus});
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
              _circleBtn(Icons.remove, filled: false, enabled: onMinus != null, onTap: onMinus),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text('$value', style: AppTheme.dm(size: 15, weight: FontWeight.w700)),
              ),
              _circleBtn(Icons.add, filled: true, onTap: onPlus),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, {required bool filled, bool enabled = true, VoidCallback? onTap}) => GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? AppColors.navy : Colors.transparent,
            border: filled ? null : Border.all(color: enabled ? AppColors.navy : AppColors.border, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: filled ? AppColors.white : (enabled ? AppColors.navy : const Color(0xFFBBBBBB))),
        ),
      );
}
