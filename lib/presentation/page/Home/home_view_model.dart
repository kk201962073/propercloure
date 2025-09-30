import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<Map<String, dynamic>> transactions = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeViewModel() {
    loadTransactions();
  }

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

  Future<void> loadTransactions() async {
    final querySnapshot = await _firestore.collection('transactions').get();
    transactions = querySnapshot.docs.map<Map<String, dynamic>>((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'],
        'amount': data['amount'],
        'category': data['category'],
        'date': DateTime.parse(data['date']),
      };
    }).toList();
    notifyListeners();
  }

  Future<void> addTransaction(
    String title,
    int amount,
    String category,
    DateTime date,
  ) async {
    final docRef = await _firestore.collection('transactions').add({
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    });
    transactions.add({
      'id': docRef.id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    });
    notifyListeners();
  }

  Future<void> updateTransaction(
    int index,
    Map<String, dynamic> newTransaction,
  ) async {
    if (index >= 0 && index < transactions.length) {
      final transaction = transactions[index];
      final String? docId = transaction['id'];
      if (docId != null) {
        try {
          await _firestore.collection('transactions').doc(docId).update({
            'title': newTransaction['title'],
            'amount': newTransaction['amount'],
            'category': newTransaction['category'],
            'date': (newTransaction['date'] is DateTime)
                ? (newTransaction['date'] as DateTime).toIso8601String()
                : newTransaction['date'],
          });
          transactions[index] = {
            'id': docId,
            'title': newTransaction['title'],
            'amount': newTransaction['amount'],
            'category': newTransaction['category'],
            'date': newTransaction['date'] is DateTime
                ? newTransaction['date']
                : DateTime.parse(newTransaction['date']),
          };
          notifyListeners();
        } catch (e) {
          debugPrint('Failed to update transaction: $e');
        }
      }
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
