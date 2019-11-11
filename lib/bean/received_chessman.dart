import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/player.dart';
import 'package:json_annotation/json_annotation.dart';
part 'received_chessman.g.dart';

@JsonSerializable()
class ReceivedChessman{
   Player me;
   Player adversary;
   Chessman chessman;
   int time;

   ReceivedChessman({this.me,this.adversary,this.chessman,this.time});


   factory ReceivedChessman.fromJson(Map<String,dynamic> json) => _$ReceivedChessmanFromJson(json);

   Map<String,dynamic> toJson() => _$ReceivedChessmanToJson(this);


}