import 'package:flutter/material.dart';

class DepositViewModel extends ChangeNotifier {
  int _amount = 0;
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();

  int get amount => _amount;
  String get selectedCategory => _selectedCategory;
  DateTime get selectedDate => _selectedDate;

  void setAmount(int value) {
    _amount = value;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void reset() {
    _amount = 0;
    _selectedCategory = '';
    _selectedDate = DateTime.now();
    notifyListeners();
  }
}
