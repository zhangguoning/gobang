import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/player.dart';
import 'package:json_annotation/json_annotation.dart';
part 'game_over.g.dart';

enum GameStatus{
  PLAYING,OVER_WIN,OVER_FULL
}

@JsonSerializable()
class GameOver{
  int time;
  String fightingId;
  Player initiatorPlayer;
  Player inviteesPlayer;
  GameWinner winner;

  GameOver({this.time,this.fightingId,this.initiatorPlayer,this.inviteesPlayer,this.winner});

  factory GameOver.fromJson(Map<String,dynamic> json) => _$GameOverFromJson(json);

  Map<String,dynamic> toJson() => _$GameOverToJson(this);
}

@JsonSerializable()
class GameWinner{
  List<Chessman> winResult;
  Player winner;
  GameStatus status;

  GameWinner({this.winner,this.status,this.winResult});

  factory GameWinner.fromJson(Map<String,dynamic> json) => _$GameWinnerFromJson(json);

  Map<String,dynamic> toJson() => _$GameWinnerToJson(this);
}

