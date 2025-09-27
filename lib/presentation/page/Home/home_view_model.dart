import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  DateTime get selectedDay => _selectedDay;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    _selectedMonth = day.month;
    _selectedYear = day.year;
    notifyListeners();
  }

  void setMonth(int month) {
    _selectedMonth = month;
    _selectedDay = DateTime(_selectedYear, _selectedMonth, _selectedDay.day);
    notifyListeners();
  }

  void setYear(int year) {
    _selectedYear = year;
    _selectedDay = DateTime(_selectedYear, _selectedMonth, _selectedDay.day);
    notifyListeners();
  }

  List<int> get allMonths => List.generate(12, (index) => index + 1);

  List<int> get allYears {
    final currentYear = DateTime.now().year;
    return List.generate(11, (index) => currentYear - 5 + index);
  }
}
