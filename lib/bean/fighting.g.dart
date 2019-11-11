// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fighting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Fighting _$FightingFromJson(Map<String, dynamic> json) {
  return Fighting(
      json['initiatorPlayer'] == null
          ? null
          : Player.fromJson(json['initiatorPlayer'] as Map<String, dynamic>),
      json['InviteesPlayer'] == null
          ? null
          : Player.fromJson(json['InviteesPlayer'] as Map<String, dynamic>),
      json['time'] as int,
      fightingId: json['fightingId'] as String,
      chessmanList: (json['chessmanList'] as List)
          ?.map((e) =>
              e == null ? null : Chessman.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      firstPlayerChessmanList: (json['firstPlayerChessmanList'] as List)
          ?.map((e) =>
              e == null ? null : Chessman.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      secondPlayerChessmanList: (json['secondPlayerChessmanList'] as List)
          ?.map((e) =>
              e == null ? null : Chessman.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$FightingToJson(Fighting instance) => <String, dynamic>{
      'fightingId': instance.fightingId,
      'initiatorPlayer': instance.initiatorPlayer,
      'InviteesPlayer': instance.InviteesPlayer,
      'time': instance.time,
      'chessmanList': instance.chessmanList,
      'firstPlayerChessmanList': instance.firstPlayerChessmanList,
      'secondPlayerChessmanList': instance.secondPlayerChessmanList
    };
