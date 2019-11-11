import 'package:gobang/bean/player.dart';
import 'package:json_annotation/json_annotation.dart';
part 'fighting_confirm.g.dart';

@JsonSerializable()
class FightingConfirm{
  String fightingId;
  Player initiatorPlayer ;
  Player Invitees ;
  int time;

  FightingConfirm({this.fightingId,this.initiatorPlayer,this.time ,this.Invitees});

  factory FightingConfirm.fromJson(Map<String,dynamic> json) => _$FightingConfirmFromJson(json);

  Map<String,dynamic> toJson() => _$FightingConfirmToJson(this);

}