import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gobang/bean/bool_result.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/game_over.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/play_game.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/bean/send_chessman.dart';
import 'package:gobang/net/common/api_helper.dart';
import 'package:gobang/widget/dialog.dart';
import 'package:gobang/widget/pvp_board.dart';

import 'Invite_fighting_listen.dart';

class PlayGamePage extends StatefulWidget {
  final PlayGameBean bean;

  PlayGamePage(this.bean, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayGamePageState();
  }
}

class GameData{
  List<Chessman> chessmanList;
  List<Chessman> winResult;
  Player currentPlayer;
  Player adversaryPlayer;

  GameData(this.currentPlayer ,this.adversaryPlayer):this.chessmanList = List<Chessman>() ,winResult = List<Chessman>();
}

class GameDataWidget extends InheritedWidget{

  final GameData gameData;


  GameDataWidget({Key key ,@required this.gameData ,@required Widget child ,}) : super(key:key,child:child);

  static GameDataWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect:GameDataWidget);
    // return context?.inheritFromWidgetOfExactType(GameDataWidget);
  }

  @override
  bool updateShouldNotify(GameDataWidget oldWidget) {
    return  oldWidget != this || this.gameData.hashCode != oldWidget.gameData.hashCode;
  }

}

class _PlayGamePageState extends InviteFightingConfirmWidgetState<PlayGamePage> {

  GameData gameData  ;//= GameData(null,null);
  Player currentPlayer;
  String fightingId;
  Player adversary;

  StreamSubscription<InviteFightingResult> fightingSubscription;
  StreamSubscription<Chessman> chessmanSubscription;
  StreamSubscription<Chessman> falledChessmanSubscription;
  StreamSubscription<BoolResult> quitGameSubscription;
  StreamSubscription<GameOver> gameOverSubscription;
  bool abort = false;

  PvpGobangBoardWidget gobangBoardWidget;

  CustomDialog winHintDialog;


  @override
  void initData() {
    super.initData();
//    adversary = widget.bean.result.fighting.initiatorPlayer.deviceId == me.deviceId ? widget.bean.result.fighting.InviteesPlayer : me;
    fightingId = widget.bean.result.fighting.fightingId;

    Player p1 = widget.bean.result.fighting.initiatorPlayer;
    Player p2 = widget.bean.result.fighting.InviteesPlayer;
    adversary = me == p1 ? p2 : p1;


    currentPlayer = widget.bean.result.fighting.initiatorPlayer;

    gameData = GameData(currentPlayer,adversary);
    setCurrentPlayer(widget.bean.result.fighting.initiatorPlayer);
  }

  void invalidate() {
    setState(() {});
  }

  void setCurrentPlayer(Player player){
    currentPlayer = player;
    gameData.currentPlayer = currentPlayer;
    invalidate();
  }

  void onConnectedSuccess(ApiHelper apiHelper) {

    fightingSubscription = apiHelper.listenFighting((InviteFightingResult result){
      print("监听到 接受游戏邀请的通知!");
      widget.bean.result = result;
      initData();
      invalidate();
    });

    apiHelper.startGame(widget.bean.result); //Loading...
    chessmanSubscription = apiHelper.listenReceivedChessman((Chessman chessman) {
      gameData.chessmanList.add(chessman);
      setCurrentPlayer(_getAdversary(chessman.owner));
    });


    quitGameSubscription = apiHelper.listenQuitGame((result){
      if(result?.result == true){
        setCurrentPlayer(null);
        abort =  true;
        Fluttertoast.showToast(msg: "对手逃跑了,本局游戏自动结束!");
      }
    });


    gameOverSubscription = apiHelper.listenGameOver((GameOver result){
      if(result?.winner?.status == GameStatus.OVER_FULL){
        Fluttertoast.showToast(msg: "平局!");
      }else if(result?.winner?.status == GameStatus.OVER_WIN){
        String winMsg = result?.winner?.winner == me ? "恭喜,您已获胜!" : "很遗憾,您输了";
        winHintDialog = CustomDialog(context,
          content: winMsg,
          leftButtonText: result?.winner?.winner == me ? "" :"退出",
          rightButtonText: "取消",
          onLeftButtonClicked: (){
            abort = true;
            winHintDialog.dismiss();
            Navigator.of(context).pop();
          },
          onRightButtonClicked: (){
            abort = true;
            winHintDialog.dismiss();
          },
        );

        winHintDialog.show();
      }
    });
  }

//  void Function(Chessman chessman) receivedChessman;

  void sendChessman(Chessman chessman/*,void Function(Chessman chessman) receivedChessman*/) async {
//    this.receivedChessman = receivedChessman;
    setCurrentPlayer(_getAdversary(chessman.owner));
    BoolResult result = await apiHelper.sendChessman(SendChessman(fightingId:fightingId,chessman: chessman));
  }

  Player _getAdversary(Player currentPlayer){
    Player p1 = widget.bean.result.fighting.initiatorPlayer;
    Player p2 = widget.bean.result.fighting.InviteesPlayer;

    return currentPlayer.deviceId == p1.deviceId ? p2 : p1 ;
  }


  @override
  Widget buildView(BuildContext context) {
    return GameDataWidget(
        gameData:gameData,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                "与${adversary.name}对战中..."),
            centerTitle: false,
          ),
          body: _buildBody(),
        )
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    "黑方: ${widget.bean.result.fighting.initiatorPlayer.name}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "白方: ${widget.bean.result.fighting.InviteesPlayer.name}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "当前: (${currentPlayer?.name == widget.bean.result.fighting.initiatorPlayer.name ? "黑方" : "白方"})${currentPlayer?.name}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
            ),
            padding: EdgeInsets.only(left: 15, right: 15),
            child: gobangBoardWidget = PvpGobangBoardWidget(sendChessman),
          ),
        ],
      ),
    );
  }

  @override
  void onDestroySubscription() {
    super.onDestroySubscription();
    chessmanSubscription?.cancel();
    falledChessmanSubscription?.cancel();
    quitGameSubscription?.cancel();
    gameOverSubscription?.cancel();
    fightingSubscription?.cancel();
  }


  @override
  Future<bool> onBackspacePress() async {
    return await _showExitDialog();
  }

  CustomDialog exitDialog;
  Future<bool> _showExitDialog() async{
    Completer<bool> completer = Completer();
    if(abort){
      return Future.value(true);
    }
    exitDialog = CustomDialog(context,
        title:"退出提示",
        content:"游戏尚未结束,确定要提前退出吗?",
        leftButtonText:"退出",
        rightButtonText:"取消",
        onLeftButtonClicked:(){
          _quitGame();
      exitDialog.dismiss();
      completer.complete(true);
    },
    onRightButtonClicked:(){
      exitDialog.dismiss();
      completer.complete(false);
    });
    exitDialog.show();

    return completer.future;
  }

  void _quitGame(){
    apiHelper.quitGame(widget.bean.result.fighting);
  }
  @override
  void dispose() {
    super.dispose();
  }
}
