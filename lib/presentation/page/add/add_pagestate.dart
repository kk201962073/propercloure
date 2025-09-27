class AddPageState {
  DateTime date;
  int amount;
  String category;

  AddPageState({
    required this.date,
    required this.amount,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {'date': date, 'amount': amount, 'category': category};
  }
}
