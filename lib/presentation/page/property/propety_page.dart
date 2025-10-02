import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/list/list_page.dart';
import 'package:propercloure/presentation/page/minuse/minuse_page.dart';
import 'package:propercloure/presentation/page/property/propety_viwe_model.dart';
import 'package:propercloure/presentation/page/pulse/pulse_page.dart';
import 'package:propercloure/presentation/page/guitar/guitar_page.dart';
import 'package:propercloure/presentation/page/home/home_page.dart';
import 'package:provider/provider.dart';

class PropertyPage extends StatelessWidget {
  const PropertyPage({super.key});

  String _formatAmount(int amount) {
    final str = amount.abs().toString();
    final buffer = StringBuffer();
    int len = str.length;
    for (int i = 0; i < len; i++) {
      buffer.write(str[i]);
      int pos = len - i - 1;
      if (pos % 3 == 0 && i != len - 1) {
        buffer.write(',');
      }
    }
    return '${amount < 0 ? '-' : ''}${buffer.toString()}원';
  }

  Widget _buildAssetCard(String title, String amount) {
    Color amountColor;
    if (title == "지출") {
      amountColor = Colors.red;
    } else if (amount.startsWith('-')) {
      amountColor = Colors.red;
    } else if (amount != "0원") {
      amountColor = Colors.blue;
    } else {
      amountColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: const Text("자산"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<PropertyViewModel>(
          builder: (context, vm, child) {
            final int total = vm.total;
            final int cash = vm.cash;
            final int income = vm.income;
            final int expense = vm.expense;
            final int others = vm.others;

            debugPrint("[PropertyPage] total: $total");
            debugPrint(
              "[PropertyPage] cash: $cash, income: $income, expense: $expense, others: $others",
            );
            debugPrint("[PropertyPage] records length: ${vm.records.length}");
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("총 자산", style: TextStyle(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  _formatAmount(total),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // 내 계좌
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "내 계좌",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListPage(),
                          ),
                        );
                      },
                      child: Text(
                        "${_formatAmount(cash)} >",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildAssetCard("현금", _formatAmount(cash)),

                const SizedBox(height: 30),

                // 내역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "내역",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatAmount(total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlusePage(),
                      ),
                    );
                  },
                  child: _buildAssetCard("수입", _formatAmount(income)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MinusePage(),
                      ),
                    );
                  },
                  child: _buildAssetCard("지출", _formatAmount(expense)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GuitarPage(),
                      ),
                    );
                  },
                  child: _buildAssetCard("기타", _formatAmount(others)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
