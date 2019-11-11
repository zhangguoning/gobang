// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'received_chessman.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceivedChessman _$ReceivedChessmanFromJson(Map<String, dynamic> json) {
  return ReceivedChessman(
      me: json['me'] == null
          ? null
          : Player.fromJson(json['me'] as Map<String, dynamic>),
      adversary: json['adversary'] == null
          ? null
          : Player.fromJson(json['adversary'] as Map<String, dynamic>),
      chessman: json['chessman'] == null
          ? null
          : Chessman.fromJson(json['chessman'] as Map<String, dynamic>),
      time: json['time'] as int);
}

Map<String, dynamic> _$ReceivedChessmanToJson(ReceivedChessman instance) =>
    <String, dynamic>{
      'me': instance.me,
      'adversary': instance.adversary,
      'chessman': instance.chessman,
      'time': instance.time
    };
