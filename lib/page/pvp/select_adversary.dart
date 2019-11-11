import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/play_game.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/bean/player_list.dart';
import 'package:gobang/net/common/api_helper.dart';
import 'package:gobang/page/pvp/Invite_fighting_listen.dart';
import 'package:gobang/page/pvp/play_game.dart';
import 'package:gobang/user/current_player.dart';
import 'package:provider/provider.dart';
import 'package:gobang/common/global_config.dart' as config;
import 'package:gobang/widget/dialog.dart';

import 'dart:math' as math;


class SelectAdversaryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SelectAdversaryPageState();
  }
}

class _SelectAdversaryPageState extends InviteFightingConfirmWidgetState<SelectAdversaryPage> {

  _SelectAdversaryPageState() : super();

  bool isLoading = true;

  List<Player> players = List();
  StreamController<InviteFightingResult> _streamController;
  int waitingTime = config.Timer.WAITING_TIME;

  StreamSubscription sendInviteFightingSubscription;
  StreamSubscription<InviteFightingResult> fightingSubscription;
  StreamSubscription<FightingConfirm> fightingConfirmSubscription;



  @override
  void onConnectedSuccess(ApiHelper apiHelper) {
    findPlayers();
    fightingSubscription = apiHelper.listenFighting((InviteFightingResult result){
      print("监听到 接受游戏邀请的通知!");
      if(_streamController?.isClosed == false){
        _streamController.sink.add(result);
      }
    });

    fightingConfirmSubscription = apiHelper.listenFightingConfirm((result){
      print("监听到 有人邀请游戏 的通知!");
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return _buildSelectAdversaryPageState(context);
  }

  CustomDialog winHintDialog;

  void findPlayers() async{
    isLoading = true;
    invalidate();

    me = Provider.of<CurrentPlayer>(context).user;
    PlayerList pl = await apiHelper.register(me);
    players.clear();
    players.addAll(pl.players);
    isLoading = false;
    invalidate();
  }

  void invalidate() {
    setState(() {});
  }

  Widget _buildSelectAdversaryPageState(BuildContext context) {
    return Scaffold(
      key: Key("_SelectAdversaryPageState_key"),
      appBar: AppBar(
        title: Text("选择对手"),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          ///child - 1
          Container(
            height: 30,
            margin: EdgeInsets.only(bottom: 10),
            child: isLoading
                ? Container(
                    child: Row(
                      children: <Widget>[
                        Text("查找中..."),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: SizedBox(
                            width: 13,
                            height: 13,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
              alignment: Alignment.centerLeft,
              child: FlatButton(onPressed: (){findPlayers();}, child: Text("刷新")),
            ),
          ),

          ///child - 2
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: players.length,
                  itemBuilder: listViewItemBuilder),
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewItemBuilder(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      color: index % 2 == 0 ? Colors.blue[100] : Colors.grey[300],
      child: Row(
        children: <Widget>[
          Text(players[index].name),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: FlatButton(
                onPressed: (){if(players[index].deviceId != me.deviceId ){_fighting(players[index]);}},
                child: Text(players[index].deviceId == me.deviceId ? "我自己" : "邀请游戏")) ,
          ),
        ],
      ),
    );
  }

  void _fighting(Player adversary) async{
    InviteFighting inviteFighting = InviteFighting();
    inviteFighting..time = DateTime.now().millisecondsSinceEpoch
                  ..adversary = adversary;

    _showInviteFightingDialog(context,inviteFighting);

  }

  CustomDialog inviteFightingDialog ;
  void _showInviteFightingDialog(BuildContext context,
      InviteFighting inviteFighting) async {
    inviteFightingDialog = CustomDialog(context,
      title: "发送邀请",
      content: "向玩家${inviteFighting.adversary.name}发送游戏邀请,与他一决高下",
      leftButtonText: "邀请",
      rightButtonText: "取消",
      onLeftButtonClicked: () {
        inviteFightingDialog?.dismiss();
        _sendInviteFighting(inviteFighting);
      },
      onRightButtonClicked: () {
        inviteFightingDialog?.dismiss();
      },
    );

    inviteFightingDialog.show();
  }


  void _sendInviteFighting(InviteFighting inviteFighting){

    LoadingDialog loading = LoadingDialog(context,message: "等待对方接受...",cancelable: false,);
    loading.show();

    apiHelper.inviteFighting(inviteFighting).then((FightingConfirm confirm){
      loading.setCancelable(true);
    });

    _streamController = new StreamController();
    Future.delayed(Duration(seconds: config.Timer.WAITING_TIME),(){
      _streamController.sink.add(null);
    }).catchError((error){
      print(error);
    });

    sendInviteFightingSubscription = _streamController.stream.listen((InviteFightingResult result){
      loading.dismiss();
      inviteFightingDialog?.dismiss();
      
      if(result == null){
        ///等待超时
        Fluttertoast.showToast(msg: "等待超时");

      }else if(result.acceptFighting.accept == true){
        Fluttertoast.showToast(msg: "玩家 ${result.acceptFighting.confirm.Invitees.name} 接受了您的游戏邀请,即将开始游戏!");
        Navigator.of(context).push(MaterialPageRoute(builder: (a){
          me.isFirst = true ;
          Provider.of<CurrentPlayer>(context).updateCurrentPlayer(me);
          return PlayGamePage(PlayGameBean(FightingType.NETWORK,result));
        }));
//        apiHelper.startGame(result).then((BoolResult boolResult){
//          dialog.openLoadingDialog(context, "start...");
//        });
      }else{
        
        Fluttertoast.showToast(msg: "玩家 ${result.acceptFighting.confirm.Invitees.name} 拒绝了您的游戏邀请!");
      }

      sendInviteFightingSubscription.cancel();
      _streamController.close();
    });
  }

  void timer(int time){
    waitingTime = time;
    invalidate();
    if(time < 0 ){
      waitingTime = config.Timer.WAITING_TIME;
      return ;
    }else{
      Future.delayed(Duration(seconds: 1),(){
        timer(time - 1);
      });
    }
  }

  void onDestroySubscription(){
    super.onDestroySubscription();
    fightingSubscription?.cancel();
    fightingConfirmSubscription?.cancel();
    sendInviteFightingSubscription?.cancel();
  }


  @override
  Future<bool> onBackspacePress() {
    return Future.value(true);
  }
}
