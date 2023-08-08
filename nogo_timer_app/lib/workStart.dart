import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nogo_timer_app/workingState.dart';
import '../commonWidget/underlined_title_container_widget.dart';

class workStart extends StatefulWidget {
  const workStart({Key? key}) : super(key: key);
  @override
  State<workStart> createState() => _workStartState();
}

class _workStartState extends State<workStart> {
  //テキスト取得用変数を容易
  final _editControllerToDo = TextEditingController();
  final _editControllerNoGo1 = TextEditingController();
  final _editControllerNoGo2 = TextEditingController();
  final _editControllerNoGo3 = TextEditingController();
  //デフォルト時間
  int? isSelectedItem = 20;
  final _formKey = GlobalKey<FormState>();

  //radioボタンのグループバリューになるもの
  int? _radioSelected =1;
  final _editControllerTime = TextEditingController();

  bool _isenabledTextField = false;
  bool _isenabledDropdownBtn = true;

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
            Center(
              child: Column(children: const [
                SizedBox(height: 20),
                Text('やるべきことと'),
                Text('やらないことを決めましょう'),
              ],),
            ),
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
                    //_formKey:Validation用
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
                            validator: (editControllerToDo) {
                              if (editControllerToDo == null || editControllerToDo.isEmpty) {
                                return 'やることを入力してください';
                              }
                              if(editControllerToDo.length > 20){
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
                          const SizedBox(height: 8),
                          const Text('多くても3つまでにしましょう'),
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
                                validator: (editControllerNoGo1) {
                                  if (editControllerNoGo1 == null || editControllerNoGo1.isEmpty) {
                                    return 'やらないことを入力してください';
                                  }
                                  if(editControllerNoGo1.length > 20){
                                    return '20文字以内で入力してください';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: _editControllerNoGo2,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (editControllerNoGo2) {
                                  if(editControllerNoGo2==null){
                                    return null;
                                  }else{
                                    if(editControllerNoGo2.length > 20){
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
                                validator: (editControllerNoGo3) {
                                  if(editControllerNoGo3==null){
                                    return null;
                                  }else{
                                    if(editControllerNoGo3.length > 30){
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
                                      value: 20,
                                      child: Text(' 20 ')
                                  ),
                                  DropdownMenuItem(
                                      value: 30,
                                      child: Text(' 30 ')
                                  ),
                                  DropdownMenuItem(
                                      value: 40,
                                      child: Text(' 40 ' )
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
                                    FilteringTextInputFormatter.digitsOnly // ③ 数字入力のみ許可する
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00979b),
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              fixedSize:const Size.fromWidth(double.maxFinite),
                            ),
                            child: const Text('開 始'),
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
    String todo = _editControllerToDo.text;
    String nogo1 = _editControllerNoGo1.text;
    String nogo2 = _editControllerNoGo2.text;
    String nogo3 = _editControllerNoGo3.text;

    int? time = 0;
    print("_radioSelected:$_radioSelected");
    print("_editControllerTime:$_editControllerTime.text");
    if(_radioSelected==2) {
      try {
        time = int.parse(_editControllerTime.text);
      } catch (e) {
        print('パースエラー: _editControllerTime:$e');
        //time = 1;
      }
    }else{
      time = isSelectedItem;
      print("isSelectedItem:$isSelectedItem");
    }

    List<String> recordList =[];
    recordList.addAll([todo,nogo1,nogo2,nogo3]);
    print('time:$time');
    if(_formKey.currentState?.validate() == true) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          workingState(
            // time: 1, test
            time: time, recordList: recordList
          )),
      );
    }
  }


}


