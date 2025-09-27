import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/category/deposit/deposit_page.dart';
import 'package:propercloure/presentation/page/category/expense/expense_page.dart';
import 'package:propercloure/presentation/page/add/add_view_model.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  final DateTime initialDate;

  const AddPage({super.key, required this.initialDate});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddViewModel(widget.initialDate),
      child: Consumer<AddViewModel>(
        builder: (context, viewModel, child) {
          // TextField 값 동기화
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
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: viewModel.selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (!mounted) return;
                      if (picked != null && picked != viewModel.selectedDate) {
                        viewModel.setDate(picked);
                      }
                    },
                    child: Text(
                      '${viewModel.selectedDate.year}년 '
                      '${viewModel.selectedDate.month.toString().padLeft(2, '0')}월 '
                      '${viewModel.selectedDate.day.toString().padLeft(2, '0')}일',
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
                              viewModel.amountRight = int.tryParse(value) ?? 0;
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
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DepositPage(
                                  amount: viewModel.amountRight,
                                  selectedDate: viewModel.selectedDate,
                                ),
                              ),
                            );
                            if (!mounted) return;
                            String category = '';
                            if (result != null) {
                              if (result is String) {
                                category = result;
                              } else if (result is Map &&
                                  result['category'] is String) {
                                category = result['category'];
                              }
                            }
                            Navigator.pop(context, {
                              'amount': viewModel.amountRight.abs(),
                              'category': category,
                              'date': viewModel.selectedDate,
                            });
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
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ExpensePage(
                                  amount: viewModel.amountRight,
                                  selectedDate: viewModel.selectedDate,
                                ),
                              ),
                            );
                            if (!mounted) return;
                            String category = '';
                            if (result != null) {
                              if (result is String) {
                                category = result;
                              } else if (result is Map &&
                                  result['category'] is String) {
                                category = result['category'];
                              }
                            }
                            Navigator.pop(context, {
                              'amount': -viewModel.amountRight.abs(),
                              'category': category,
                              'date': viewModel.selectedDate,
                            });
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
