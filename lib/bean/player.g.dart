// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player(
      json['ip'] as String,
      json['deviceId'] as String,
      json['name'] as String,
      _$enumDecodeNullable(_$UserStatusEnumMap, json['status']),
      json['fightingId'] as String,
      json['isFirst'] as bool);
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'ip': instance.ip,
      'name': instance.name,
      'deviceId': instance.deviceId,
      'status': _$UserStatusEnumMap[instance.status],
      'fightingId': instance.fightingId,
      'isFirst': instance.isFirst
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$UserStatusEnumMap = <UserStatus, dynamic>{
  UserStatus.FREE: 'FREE',
  UserStatus.WAITING: 'WAITING',
  UserStatus.PLAYING: 'PLAYING'
};
