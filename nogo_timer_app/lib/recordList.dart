import 'dart:core';
import 'package:flutter/material.dart';
import 'package:nogo_timer_app/viewRegisteredContents.dart';
import 'commonWidget/loading_indicator.dart';
import 'helpers/DbHelper.dart';
import 'package:intl/intl.dart';

class recordList extends StatefulWidget {
  const recordList({Key? key}) : super(key: key);
  @override
  State<recordList> createState() => _recordListState();
}

class _recordListState extends State<recordList> {
  @override
  void initState(){
    super.initState();
  }

  List<Map<String, dynamic>> _allMemo = [];

  Future<List<Map<String, dynamic>>> getItems() async {
    final gotMemoList = await DbHelper.instance.getMemo();
    _allMemo = gotMemoList;
    return gotMemoList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(//非同期処理（レコードリスト取得）
        future: getItems(),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('これまでの記録'),
                elevation: 0,
                backgroundColor: const Color(0xff00979b),
              ),
              body: Container(
                color: const Color(0xfff7e3af),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _allMemo.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    _goToViewRegisteredContents(index);
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.all(1.0),

                                    color: const Color(0xfffffff0),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                        Row(
                                          children: [
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              child:
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: <Widget>[
                                                  _textDateWidget(index),
                                                  _textTodoWidget(index),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Container(
                                              child:
                                              _textTimeWidget(index),
                                            ),
                                            const SizedBox(width: 30,),
                                            Row(children: [
                                              const Text('評価：'),
                                              _textEvaWidget(index),
                                              const SizedBox(width: 10,),
                                            ],),
                                          ],),
                                    ),
                                  ),
                                );
                              }
                          ),
                        ],),
                    ),
                  ),
                ],),
              ),
            );
          } else if (snapshot.hasError) {
            return Column();
          }else{
            //取得中ぐるぐる出す
            return const LoadingIndicator();
          }
        }
    );
  }

  Widget _textDateWidget(int i){
    DateTime _dateDisplay = DateTime.parse(_allMemo[i]['DATE_YMD']);
    var dtFormat = DateFormat("yyyy-MM-dd HH:mm");
    String strDate = dtFormat.format(_dateDisplay);
    return Text(strDate);
  }

  Widget _textTodoWidget(int i){
    String _textTodo = _allMemo[i]['TODO'];
    return Text(_textTodo);
  }

  Widget _textEvaWidget(int i){
    int? _intEva =_allMemo[i]['EVALUATION'];
    String _stringEva ='';

    if(_intEva == '' || _intEva == null){
      _stringEva='未評価';
    }else if(_intEva==1){
      _stringEva='◎';
    }else if(_intEva==2){
      _stringEva='○';
    } else {
      _stringEva='△';
    }
    return Text(_stringEva);
  }

  Widget _textTimeWidget(int i){
    int? _intTime =_allMemo[i]['TODO_TIME'];
    _intTime ??= 0;
    return Text('$_intTime分');
  }

  void _goToViewRegisteredContents(int i){
    int _id = _allMemo[i]['_id'];
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => viewRegisteredContents(id:_id)));
  }
}
