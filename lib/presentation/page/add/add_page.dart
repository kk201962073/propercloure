import 'package:propercloure/presentation/page/category/deposit/deposit_page.dart';
import 'package:propercloure/presentation/page/category/expense/expense_page.dart';
import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/add/add_view_model.dart';
import 'package:provider/provider.dart';

class AddPage extends StatelessWidget {
  final DateTime initialDate;
  const AddPage({super.key, required this.initialDate});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddViewModel(initialDate),
      child: Consumer<AddViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('등록'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: viewModel.selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != viewModel.selectedDate) {
                        viewModel.setDate(picked);
                      }
                    },
                    child: Text(
                      '${viewModel.selectedDate.year}년 ${viewModel.selectedDate.month.toString().padLeft(2, '0')}월 ${viewModel.selectedDate.day.toString().padLeft(2, '0')}일',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        '₩',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              child: SizedBox(
                                width: constraints.maxWidth,
                                height: 60,
                                child: TextField(
                                  controller:
                                      TextEditingController(
                                          text: viewModel.amountRight
                                              .toString(),
                                        )
                                        ..selection =
                                            TextSelection.fromPosition(
                                              TextPosition(
                                                offset: viewModel.amountRight
                                                    .toString()
                                                    .length,
                                              ),
                                            ),
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 50,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) {
                                    final parsed = int.tryParse(value) ?? 0;
                                    viewModel.amountRight = parsed;
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(148, 76),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DepositPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "입금",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: const Size(148, 76),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpensePage(),
                              ),
                            );
                          },
                          child: const Text(
                            "지출",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
