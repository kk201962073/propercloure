import 'package:flutter/material.dart';

class PropertyViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _records = [];

  int _amountOf(Map<String, dynamic> r) {
    final a = r['amount'];
    if (a == null) return 0;
    if (a is int) return a;
    if (a is double) return a.toInt();
    if (a is num) return a.toInt();
    // fallback if stored as string
    return int.tryParse(a.toString()) ?? 0;
  }

  /// 전체 합: 모든 레코드의 amount 합계
  int get total => _records.fold(0, (sum, r) => sum + _amountOf(r));

  /// 수입: amount가 양수이면서 category가 '기타'가 아닌 항목들의 합
  int get income => _records
      .where(
        (r) => _amountOf(r) > 0 && (r['category']?.toString() ?? '') != '기타',
      )
      .fold(0, (sum, r) => sum + _amountOf(r));

  /// 지출: amount가 음수인 항목들의 절대값 합
  /// (예: -100 + -200 => 300)
  int get expense => _records
      .where(
        (r) => _amountOf(r) < 0 && (r['category']?.toString() ?? '') != '기타',
      )
      .fold(0, (sum, r) => sum + (_amountOf(r).abs()));

  /// 현금: category가 '현금'인 항목들의 합
  int get cash => _records
      .where((r) => (r['category']?.toString() ?? '') == '현금')
      .fold(0, (sum, r) => sum + _amountOf(r));

  /// 기타: 금액이 0이거나 category가 '기타'로 분류된 항목들의 합
  int get others => _records
      .where(
        (r) => _amountOf(r) == 0 || (r['category']?.toString() ?? '') == '기타',
      )
      .fold(0, (sum, r) => sum + _amountOf(r));

  List<Map<String, dynamic>> get records => List.unmodifiable(_records);

  void addRecord(Map<String, dynamic> record) {
    _records.add(record);
    notifyListeners();
  }

  void addIncome(int amount) {
    addRecord({'amount': amount, 'category': '수입'});
  }

  void addExpense(int amount) {
    addRecord({'amount': -amount, 'category': '지출'});
  }

  void addOthers(int amount) {
    addRecord({'amount': amount, 'category': '기타'});
  }

  /// Public setters for each category (convenience helpers)
  void setIncome(int amount) {
    _records.add({'amount': amount, 'category': '수입'});
    notifyListeners();
  }

  void setExpense(int amount) {
    _records.add({'amount': -amount, 'category': '지출'});
    notifyListeners();
  }

  void setCash(int amount) {
    _records.add({'amount': amount, 'category': '현금'});
    notifyListeners();
  }

  void setOthers(int amount) {
    _records.add({'amount': amount, 'category': '기타'});
    notifyListeners();
  }

  void setRecords(List<Map<String, dynamic>> newRecords) {
    debugPrint(
      "[PropertyViewModel] setRecords 호출됨. newRecords 길이: ${newRecords.length}",
    );
    for (var record in newRecords) {
      debugPrint("[PropertyViewModel] record: $record");
    }
    _records.clear();
    _records.addAll(newRecords);
    debugPrint("[PropertyViewModel] ✅ 최종 저장된 _records 길이: ${_records.length}");
    notifyListeners();
  }
}
