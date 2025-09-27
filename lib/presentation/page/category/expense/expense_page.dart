import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/home/home_page.dart';

class ExpensePage extends StatelessWidget {
  final int amount;
  final DateTime selectedDate;

  const ExpensePage({
    super.key,
    required this.amount,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final expenseCategories = [
      {'image': 'assets/image/food.png', 'label': '식비'},
      {'image': 'assets/image/transportation.png', 'label': '교통비'},
      {'image': 'assets/image/clothing.png', 'label': '의류'},
      {'image': 'assets/image/lnsurance.png', 'label': '보험'},
      {'image': 'assets/image/beauty.png', 'label': '미용'},
      {'image': 'assets/image/healthcare.png', 'label': '의료건강'},
      {'image': 'assets/image/education.png', 'label': '교육'},
      {'image': 'assets/image/communication.png', 'label': '통신비'},
      {'image': 'assets/image/utilities.png', 'label': '공과금'},
      {'image': 'assets/image/savings.png', 'label': '저축'},
      {'image': 'assets/image/dots.png', 'label': '기타'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${amount.toString()}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _buildCategoryGrid(expenseCategories),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          child: Column(
            children: [
              SizedBox(
                height: 48,
                width: 48,
                child: Image.asset(category['image'], fit: BoxFit.contain),
              ),
              const SizedBox(height: 8),
              Text(category['label']),
            ],
          ),
        );
      },
    );
  }
}
