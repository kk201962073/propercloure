import 'package:flutter/material.dart';

class PlusePage extends StatelessWidget {
  const PlusePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 124, 197, 230),
            child: Container(
              width: double.infinity,
              height: 300,
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
                    "수입 내역이 없습니다.",
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
