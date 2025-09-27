import 'package:flutter/material.dart';

class AddViewModel extends ChangeNotifier {
  DateTime _selectedDate;

  DateTime get selectedDate => _selectedDate;

  AddViewModel(DateTime initialDate) : _selectedDate = initialDate;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
