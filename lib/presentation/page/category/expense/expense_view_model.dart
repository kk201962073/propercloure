import 'package:flutter/material.dart';

class ExpenseViewModel extends ChangeNotifier {
  double amount = 0.0;
  DateTime selectedDate = DateTime.now();
  String selectedCategory = '';

  void updateAmount(double newAmount) {
    amount = newAmount;
    notifyListeners();
  }

  void updateSelectedDate(DateTime newDate) {
    selectedDate = newDate;
    notifyListeners();
  }

  void updateCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void reset() {
    amount = 0.0;
    selectedDate = DateTime.now();
    selectedCategory = '';
    notifyListeners();
  }

  void navigateToHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }
}
