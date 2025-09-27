class TransactionState {
  final DateTime date;
  final double amount;
  final String category;
  final String title;

  TransactionState({
    required this.date,
    required this.amount,
    required this.category,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'amount': amount,
      'category': category,
      'title': title,
    };
  }
}
