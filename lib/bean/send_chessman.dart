import 'package:gobang/bean/chessman.dart';
import 'package:json_annotation/json_annotation.dart';
part 'send_chessman.g.dart';

@JsonSerializable()
class SendChessman {
  String fightingId;
  Chessman chessman;

  SendChessman({this.fightingId,this.chessman});

  factory SendChessman.fromJson(Map<String,dynamic> json) => _$SendChessmanFromJson(json);

  Map<String,dynamic> toJson() => _$SendChessmanToJson(this);
}