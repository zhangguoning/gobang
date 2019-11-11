import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/player.dart';
import 'package:json_annotation/json_annotation.dart';
part 'fighting.g.dart';

@JsonSerializable()
class Fighting{
   String fightingId;
   Player initiatorPlayer;
   Player InviteesPlayer;
   int time;
   List<Chessman> chessmanList;
   List<Chessman> firstPlayerChessmanList;
   List<Chessman> secondPlayerChessmanList;

   Fighting(this.initiatorPlayer,this.InviteesPlayer,this.time,{this.fightingId,this.chessmanList,this.firstPlayerChessmanList,this.secondPlayerChessmanList});

   factory Fighting.fromJson(Map<String,dynamic> json) => _$FightingFromJson(json);

   Map<String,dynamic> toJson() => _$FightingToJson(this);
}
