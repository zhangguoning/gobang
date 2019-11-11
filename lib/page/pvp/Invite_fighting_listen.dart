import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/play_game.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/common/global_config.dart';
import 'package:gobang/net/common/api_helper.dart';
import 'package:gobang/net/common/route_observer_manager.dart';
import 'package:gobang/page/pvp/play_game.dart';
import 'package:gobang/user/current_player.dart';
import 'package:gobang/widget/dialog.dart';
import 'package:provider/provider.dart';

abstract class InviteFightingConfirmWidgetState<T extends StatefulWidget>
    extends State<T> with RouteAware ,WidgetsBindingObserver{
  ApiHelper apiHelper;
  Player me ;
  CustomDialog dialog;
  StreamSubscription<FightingConfirm> fcSubscription;

  bool isAlive = true;
  bool init = false ;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    ApiHelper.socket()
        .connect(ServerConfig.WEB_SOCKET_HOST, ServerConfig.WEB_SOCKET_PORT,timeout: Duration(seconds: Timer.TIME_OUT))
        .then((helper) {
      apiHelper = helper;

      onConnectedSuccess(apiHelper);
      fcSubscription = apiHelper.listenFightingConfirm((FightingConfirm confirm) {
        print("接收到来自 ${confirm.initiatorPlayer.name} 的游戏邀请!");
        if(!isAlive){
          return ;
        }

        if(!fcSubscription.isPaused){
          fcSubscription.pause();
        }

        dialog = CustomDialog(context,
          title: "游戏邀请",
          content: "玩家 ${confirm.initiatorPlayer.name} 想与您一决高下,是否应战?",
          leftButtonText: "接受",
          rightButtonText: "拒绝",
          onLeftButtonClicked: () {
            _accept(context, confirm);
          },
          onRightButtonClicked: () {
            _refuse(confirm);
            dialog?.dismiss();
          },
        );
        dialog.show();
      });
    });
  }


  @override
  void didChangeDependencies() {
    RouteObserverManager.getInstance().getObserver().subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
    if(!init){
      init = true;
      initData();
    }
    print("InviteFightingConfirmWidgetState -> didChangeDependencies() -> context = $context");

  }


  @mustCallSuper
  void initData(){
       me ??= Provider.of<CurrentPlayer>(context).user;
  }


  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState() -> state = $state");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: buildView(context),
      onWillPop: onWillPop,
    );
  }

  @mustCallSuper
  Future<bool> onWillPop() async{
    if(await onBackspacePress()){
      onDestroySubscription();
      return true;
    }else{
      return false;
    }
  }

  Future<bool> onBackspacePress();

  Widget buildView(BuildContext context);

  @mustCallSuper
  @override
  void dispose() {
    RouteObserverManager.getInstance().getObserver().unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print("InviteFightingConfirmWidgetState -> didPush() -> context = $context");
    isAlive = true;
  }
  @override
  void didPop() {
    print("InviteFightingConfirmWidgetState -> didPop() -> context = $context");
    isAlive = false;
  }

  void didPushNext() {
    print("InviteFightingConfirmWidgetState -> didPushNext() -> context = $context");
    isAlive = false;
  }

  @override
  void didPopNext() {
    print("InviteFightingConfirmWidgetState -> didPopNext() -> context = $context");
    isAlive = true;
  }


  @mustCallSuper
  void onDestroySubscription(){
    fcSubscription?.cancel();
  }


  void onConnectedSuccess(ApiHelper apiHelper) {}

  void onAcceptFighting(InviteFightingResult inviteFightingResult) {
    if(fcSubscription.isPaused){
      fcSubscription.resume();
    }
  }

  void _accept(BuildContext context, FightingConfirm fightingConfirm) {
    apiHelper.acceptFighting(fightingConfirm).then((result) {
      dialog?.dismiss();
      print("接受邀请 - result = $result , 准备进入游戏");
      onAcceptFighting(result);
      if(result?.fighting!=null){
        Navigator.of(context).push(MaterialPageRoute(builder: (c){
          me.isFirst = false ;
          Provider.of<CurrentPlayer>(context).updateCurrentPlayer(me);
          return PlayGamePage(PlayGameBean(FightingType.NETWORK,result));
        }));
      }else{
        Fluttertoast.showToast(msg: "已失效");
      }
    });
  }

  void onRefuseFighting(InviteFightingResult inviteFightingResult) {
    if(fcSubscription.isPaused){
      fcSubscription.resume();
    }
  }

  void _refuse(FightingConfirm fightingConfirm) {
    apiHelper.refuseFighting(fightingConfirm).then((result) {
      print("拒绝邀请 - result-$result");
      onRefuseFighting(result);
    });
  }

}

