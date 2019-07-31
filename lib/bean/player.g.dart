// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player(
      json['ip'] as String, json['deviceId'] as String, json['name'] as String);
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'ip': instance.ip,
      'name': instance.name,
      'deviceId': instance.deviceId
    };

String _$PlayerToJsonString(Player instance ,{Map<String,dynamic> jsonMap}){
  Map<String,dynamic> map = jsonMap!=null ? jsonMap : _$PlayerToJson(instance);
  List<String> keys = map.keys.toList();
  StringBuffer buffer = StringBuffer("{");
  for(String k in keys){
    buffer.write("\"$k\":\"${map[k]}\",");
  }
  return buffer.toString().substring(0,buffer.length-1) + "}";
}