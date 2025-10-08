import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:propercloure/presentation/page/add/add_page.dart';
import 'package:propercloure/presentation/page/property/propety_viwe_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';
import 'package:propercloure/presentation/page/property/propety_page.dart';
import 'package:propercloure/presentation/page/profile/profile_page.dart';
import 'package:propercloure/presentation/page/ai/ai_page.dart';

class HomePage extends StatefulWidget {
  final bool hasExpense;
  const HomePage({super.key, this.hasExpense = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      final propertyViewModel = Provider.of<PropertyViewModel>(
        context,
        listen: false,
      );
      homeViewModel.loadTransactions(propertyViewModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          DateTime selectedDay = viewModel.selectedDay;
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 상단: 월, 합계
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // 1. 연도 선택 다이얼로그 표시
                            final int? selectedYear = await showDialog<int>(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: const Text("연도 선택"),
                                  children: viewModel.allYears
                                      .map(
                                        (year) => SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.of(context).pop(year);
                                          },
                                          child: Text("$year년"),
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                            );
                            if (selectedYear == null) return;
                            // 2. 월 선택 다이얼로그 표시
                            final int? selectedMonth = await showDialog<int>(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: const Text("월 선택"),
                                  children: viewModel.allMonths
                                      .map(
                                        (month) => SimpleDialogOption(
                                          onPressed: () {
                                            Navigator.of(context).pop(month);
                                          },
                                          child: Text("$month월"),
                                        ),
                                      )
                                      .toList(),
                                );
                              },
                            );
                            if (selectedMonth == null) return;
                            // ViewModel에 연도와 월을 업데이트
                            viewModel.setYear(selectedYear);
                            viewModel.setMonth(selectedMonth);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${viewModel.selectedYear}년 ${viewModel.selectedMonth}월",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ],
                          ),
                        ),
                        // 총 합계는 아래 StreamBuilder에서 계산된 값을 사용하도록 교체됨
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('transactions')
                              .snapshots(),
                          builder: (context, snapshot) {
                            int monthlyIncome = 0;
                            int monthlyExpense = 0;
                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              final docs = snapshot.data!.docs;
                              final List<Map<String, dynamic>> parsed = docs
                                  .map<Map<String, dynamic>>((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    final dynamic dateRaw = data['date'];
                                    DateTime date;
                                    if (dateRaw is DateTime) {
                                      date = dateRaw;
                                    } else if (dateRaw is String) {
                                      try {
                                        date = DateTime.parse(dateRaw);
                                      } catch (_) {
                                        date = DateTime.now();
                                      }
                                    } else if (dateRaw is Timestamp) {
                                      date = dateRaw.toDate();
                                    } else {
                                      date = DateTime.now();
                                    }
                                    return {...data, 'date': date};
                                  })
                                  .toList();
                              final currentMonthTx = parsed.where((tx) {
                                final txDate = tx['date'] as DateTime;
                                return txDate.year == viewModel.selectedYear &&
                                    txDate.month == viewModel.selectedMonth;
                              }).toList();
                              for (final tx in currentMonthTx) {
                                final amount = tx['amount'] is int
                                    ? tx['amount'] as int
                                    : int.tryParse(
                                            tx['amount']?.toString() ?? '0',
                                          ) ??
                                          0;
                                if (amount > 0) {
                                  monthlyIncome += amount;
                                } else {
                                  monthlyExpense += amount;
                                }
                              }
                            }
                            final monthlyBalance =
                                monthlyIncome + monthlyExpense;
                            return Text(
                              "총 합계 $monthlyBalance",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 월간 수입/지출 요약 (달력 위)
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('transactions')
                          .snapshots(),
                      builder: (context, snapshot) {
                        int monthlyIncome = 0;
                        int monthlyExpense = 0;
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          final docs = snapshot.data!.docs;
                          final List<Map<String, dynamic>> parsed = docs
                              .map<Map<String, dynamic>>((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final dynamic dateRaw = data['date'];
                                DateTime date;
                                if (dateRaw is DateTime) {
                                  date = dateRaw;
                                } else if (dateRaw is String) {
                                  try {
                                    date = DateTime.parse(dateRaw);
                                  } catch (_) {
                                    date = DateTime.now();
                                  }
                                } else if (dateRaw is Timestamp) {
                                  date = dateRaw.toDate();
                                } else {
                                  date = DateTime.now();
                                }
                                return {...data, 'date': date};
                              })
                              .toList();

                          final currentMonthTx = parsed.where((tx) {
                            final txDate = tx['date'] as DateTime;
                            return txDate.year == viewModel.selectedYear &&
                                txDate.month == viewModel.selectedMonth;
                          }).toList();

                          for (final tx in currentMonthTx) {
                            final amount = tx['amount'] is int
                                ? tx['amount'] as int
                                : int.tryParse(
                                        tx['amount']?.toString() ?? '0',
                                      ) ??
                                      0;
                            if (amount > 0) {
                              monthlyIncome += amount;
                            } else {
                              monthlyExpense += amount;
                            }
                          }
                        }
                        // monthlyBalance is available here if needed
                        return Row(
                          children: [
                            Text(
                              "수입 +$monthlyIncome",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.blue
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              "지출 -${monthlyExpense.abs()}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // 달력
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      headerVisible: false,
                      selectedDayPredicate: (day) {
                        return isSameDay(day, selectedDay);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        viewModel.setSelectedDay(selectedDay);
                      },
                      onPageChanged: (focusedDay) {
                        viewModel.setYear(focusedDay.year);
                        viewModel.setMonth(focusedDay.month);
                      },
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue
                              : Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // 지출 내역 - Firestore StreamBuilder (실시간 반영) + 월간 수입/지출 계산
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('transactions')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Expanded(
                              child: Center(child: _NoExpenseText()),
                            );
                          }
                          final docs = snapshot.data!.docs;

                          final List<Map<String, dynamic>> sortedTransactions =
                              docs.map<Map<String, dynamic>>((doc) {
                                final data = doc.data() as Map<String, dynamic>;
                                final dynamic dateRaw = data['date'];
                                DateTime date;
                                if (dateRaw is DateTime) {
                                  date = dateRaw;
                                } else if (dateRaw is String) {
                                  try {
                                    date = DateTime.parse(dateRaw);
                                  } catch (_) {
                                    date = DateTime.now();
                                  }
                                } else {
                                  date = DateTime.now();
                                }
                                return {...data, 'date': date};
                              }).toList()..sort(
                                (a, b) => (a['date'] as DateTime).compareTo(
                                  b['date'] as DateTime,
                                ),
                              );

                          return Column(
                            children: [
                              // 지출 내역 리스트
                              Expanded(
                                child: ListView.builder(
                                  itemCount: sortedTransactions.length,
                                  itemBuilder: (context, index) {
                                    final tx = sortedTransactions[index];
                                    final DateTime txDate =
                                        tx['date'] as DateTime;
                                    final int amount = (tx['amount'] is int)
                                        ? tx['amount'] as int
                                        : int.tryParse(
                                                tx['amount']?.toString() ?? '0',
                                              ) ??
                                              0;
                                    final String category =
                                        tx['category']?.toString() ?? '기타';
                                    return _buildExpenseItem(
                                      amount,
                                      category,
                                      txDate,
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 플로팅 버튼
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                debugPrint('Navigating to AddPage...');
                final result = await Navigator.push<Map<String, dynamic>?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPage(initialDate: selectedDay),
                  ),
                );

                if (!context.mounted) return;

                debugPrint('Returned from AddPage with result: $result');

                if (result != null) {
                  debugPrint('Result keys: ${result.keys}');
                  debugPrint('Result values: $result');

                  final dynamic titleDynamic = result['title'];
                  final String title = titleDynamic is String
                      ? titleDynamic
                      : titleDynamic is Map
                      ? (titleDynamic['name'] ?? '')
                      : '';

                  final dynamic amountDynamic = result['amount'];
                  int amount = 0;
                  if (amountDynamic is int) {
                    amount = amountDynamic;
                  } else if (amountDynamic is String) {
                    amount = int.tryParse(amountDynamic) ?? 0;
                  }

                  final dynamic categoryDynamic = result['category'];
                  final String category = categoryDynamic is String
                      ? categoryDynamic
                      : categoryDynamic is Map
                      ? (categoryDynamic['name'] ?? '')
                      : '';

                  final dynamic dateDynamic = result['date'];
                  DateTime date = selectedDay;
                  if (dateDynamic is DateTime) {
                    date = dateDynamic;
                  } else if (dateDynamic is String) {
                    try {
                      date = DateTime.parse(dateDynamic);
                    } catch (_) {}
                  }

                  debugPrint('Parsed Title: $title');
                  debugPrint('Parsed Amount: $amount');
                  debugPrint('Parsed Category: $category');
                  debugPrint('Parsed Date: $date');

                  final safeTitle = title.isNotEmpty ? title : '제목 없음';
                  final safeCategory = category.isNotEmpty ? category : '기타';

                  viewModel.setSelectedDay(date);
                  await viewModel.addTransaction(
                    safeTitle,
                    amount,
                    safeCategory,
                    date,
                  );
                }
              },
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blue
                  : Theme.of(context).colorScheme.primary,
              child: Icon(Icons.add, color: Theme.of(context).iconTheme.color),
            ),

            // 하단 네비게이션
            bottomNavigationBar: BottomAppBar(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              height: 80,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/image/calender.png",
                        width: 64,
                        height: 64,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PropertyPage(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/image/money.png",
                        width: 64,
                        height: 64,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AiPage(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/image/ai.png",
                        width: 64,
                        height: 64,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        "assets/image/profile.png",
                        width: 64,
                        height: 64,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildExpenseItem(int amount, String category, DateTime date) {
  final isIncome = amount > 0;
  return Builder(
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Text(
            isIncome ? "+${amount.abs()}원" : "-${amount.abs()}원",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isIncome
                  ? (Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue
                        : Theme.of(context).colorScheme.primary)
                  : Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    ),
  );
}

class _NoExpenseText extends StatelessWidget {
  const _NoExpenseText();
  @override
  Widget build(BuildContext context) {
    return Text(
      "지출 내역이 없습니다.",
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}
