import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gobang/net/webserver/websocket_client.dart';
import 'package:gobang/page/pvp/net_setting.dart';

class LANOptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LANOptionPageState();
  }
}

class _LANOptionPageState extends State<LANOptionPage> {
  @override
  Widget build(BuildContext context) {
    return buildLANOptionPageState();
  }

  Widget buildLANOptionPageState() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "联网对战",
        ),
        centerTitle: true,
      ),
      body: buildBodyWidget(),
    );
  }

  Widget buildBodyWidget() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Theme(
          data: Theme.of(context).copyWith(
            buttonTheme: ButtonThemeData(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              minWidth: 64.0,
              height: 30.0,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            textTheme: TextTheme(
                button: TextStyle(
              fontSize: 14.0,
            )),
          ),
          child: Column(
            children: <Widget>[
              Container(
                child: FlatButton(
                    color: Color(0xFFF6F6F6),
                    child: Text("进入游戏"),
                    onPressed: () {onEnterGameClicked();}),
              ),
              Container(
                child: FlatButton(
                    color: Color(0xFFF6F6F6),
                    child: Text("网络设置"),
                    onPressed: () {onNetSettingClicked(context);}),
              ),
            ],
          )),
    );
  }
  ClientSocketManager manager ;
  int count = 1 ;
  void onEnterGameClicked() async {
    manager ??= await ClientSocketManager.getInstance()
      ..addListener((data) {
      print("received data from server: $data");
    });
    manager.sendMsg("click $count");
//    ClientSocketManager.getInstance()
//      ..addListener((data) {
//        print("received data from server: $data");
//      })
//      ..sendMsg("呵呵呵呵呵");
    count++;
  }

  void onNetSettingClicked(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return NetSettingPage();
    }));

  }

}
