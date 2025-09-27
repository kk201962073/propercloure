import 'package:flutter/material.dart';

class DepositPage extends StatelessWidget {
  const DepositPage({super.key});

  @override
  Widget build(BuildContext context) {
    final depositCategories = [
      {'image': 'assets/image/salary.png', 'label': '월급'},
      {'image': 'assets/image/cash.png', 'label': '용돈'},
      {'image': 'assets/image/backorder.png', 'label': '이월'},
      {'image': 'assets/image/dots.png', 'label': '기타'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("0원"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
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
        return Column(
          children: [
            SizedBox(
              height: 48,
              width: 48,
              child: Image.asset(category['image'], fit: BoxFit.contain),
            ),
            const SizedBox(height: 8),
            Text(category['label']),
          ],
        );
      },
    );
  }
}
