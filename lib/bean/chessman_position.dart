import 'package:json_annotation/json_annotation.dart';
part 'chessman_position.g.dart';

@JsonSerializable()
class ChessmanPosition{
  int x ;
  int y ;

  ChessmanPosition(this.x,this.y,);

  factory ChessmanPosition.fromJson(Map<String,dynamic> json) => _$ChessmanPositionFromJson(json);

  Map<String,dynamic> toJson() => _$ChessmanPositionToJson(this);

}