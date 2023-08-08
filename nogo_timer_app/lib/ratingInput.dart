import 'package:flutter/material.dart';


import 'commonWidget/dialog_tite_widget.dart';
import 'commonWidget/simpleDialogOption_text_widget.dart';
import 'commonWidget/simpleDialog_set_widget.dart';
import 'commonWidget/underlined_text_container_widget.dart';
import 'commonWidget/underlined_title_container_widget.dart';
import 'helpers/DbHelper.dart';
import 'helpers/ImagePathList.dart';


class ratingInput extends StatefulWidget {
  final int? id;
  final int? time;
  final List<String> recordList;
  const ratingInput({Key? key,
    required this.id,
    required this.time,
    required this.recordList})
      : super(key: key);

  @override
  State<ratingInput> createState() => _ratingInputState(id,time,recordList);
}

class _ratingInputState extends State<ratingInput>{
  final int? id;
  final int? _time;
  final List<String> _recordList;
  _ratingInputState(this.id,this._time,this._recordList);
  late String _todo;
  late String _no1;
  late String _no2;
  late String _no3;
  final int numOfImgPath = 3;
  int? _selected =1; //radioグループバリュー
  final _editControllerComment = TextEditingController();
  late String? imgPath;


  @override
  void initState(){
    super.initState();
    _todo = _recordList[0];
    _no1 = _recordList[1];
    _no2 = _recordList[2];
    _no3 = _recordList[3];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('評価する'),
        elevation: 0,
        backgroundColor: const Color(0xff00979b),
        automaticallyImplyLeading: false,
      ),
      body:Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xfff7e3af),
        child:
        SingleChildScrollView(
          child:
          Padding(
            padding: const EdgeInsets.all(16),
            child:
            Column(
                children:[
                  const Text("予定どおり集中できたか"),
                  const Text("評価をしましょう"),
                  const SizedBox(height: 16),
                  _buildLowerWidget(),
                  const SizedBox(height: 16),
                  _buildUpperWidget(),

                ]),
          ),
        ),
      ),

    );

  }

  Widget _buildUpperWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffffff0),
        border: Border.all(
          color: const Color(0xff665544),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TO-DO',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xff554433),
              ),),
            const SizedBox(height: 10,),
            const UnderlinedTitleContainer(
              text: 'やること',
            ),
            UnderlinedTextContainerWidget(
              text:_todo,
            ),
            const SizedBox(height: 10,),
            const UnderlinedTitleContainer(
              text: 'やらないこと',
            ),
            UnderlinedTextContainerWidget(
              text:_no1,
            ),

            if(_no2.isNotEmpty)...{
              UnderlinedTextContainerWidget(
                text:_no2,
              ),
            },
            if(_no3.isNotEmpty)...{
              UnderlinedTextContainerWidget(
                text:_no3,
              ),
            },
            const SizedBox(height: 16),
            const UnderlinedTitleContainer(
              text: '時間',
            ),
            Text("$_time"),
            const SizedBox(height: 16),
          ]
      ),
    );
  }

  Widget _buildLowerWidget(){
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffffff0),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(2),
      ),

      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('評価',
              style: TextStyle(
                fontSize: 24,
                color: Color(0xff554433),
              ),),
            const SizedBox(height: 10,),
            const UnderlinedTitleContainer(
              text: '評価',
            ),

            Row(
              children: <Widget>[
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
              ],
            ),
            const SizedBox(height: 10,),
            const UnderlinedTitleContainer(
              text: 'コメント',
            ),
            TextFormField(
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(),
              ),
              maxLines: 3, // 最大で3行まで入力できるように設定します
              //keyboardType: TextInputType.multiline,
              controller: _editControllerComment,
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: confirmDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff00979b),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
                fixedSize:const Size.fromWidth(double.maxFinite),
              ),
              child:const Text("評価登録"),
            ),
          ]
      ),
    );
  }


  Widget nogo2Widget(String nogo){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 38,
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          const Icon(Icons.circle,
            size: 10,
            color: Colors.grey,),
          const SizedBox(width: 16,),
          Text(nogo),
        ],
      ),
    );
  }

  void checkChanged(int? value) {
    setState(() {
      _selected = value;
    });
  }

  //登録確認用のダイアログボックスを開く
  void confirmDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            SimpleDialogSet(
                title: 'この内容で登録しますか？',
                text: '登録する',
                onClicked: (){OnPressedRegisterBtn();},
            ),
    );
  }

  //確認用ダイアログボックスで登録ボタン押す→ＤＢに登録
  void OnPressedRegisterBtn() async {
    //日付を文字列に
    final DateTime now = DateTime.now().add(Duration(hours: 9));
    final nowIso = now.toIso8601String();

    int? evaluation = _selected;
    String comment = _editControllerComment.text;

    if(evaluation==1){
      ImagePathList imagePathList = ImagePathList();
      imgPath = imagePathList.getImagePath();
    }else if(evaluation==2){
      imgPath='assets/images/stamps/2_stamp_aka.png';
    }else{
      imgPath='assets/images/stamps/3_stamp_aka.png';
    }

    String updateQuery = 'UPDATE NO_GO_RECORDS SET '
        'EVALUATION = $evaluation, '
        'COMMENT = "$comment", '
        'UPDATE_TIME = "$nowIso", '
        'IMAGE_PATH = "$imgPath" '
        'WHERE _id = $id'
        ';';

    await DbHelper.instance.updateMemo(updateQuery);

    //登録完了ダイアログボックス開く
    HasRegisteredDialog(imgPath);
  }

  //登録完了ダイアログ→homeへ戻る
  void HasRegisteredDialog(String? imgPath) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: const Text('登録しました'),
          children: <Widget>[
            SizedBox(
              width: 90,
              height: 90,
              child: Image.asset('$imgPath', fit: BoxFit.contain),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('ホームへ戻る'),
            ),
          ],
        )
    );
  }


}






