// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryPlayersResponse _$QueryPlayersResponseFromJson(Map<String, dynamic> json) {
  return QueryPlayersResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : PlayerList.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$QueryPlayersResponseToJson(
        QueryPlayersResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

RegisterResponse _$RegisterResponseFromJson(Map<String, dynamic> json) {
  return RegisterResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : PlayerList.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RegisterResponseToJson(RegisterResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

FightingResponse _$FightingResponseFromJson(Map<String, dynamic> json) {
  return FightingResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : Fighting.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$FightingResponseToJson(FightingResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

FightingConfirmResponse _$FightingConfirmResponseFromJson(
    Map<String, dynamic> json) {
  return FightingConfirmResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : FightingConfirm.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$FightingConfirmResponseToJson(
        FightingConfirmResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

InviteFightingResponse _$InviteFightingResponseFromJson(
    Map<String, dynamic> json) {
  return InviteFightingResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : FightingConfirm.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InviteFightingResponseToJson(
        InviteFightingResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

BoolResultResponse _$BoolResultResponseFromJson(Map<String, dynamic> json) {
  return BoolResultResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : BoolResult.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$BoolResultResponseToJson(BoolResultResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

InviteFightingResultResponse _$InviteFightingResultResponseFromJson(
    Map<String, dynamic> json) {
  return InviteFightingResultResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : InviteFightingResult.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InviteFightingResultResponseToJson(
        InviteFightingResultResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

ReceivedChessmanResponse _$ReceivedChessmanResponseFromJson(
    Map<String, dynamic> json) {
  return ReceivedChessmanResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : ReceivedChessman.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ReceivedChessmanResponseToJson(
        ReceivedChessmanResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };

GameOverResponse _$GameOverResponseFromJson(Map<String, dynamic> json) {
  return GameOverResponse()
    ..code = json['code'] as int
    ..state = json['state'] as bool
    ..error = json['error'] == null
        ? null
        : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
    ..data = json['data'] == null
        ? null
        : GameOver.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GameOverResponseToJson(GameOverResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'state': instance.state,
      'error': instance.error,
      'data': instance.data
    };
