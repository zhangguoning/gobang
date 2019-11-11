import 'package:gobang/bean/accept_fighting.dart';
import 'package:gobang/bean/player.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fighting.dart';
part 'invite_fighting.g.dart';

@JsonSerializable()
class InviteFighting {
  Player adversary;
  int time;

  InviteFighting({this.adversary,this.time});
  factory InviteFighting.fromJson(Map<String,dynamic> json) => _$InviteFightingFromJson(json);

  Map<String,dynamic> toJson() => _$InviteFightingToJson(this);
}

@JsonSerializable()
class InviteFightingResult{
  int time;
  AcceptFighting acceptFighting;
  Fighting fighting;
  int code;

  InviteFightingResult({this.time,this.acceptFighting,this.fighting});
  factory InviteFightingResult.fromJson(Map<String,dynamic> json) => _$InviteFightingResultFromJson(json);

  Map<String,dynamic> toJson() => _$InviteFightingResultToJson(this);
}