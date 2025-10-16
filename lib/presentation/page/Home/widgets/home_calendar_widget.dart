import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeCalendarWidget extends StatelessWidget {
  const HomeCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TableCalendar(
        focusedDay: viewModel.selectedDay,
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        headerVisible: false,
        selectedDayPredicate: (day) => isSameDay(viewModel.selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          viewModel.setSelectedDay(selectedDay);
        },
        onPageChanged: (focusedDay) {
          viewModel.setYear(focusedDay.year);
          viewModel.setMonth(focusedDay.month);
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: isDark ? Colors.blue : theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: theme.colorScheme.error,
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          selectedTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          weekendTextStyle: TextStyle(
            color: isDark ? Colors.red[300] : Colors.red,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          weekendStyle: TextStyle(
            color: isDark ? Colors.red[200] : Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
