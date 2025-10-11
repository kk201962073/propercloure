import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/minuse/minuse_view_model.dart';
import 'package:provider/provider.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';

class MinusePage extends StatefulWidget {
  const MinusePage({super.key});

  @override
  State<MinusePage> createState() => _MinusePageState();
}

class _MinusePageState extends State<MinusePage> {
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    // 홈에서 불러온 거래 목록을 PulseViewModel로 복사
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized) return;
      _initialized = true;

      final homeVM = context.read<HomeViewModel>();
      final pulseVM = context.read<MinuseViewModel>();
      pulseVM.setTransactions(homeVM.transactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.red
                : Colors.red,
            child: Container(
              width: double.infinity,
              height: 200,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.red
                  : Colors.red,
              child: Stack(
                children: [
                  SafeArea(
                    top: true,
                    child: Container(
                      height: kToolbarHeight,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                "지출",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),

                  // 중앙 금액
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 80),
                        Consumer<MinuseViewModel>(
                          builder: (context, vm, _) => Text(
                            "${NumberFormat('#,###').format(vm.expenseTotal)}원",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 우측 하단 날짜순 (정렬 토글)
                  Positioned(
                    right: 12,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: () {
                        context.read<MinuseViewModel>().toggleSortOrder();
                      },
                      child: Consumer<MinuseViewModel>(
                        builder: (context, vm, _) => Text(
                          vm.isAscending ? "날짜↑" : "날짜↓",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Consumer<MinuseViewModel>(
                  builder: (context, vm, _) {
                    final expenseList = vm.expenseTransactions
                        .where((tx) => tx.category != "기타")
                        .toList()
                        .fold<Map<String, dynamic>>({}, (map, tx) {
                          map[tx.id] = tx;
                          return map;
                        })
                        .values
                        .toList();
                    if (expenseList.isEmpty) {
                      return Center(
                        child: Text(
                          "지출 내역이 없습니다.",
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: expenseList.length,
                      itemBuilder: (context, index) {
                        final tx = expenseList[index];
                        return ListTile(
                          title: Text(
                            tx.category,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(tx.date),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                            ),
                          ),
                          trailing: Text(
                            "${NumberFormat('#,###').format(tx.amount)}원",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.color,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
