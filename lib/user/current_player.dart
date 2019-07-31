import 'package:flutter/foundation.dart';
import 'package:gobang/bean/player.dart';
class CurrentPlayer with ChangeNotifier{

  Player _user;

  get user => _user;

  CurrentPlayer(this._user);

  void updateCurrentPlayer(Player user){
    if(_user == null){
      _user = user;
    }else{
      _user.name = user.name ;
      _user.deviceId = user.deviceId;
      _user.ip = user.ip;
    }
    notifyListeners();
  }

}