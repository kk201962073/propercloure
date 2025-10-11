import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/Home/home_pagestate.dart';
import 'package:propercloure/presentation/page/guitar/guitar_view_model.dart';
import 'package:provider/provider.dart';
import 'package:propercloure/presentation/page/Home/home_view_model.dart';

class GuitarPage extends StatefulWidget {
  const GuitarPage({super.key});

  @override
  State<GuitarPage> createState() => _GuitarPageState();
}

class _GuitarPageState extends State<GuitarPage> {
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    // 홈에서 불러온 거래 목록을 GuitarViewModel로 복사
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_initialized) return;
      _initialized = true;

      final homeVM = context.read<HomeViewModel>();
      final guitarVM = context.read<GuitarViewModel>();
      print("[GuitarPage] 홈 트랜잭션 불러오기, 개수: ${homeVM.transactions.length}");

      final txList = homeVM.transactions
          .map((tx) {
            print("[GuitarPage] 원본 tx: $tx");
            return TransactionState.fromJson(tx);
          })
          .where((tx) {
            final result = tx.category == "기타";
            print(
              "[GuitarPage] 변환된 tx: ${tx.title}, category: ${tx.category}, 포함여부: $result",
            );
            return result;
          })
          .toList();

      print("[GuitarPage] 기타 카테고리 tx 개수: ${txList.length}");
      guitarVM.setTransactions(txList);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("[GuitarPage] build 실행됨");
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.orange
                : Colors.orange,
            child: Container(
              width: double.infinity,
              height: 200,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.orange
                  : Colors.orange,
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
                                "기타",
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
                        Consumer<GuitarViewModel>(
                          builder: (context, vm, _) => Text(
                            "${NumberFormat('#,###').format(vm.guitarTransactions.fold<int>(0, (sum, tx) => sum + tx.amount.toInt()))}원",
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
                        context.read<GuitarViewModel>().toggleSortOrder();
                      },
                      child: Consumer<GuitarViewModel>(
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
                child: Consumer<GuitarViewModel>(
                  builder: (context, vm, _) {
                    final guitarList = vm.guitarTransactionsSorted
                        .fold<Map<String, dynamic>>({}, (map, tx) {
                          map[tx.id] = tx;
                          return map;
                        })
                        .values
                        .toList();
                    print(
                      "[GuitarPage] Consumer 빌드됨, 기타 내역 개수: ${vm.guitarTransactionsSorted.length}",
                    );
                    if (guitarList.isEmpty) {
                      return Center(
                        child: Text(
                          "기타 내역이 없습니다.",
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
                      itemCount: guitarList.length,
                      itemBuilder: (context, index) {
                        final tx = guitarList[index];
                        print(
                          "[GuitarPage] 리스트 아이템 index=$index, title=${tx.title}, amount=${tx.amount}",
                        );
                        return ListTile(
                          title: Text(
                            (tx.title.isEmpty || tx.title == "제목 없음")
                                ? tx.category
                                : tx.title,
                            style:
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ).copyWith(
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
                            style:
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ).copyWith(
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
