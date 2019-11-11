// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gobang/bean/bool_result.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/chessman_position.dart';
import 'package:gobang/bean/fighting.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/bean/player_list.dart';
import 'package:gobang/bean/response.dart';

import 'package:gobang/main.dart';
import 'package:gobang/net/common/api.dart';
import 'package:gobang/net/common/api_helper.dart';
import 'package:gobang/net/common/command.dart';
import 'package:gobang/net/common/command_parser.dart';
import 'package:gobang/net/internet/websocket_connect_api.dart';
import 'package:gobang/net/localserver/socket_connect_api.dart';
import 'package:gobang/widget/dialog.dart';
import 'package:web_socket_channel/io.dart';


void main() {
  String playerInfo = "{\"ip\":\"192.1.1.1\",\"name\":\"jerry\",\"deviceId\":\"qwer4321\"}";
//  String playerInfo = "{\"ip\":\"192.1.1.2\",\"name\":\"tom\",\"deviceId\":\"abcd1234\"}";
  Future time(int time) async {
    Completer c = new Completer();
    new Timer(new Duration(seconds: time), (){
      c.complete('done with time out');
    });

    return c.future;
  }


  CustomDialog winHintDialog;
  test("testDialog",() async{
    String winMsg = "这里是内容区域!";
    winHintDialog = CustomDialog(context,
      content: winMsg,
      title: "标题",
      leftButtonText: "退出",
      rightButtonText: "取消",
      onLeftButtonClicked: (){
        print("onLeftButtonClicked()");
        winHintDialog.dismiss();
      },
      onRightButtonClicked: (){
        print("onRightButtonClicked()");
        winHintDialog.dismiss();
      },
      onBackPressedToCancel: (){
        print("onBackPressedToCancel()");
      },
      onDismiss: (){
        print("onDismiss()");
      },
      canceledOnTouchOutside: true,
    );
    winHintDialog.show();
  });


  test("testCompleter",() async{
    print("----start-----");
    String string = await time(3);
    print("---complate0---");
    print("string = $string");

  });


  test("testP1SendChessman",() async{

    Player player1 = Player("192.1.1.2","devices-fdsa4321","jerry",0,true);
    Chessman chessman = Chessman(player1, ChessmanPosition(0,0), 0) ;


    await Future.delayed(Duration(seconds: 10),(){
      print("player1 等待中...");
    });

    print("player1 发起连接...");
    ApiHelper apiHelper = ApiHelper.webSocket();
    await apiHelper.connect("172.18.81.240", 9893);

    apiHelper.listenReceivedChessman((Chessman chessman){
      print("player1 接收到对手的落子[${chessman.position.x} ,${chessman.position.y}]");
    });

    print("player1 落子...");
    BoolResult result = await apiHelper.sendChessman(chessman);
    print("sendChessman()=>{$result}");

    Future.delayed(Duration(seconds: 30),(){
      apiHelper.close();
      print("player1 断开连接!");
    });
  });

  test("testP2SendChessman",() async{

    Player player2 = Player("192.1.1.1","devices-abcd1234","tom",0);
    Chessman chessman = Chessman(player2, ChessmanPosition(0,0), 0) ;


    await Future.delayed(Duration(seconds: 10),(){
      print("player2 等待中...");
    });

    print("player2 发起连接...");
    ApiHelper apiHelper = ApiHelper.webSocket();
    await apiHelper.connect("172.18.81.240", 9893);

    apiHelper.listenReceivedChessman((Chessman chessman){
      print("player2 接收到对手的落子[${chessman.position.x} ,${chessman.position.y}]");
    });

    print("player2 落子...");
    BoolResult result = await apiHelper.sendChessman(chessman);
    print("sendChessman()=>{$result}");

    Future.delayed(Duration(seconds: 30),(){
      apiHelper.close();
      print("player2 断开连接!");
    });
  });

  test("testP2SendChessman",() async{
    ApiHelper apiHelper = ApiHelper.webSocket();
    await apiHelper.connect("172.18.81.240", 9893);

    Player player2 = Player("192.1.1.1","devices-abcd1234","tom",0);
    Chessman chessman = Chessman(player2, ChessmanPosition(2,2), 1) ;
    BoolResult result = await apiHelper.sendChessman(chessman);
    print("sendChessman()=>{$result}");

    Future.delayed(Duration(seconds: 30),(){
      apiHelper.close();
      print("player2 断开连接!");
    });
  });





  test("testRegisterAndsendChessman",() async {
    Player player = Player("192.1.1.2","devices-fdsa4321","jerry",0);
    Player player2 = Player("192.1.1.1","devices-abcd1234","tom",0);
    ApiHelper apiHelper = ApiHelper.webSocket();
    await apiHelper.connect("172.18.81.240", 9893);

    Chessman chessman = Chessman(player, ChessmanPosition(0,0), 1) ;


    var list = await apiHelper.register(player);
    print("register()=?{$list}");



    BoolResult result = await apiHelper.sendChessman(chessman);
    print("sendChessman()=>{$result}");

    var player2Register = await apiHelper.register(player2);
    print("player2Register()=?{$player2Register}");





  });

}
