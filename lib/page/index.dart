import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getuuid/flutter_getuuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/net/LAN.dart';
import 'package:gobang/page/pvp/network_battle.dart';
import 'package:gobang/user/current_player.dart';
import 'package:gobang/util/util.dart';
import 'package:provider/provider.dart';

import 'game_main.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IndexPageState();
  }
}

class _IndexPageState extends State<IndexPage> {
  LocalServer ls;

  TextEditingController controller;

  bool inputEnable = true;

  String serverReceivedData;
  String clientReceivedData;

  @override
  void initState() {
    super.initState();
    init();
    initPlayerInfo();
  }

  void init() {
    if (controller == null) {
      controller = TextEditingController()
        ..addListener(() {
          print('input ${controller.text}');
        });
    }
    if (ls == null) {
      ls = LocalServer(onServerReceived: (data) {
        serverReceivedData = data;
        invalidate();
      }, onClientReceived: (data) {
        clientReceivedData = data;
        invalidate();
      });
    }
  }

  Future<void> initPlayerInfo() async {
    String deviceId = await FlutterGetuuid.platformUid;
    Player user = Provider.of<CurrentPlayer>(context).user;
    if (user == null) {
      user = Player.formDeviceId(deviceId);
    } else {
      user.deviceId = deviceId;
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
