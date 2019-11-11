import 'package:gobang/bean/fighting.dart';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/game_over.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/player_list.dart';
import 'package:gobang/bean/error_response.dart';
import 'package:gobang/bean/received_chessman.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bool_result.dart';

part 'response.g.dart';

class BaseResponse<T>{
  int code;
  bool state;
  ErrorResponse error;
  T data;
}


@JsonSerializable()
class QueryPlayersResponse extends BaseResponse<PlayerList>{
  QueryPlayersResponse();
  factory QueryPlayersResponse.fromJson(Map<String,dynamic> json) => _$QueryPlayersResponseFromJson(json);
  Map<String,dynamic> toJson() => _$QueryPlayersResponseToJson(this);
}


@JsonSerializable()
class RegisterResponse extends BaseResponse<PlayerList>{
  RegisterResponse();
  factory RegisterResponse.fromJson(Map<String,dynamic> json) => _$RegisterResponseFromJson(json);
  Map<String,dynamic> toJson() => _$RegisterResponseToJson(this);
}

@JsonSerializable()
class FightingResponse extends BaseResponse<Fighting> {
  FightingResponse();
  factory FightingResponse.fromJson(Map<String,dynamic> json) => _$FightingResponseFromJson(json);
  Map<String,dynamic> toJson() => _$FightingResponseToJson(this);
}

@JsonSerializable()
class FightingConfirmResponse extends BaseResponse<FightingConfirm>{
  FightingConfirmResponse();
  factory FightingConfirmResponse.fromJson(Map<String,dynamic> json) => _$FightingConfirmResponseFromJson(json);
  Map<String,dynamic> toJson() => _$FightingConfirmResponseToJson(this);
}

@JsonSerializable()
class InviteFightingResponse extends BaseResponse<FightingConfirm>{
  InviteFightingResponse();
  factory InviteFightingResponse.fromJson(Map<String,dynamic> json) => _$InviteFightingResponseFromJson(json);
  Map<String,dynamic> toJson() => _$InviteFightingResponseToJson(this);
}

@JsonSerializable()
class BoolResultResponse extends BaseResponse<BoolResult>{
  BoolResultResponse();
  factory BoolResultResponse.fromJson(Map<String,dynamic> json) => _$BoolResultResponseFromJson(json);
  Map<String,dynamic> toJson() => _$BoolResultResponseToJson(this);
}

@JsonSerializable()
class InviteFightingResultResponse extends BaseResponse<InviteFightingResult>{
  InviteFightingResultResponse();
  factory InviteFightingResultResponse.fromJson(Map<String,dynamic> json) => _$InviteFightingResultResponseFromJson(json);
  Map<String,dynamic> toJson() => _$InviteFightingResultResponseToJson(this);
}


@JsonSerializable()
class ReceivedChessmanResponse extends BaseResponse<ReceivedChessman> {
  ReceivedChessmanResponse();

  factory ReceivedChessmanResponse.fromJson(Map<String, dynamic> json) =>
      _$ReceivedChessmanResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReceivedChessmanResponseToJson(this);
}

@JsonSerializable()
class GameOverResponse extends BaseResponse<GameOver>{
  GameOverResponse();
  factory GameOverResponse.fromJson(Map<String,dynamic> json) => _$GameOverResponseFromJson(json);
  Map<String,dynamic> toJson() => _$GameOverResponseToJson(this);
}

