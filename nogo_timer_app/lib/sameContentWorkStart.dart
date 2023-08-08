import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nogo_timer_app/workingState.dart';
import 'commonWidget/underlined_title_container_widget.dart';

class sameContentWorkStart extends StatefulWidget {
  final Map<String, dynamic> recordMap;
  const sameContentWorkStart({
    Key? key,
    required this.recordMap}) : super(key: key);
  @override
  State<sameContentWorkStart> createState() => _sameContentWorkStartState(recordMap);
}

class _sameContentWorkStartState extends State<sameContentWorkStart> {
  final Map<String, dynamic> _recordMap;
  _sameContentWorkStartState(this._recordMap);

  late String todo = _recordMap['TODO'];
  late String nogo1 = _recordMap['NO_GO_01'];
  late String nogo2 = _recordMap['NO_GO_02'];
  late String nogo3 = _recordMap['NO_GO_03'];
  late int time = _recordMap['TODO_TIME'];

  //テキスト取得用変数を容易
  late final _editControllerToDo = TextEditingController(text: todo);
  late final _editControllerNoGo1 = TextEditingController(text: nogo1);
  late final _editControllerNoGo2 = TextEditingController(text: nogo2);
  late final _editControllerNoGo3 = TextEditingController(text: nogo3);

  //radioボタンのグループバリューになるもの
  int? _radioSelected;

  //ドロップダウンリスト用時間
  int? isSelectedItem = 20;
  final _formKey = GlobalKey<FormState>();

  //時間のテキストフィールド
  final _editControllerTime = TextEditingController();

  //活性比活性化用
  bool _isenabledTextField = false;
  bool _isenabledDropdownBtn = true;

