import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pulse_view_model.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';

class PlusePage extends StatefulWidget {
  const PlusePage({super.key});

  @override
  State<PlusePage> createState() => _PlusePageState();
}

class _PlusePageState extends State<PlusePage> {
  @override
  void initState() {
    super.initState();
    // 홈에서 불러온 거래 목록을 PulseViewModel로 복사
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeVM = context.read<HomeViewModel>();
      final pulseVM = context.read<PulseViewModel>();
      pulseVM.setTransactions(homeVM.transactions);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 124, 197, 230),
            child: Container(
              width: double.infinity,
              height: 200,
              color: const Color.fromARGB(255, 124, 197, 230),
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
                          const Expanded(
                            child: Center(
                              child: Text(
                                "수입",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
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
                        Consumer<PulseViewModel>(
                          builder: (context, vm, _) => Text(
                            "${NumberFormat('#,###').format(vm.incomeTotal)}원",
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
                        context.read<PulseViewModel>().toggleSortOrder();
                      },
                      child: Consumer<PulseViewModel>(
                        builder: (context, vm, _) => Text(
                          (vm.isAscending) ? "날짜↑" : "날짜↓",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
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
                color: Colors.white,
                child: Consumer<PulseViewModel>(
                  builder: (context, vm, _) {
                    final incomeList = vm.incomeTransactions
                        .where((tx) => tx.category != "기타")
                        .toList();
                    if (incomeList.isEmpty) {
                      return const Center(
                        child: Text(
                          "수입 내역이 없습니다.",
                          style: TextStyle(color: Colors.black45, fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: incomeList.length,
                      itemBuilder: (context, index) {
                        final tx = incomeList[index];
                        return ListTile(
                          title: Text(
                            tx.category,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('yyyy-MM-dd HH:mm').format(tx.date),
                          ),
                          trailing: Text(
                            "${NumberFormat('#,###').format(tx.amount)}원",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
