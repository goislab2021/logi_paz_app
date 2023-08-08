import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class questionPage extends StatefulWidget {
  const questionPage({Key? key}) : super(key: key);

  @override
  State<questionPage> createState() => _questionPageState();
}

class _questionPageState extends State<questionPage> {
  List<Widget> listItems = [];
  List<int> testList = [1,2,3];

  @override
  void initState(){
    super.initState();
    initializeListItems();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('よくある質問'),
        elevation: 0,
        backgroundColor: const Color(0xff00979b),
      ),
      body:
      Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: const Color(0xfff7e3af),
        child:
        Padding(
          padding: EdgeInsets.all(18.0),
          child:


        ListView.builder(
                    itemCount: listItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:listItems[index],
                      );
                    },
                  ),
            ),

      ),
      );

  }

  void initializeListItems() {
    listItems.add(listItem01());
  }

  Widget listItem01(){
    return Container(
      child:
      Container(

        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xfffffff0),
            borderRadius: BorderRadius.circular(5),
        ),
        child: ExpandablePanel(
          header: Text('スタンプを変更するには'),
          collapsed: Container(),
          expanded: Text('スタンプを変更するには、スタンプ帳のページで変更したいスタンプを長押しすると変更できます。'),
        ),
      ),
    );
  }





}


Widget _expandablePanelWidget(Widget widget){
  return Container(
   padding: const EdgeInsets.all(18),
   decoration: BoxDecoration(
     borderRadius: BorderRadius.circular(2),
   ),
   child: widget,
  );



}