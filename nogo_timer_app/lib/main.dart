import 'package:flutter/material.dart';
import 'package:nogo_timer_app/recordList.dart';
import 'package:nogo_timer_app/settingPage.dart';
import 'package:nogo_timer_app/stampBook.dart';
import 'workStart.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'nogo timer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home()
    );
  }
}

class Home extends StatelessWidget{
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text('NO-GO TIMER'),
          elevation: 0,
          backgroundColor: const Color(0xff00979b),
        ),
        body:
        SingleChildScrollView(child:
        Container(
          height: MediaQuery.of(context).size.height,
          color: const Color(0xfff7e3af),
          child:
          Center(
              child:
              Column(
                  children:  <Widget>[
                    Padding(
                      padding:
                      const EdgeInsets.only(top: 80),
                      child:
                      SizedBox(
                        width: 140,
                        height: 160,
                        child: Image.asset('assets/images/main_img.png'),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const workStart()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffc03619),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          fixedSize: const Size(180,40),
                        ),//onPressed
                        child: const Text('タイマー開始'),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const recordList()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00979b),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          fixedSize: const Size(180,40),
                        ),
                        child: const Text('これまでの記録'),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      ElevatedButton(
                        onPressed: () {
                          // ボタンが押されたときに発動される処理
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const stampBook()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00979b),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          fixedSize: const Size(180,40),
                        ),
                        child: const Text('スタンプ帳を見る'),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                      ElevatedButton(
                        onPressed: () {
                          // ボタンが押されたときに発動される処理
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const settingPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00979b),
                          foregroundColor: Colors.white,
                          shape: const StadiumBorder(),
                          fixedSize: const Size(180,40),
                        ),
                        child: const Text('設定'),
                      ),
                    ),

                  ],),
          ),
        ),
        ),
      );
  }
}









