import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/Home/home_pagestate.dart';

class MinuseViewModel extends ChangeNotifier {
  final List<TransactionState> _transactions = [];

  List<TransactionState> get transactions => _transactions;

  List<TransactionState> get expenseTransactions =>
      _transactions.where((tx) => tx.amount < 0).toList();

  int get expenseTotal {
    // 중복 제거 (id 기준)
    final uniqueTx = <String, TransactionState>{};
    for (final tx in expenseTransactions) {
      uniqueTx[tx.id] = tx;
    }

    // 총합 계산 (기타 제외, 중복 제거 후)
    final result = uniqueTx.values
        .where((tx) => tx.category != "기타")
        .fold(0, (sum, tx) => sum + tx.amount.abs().toInt());

    return result;
  }

  //날짜 오름차순 (과거 → 최신)
  List<TransactionState> get expenseTransactionsByDateAsc {
    final sorted = List<TransactionState>.from(expenseTransactions);
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  // 날짜 내림차순 (최신 → 과거)
  List<TransactionState> get expenseTransactionsByDateDesc {
    final sorted = List<TransactionState>.from(expenseTransactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  bool _isAscending = true;
  bool get isAscending => _isAscending;

  void addTransaction(TransactionState tx) {
    _transactions.add(tx);
    notifyListeners();
  }

  void setTransactions(List<dynamic> newTx) {
    _transactions.clear();
    _transactions.addAll(
      newTx.map((tx) {
        if (tx is TransactionState) {
          return tx;
        } else if (tx is Map<String, dynamic>) {
          return TransactionState.fromJson(tx);
        } else {
          throw ArgumentError("Unsupported transaction type: $tx");
        }
      }),
    );
    notifyListeners();
  }

  void toggleSortOrder() {
    _isAscending = !_isAscending;
    _transactions.sort(
      (a, b) =>
          _isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
    notifyListeners();
  }

  List<TransactionState> get expenseTransactionsSorted {
    final sorted = List<TransactionState>.from(
      expenseTransactions.where((tx) => tx.category != "기타"),
    );
    sorted.sort(
      (a, b) =>
          _isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
    return sorted;
  }
}
