import 'package:flutter/material.dart';
import 'package:nogo_timer_app/commonWidget/simpleDialogOption_text_widget.dart';

import 'dialog_divider_widget.dart';
import 'dialog_tite_widget.dart';

class SimpleDialogSet extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onClicked;

  const SimpleDialogSet({
    Key? key,
    required this.title,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: DialogTitle(text:title),
      children: <Widget>[
        Column(children: [
          DialogDivider(),
          SimpleDialogOption(
            onPressed: onClicked,
            child: SimpleDialogOptionText(text: text),
          ),
        ],)

      ],
    );
  }
}