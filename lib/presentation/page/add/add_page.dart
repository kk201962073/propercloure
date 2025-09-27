import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/category/deposit/deposit_page.dart';
import 'package:propercloure/presentation/page/category/expense/expense_page.dart';
import 'package:propercloure/presentation/page/add/add_view_model.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  final DateTime initialDate;
  const AddPage({super.key, required this.initialDate});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddViewModel(widget.initialDate),
      child: Consumer<AddViewModel>(
        builder: (context, viewModel, child) {
          final newText = viewModel.amountRight.toString();
          if (_controller.text != newText) {
            _controller.text = newText;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          }

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
                        print('Date picked: $picked');
                        viewModel.setDate(picked);
                        print(
                          'Date updated in viewModel: ${viewModel.selectedDate}',
                        );
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
                        child: SizedBox(
                          height: 60,
                          child: TextField(
                            controller: _controller,
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
                              print(
                                'TextField changed: value=$value, amountRight=${viewModel.amountRight}',
                              );
                            },
                          ),
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
                          onPressed: () async {
                            print('Deposit button pressed:');
                            print('amountRight: ${viewModel.amountRight}');
                            print('selectedDate: ${viewModel.selectedDate}');
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DepositPage(
                                  amount: viewModel.amountRight,
                                  selectedDate: viewModel.selectedDate,
                                ),
                              ),
                            );
                            print('result: $result');
                            String category = '';
                            if (result != null) {
                              if (result is String) {
                                category = result;
                              } else if (result is Map &&
                                  result['category'] is String) {
                                category = result['category'];
                              }
                              Navigator.pop(context, {
                                'amount': viewModel.amountRight.abs(),
                                'category': category,
                                'date': viewModel.selectedDate,
                              });
                            } else {
                              Navigator.pop(context, {
                                'amount': viewModel.amountRight.abs(),
                                'category': '',
                                'date': viewModel.selectedDate,
                              });
                            }
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
                          onPressed: () async {
                            print('Expense button pressed:');
                            print('amountRight: ${viewModel.amountRight}');
                            print('selectedDate: ${viewModel.selectedDate}');
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpensePage(
                                  amount: viewModel.amountRight,
                                  selectedDate: viewModel.selectedDate,
                                ),
                              ),
                            );
                            print('result: $result');
                            String category = '';
                            if (result != null) {
                              if (result is String) {
                                category = result;
                              } else if (result is Map &&
                                  result['category'] is String) {
                                category = result['category'];
                              }
                              Navigator.pop(context, {
                                'amount': -viewModel.amountRight.abs(),
                                'category': category,
                                'date': viewModel.selectedDate,
                              });
                            } else {
                              Navigator.pop(context, {
                                'amount': -viewModel.amountRight.abs(),
                                'category': '',
                                'date': viewModel.selectedDate,
                              });
                            }
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
