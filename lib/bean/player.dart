import 'package:json_annotation/json_annotation.dart';
part 'player.g.dart';

@JsonSerializable()
class Player{
   String ip ;
   String name;
   String deviceId;

   Player(this.ip,this.deviceId,this.name);

   Player.formDeviceId(this.deviceId,{this.ip = "0.0.0.0" , this.name = ""});

   factory Player.fromJson(Map<String,dynamic> json) => _$PlayerFromJson(json);

   Map<String,dynamic> toJson() => _$PlayerToJson(this);

   String toJsonString({Map<String,dynamic> json}) =>_$PlayerToJsonString(this, jsonMap: json);
}