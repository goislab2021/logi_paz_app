import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  final String text;

  const DialogTitle({
    Key? key,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: TextStyle(
        fontSize: 20,
        color: const Color(0xff70372c),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}