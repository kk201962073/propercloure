import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.content, required this.isReceived});

  final String content; // 말풍선에 표시할 텍스트
  final bool isReceived; // true면 왼쪽(AI), false면 오른쪽(사용자)

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isReceived ? Colors.grey[300] : Colors.grey[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          content,
          style: const TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }
}