  @override
  void initState(){
    super.initState();
    if(time == 20 || time == 30 || time == 40){
      _radioSelected=1;
      isSelectedItem = time;
    }else{
      _radioSelected=2;
      _editControllerTime.text = time.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('作業を開始する'),
        elevation: 0,
        backgroundColor: const Color(0xff00979b),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xfff7e3af),
        child: SingleChildScrollView(
          child:Column(children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                color: const Color(0xfffffff0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0x88554433)),
                      borderRadius: BorderRadius.circular(2)
                  ),
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const UnderlinedTitleContainer(
                            text: 'やること',
                          ),
                          TextFormField(
                            controller: _editControllerToDo,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (_editControllerToDo) {
                              if (_editControllerToDo == null || _editControllerToDo.isEmpty) {
                                return 'やることを入力してください';
                              }
                              if(_editControllerToDo.length > 20){
                                return '20文字以内で入力してください';
                              }
                              return null;
                            },
                            decoration:const InputDecoration(
                                fillColor: Colors.white, // テキストフィールドの背景色を灰色に設定
                                filled: true, // テキストフィールドの背景を塗りつぶす
                                border: OutlineInputBorder(),
                                hintText: '20文字以内'
                            ),
                          ),
                          const SizedBox(height: 20),
                          const UnderlinedTitleContainer(
                            text: 'やらないこと',
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child:Column(children:[
                              TextFormField(
                                controller: _editControllerNoGo1,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white, // テキストフィールドの背景色を灰色に設定
                                  filled: true, // テキストフィールドの背景を塗りつぶす
                                  prefixIcon: Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: Colors.grey,),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (_editControllerNoGo1) {
                                  if (_editControllerNoGo1 == null || _editControllerNoGo1.isEmpty) {
                                    return 'やらないことを入力してください';
                                  }
                                  if(_editControllerNoGo1.length > 20){
                                    return '20文字以内で入力してください';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _editControllerNoGo2,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (_editControllerNoGo2) {
                                  if(_editControllerNoGo2==null){
                                    return null;
                                  }else{
                                    if(_editControllerNoGo2.length > 20){
                                      return '20文字以内で入力してください';
                                    }
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white, // テキストフィールドの背景色を灰色に設定
                                  filled: true, // テキストフィールドの背景を塗りつぶす
                                  prefixIcon: Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: Colors.grey,),
                                ),
                              ),
                              TextFormField(
                                controller: _editControllerNoGo3,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (_editControllerNoGo3) {
                                  if(_editControllerNoGo3==null){
                                    return null;
                                  }else{
                                    if(_editControllerNoGo3.length > 30){
                                      return '20文字以内で入力してください';
                                    }
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  fillColor: Colors.white, // テキストフィールドの背景色を灰色に設定
                                  filled: true, // テキストフィールドの背景を塗りつぶす
                                  prefixIcon: Icon(
                                    Icons.circle,
                                    size: 10,
                                    color: Colors.grey,),
                                ),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 20),
                          const UnderlinedTitleContainer(
                            text: '作業時間',
                          ),
                          //ここから作業時間の行
                          Row(children: [
                            Radio(
                              value: 1,
                              groupValue: _radioSelected,
                              onChanged: (int? value)=>_onRadioChanged(value),
                            ),
                            //ここからドロップダウン
                            Row(children: [
                              DropdownButton(
                                dropdownColor: Colors.white,
                                items: const[
                                  DropdownMenuItem(
                                      child: Text(' 20 '),
                                      value: 20
                                  ),
                                  DropdownMenuItem(
                                      child: Text(' 30 '),
                                      value: 30
                                  ),
                                  DropdownMenuItem(
                                      child: Text(' 40 ' ),
                                      value: 40
                                  ),
                                ],
                                onChanged: (int? value) {
                                  //三項演算子でfalceの時はnullを指定して比活性化に
                                  _isenabledDropdownBtn
                                      ? setState(() {
                                    isSelectedItem = value;
                                  })
                                      :null;
                                },
                                value: isSelectedItem,
                              ),
                              const Text('分'),
                            ],),
                            const SizedBox(width: 20),
                            Radio(
                              value: 2,
                              groupValue: _radioSelected,
                              onChanged: (int? value)=>_onRadioChanged(value),
                            ),
                            //ここからテキストフィールド
                            Row(children: [
                              SizedBox(
                                width: 50,
                                child:
                                TextFormField(
                                  enabled: _isenabledTextField,
                                  keyboardType: TextInputType.number,
                                  //数値のみ受付
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly // 数字入力のみ許可する
                                  ],
                                  controller: _editControllerTime,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (editControllerTime) {
                                    // 入力値をint型に変換してみる。できない場合はnullが入る
                                    int? parsedValue = int.tryParse(editControllerTime!);
                                    if(_radioSelected==2) {
                                      //テキストボックスが空値か数字に変換できない入力だったら
                                      if (editControllerTime.isEmpty ||
                                          parsedValue == null) {
                                        return '数値を入力';
                                      }
                                      if(parsedValue>120){
                                        return '120以下';
                                      }
                                      if(parsedValue<1){
                                        return '1以上';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              const Text('分'),
                            ],),
                          ],),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _startWork,
                            child: const Text('開 始'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00979b),
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              fixedSize:const Size.fromWidth(double.maxFinite),
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  //ドロップダウンかテキストフィールドかのラジオボタン
  //活性比活性コントローラ
  void _onRadioChanged(int? value){
    setState(() {
      _radioSelected = value;
      if(value==2){
        _isenabledDropdownBtn = false;
        _isenabledTextField = true;
      }else{
        _isenabledDropdownBtn = true;
        _isenabledTextField = false;
      }
    });
  }

  void _startWork(){
    todo = _editControllerToDo.text;
    nogo1 = _editControllerNoGo1.text;
    String nogo2 = _editControllerNoGo2.text;
    String nogo3 = _editControllerNoGo3.text;
    List<String> recordList =[];
    recordList.addAll([todo,nogo1,nogo2,nogo3]);

    int? time = 0;
    if(_radioSelected==2) {
      try {
        time = int.parse(_editControllerTime.text);
      } catch (e) {
        print('パースエラー: _editControllerTime:$e');
        //time = 1;
      }
    }else{
      time = isSelectedItem;
    }

    if(_formKey.currentState?.validate() == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          workingState(
              //time: 1, //test
              recordList: recordList,
              time: time
          )),
      );
    }
  }
}

