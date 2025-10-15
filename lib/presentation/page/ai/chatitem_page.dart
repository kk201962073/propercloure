import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({super.key, required this.content, required this.isReceived});

  final String content; // 말풍선에 표시할 텍스트
  final bool isReceived; // true면 왼쪽(AI), false면 오른쪽(사용자)

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.75;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isReceived
                    ? const Color(0xFFF2F2F2)
                    : Colors.indigoAccent.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      isReceived ? const Radius.circular(4) : const Radius.circular(16),
                  bottomRight:
                      isReceived ? const Radius.circular(16) : const Radius.circular(4),
                ),
              ),
              child: Text(
                content,
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: isReceived ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
