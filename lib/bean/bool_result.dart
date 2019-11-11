import 'package:json_annotation/json_annotation.dart';
part 'bool_result.g.dart';

@JsonSerializable()
class BoolResult{
  int code ;
  bool result ;

  BoolResult(this.code ,this.result);

  factory BoolResult.fromJson(Map<String,dynamic> json) => _$BoolResultFromJson(json);

  Map<String,dynamic> toJson() => _$BoolResultToJson(this);

}