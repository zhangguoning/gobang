// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerList _$PlayerListFromJson(Map<String, dynamic> json) {
  return PlayerList((json['players'] as List)
      ?.map(
          (e) => e == null ? null : Player.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$PlayerListToJson(PlayerList instance) =>
    <String, dynamic>{'players': instance.players};
