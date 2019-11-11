// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_over.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameOver _$GameOverFromJson(Map<String, dynamic> json) {
  return GameOver(
      time: json['time'] as int,
      fightingId: json['fightingId'] as String,
      initiatorPlayer: json['initiatorPlayer'] == null
          ? null
          : Player.fromJson(json['initiatorPlayer'] as Map<String, dynamic>),
      inviteesPlayer: json['inviteesPlayer'] == null
          ? null
          : Player.fromJson(json['inviteesPlayer'] as Map<String, dynamic>),
      winner: json['winner'] == null
          ? null
          : GameWinner.fromJson(json['winner'] as Map<String, dynamic>));
}

Map<String, dynamic> _$GameOverToJson(GameOver instance) => <String, dynamic>{
      'time': instance.time,
      'fightingId': instance.fightingId,
      'initiatorPlayer': instance.initiatorPlayer,
      'inviteesPlayer': instance.inviteesPlayer,
      'winner': instance.winner
    };

GameWinner _$GameWinnerFromJson(Map<String, dynamic> json) {
  return GameWinner(
      winner: json['winner'] == null
          ? null
          : Player.fromJson(json['winner'] as Map<String, dynamic>),
      status: _$enumDecodeNullable(_$GameStatusEnumMap, json['status']),
      winResult: (json['winResult'] as List)
          ?.map((e) =>
              e == null ? null : Chessman.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$GameWinnerToJson(GameWinner instance) =>
    <String, dynamic>{
      'winResult': instance.winResult,
      'winner': instance.winner,
      'status': _$GameStatusEnumMap[instance.status]
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

const _$GameStatusEnumMap = <GameStatus, dynamic>{
  GameStatus.PLAYING: 'PLAYING',
  GameStatus.OVER_WIN: 'OVER_WIN',
  GameStatus.OVER_FULL: 'OVER_FULL'
};
