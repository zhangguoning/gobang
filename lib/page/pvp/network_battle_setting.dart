import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/net/common/api_helper.dart';
import 'package:gobang/net/common/route_observer_manager.dart';
import 'package:gobang/net/internet/websocket_connect_api.dart';
import 'package:gobang/page/pvp/Invite_fighting_listen.dart';
import 'package:gobang/page/pvp/net_setting.dart';
import 'package:gobang/page/pvp/select_adversary.dart';

import 'bluetooth_setting.dart';

class LANOptionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LANOptionPageState();
  }
}

class _LANOptionPageState extends InviteFightingConfirmWidgetState<LANOptionPage>{

  _LANOptionPageState() : super();


  @override
  void initState() {
    super.initState();
    print("_LANOptionPageState -> initState() -> context = $context");
    WidgetsBinding.instance.addObserver(this);
//    RouteObserverManager.getInstance().getObserver().subscribe(this, ModalRoute.of(context));
  }


  @override
  Widget buildView(BuildContext context) {
    return buildLANOptionPageState();
  }


  Widget buildLANOptionPageState() {
    return Scaffold(
      key: Key("_LANOptionPageState_key"),
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
  void onEnterGameClicked() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
      return SelectAdversaryPage();
    }));
  }

  void onNetSettingClicked(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context){
//      return NetSettingPage();
      return BlueToothSettingPage();
    }));

  }
  @override
  Future<bool> onBackspacePress() {
    return Future.value(true);
  }

}
