// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gobang/main.dart';
import 'package:gobang/net/webserver/websocket_client.dart';

void main() {
  test("testConnent", () async {
    ClientSocketManager manager = await ClientSocketManager.getInstance()
      ..addListener((data) {
        print("来自JavaServer的回应: $data");
      });
//      ..sendMsg("来自flutter的问候1")
//      ..sendMsg("来自flutter的问候2")
//      ..sendMsg("来自flutter的问候3");

    manager.sendMsg("来自flutter的问候1");
    manager.sendMsg("来自flutter的问候2");
    manager.sendMsg("来自flutter的问候3");



    await Future.delayed(Duration(seconds: 5), () {
     manager.close();
     print("已关闭连接!");
    });

    await Future.delayed(Duration(seconds: 5),(){
      print("关闭连接后再次尝试发送消息!");
    });
  });
}
