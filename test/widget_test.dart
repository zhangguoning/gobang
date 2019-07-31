// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gobang/main.dart';
import 'package:gobang/net/websocket_client.dart';

void main() {

  test("testConnent", (){
    ClientSocketManager.getInstance(<String>(data){
      print("received data from server: $data");
    }).sendMsg("hello");

    Future.delayed(Duration(seconds: 5),(){
      print("delayed end!");
    });
  });

}
