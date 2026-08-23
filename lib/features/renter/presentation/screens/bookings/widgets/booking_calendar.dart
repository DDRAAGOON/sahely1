import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:sahely/core/theme/app_colors.dart';
import 'package:sahely/core/theme/app_theme.dart';

class BookingCalendar extends StatelessWidget {
  final DateTime selectedDay;
  final DateTime focusedDay;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final Function(DateTime, DateTime) onDaySelected;

  const BookingCalendar({
    super.key,
    required this.selectedDay,
    required this.focusedDay,
    required this.checkInDate,
    required this.checkOutDate,
    required this.onDaySelected,
  });

  bool _isCheckIn(DateTime day) {
    return checkInDate != null &&
        day.year == checkInDate!.year &&
        day.month == checkInDate!.month &&
        day.day == checkInDate!.day;
  }

  bool _isCheckOut(DateTime day) {
    return checkOutDate != null &&
        day.year == checkOutDate!.year &&
        day.month == checkOutDate!.month &&
        day.day == checkOutDate!.day;
  }

  bool _isInRange(DateTime day) {
    if (checkInDate == null || checkOutDate == null) return false;
    return day.isAfter(checkInDate!) && day.isBefore(checkOutDate!);
  }

  bool _localIsSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    Widget buildDayCell(DateTime day, bool isOutside) {
      final isCheckIn = _isCheckIn(day);
      final isCheckOut = _isCheckOut(day);
      final isInRange = _isInRange(day);

      return Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isCheckIn || isCheckOut
              ? AppColors.navy
              : isInRange
                  ? AppColors.gold.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: AppTheme.dm(
              size: 13,
              color: isOutside
                  ? AppColors.secondary.withValues(alpha: 0.4)
                  : isCheckIn || isCheckOut
                      ? Colors.white
                      : isInRange
                          ? AppColors.navy
                          : AppColors.dark,
              weight: isCheckIn || isCheckOut ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border : null,
      ),
      child: TableCalendar(
        firstDay: todayStart,
        lastDay: todayStart.add(const Duration(days: 365)),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => _localIsSameDay(selectedDay, day),
        calendarFormat: CalendarFormat.month,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: AppTheme.dm(
            size: 15,
            weight: FontWeight.w700,
            color: AppColors.navy,
          ),
          leftChevronIcon:
              const Icon(Icons.chevron_left, color: AppColors.navy, size: 20),
          rightChevronIcon:
              const Icon(Icons.chevron_right, color: AppColors.navy, size: 20),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: AppTheme.dm(
            size: 11,
            color: AppColors.secondary,
          ),
          weekendStyle: AppTheme.dm(
            size: 11,
            color: AppColors.secondary,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          prioritizedBuilder: (context, day, focusedDay) {
            // Check if day is outside current month view
            final isOutside = day.month != focusedDay.month;
            return buildDayCell(day, isOutside);
          },
        ),
        onDaySelected: onDaySelected,
      ),
    );
  }
}
