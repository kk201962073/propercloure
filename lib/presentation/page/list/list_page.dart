import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("계좌 목록"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 총합
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "총합",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text("1,000원", style: TextStyle(fontSize: 16)),
              ],
            ),
            const Divider(height: 24, thickness: 1),

            // 계좌 항목 (현금)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "현금",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  "1,000원",
                  style: TextStyle(fontSize: 16, color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
