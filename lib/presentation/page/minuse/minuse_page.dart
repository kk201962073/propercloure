import 'package:flutter/material.dart';

class MinusePage extends StatelessWidget {
  const MinusePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 194, 150, 5),
            child: Container(
              width: double.infinity,
              height: 300,
              color: const Color.fromARGB(255, 194, 150, 5),
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
                                "지출",
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
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 80),
                        Text(
                          "0원",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 우측 하단 날짜순
                  const Positioned(
                    right: 12,
                    bottom: 8,
                    child: Text(
                      "날짜순",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
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
                child: const Center(
                  child: Text(
                    "지출 내역이 없습니다.",
                    style: TextStyle(color: Colors.black45, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
