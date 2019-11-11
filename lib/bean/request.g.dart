// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) {
  return RegisterRequest()
    ..code = json['code'] as int
    ..time = json['time'] as int
    ..data = json['data'] == null
        ? null
        : Player.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RegisterRequestToJson(RegisterRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'data': instance.data
    };

InviteFightingRequest _$InviteFightingRequestFromJson(
    Map<String, dynamic> json) {
  return InviteFightingRequest()
    ..code = json['code'] as int
    ..time = json['time'] as int
    ..data = json['data'] == null
        ? null
        : InviteFighting.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InviteFightingRequestToJson(
        InviteFightingRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'data': instance.data
    };

CancelInviteFightingRequest _$CancelInviteFightingRequestFromJson(
    Map<String, dynamic> json) {
  return CancelInviteFightingRequest()
    ..code = json['code'] as int
    ..time = json['time'] as int
    ..data = json['data'] == null
        ? null
        : FightingConfirm.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CancelInviteFightingRequestToJson(
        CancelInviteFightingRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'data': instance.data
    };

AcceptFightingRequest _$AcceptFightingRequestFromJson(
    Map<String, dynamic> json) {
  return AcceptFightingRequest()
    ..code = json['code'] as int
    ..time = json['time'] as int
    ..data = json['data'] == null
        ? null
        : AcceptFighting.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$AcceptFightingRequestToJson(
        AcceptFightingRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'data': instance.data
    };

SendChessmanRequest _$SendChessmanRequestFromJson(Map<String, dynamic> json) {
  return SendChessmanRequest()
    ..code = json['code'] as int
    ..time = json['time'] as int
    ..data = json['data'] == null
        ? null
        : SendChessman.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SendChessmanRequestToJson(
        SendChessmanRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'data': instance.data
    };

StartGameRequest _$StartGameRequestFromJson(Map<String, dynamic> json) {
  return StartGameRequest()
    ..code = json['code'] as int
    ..time = json['time'] as int
    ..data = json['data'] == null
        ? null
        : InviteFightingResult.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$StartGameRequestToJson(StartGameRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'data': instance.data
    };

QuitGameRequest _$QuitGameRequestFromJson(Map<String, dynamic> json) {
  return QuitGameRequest()
    ..code = json['code'] as int
    ..time = json['time'] as int
    ..data = json['data'] == null
        ? null
        : Fighting.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$QuitGameRequestToJson(QuitGameRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'time': instance.time,
      'data': instance.data
    };
