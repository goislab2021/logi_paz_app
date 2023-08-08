import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:nogo_timer_app/questionsPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class settingPage extends StatefulWidget {
  const settingPage({Key? key}) : super(key: key);
  @override
  State<settingPage> createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  final prefs = SharedPreferences.getInstance();
  late bool _isOnSound = true;
  late bool _isOnVibration = true;

  @override
  void initState(){
    super.initState();
    init();
  }
  Future<void> init() async {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _isOnSound = prefs.getBool('boolSound')??true;
        _isOnVibration = prefs.getBool('boolVibration')??true;
        print('boolSound*$_isOnSound');
        print('boolVibration*$_isOnVibration');
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
        elevation: 0,
        backgroundColor: const Color(0xff00979b),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color(0xfff7e3af),
        child:
        Column(children: [
          const SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              color: const Color(0xfffffff0),
                child:Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color(0x88554433)),
                      borderRadius: BorderRadius.circular(2)
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child:
                  Column(children: [
                    const SizedBox(height: 16,),
                    Row(children: [
                      const SizedBox(width: 16,),
                      const Icon(
                        Icons.notifications_active,
                        size: 32,
                        color: Color(0xff70372c),
                      ),
                      const SizedBox(width: 16,),
                      const SizedBox(
                        width: 160,
                        child: Text('アラーム音'),
                      ),
                      Switch(
                          value: _isOnSound,
                          onChanged:_onChangedSound,
                      ),
                    ],),
                    const SizedBox(height: 16,),
                    Row(children: [
                      const SizedBox(width: 16,),
                      const Icon(
                        Icons.vibration,
                        size: 32,
                        color: Color(0xff70372c),
                      ),
                      const SizedBox(width: 16,),
                      const SizedBox(
                        width: 160,
                        child: Text('バイブレーション'),
                      ),
                      Switch(
                        value: _isOnVibration,
                        onChanged:_onChangedVibration,
                      ),
                    ],),
                    const SizedBox(height: 16,),
                  ],),
                ),
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child:
            Container(
              padding: const EdgeInsets.all(18.0),
              child:
              Column(children: [
                Row(children: [
                  IconButton(
                    onPressed: _goTOQuestionsPage,
                    icon: const Icon(
                      Icons.question_mark_rounded,
                      size: 32,
                      color: Color(0xff70372c),
                    ),
                  ),
                  const SizedBox(width: 16,),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:const Color(0xff70372c),
                    ),
                    onPressed: _goTOQuestionsPage,
                    child: const Text('よくある質問'),
                  ),
                ],),
                const SizedBox(height: 16),
                Row(children: [

                  IconButton(
                    onPressed: _openPrivacyPolicy,
                    icon: const Icon(
                      Icons.privacy_tip_outlined,
                      size: 32,
                      color: Color(0xff70372c),
                    ),
                  ),
                  const SizedBox(width: 16,),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:const Color(0xff70372c),
                    ),
                    onPressed: _openPrivacyPolicy,
                    child: const Text('プライバシーポリシー'),
                  ),
                ],),
                const SizedBox(height: 16),
                Row(children: [
                  const SizedBox(height: 40,),
                  IconButton(
                    onPressed: _openEmailApp,
                    icon: const Icon(
                      Icons.email,
                      size: 32,
                      color: Color(0xff70372c),
                    ),
                  ),
                  const SizedBox(width: 16,),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:const Color(0xff70372c),
                    ),
                    onPressed: _openEmailApp,
                    child: const Text('お問い合わせ'),
                  ),
                ],),
              ],),
            ),
          ),
        ],),
      ),

    );
  }

//効果音オンオフ時
  void _onChangedSound(value) async{
    setState(() {
      _isOnSound = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolSound',value);
    print('boolSound*$_isOnSound');
  }

//バイプレーションオンオフ時
  void _onChangedVibration(value) async{
    setState(() {
      _isOnVibration = value;
    });

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolVibration',value);
  }

  void _goTOQuestionsPage(){
    // ボタンが押されたときに発動される処理
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const questionPage()));
  }


  //端末情報取得してメーラー起動
  void _openEmailApp() async{
    String os = "OS:その他";
    String osVersion = "";
    int sdkVersion = 0;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid){
      final androidInfo = await deviceInfo.androidInfo;
      os = "OS:Android";
      osVersion = androidInfo.version.release!;
      sdkVersion = androidInfo.version.sdkInt!; // これは
    }

    if(Platform.isIOS){
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      os = "OS:IOS";
      osVersion = iosInfo.systemVersion!;
    }

    final title = Uri.encodeComponent('[NO-GO-TIMER]お問い合わせ');
    //本文をリスト化
    final bodyLines = [
      Uri.encodeComponent(''),
      Uri.encodeComponent(''),
      Uri.encodeComponent('件名、および以下の情報は変更せずに送信をお願いいたします。'),
      Uri.encodeComponent('---端末情報---'),
      Uri.encodeComponent('$os $osVersion'),
      Uri.encodeComponent('sdk:$sdkVersion'),
      Uri.encodeComponent('-------------'),
    ];

    final body = bodyLines.join('%0D%0A');
    const mailAddress = 'goislab2021@gmail.com';

    return _launchURL(
      'mailto:$mailAddress?subject=$title&body=$body',
    );
  }

  void _openPrivacyPolicy() async{
    const url = 'https://goislab.github.io/nogo-timer/';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      final Error error = ArgumentError('Could not launch $url');
      throw error;
    }
  }

}
