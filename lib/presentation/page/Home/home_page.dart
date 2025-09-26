import 'package:flutter/material.dart';
import 'package:propercloure/presentation/page/add/add_page.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatelessWidget {
  final bool hasExpense;
  const HomePage({super.key, this.hasExpense = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단: 월, 합계
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "9월 v",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "총 합계 0",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 수입 / 지출
              Row(
                children: const [
                  Text(
                    "수입 0",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "지출 0",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 달력
              TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                headerVisible: false, // 상단 월/연도 숨김
                calendarStyle: const CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // 지출 내역 없음
              hasExpense
                  ? Column(
                      children: [
                        _buildExpenseItem("월급", 10000),
                        _buildExpenseItem("CU 편의점", -2700),
                        _buildExpenseItem("메아커피", -3000),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "지출 내역이 없습니다.",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            ],
          ),
        ),
      ),

      // 플로팅 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // 하단 네비게이션
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset("assets/image/calender.png", width: 32, height: 32),
              Image.asset("assets/image/money.png", width: 32, height: 32),
              Image.asset("assets/image/ai.png", width: 32, height: 32),
              Image.asset("assets/image/profile.png", width: 32, height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildExpenseItem(String title, int amount) {
  final isIncome = amount > 0;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Text(
          "${isIncome ? '+' : ''}$amount",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isIncome ? Colors.blue : Colors.red,
          ),
        ),
      ],
    ),
  );
}
