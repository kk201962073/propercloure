import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propercloure/presentation/page/property/propety_viwe_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeViewModel extends ChangeNotifier {
  DateTime _selectedDay = DateTime.now();
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  List<Map<String, dynamic>> transactions = [];
  late final FirebaseFirestore _firestore;

  HomeViewModel() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (e) {}
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

  void loadTransactions(String uid, PropertyViewModel propertyViewModel) {
    _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .snapshots()
        .listen((querySnapshot) {
          try {
            transactions = querySnapshot.docs.map<Map<String, dynamic>>((doc) {
              final data = doc.data();
              final rawAmount = data['amount'];
              int parsedAmount = 0;
              if (rawAmount is int) {
                parsedAmount = rawAmount;
              } else if (rawAmount is String) {
                parsedAmount = int.tryParse(rawAmount) ?? 0;
              }
              return {
                'id': doc.id,
                'title': data['title'] ?? '',
                'amount': parsedAmount,
                'category': data['category'] ?? '',
                'date': data['date'] != null
                    ? DateTime.tryParse(data['date'].toString()) ??
                          DateTime.now()
                    : DateTime.now(),
              };
            }).toList();
            debugPrint(
              "[HomeViewModel] Transactions loaded: ${transactions.length}",
            );
            propertyViewModel.setRecords(transactions);
            debugPrint(
              "[HomeViewModel] setRecords 호출됨. 길이: ${transactions.length}",
            );
            notifyListeners();
          } catch (e, st) {
            debugPrint("[HomeViewModel] Error parsing transactions: $e\n$st");
          }
        });
  }

  Future<void> addTransaction(
    String uid,
    String title,
    int amount,
    String category,
    DateTime date,
  ) async {
    try {
      final docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .add({
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
    } catch (e) {}
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
                : (newTransaction['date']?.toString() ??
                      DateTime.now().toIso8601String()),
          });
          transactions[index] = {
            'id': docId,
            'title': newTransaction['title'],
            'amount': newTransaction['amount'],
            'category': newTransaction['category'],
            'date': newTransaction['date'] is DateTime
                ? newTransaction['date']
                : (newTransaction['date'] != null
                      ? DateTime.tryParse(newTransaction['date'].toString()) ??
                            DateTime.now()
                      : DateTime.now()),
          };
          notifyListeners();
        } catch (e) {}
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

  // 월별 데이터 필터링
  List<Map<String, dynamic>> get monthlyTransactions {
    return transactions.where((tx) {
      final date = tx['date'] as DateTime;
      return date.year == _selectedYear && date.month == _selectedMonth;
    }).toList();
  }

  // 일별 데이터 필터링
  List<Map<String, dynamic>> get dailyTransactions {
    return transactions.where((tx) {
      final date = tx['date'] as DateTime;
      return date.year == _selectedDay.year &&
          date.month == _selectedDay.month &&
          date.day == _selectedDay.day;
    }).toList();
  }

  // 월별 합계
  int get monthlyIncome => monthlyTransactions
      .where((tx) => tx['amount'] > 0)
      .fold(0, (sum, tx) => sum + (tx['amount'] as int));

  int get monthlyExpense => monthlyTransactions
      .where((tx) => tx['amount'] < 0)
      .fold(0, (sum, tx) => sum + (tx['amount'] as int).abs());

  int get monthlyBalance =>
      monthlyTransactions.fold(0, (sum, tx) => sum + (tx['amount'] as int));

  // 일별 합계
  int get dailyIncome => dailyTransactions
      .where((tx) => tx['amount'] > 0)
      .fold(0, (sum, tx) => sum + (tx['amount'] as int));

  int get dailyExpense => dailyTransactions
      .where((tx) => tx['amount'] < 0)
      .fold(0, (sum, tx) => sum + (tx['amount'] as int).abs());

  int get dailyBalance =>
      dailyTransactions.fold(0, (sum, tx) => sum + (tx['amount'] as int));
}
