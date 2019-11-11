import 'package:flutter/material.dart';

class RouteObserverManager {

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  RouteObserverManager._();
  static RouteObserverManager _instance ;

  static getInstance(){
    if(_instance == null){
      _instance = RouteObserverManager._();
    }
    return _instance;
  }

  RouteObserver<PageRoute> getObserver(){
    return routeObserver;
  }


}