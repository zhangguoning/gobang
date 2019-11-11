import 'package:gobang/bean/invite_fighting.dart';

class PlayGameBean{
  FightingType fightingType;
  InviteFightingResult result;

  PlayGameBean(this.fightingType,this.result);
}

enum FightingType{
  NETWORK,BLUETOOTH,WIFI
}