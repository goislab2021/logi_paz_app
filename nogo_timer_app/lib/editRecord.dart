import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'Helpers/ImagePathList.dart';
import 'package:intl/intl.dart';
import 'commonWidget/bottom_tab_bar_widget.dart';
import 'commonWidget/simpleDialog_set_widget.dart';
import 'commonWidget/underlined_title_container_widget.dart';
import 'helpers/DbHelper.dart';

class editRecord extends StatefulWidget {
  final Map<String, dynamic> recordmap;
  const editRecord({Key? key,required this.recordmap}) : super(key: key);
  @override
  State<editRecord> createState() => _editRecordState(recordmap);
}

class _editRecordState extends State<editRecord> {
  final Map<String, dynamic> recordmap;
  _editRecordState(this.recordmap);

  late final int _id;
  late final _editTodo;
  late final  _editNo1;
  late final _editNo2;
  late final _editNo3;
  late final _editComment;
  late int? _selected; //radioグループバリュー

  @override
  void initState() {
    super.initState();
    _id = recordmap['_id'];
    _editTodo =  TextEditingController(text: recordmap['TODO']);
    _editNo1 =  TextEditingController(text: recordmap['NO_GO_01']);
    _editNo2 =  TextEditingController(text: recordmap['NO_GO_02']);
    _editNo3 =  TextEditingController(text: recordmap['NO_GO_03']);
    _editComment =  TextEditingController(text: recordmap['COMMENT']);

    //未評価状態だったら、1をセット
    if(recordmap['EVALUATION']==null){
      _selected = 1;
    }else{
      _selected = recordmap['EVALUATION'];
    }
  }

  void checkChanged(int? value) {
    setState(() {
      _selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('修正する'),
        elevation: 0,
        backgroundColor: const Color(0xff00979b),
      ),
      body:
      Column(children: [
        Expanded(child:
        Container(
          color: const Color(0xfff7e3af),
          padding: const EdgeInsets.all(16),
          child:
          SingleChildScrollView(child:
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xfffffff0),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(2),
            ),
            child:
            Column(
                mainAxisSize: MainAxisSize.min,
                children:[
                  SingleChildScrollView(child:
                  Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('TO-DO',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff554433),
                          ),),
                        _textDateWidget(),
                      ],),
                    const SizedBox(height: 10,),
                    const UnderlinedTitleContainer(
                      text: 'やること',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      controller: _editTodo,
                    ),
                    const SizedBox(height: 10,),
                    const UnderlinedTitleContainer(
                      text: 'やらないこと',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      controller: _editNo1,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      controller: _editNo2,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      controller: _editNo3,
                    ),
                    const SizedBox(height: 10,),
                    const UnderlinedTitleContainer(
                      text: '評価',
                    ),
                    Row(children: <Widget>[
                      Radio<int>(
                        value: 1,
                        groupValue: _selected,
                        onChanged: (int? value)=> checkChanged(value),
                      ),
                      SizedBox(
                        height: 24,
                        child: Image.asset('assets/images/mark_nice.jpg'),
                      ),
                      const SizedBox(width: 16,),
                      Radio<int>(
                        value: 2,
                        groupValue: _selected,
                        onChanged: (int? value)=> checkChanged(value),
                      ),
                      SizedBox(
                        height: 24,
                        child: Image.asset('assets/images/mark_good.jpg'),
                      ),
                      const SizedBox(width: 16,),
                      Radio<int>(
                        value: 3,
                        groupValue: _selected,
                        onChanged: (int? value)=> checkChanged(value),
                      ),
                      SizedBox(
                        height: 24,
                        child: Image.asset('assets/images/mark_enough.jpg'),
                      ),
                    ],),
                    const SizedBox(height: 10,),
                    const UnderlinedTitleContainer(
                      text: '評価コメント',
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                      ),
                      maxLines: 3,
                      controller: _editComment,
                    ),
                  ],),
                  ),
                  ElevatedButton(onPressed: confirmDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00979b),
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      fixedSize:const Size.fromWidth(double.maxFinite), ),
                    child: const Text('修正する'),
                  ),
                ]),
          ),
          ),
        ),
        ),
        BottomTabBarWidget(
            context: context,
            recordMap:recordmap,
            pageFlag:2),
      ]),
    );
  }

  Widget _textDateWidget() {
    DateTime _dateDisplay = DateTime.parse(recordmap['DATE_YMD']);
    var dtFormat = DateFormat("yyyy-MM-dd HH:mm");
    String strDate = dtFormat.format(_dateDisplay);
    return Text(strDate);
  }

  //登録確認ダイアログを表示
  void confirmDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialogSet(
              title: 'この内容に修正しますか？',
              text: '修正する',
              onClicked: (){registerCorrections();},
            ),
    );
  }

  //登録確認ダイアログ→DBに登録
  Future<void> registerCorrections() async {
    String _todo = _editTodo.text;
    String _no1 = _editNo1.text;
    String _no2 = _editNo2.text;
    String _no3 = _editNo3.text;
    String _comment = _editComment.text;
    int? _editEvaluation = _selected;
    //日付を文字列に
    final DateTime now = DateTime.now().add(Duration(hours: 9));
    final nowIso = now.toIso8601String();
    //imgPathを選択
    String? _imgPath;
    _imgPath = imgPathController();

    String _updateQuery;
    _updateQuery = 'UPDATE NO_GO_RECORDS SET '
        'TODO = "$_todo", '
        'NO_GO_01 = "$_no1",'
        'NO_GO_02 = "$_no2",'
        'NO_GO_03 = "$_no3",'
        'EVALUATION = $_editEvaluation,'
        'COMMENT = "$_comment",'
        'UPDATE_TIME = "$nowIso",'
        'IMAGE_PATH = "$_imgPath" '
        'WHERE _id = $_id'
        ';';
    await DbHelper.instance.updateMemo(_updateQuery);
    //修正しましたダイアログ表示
    HasRegisteredDialog();
  }

  String? imgPathController(){
    String? imgPath;
    if(recordmap['EVALUATION']==_selected){
      imgPath = recordmap['IMAGE_PATH'];
    }else{
      if(_selected==1){
        ImagePathList imagePathList = ImagePathList();
        imgPath = imagePathList.getImagePath();
      }else if(_selected==2){
        imgPath='assets/images/stamps/2_stamp_aka.png';
      }else if(_selected==3){
        imgPath='assets/images/stamps/3_stamp_aka.png';
      }else{
        if (kDebugMode) {
          print('imfPath error');
        }
      }
    }
    return imgPath;
  }

  //修正完了ダイアログ
  void HasRegisteredDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialogSet(
              title: '修正しました',
              text: 'ホームへ戻る',
              onClicked: (){
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
    );
  }
}

