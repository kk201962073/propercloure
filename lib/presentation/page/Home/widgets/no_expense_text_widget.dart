import 'package:flutter/material.dart';

class NoExpenseTextWidget extends StatelessWidget {
  const NoExpenseTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '지출 내역이 없습니다.',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
