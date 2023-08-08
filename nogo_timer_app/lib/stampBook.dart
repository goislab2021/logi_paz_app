import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nogo_timer_app/viewRegisteredContents.dart';
import 'Helpers/ImagePathList.dart';
import 'commonWidget/dialog_divider_widget.dart';
import 'commonWidget/dialog_tite_widget.dart';
import 'commonWidget/loading_indicator.dart';
import 'commonWidget/simpleDialogOption_text_widget.dart';
import 'commonWidget/simpleDialog_set_widget.dart';
import 'helpers/DbHelper.dart';

class stampBook extends StatefulWidget {
  const stampBook({Key? key}) : super(key: key);
  @override
  State<stampBook> createState() => _stampBookState();
}

class _stampBookState extends State<stampBook> {
  late List<Map<String, dynamic>> _gotList;
  //タブの数（パスリストを30で割った数）
  late int _tabCount;
  late int _listLength;
  late String _imgPath='';
  late String _todoDate;

  //DBヘルパーからイメージパスリストとタブ数ゲット
  Future<List<dynamic>> getImgPathList() async{
    _gotList  = await DbHelper.instance.getImgPathList();
    _listLength=_gotList.length;
    //タブ数、割って切り上げ
    _tabCount= (_listLength/30).ceil();
    return _gotList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getImgPathList(),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return DefaultTabController(
              initialIndex: 0, // 最初に表示するタブ
              length: _tabCount, // タブの数
              child:
              Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: const Color(0xff00979b),
                  title: const Text('ご褒美スタンプ帳'),
                  bottom: PreferredSize(
                    //AppBarのデフォルトの高さ(56)にプラスする高さ
                    preferredSize: Size.fromHeight(36),
                    child: SizedBox(
                      height: 42, // TabBarの高さを30に設定
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: <Widget>[
                          //レコード数に応じたタブインデックスを作る
                          for(int i = 0; i < _tabCount; i++)...{
                            _tabListWidget(i),
                          }
                        ],
                      ),
                    ),
                  ),
                ),
                body:
                TabBarView(
                  //タブの数だけビューを作る
                  children: <Widget>[
                    for(int i = 0; i < _tabCount; i++)...{
                      _returnTableWidget(i),
                      //_gridReturn(i)
                    }
                  ],
                ),
              ),
            );
          }else if (snapshot.hasError) {
            return Column();
          }else{
            //取得中ぐるぐる出す
            return const LoadingIndicator();
          }
        }
    );
  }

  //タブインデックスごとにタブの番号（タブに表示）を返す
  Widget  _tabListWidget(int i){
    i=i+1;
    Tab _tabList=Tab(text:'$i');
    return _tabList;
  }

  Widget _returnTableWidget(int currentIndex){
    Widget tableWidget =
    Container(
      padding: const EdgeInsets.only(top: 24,right: 16,left: 16,bottom:16 ),
      color: const Color(0xfff7e3af),
      alignment: Alignment.topCenter,
      child:Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(top: 24,right: 16,left: 16,bottom:16 ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: const Color(0xfffffff0),
        ),
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(
              color: const Color(0xff9b948e),
              width: 0.5,
            ),
            children: List.generate(
              6,
                  (rowIndex) => TableRow(
                children: List.generate(
                  5,
                      (colIndex) => Container(
                    alignment: Alignment.center,
                    child: _returnCell(rowIndex,colIndex,currentIndex),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return tableWidget;
  }

  Widget _returnCell(int rowIndex,int colIndex,int currentIndex){
    int pathIndex =0;
    Map imgMap;

    //スタンプ表示
    if(_listLength>=(((_tabCount-currentIndex-1)*30)+(rowIndex*5)+(colIndex+1))){
      pathIndex =((_tabCount-currentIndex-1)*30)+(rowIndex*5)+(colIndex+1)-1;
      //print('pathIndex:$pathIndex');
      //レコードリストの対象レコード
      imgMap = _gotList[pathIndex];
      //対象レコードのID
      int pathId = imgMap['_id'];

      //nullはないけど念のため
      if (imgMap['DATE_YMD'] == '' || imgMap['DATE_YMD'] == null){
        _todoDate = '';
      }else{
        DateTime _dateDisplay = DateTime.parse(imgMap['DATE_YMD']);
        var dtFormat = DateFormat("MM/dd");
        _todoDate = dtFormat.format(_dateDisplay);
      }

      //未評価状態でスタンプパスなかった場合
      if (imgMap['IMAGE_PATH'] == '' || imgMap['IMAGE_PATH'] == null){
        _imgPath = 'assets/images/unspecified.png';
      }else{
        _imgPath = imgMap['IMAGE_PATH'];
      }
      return InkWell(
        onTap: () {//編集画面へ
          goToViewRegisteredContents(pathId);
        },
        onLongPress: (){
          //イメージパスが存在する時のみ長押しで変更可能にする
          if (imgMap['IMAGE_PATH'] == '' || imgMap['IMAGE_PATH'] == null){
          }else{
            //スタンプ変更ダイアログ出す
            openStampChangeDialog(imgMap,pathId);
          }
        },
        child: Center(
          child: Column(children: [
            Padding(padding: const EdgeInsets.only(top:2),
              child: Text(_todoDate),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                _imgPath,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ],),
        ),
      );
    }else{//
      return Center(
        child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top:2),
                child: Text(''),
              ),
              Container(
                padding: const EdgeInsets.all(5.0),
                child:
                Image.asset(
                  'assets/images/unspecifiedStamp.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              )
            ]),
      );
    }
  }

  //タップで修正画面へ
  void goToViewRegisteredContents(int id){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => viewRegisteredContents(id:id)));
  }

  //スタンプ修正ダイアログ開く
  void openStampChangeDialog(Map _imgMap,int pathId){
    Map<int, String> _imgPathMap;
    int evaluation = _imgMap['EVALUATION'];
    if(evaluation == 1){
      _imgPathMap = ImagePathList.imagePathMap;
    }else if(evaluation == 2){
      _imgPathMap = ImagePathList2.imagePathMap;
    }else{
      _imgPathMap = ImagePathList3.imagePathMap;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
          title:DialogTitle(text:'スタンプを変更しますか？'),
          children:<Widget>[
            DialogDivider(),

            SizedBox(
              width: 60.0,
              height: 400.0,
              child: GridView.count(
                  crossAxisCount: 5,
                  padding: EdgeInsets.all(3),
                  children:
                  <Widget>[
                    //評価に応じてゲットしたイメージパスリストの値ごとにスタンプを表示
                    for (var data in _imgPathMap.values)...{
                      Padding(
                        padding: EdgeInsets.all(2.5),
                        child:
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: InkWell(
                            onTap: () {
                              confirmChangeStampImgDialog(data,pathId);
                            },
                            child: Image.asset(data, fit: BoxFit.contain),)
                      ),
                          ),
                    }
                  ]),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: SimpleDialogOptionText(text: '戻る'),
            ),

          ]),
    );//showDialog
  }

  //スタンプ変更確認ダイアログ
  void confirmChangeStampImgDialog(String imgPath,int pathId){
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
          title:  DialogTitle(text:'このスタンプで登録しますか？'),

          children: <Widget>[
            DialogDivider(),
            SizedBox(
              width: 90,
              height: 90,
              child: Image.asset(imgPath, fit: BoxFit.contain),
            ),

            SimpleDialogOption(
              onPressed: (){
                Navigator.pop(context);
                changeStampImg(imgPath,pathId);
              },
              child: SimpleDialogOptionText(text: '登録する'),
            ),

          ]),
    );
  }

  void changeStampImg(String imgPath,int pathId) async{
    String _updateQuery = 'UPDATE NO_GO_RECORDS SET '
        'IMAGE_PATH = "$imgPath" '
        'WHERE _id = $pathId'
        ';';
    await DbHelper.instance.updateMemo(_updateQuery);
    Navigator.pop(context);
    changeCompletedDialog();
  }

  void changeCompletedDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          SimpleDialogSet(
            title: '登録しました',
            text: '戻る',
            onClicked: (){
              Navigator.pop(context);
              setState(() {});
            },
          ),
    );
  }
}
