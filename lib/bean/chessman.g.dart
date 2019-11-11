// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chessman.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chessman _$ChessmanFromJson(Map<String, dynamic> json) {
  return Chessman(
      json['owner'] == null
          ? null
          : Player.fromJson(json['owner'] as Map<String, dynamic>),
      json['position'] == null
          ? null
          : ChessmanPosition.fromJson(json['position'] as Map<String, dynamic>),
      json['numberId'] as int);
}

Map<String, dynamic> _$ChessmanToJson(Chessman instance) => <String, dynamic>{
      'owner': instance.owner,
      'position': instance.position,
      'numberId': instance.numberId
    };
