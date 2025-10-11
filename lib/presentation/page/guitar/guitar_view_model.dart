import 'package:flutter/foundation.dart';
import 'package:propercloure/presentation/page/Home/home_pagestate.dart';

class GuitarViewModel extends ChangeNotifier {
  bool isAscending = true;
  List<TransactionState> guitarTransactions = [];

  void setTransactions(List<TransactionState> tx) {
    // "기타" 카테고리만 필터링
    final filtered = tx.where((t) => t.category == "기타").toList();

    // id 기준으로 중복 제거
    final uniqueTx = <String, TransactionState>{};
    for (final t in filtered) {
      uniqueTx[t.id] = t;
    }

    // 기존 데이터와 동일할 경우 업데이트 생략 (중복 합산 방지)
    final newList = uniqueTx.values.toList();
    if (listEquals(guitarTransactions, newList)) {
      return;
    }

    guitarTransactions = newList;
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
