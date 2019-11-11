import 'package:gobang/bean/accept_fighting.dart';
import 'package:gobang/bean/fighting.dart';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/bean/send_chessman.dart';
import 'package:json_annotation/json_annotation.dart';
part 'request.g.dart';

class BaseRequest<T>{
  int code;
  int time;
  T data;
}



@JsonSerializable()
class RegisterRequest extends BaseRequest<Player>{
  RegisterRequest();
  factory RegisterRequest.fromJson(Map<String,dynamic> json) => _$RegisterRequestFromJson(json);
  Map<String,dynamic> toJson() => _$RegisterRequestToJson(this);
}


@JsonSerializable()
class InviteFightingRequest extends BaseRequest<InviteFighting>{
  InviteFightingRequest();
  factory InviteFightingRequest.fromJson(Map<String,dynamic> json) => _$InviteFightingRequestFromJson(json);
  Map<String,dynamic> toJson() => _$InviteFightingRequestToJson(this);
}


@JsonSerializable()
class CancelInviteFightingRequest extends BaseRequest<FightingConfirm>{
  CancelInviteFightingRequest();
  factory CancelInviteFightingRequest.fromJson(Map<String,dynamic> json) => _$CancelInviteFightingRequestFromJson(json);
  Map<String,dynamic> toJson() => _$CancelInviteFightingRequestToJson(this);
}

@JsonSerializable()
class AcceptFightingRequest extends BaseRequest<AcceptFighting>{
  AcceptFightingRequest();
  factory AcceptFightingRequest.fromJson(Map<String,dynamic> json) => _$AcceptFightingRequestFromJson(json);
  Map<String,dynamic> toJson() => _$AcceptFightingRequestToJson(this);
}

@JsonSerializable()
class SendChessmanRequest extends BaseRequest<SendChessman>{
  SendChessmanRequest();
  factory SendChessmanRequest.fromJson(Map<String,dynamic> json) => _$SendChessmanRequestFromJson(json);
  Map<String,dynamic> toJson() => _$SendChessmanRequestToJson(this);
}

@JsonSerializable()
class StartGameRequest extends BaseRequest<InviteFightingResult> {
  StartGameRequest();

  factory StartGameRequest.fromJson(Map<String, dynamic> json) =>
      _$StartGameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$StartGameRequestToJson(this);
}

@JsonSerializable()
class QuitGameRequest extends BaseRequest<Fighting> {
  QuitGameRequest();

  factory QuitGameRequest.fromJson(Map<String, dynamic> json) =>
      _$QuitGameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$QuitGameRequestToJson(this);
}
