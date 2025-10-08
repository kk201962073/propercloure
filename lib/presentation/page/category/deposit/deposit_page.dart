import 'package:flutter/material.dart';

class DepositPage extends StatefulWidget {
  final int amount;
  final DateTime selectedDate;

  const DepositPage({
    super.key,
    required this.amount,
    required this.selectedDate,
  });

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  @override
  Widget build(BuildContext context) {
    final depositCategories = [
      {'image': 'assets/image/salary.png', 'label': '월급'},
      {'image': 'assets/image/cash.png', 'label': '용돈'},
      {'image': 'assets/image/backorder.png', 'label': '이월'},
      {'image': 'assets/image/dots.png', 'label': '기타'},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
        title: Text("${widget.amount}원"),
      ),
      body: _buildCategoryGrid(depositCategories),
    );
  }

  Widget _buildCategoryGrid(List<Map<String, dynamic>> categories) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return InkWell(
          onTap: () {
            Navigator.pop(context, {
              'amount': widget.amount,
              'selectedDate': widget.selectedDate,
              'category': category['label'],
            });
          },
          child: Column(
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: Image.asset(category['image'], fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(
                category['label'],
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
