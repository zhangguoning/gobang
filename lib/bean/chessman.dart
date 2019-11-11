import 'package:gobang/bean/chessman_position.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:gobang/bean/player.dart';
part 'chessman.g.dart';

@JsonSerializable()
class Chessman {
  Player owner;
  ChessmanPosition position;
  int numberId ;

  Chessman(this.owner,this.position,this.numberId,);

  factory Chessman.fromJson(Map<String,dynamic> json) => _$ChessmanFromJson(json);

  Map<String,dynamic> toJson() => _$ChessmanToJson(this);

}