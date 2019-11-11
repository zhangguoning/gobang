// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_chessman.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendChessman _$SendChessmanFromJson(Map<String, dynamic> json) {
  return SendChessman(
      fightingId: json['fightingId'] as String,
      chessman: json['chessman'] == null
          ? null
          : Chessman.fromJson(json['chessman'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SendChessmanToJson(SendChessman instance) =>
    <String, dynamic>{
      'fightingId': instance.fightingId,
      'chessman': instance.chessman
    };
