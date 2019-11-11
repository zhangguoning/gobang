import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/player.dart';
import 'package:json_annotation/json_annotation.dart';
part 'accept_fighting.g.dart';

@JsonSerializable()
class AcceptFighting{
  bool accept;
  FightingConfirm confirm;

  AcceptFighting({this.accept,this.confirm});


  factory AcceptFighting.fromJson(Map<String,dynamic> json) => _$AcceptFightingFromJson(json);

  Map<String,dynamic> toJson() => _$AcceptFightingToJson(this);

}