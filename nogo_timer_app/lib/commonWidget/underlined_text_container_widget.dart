import 'package:flutter/material.dart';

class UnderlinedTextContainerWidget extends StatelessWidget {
  final String text;
  final Color color;

  const UnderlinedTextContainerWidget({
    Key? key,
    required this.text,
    this.color = Colors.grey,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 32,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: color,
          ),
        ),
      ),
      child: Text(text),
    );

  }
}


