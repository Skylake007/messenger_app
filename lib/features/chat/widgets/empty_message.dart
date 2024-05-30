import 'package:flutter/material.dart';
import 'package:messenger_app/widgets/colors.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Không có liên hệ nào',
        style: TextStyle(fontSize: 16, color: greyColor),
      ),
    );
  }
}
