import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/Home/home_pagestate.dart';

class PulseViewModel extends ChangeNotifier {
  final List<TransactionState> _transactions = [];

  List<TransactionState> get transactions => _transactions;

  List<TransactionState> get incomeTransactions => _transactions
      .where((tx) => tx.category == "수입" || tx.amount > 0)
      .toList();

  int get incomeTotal {
    // id 기준 중복 제거
    final uniqueTx = <String, TransactionState>{};
    for (final tx in _transactions) {
      uniqueTx[tx.id] = tx;
    }

    // 수입만 합산 (기타 제외)
    return uniqueTx.values
        .where((tx) => tx.amount > 0 && tx.category != "기타")
        .fold(0, (sum, tx) => sum + tx.amount.toInt());
  }

  //날짜 오름차순 (과거 → 최신)
  List<TransactionState> get incomeTransactionsByDateAsc {
    final sorted = List<TransactionState>.from(incomeTransactions);
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  // 날짜 내림차순 (최신 → 과거)
  List<TransactionState> get incomeTransactionsByDateDesc {
    final sorted = List<TransactionState>.from(incomeTransactions);
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
    debugPrint(
      "[PulseViewModel] Transactions reset. New count: ${_transactions.length}",
    );
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

  List<TransactionState> get incomeTransactionsSorted {
    final sorted = List<TransactionState>.from(
      incomeTransactions.where((tx) => tx.category != "기타"),
    );
    sorted.sort(
      (a, b) =>
          _isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
    return sorted;
  }
}
