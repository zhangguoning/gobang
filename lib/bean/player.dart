import 'package:json_annotation/json_annotation.dart';
part 'player.g.dart';

@JsonSerializable()
class Player{
   String ip ;
   String name;
   String deviceId;
   UserStatus status; //0:free ,1:busy
   String fightingId;
   bool isFirst;

   Player(this.ip,this.deviceId,this.name,this.status,this.fightingId,this.isFirst);

   bool operator == ( other){
      return this.deviceId == other.deviceId;
   }

   int get hashCode => super.hashCode;

   Player.formDeviceId(this.deviceId,{this.ip = "0.0.0.0" , this.name = ""});

   factory Player.fromJson(Map<String,dynamic> json) => _$PlayerFromJson(json);

   Map<String,dynamic> toJson() => _$PlayerToJson(this);
}

enum UserStatus{
   FREE,WAITING,PLAYING
}