import 'package:flutter/material.dart';

class SimpleDialogOptionText extends StatelessWidget {
  final String text;

  const SimpleDialogOptionText({
    Key? key,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 17,
        color: const Color(0xff00979b),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}