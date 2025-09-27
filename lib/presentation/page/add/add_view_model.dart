import 'package:flutter/material.dart';

class AddViewModel extends ChangeNotifier {
  DateTime _selectedDate;
  int _amount = 0;
  int _amountRight = 0;
  String? _selectedCategory;

  DateTime get selectedDate => _selectedDate;
  int get amount => _amount;
  int get amountRight => _amountRight;
  String? get selectedCategory => _selectedCategory;

  AddViewModel(DateTime initialDate) : _selectedDate = initialDate;

  set amount(int amount) {
    _amount = amount;
    notifyListeners();
  }

  set amountRight(int amountRight) {
    _amountRight = amountRight;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void reset() {
    _amount = 0;
    _amountRight = 0;
    _selectedCategory = null;
    _selectedDate = DateTime.now();
    notifyListeners();
  }
}
