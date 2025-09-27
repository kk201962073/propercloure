import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final int amount;
  final String category;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.category,
  });

  DateTime? get date => null;
}

class HomeViewModel extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<TransactionModel> transactions = [];

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

  void addTransaction(String title, int amount, String category) {
    transactions.add(
      TransactionModel(title: title, amount: amount, category: category),
    );
    notifyListeners();
  }

  int get totalIncome => transactions
      .where((tx) => tx.amount > 0)
      .fold(0, (sum, tx) => sum + tx.amount);

  int get totalExpense => transactions
      .where((tx) => tx.amount < 0)
      .fold(0, (sum, tx) => sum + tx.amount.abs());

  int get totalBalance => transactions.fold(0, (sum, tx) => sum + tx.amount);
}
