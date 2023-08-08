import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nogo_timer_app/ratingInput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commonWidget/dialog_divider_widget.dart';
import 'commonWidget/dialog_tite_widget.dart';
import 'commonWidget/simpleDialogOption_text_widget.dart';
import 'commonWidget/todo_and_time_title_widget.dart';
import 'commonWidget/underlined_text_container_widget.dart';
import 'commonWidget/underlined_title_container_widget.dart';
import 'helpers/DbHelper.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class workingState extends StatefulWidget {
  final int? time;
  final List<String> recordList;

  const workingState({Key? key,
    required this.time,
    required this.recordList})
      : super(key: key);

  @override
  State<workingState> createState() => _workingStateState(time,recordList);
}

class _workingStateState extends State<workingState>{
  final prefs = SharedPreferences.getInstance();
  late bool _isOnVibration = true;
  late bool _isOnSound = true;

  final int? _time;
  final List<String> _recordList;
  _workingStateState(this._time,this._recordList);

  // テキストフィールドを管理するコントローラを作成(入力内容の取得用)
  final textController = TextEditingController();

  late Timer _timer;
  int _currentSeconds=0;

  late String _todo;
  late String _no1;
  late String _no2;
  late String _no3;
  late int? id;

  @override
  void initState() {
    super.initState();
    final workMinutes = _time;
    _currentSeconds = (workMinutes! * 60);
    _timer = countTimer();

    _todo = _recordList[0];
    _no1 = _recordList[1];
    _no2 = _recordList[2];
    _no3 = _recordList[3];

    init();
  }

  Future<void> init() async {
    //音量・バイブレーション設定取得
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isOnSound = prefs.getBool('boolSound')??true;
      _isOnVibration = prefs.getBool('boolVibration')??true;
      print('boolSound*$_isOnSound');
      print('boolVibration*$_isOnVibration');
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  Timer countTimer() {
    return Timer.periodic(
      const Duration(seconds: 1),
          (Timer timer) async {
        if (_currentSeconds < 1) {
          //残り0秒で以下処理
          print('boolSound*$_isOnSound');
          print('boolVibration*$_isOnVibration');
          if(_isOnVibration){
            Vibration.vibrate(pattern: [300,300,300,300,300,300]);
          }
          if(_isOnSound){
            //FlutterRingtonePlayer.playNotification();
            FlutterRingtonePlayer.play(
              //android: AndroidSounds.notification,
              fromAsset: "assets/ringtone.mp3",
              //ios: IosSounds.glass,
              volume: 1.0,
            );
          }
          timer.cancel();
          //ここで最初のレコード作成
          id = await saveNogoRecord();
          print("id00：$id");
          //終了のダイアログボックス表示
          showDialog<void>(
            //ボックス外タップで閉じないように
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return AlertDialogTaskFinished(id:id,time:_time,recordList:_recordList);
              });
        } else {
          //１秒ごとにデクリメント
          setState(() {
            _currentSeconds = (_currentSeconds! - 1)!;
          });
        }
      },
    );
  }

  String timerString(int leftSeconds) {
    final minutes = (leftSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (leftSeconds % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('作業開始!'),
        elevation: 0,
        backgroundColor: const Color(0xff00979b),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color(0xfff7e3af),
        padding: const EdgeInsets.all(16),
        child: Center(
          child:
          Column(children: [
            _buildUpperWidget(),
            Expanded(child:Container(
              width: MediaQuery.of(context).size.width,
            ) ),
            _buildLowerWidget(),
          ]),
        ),
      ),
    );
  }

