import 'package:flutter/material.dart';

class AddViewModel extends ChangeNotifier {
  DateTime _selectedDate;
  int _amount = 0;
  int _amountRight = 0;

  DateTime get selectedDate => _selectedDate;
  int get amount => _amount;
  int get amountRight => _amountRight;

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
}
