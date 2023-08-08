import 'package:flutter/material.dart';

class DialogDivider extends StatelessWidget {
  const DialogDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey,
      height:40,
      indent: 30,
      endIndent: 30,
    );
  }
}
