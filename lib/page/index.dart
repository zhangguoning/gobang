import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getuuid/flutter_getuuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/page/pvp/network_battle_setting.dart';
import 'package:gobang/user/current_player.dart';
import 'package:gobang/util/util.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'game_main.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}

class _IndexPageState extends State<IndexPage> {

  TextEditingController controller;

  bool inputEnable = true;

  String serverReceivedData;
  String clientReceivedData;

  @override
  void initState() {
    super.initState();
    initPlayerInfo();
  }

  String randomNum(int length){
    if(length == null || length <= 0){
      return "0";
    }else{
      math.Random random = math.Random();
      StringBuffer sb = StringBuffer();
      for(int i = 0 ; i < length ; i++){
        if(i == 0){
          sb.write(1 + random.nextInt(8));
        }else{
          sb.write(random.nextInt(9));
        }
      }
      return sb.toString();
    }
  }

  Future<void> initPlayerInfo() async {
    String deviceId = await FlutterGetuuid.platformUid;
    String name = "Player-${randomNum(5)}";
    Player user = Provider.of<CurrentPlayer>(context).user;
    if (user == null || user.deviceId == "0") {
      user ??= Player.formDeviceId(deviceId);
      user.deviceId = deviceId;
      user.status = UserStatus.FREE;
      user.name = name;
    }

    ///设置用户名 和 ip
    Provider.of<CurrentPlayer>(context).updateCurrentPlayer(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top: 20,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: TextTheme(
              button: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  decoration: TextDecoration.none),
            ),
          ),
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Container(
                    color: Colors.grey[400],
                    width: double.infinity,
                    child: Text("人机对战")),
                onPressed: () {
                  startGame();
                },
              ),
              FlatButton(
                child: Container(
                    color: Colors.grey[400],
                    width: double.infinity,
                    child: Text("网络对战")),
                onPressed: () {
                  enterPVPPage();
                },
              ),
              FlatButton(
                child: Container(
                    color: Colors.grey[400],
                    width: double.infinity,
                    child: Text("退出游戏")),
                onPressed: () {
                  quit();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void invalidate() {
    setState(() {});
  }

  void startGame(){
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) {
      return GameMainPage();
    }));
  }

  void enterPVPPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LANOptionPage();
    }));
  }

  Future<void> quit() async{
    await SystemNavigator.pop();
  }
}
