import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';
import 'package:provider/provider.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key});

  Future<void> _showYearMonthPicker(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    // 연도 선택
    int? selectedYear = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('연도 선택'),
        children: viewModel.allYears
            .map(
              (year) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, year),
                child: Text(
                  '$year년',
                  style: TextStyle(
                    fontWeight: year == viewModel.selectedYear
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    if (selectedYear != null) {
      viewModel.setYear(selectedYear);

      // 월 선택
      int? selectedMonth = await showDialog<int>(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text('월 선택'),
          children: viewModel.allMonths
              .map(
                (month) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, month),
                  child: Text(
                    '$month월',
                    style: TextStyle(
                      fontWeight: month == viewModel.selectedMonth
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

      if (selectedMonth != null) {
        viewModel.setMonth(selectedMonth);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .snapshots(),
        builder: (context, snapshot) {
          int monthlyIncome = 0;
          int monthlyExpense = 0;

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docs = snapshot.data!.docs;
            for (var doc in docs) {
              final data = doc.data() as Map<String, dynamic>;
              final dynamic dateField = data['date'];
              DateTime? date;
              if (dateField is Timestamp) {
                date = dateField.toDate();
              } else if (dateField is String) {
                date = DateTime.tryParse(dateField);
              } else if (dateField is DateTime) {
                date = dateField;
              }

              if (date != null &&
                  date.year == viewModel.selectedYear &&
                  date.month == viewModel.selectedMonth) {
                final amount = int.tryParse(data['amount'].toString()) ?? 0;
                if (amount > 0) {
                  monthlyIncome += amount;
                } else {
                  monthlyExpense += amount;
                }
              }
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 연도/월
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!context.mounted) return;
                      _showYearMonthPicker(context, viewModel);
                    },
                    child: Row(
                      children: [
                        Text(
                          '${viewModel.selectedYear}년 ${viewModel.selectedMonth}월',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, color: textColor),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 총 합계 표시
              Text(
                '총 합계 ${(monthlyIncome + monthlyExpense).toString()}원',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.black,
                ),
              ),

              const SizedBox(height: 4),

              // 월간 수입/지출 표시
              Row(
                children: [
                  Text(
                    '수입 +$monthlyIncome원',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '지출 -${monthlyExpense.abs()}원',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
