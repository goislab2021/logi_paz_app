import 'package:flutter/material.dart';

class TodoAndTimeTitleWidget extends StatelessWidget {
  final int time;

  const TodoAndTimeTitleWidget({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Text('TO-DO',
        style: TextStyle(
          fontSize: 24,
          color: Color(0xff554433),
        ),),
      Expanded(child: Container(),),
      Text('$time 分',
        style: const TextStyle(
          fontSize: 20,
          color: Color(0xff554433),
        ),),

    ],);
  }



}
