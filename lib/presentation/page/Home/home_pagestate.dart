class TransactionState {
  final String id;
  final DateTime date;
  final double amount;
  final String category;
  final String title;

  TransactionState({
    required this.id,
    required this.date,
    required this.amount,
    required this.category,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category,
      'title': title,
    };
  }

  factory TransactionState.fromJson(Map<String, dynamic> json) {
    return TransactionState(
      id: json['id']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : (json['amount'] as num).toDouble(),
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '제목 없음',
    );
  }
}
