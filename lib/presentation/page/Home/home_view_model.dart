import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<Map<String, dynamic>> transactions = [];

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

  void addTransaction(
    String title,
    int amount,
    String category,
    DateTime date,
  ) {
    transactions.add({
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    });
    notifyListeners();
  }

  void updateTransaction(int index, Map<String, dynamic> newTransaction) {
    if (index >= 0 && index < transactions.length) {
      transactions[index] = newTransaction;
      notifyListeners();
    }
  }

  int get totalIncome => transactions
      .where((tx) => tx['amount'] is int && tx['amount'] > 0)
      .fold(0, (sum, tx) => sum + (tx['amount'] as int));

  int get totalExpense => transactions
      .where((tx) => tx['amount'] is int && tx['amount'] < 0)
      .fold(0, (sum, tx) => sum + (tx['amount'] as int).abs());

  int get totalBalance => transactions.fold(
    0,
    (sum, tx) => sum + (tx['amount'] is int ? (tx['amount'] as int) : 0),
  );
}
