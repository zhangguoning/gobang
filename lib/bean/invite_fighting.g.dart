// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invite_fighting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InviteFighting _$InviteFightingFromJson(Map<String, dynamic> json) {
  return InviteFighting(
      adversary: json['adversary'] == null
          ? null
          : Player.fromJson(json['adversary'] as Map<String, dynamic>),
      time: json['time'] as int);
}

Map<String, dynamic> _$InviteFightingToJson(InviteFighting instance) =>
    <String, dynamic>{'adversary': instance.adversary, 'time': instance.time};

InviteFightingResult _$InviteFightingResultFromJson(Map<String, dynamic> json) {
  return InviteFightingResult(
      time: json['time'] as int,
      acceptFighting: json['acceptFighting'] == null
          ? null
          : AcceptFighting.fromJson(
              json['acceptFighting'] as Map<String, dynamic>),
      fighting: json['fighting'] == null
          ? null
          : Fighting.fromJson(json['fighting'] as Map<String, dynamic>))
    ..code = json['code'] as int;
}

Map<String, dynamic> _$InviteFightingResultToJson(
        InviteFightingResult instance) =>
    <String, dynamic>{
      'time': instance.time,
      'acceptFighting': instance.acceptFighting,
      'fighting': instance.fighting,
      'code': instance.code
    };
