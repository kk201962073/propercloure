import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeTransactionListWidget extends StatelessWidget {
  const HomeTransactionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return const Center(
        child: Text("사용자 인증이 필요합니다.", style: TextStyle(fontSize: 16)),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("지출 내역이 없습니다.", style: TextStyle(fontSize: 16)),
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
              } else if (dateRaw is Timestamp) {
                date = dateRaw.toDate();
              } else {
                date = DateTime.now();
              }
              return {...data, 'date': date, 'id': doc.id};
            }).toList()..sort(
              (a, b) =>
                  (a['date'] as DateTime).compareTo(b['date'] as DateTime),
            );

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: sortedTransactions.length,
          itemBuilder: (context, index) {
            final tx = sortedTransactions[index];
            final DateTime txDate = tx['date'] as DateTime;
            final int amount = (tx['amount'] is int)
                ? tx['amount'] as int
                : int.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
            final String category = tx['category']?.toString() ?? '기타';
            final String docId = tx['id'];
            final bool isIncome = amount > 0;

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.3)
                        : Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            "${txDate.year}-${txDate.month.toString().padLeft(2, '0')}-${txDate.day.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
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
                      textAlign: TextAlign.right,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('삭제 확인'),
                          content: const Text('이 거래를 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('삭제'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('transactions')
                            .doc(docId)
                            .delete();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
