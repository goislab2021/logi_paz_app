import 'package:flutter/cupertino.dart';

class UnderlinedTitleContainer extends StatelessWidget {
  final String text;
  final Color color;

  const UnderlinedTitleContainer({
    Key? key,
    required this.text,
    this.color = const Color(0xff00979b),
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              color: color,
              width: 3
          ),),
      ),
      child: Text(text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),),
    );

  }
}
