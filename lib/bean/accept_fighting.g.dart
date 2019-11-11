// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_fighting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcceptFighting _$AcceptFightingFromJson(Map<String, dynamic> json) {
  return AcceptFighting(
      accept: json['accept'] as bool,
      confirm: json['confirm'] == null
          ? null
          : FightingConfirm.fromJson(json['confirm'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AcceptFightingToJson(AcceptFighting instance) =>
    <String, dynamic>{'accept': instance.accept, 'confirm': instance.confirm};
