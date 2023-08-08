import 'package:flutter/material.dart';
import 'package:nogo_timer_app/commonWidget/simpleDialog_set_widget.dart';
import '../editRecord.dart';
import '../helpers/DbHelper.dart';
import '../sameContentWorkStart.dart';

class BottomTabBarWidget extends StatefulWidget {
  final BuildContext context;
  final Map<String, dynamic> recordMap;
  //flag:1=詳細ページ、flag：2＝修正ページ
  final  int pageFlag;

  const BottomTabBarWidget({
    Key? key,
    required this.context,
    required this.recordMap,
    required this.pageFlag
  }) : super(key: key);

  @override
  _BottomTabBarWidgetState createState() =>
      _BottomTabBarWidgetState(recordMap,pageFlag);
}
class _BottomTabBarWidgetState extends State<BottomTabBarWidget> {
  final Map<String, dynamic> recordMap;
  //flag:1=詳細ページ、flag：2＝修正ページ
  final  int pageFlag;

  _BottomTabBarWidgetState(
      this.recordMap,
      this.pageFlag,
      );

  late bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return
      Container(
      width: double.infinity,
      height: 50,
      color: const Color(0xfff7e3af),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            child: const Icon(
                Icons.content_copy,
                size: 32,
                color: Color(0xff70372c)),
            onTap: _confirmCopyDialog,
          ),
          if(pageFlag==1)...{
            InkWell(
              child: const Icon(
                  Icons.border_color_outlined,
                  size: 32,
                  color: Color(0xff70372c)),
              onTap: _goToEdit,
            ),
          },
          if(pageFlag==2)...{
            const Icon(
                Icons.border_color_outlined,
                size: 32,
                color: Colors.grey),
          },
          InkWell(
            child: const Icon(
                Icons.delete_outline,
                size: 32,
                color: Color(0xff70372c)),
            onTap: confirmDeleteDialog,
          ),
        ],),
    );
  }

  //コピーアイコン押下
  //コピー確認ダイアログを表示
  void _confirmCopyDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialogSet(
              title: '同じ内容で作業しますか？',
              text: '作業する',
              onClicked: (){_copyAndStart();},
            ),
    );
  }

  void _copyAndStart(){
    print('recordMap:$recordMap');
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => sameContentWorkStart(recordMap:recordMap))
    );
  }

  //編集アイコン押下→編集画面へ
  void _goToEdit(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => editRecord(recordmap:recordMap))
    );
  }

  //消去アイコン押下
  //消去確認ダイアログを表示
  void confirmDeleteDialog(){
    _isDeleting = true; // ダイアログが表示されている間はフラグをtrueに設定
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialogSet(
              title: 'この記録を消去しますか？',
              text: '消去する',
              onClicked: (){_clearRegistration();},
            ),
    );
  }

  //消去確認ダイアログ→DB消去
  void _clearRegistration() async{
    int _id = recordMap['_id'];
    String _updateQuery = 'DELETE FROM NO_GO_RECORDS '
        'WHERE _id = $_id'
        ';';
    await DbHelper.instance.deleteMemo(_updateQuery);
    _deletedDialog();
  }

  void _deletedDialog(){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
        WillPopScope(
          onWillPop: () async {
            return !_isDeleting; // _isDeletingがtrueの場合は戻るボタンを無効にする
          },
          child:
          SimpleDialogSet(
            title: '消去しました',
            text: 'ホームへ戻る',
            onClicked: (){
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ),
    );
  }
}
