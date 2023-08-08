import 'package:flutter/material.dart';
import 'commonWidget/bottom_tab_bar_widget.dart';
import 'commonWidget/loading_indicator.dart';
import 'commonWidget/underlined_text_container_widget.dart';
import 'package:intl/intl.dart';

import 'commonWidget/underlined_title_container_widget.dart';
import 'editRecord.dart';
import 'helpers/DbHelper.dart';

class viewRegisteredContents extends StatefulWidget {
  final int? id;
  const viewRegisteredContents({Key? key, required this.id}) : super(key: key);
  @override
  State<viewRegisteredContents> createState() => _viewRegisteredContentsState(id);
}

class _viewRegisteredContentsState extends State<viewRegisteredContents> {
  final int? id;
  _viewRegisteredContentsState(this.id);
  late Map<String, dynamic> gotRecord;

  Future<Map<String, dynamic>> getRecord() async {
    //await Future.delayed(Duration(seconds: 5));
    gotRecord = await DbHelper.instance.getRecord(id);
    return gotRecord;
  }

  //フローティングボタン押下→編集画面へ
  void _goToEdit(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => editRecord(recordmap:gotRecord))
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getRecord(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('記録詳細'),
                  elevation: 0,
                  backgroundColor: const Color(0xff00979b),
                ),
                body:Column(children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xfff7e3af),
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xfffffff0),
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Column(children: <Widget>[
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),//真ん中の線
                              ),
                              child: Column(children: [
                                Row(children: [
                                  const Text('TO-DO',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Color(0xff554433),
                                    ),),
                                  Expanded(child: Container(),),
                                  _textDateWidget(),
                                ],),
                                const SizedBox(height: 10,),
                                const UnderlinedTitleContainer(
                                  text: 'やること',
                                ),
                                UnderlinedTextContainerWidget(
                                  text:gotRecord['TODO'],
                                ),
                                const SizedBox(height: 10,),
                                const UnderlinedTitleContainer(
                                  text: 'やらないこと',
                                ),
                                UnderlinedTextContainerWidget(
                                  text:gotRecord['NO_GO_01'],
                                ),
                                if(gotRecord['NO_GO_02']!=null&&gotRecord['NO_GO_02']!="")...{
                                  UnderlinedTextContainerWidget(
                                    text:gotRecord['NO_GO_02'],
                                  ),
                                },
                                if(gotRecord['NO_GO_03']!=null&&gotRecord['NO_GO_03']!="")...{
                                  UnderlinedTextContainerWidget(
                                    text:gotRecord['NO_GO_03'],
                                  ),
                                },
                                const SizedBox(height: 10,),
                                Container(
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 120,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                                color: Color(0xff00979b),
                                                width: 3
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          '時間',
                                          style: TextStyle(
                                            color: Color(0xff00979b),
                                            fontWeight: FontWeight.bold,
                                          ),),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 90,
                                            height: 32,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            child: _textTimeWidget(),
                                          ),
                                          const Text('分'),
                                        ],),
                                    ],),
                                ),
                                const SizedBox(height: 16,),
                              ],),
                            ),

                            //ここから下部
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 120,
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
                                        Container(
                                          width: double.infinity,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          padding:const EdgeInsets.only(left: 16),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey,
                                              ),),),
                                          child: _textEvaluationWidget(),
                                        ),
                                      ],),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        border: Border.all(color:Colors.grey),
                                      ),
                                      child: _stampImgWidget(),
                                    ),
                                  ),
                                ],),
                            ), const SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                const UnderlinedTitleContainer(
                                  text: 'コメント',
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  child: _textCommentWidget(),
                                ),
                              ],),
                          ],),
                        ),
                      ),
                    ),
                  ),

                  BottomTabBarWidget(
                      context: context,
                      recordMap:gotRecord,
                      pageFlag:1),

                ],)
            );

          } else if (snapshot.hasError) {
            return Column();
          }else{
            //取得中ぐるぐる出す
            return const LoadingIndicator();
          }
        });
  }

  Widget _textDateWidget() {
    DateTime _dateDisplay = DateTime.parse(gotRecord['DATE_YMD']);
    var dtFormat = DateFormat("yyyy-MM-dd HH:mm");
    String strDate = dtFormat.format(_dateDisplay);
    return Text(strDate);
  }

  Widget _textTimeWidget() {
    int _textTime = gotRecord['TODO_TIME'];
    print('_textTime;$_textTime');
    return Text('$_textTime');
  }

  Widget _textEvaluationWidget() {
    int? intEvaluation = gotRecord['EVALUATION'];
    //Widget evaluationWidget;

    if (intEvaluation == null) {
      return Text('未評価');
    } else if (intEvaluation == 1) {
      return SizedBox(height: 24,
        child: Image.asset('assets/images/mark_nice.jpg'),
      );
      //textEvaluation = "◎";
    } else if (intEvaluation == 2) {
      return SizedBox(height: 24,
        child: Image.asset('assets/images/mark_good.jpg'),
      );
    } else {
      return SizedBox(height: 24,
        child: Image.asset('assets/images/mark_enough.jpg'),
      );
    }
    //return evaluationWidget;
  }

  Widget _textCommentWidget() {
    String textComment = gotRecord['COMMENT']?? "";
    if (textComment == "") {
      textComment = "評価がされていません";
    }
    return Text(textComment);
  }

  Widget _stampImgWidget(){
    String imgPath
    = gotRecord['IMAGE_PATH']  ?? 'assets/images/unspecified.png';
    print('gotRecord$imgPath');

    return SizedBox(
      //width: 30,
      // height: 30,
      child: Image.asset(imgPath),
    );
  }

  //消去確認ダイアログを表示
  void confirmDeleteDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: const Text('この記録を消去しますか'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => clearRegistration(),
              child: const Text('消去する'),
            )
          ],
        )
    );
  }

  //消去確認ダイアログ→DB消去
  void clearRegistration() async{
    int _id = gotRecord['_id'];
    String _updateQuery = 'DELETE FROM NO_GO_RECORDS '
        'WHERE _id = $_id'
        ';';
    await DbHelper.instance.deleteMemo(_updateQuery);
    deletedDialog();
  }
  //消去完了ダイアログ
  void deletedDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
          title: const Text('消去しました'),
          children: <Widget>[
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


