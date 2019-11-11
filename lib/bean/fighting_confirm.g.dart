// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fighting_confirm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FightingConfirm _$FightingConfirmFromJson(Map<String, dynamic> json) {
  return FightingConfirm(
      fightingId: json['fightingId'] as String,
      initiatorPlayer: json['initiatorPlayer'] == null
          ? null
          : Player.fromJson(json['initiatorPlayer'] as Map<String, dynamic>),
      time: json['time'] as int,
      Invitees: json['Invitees'] == null
          ? null
          : Player.fromJson(json['Invitees'] as Map<String, dynamic>));
}

Map<String, dynamic> _$FightingConfirmToJson(FightingConfirm instance) =>
    <String, dynamic>{
      'fightingId': instance.fightingId,
      'initiatorPlayer': instance.initiatorPlayer,
      'Invitees': instance.Invitees,
      'time': instance.time
    };