  //上部タイマー部分ウィジェット
  Widget _buildUpperWidget() {
    return SizedBox(
      height: 300,
      child:
      Column(children: [
        const SizedBox(height: 10,),
        SizedBox(
          width: 180,
          height: 180,
          child:Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: 1-_currentSeconds/(_time! * 60),
                strokeWidth: 12,
                //color: Colors.orange,
                color: const Color(0xffc03619),
                backgroundColor: const Color(0xfffffff0),
              ),
              Center(child:
              Container(child:
              _timeStr(),),
              ),
            ],),
        ),
        const SizedBox(height: 20,),
        //ここから一時停止と中止アイコン表示
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _playIconButtonController(),
            const SizedBox(width: 10,),
            IconButton(
              onPressed: showStopTimerDialog,
              icon: const Icon(Icons.cancel_presentation_rounded,
                  size: 48,
                  color: Color(0xff70372c)),
            ),
          ],)
      ],),
    );
  }

  Widget _timeStr() {
    return Text(
      timerString(_currentSeconds),
      style: const TextStyle(
        fontSize: 32,
        color: Color(0xff70372c),
      ),
    );
  }

  Widget _playIconButtonController(){
    final bool isRunning = _timer.isActive;

    if(isRunning){
      return IconButton(onPressed: _pauseTimer,
          icon: const Icon(Icons.pause_rounded,
              size: 48,
              color: Color(0xff70372c)));
    }else{
      return  IconButton( onPressed: () {
        _timer = countTimer();
      },
          icon:const Icon(Icons.play_arrow_rounded ,
              size: 48,
              color: Color(0xff70372c)));
    }
  }

  void _pauseTimer(){
    setState(() {
      _timer.cancel();
    });
  }

  //下部ウィジェット
  Widget _buildLowerWidget() {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xfffffff0),
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(2),
      ),
      child:SingleChildScrollView(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TodoAndTimeTitleWidget(time: _time!),
          const SizedBox(height: 8,),
          const UnderlinedTitleContainer(
            text: 'やること',
          ),
          UnderlinedTextContainerWidget(
            text: _todo,
          ),
          const SizedBox(height: 10,),
          const UnderlinedTitleContainer(
            text: 'やらないこと',
          ),
          UnderlinedTextContainerWidget(
            text:_no1,
          ),
          if(_no2!="")...{
            UnderlinedTextContainerWidget(
              text:_no2,
            ),
          },
          if(_no3!="")...{
            UnderlinedTextContainerWidget(
              text:_no3,
            ),
          },
        ],),
      ),
    );
  }

  //タイマーキャンセルダイアログを表示させる
  void showStopTimerDialog(){
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: DialogTitle(text:'作業を中止しますか？'),
        children: [
          Container(child:
            Column(children: [
              DialogDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                SimpleDialogOption(
                  onPressed: () => onPressedCancelTimer(),
                  child: SimpleDialogOptionText(text: '作業を中止する'),
                ),
                SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: SimpleDialogOptionText(text: '続行する'),
                ),
              ],)
            ],)
          ),
        ],),
    );
  }

  void onPressedCancelTimer(){
    setState(() {
      _timer.cancel();
    });
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  //DBヘルパーでレコード登録
  Future<int?> saveNogoRecord() async {
    // 日付を文字列に(時差9時間たして）
    final DateTime now = DateTime.now().add(Duration(hours: 9));
    final nowIso = now.toIso8601String();
// レコードに追加する値を準備する
    List<Object?> params = [
      nowIso,
      _time,
      _todo,
      _no1,
      _no2,
      _no3,
    ];

// SQLクエリを作成する
    String insertQuery = '''
  INSERT INTO NO_GO_RECORDS (
    DATE_YMD,
    TODO_TIME,
    TODO,
    NO_GO_01,
    NO_GO_02,
    NO_GO_03
  ) VALUES (?, ?, ?, ?, ?, ?)
''';

// バインド変数を使用してクエリを実行する
    int? recordId = await DbHelper.instance.insertMemo(insertQuery, params);
    return recordId;
  }
}

//終了のダイアログボックスクラス
class AlertDialogTaskFinished  extends StatelessWidget {
  int? id;
  int? time;
  List<String> recordList;

  AlertDialogTaskFinished ({Key? key,
    required this.id,
    required this.time,
    required this.recordList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: DialogTitle(text:'終了！'),
      content: Text('お疲れさまでした'),
      actions: <Widget>[
        GestureDetector(
          child: SimpleDialogOptionText(
            text: '評価へ進む',
          ),
          onTap: () {
            // ボタンが押されたときに発動される処理
            Navigator.push(context,
              MaterialPageRoute(builder: (context)
              => ratingInput(id:id,time:time,recordList:recordList)),
            );
          },
        )
      ],);
  }


}