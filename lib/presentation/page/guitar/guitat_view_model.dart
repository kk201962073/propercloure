import 'package:flutter/foundation.dart';
import 'package:propercloure/presentation/page/Home/home_pagestate.dart';

class GuitarViewModel extends ChangeNotifier {
  bool isAscending = true;
  List<TransactionState> guitarTransactions = [];

  void setTransactions(List<TransactionState> tx) {
    // "기타" 카테고리만 필터링
    guitarTransactions = tx.where((t) => t.category == "기타").toList();
    notifyListeners();
  }

  void toggleSortOrder() {
    isAscending = !isAscending;
    guitarTransactions.sort(
      (a, b) =>
          isAscending ? a.date.compareTo(b.date) : b.date.compareTo(a.date),
    );
    notifyListeners();
  }

  List<TransactionState> get guitarTransactionsSorted => guitarTransactions;
}
