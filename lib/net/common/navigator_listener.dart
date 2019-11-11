
import 'dart:async';

import 'package:flutter/material.dart';

class NavigatorListener extends RouteObserver<PageRoute>{


  static NavigatorListener _instance;
  NavigatorListener._(){
    controller = new StreamController();
    stream = controller.stream.asBroadcastStream();
  }

  StreamController<NavigatorAction> controller;
  Stream<NavigatorAction> stream;

  static NavigatorListener getInstance(){
    if(_instance == null){
      _instance = NavigatorListener._();
    }
    return _instance;
  }

  StreamSubscription<NavigatorAction> listen(void Function(NavigatorAction) onData){
    if(onData == null){
      throw Exception("onData must be not null !");
    }
    return stream.listen(onData);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    controller.sink.add(NavigatorAction.POP);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    controller.sink.add(NavigatorAction.PUSH);
    super.didPush(route, previousRoute);
  }

  void close(){
    controller?.close();
  }



}
enum NavigatorAction{
  POP,PUSH
}