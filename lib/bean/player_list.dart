import 'package:gobang/bean/player.dart';
import 'package:json_annotation/json_annotation.dart';
part 'player_list.g.dart';

@JsonSerializable()
class PlayerList{
  @JsonKey(name: 'players')
  List<Player> players;

  PlayerList(this.players);

  factory PlayerList.fromJson(Map<String ,dynamic> map) => _$PlayerListFromJson(map);

  Map<String,dynamic> toJson() => _$PlayerListToJson(this);
}