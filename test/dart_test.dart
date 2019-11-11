import 'package:flutter_test/flutter_test.dart';
import 'package:gobang/bean/response.dart';
import 'package:gobang/net/common/command_parser.dart';

void main() {
  
  
  test("testRex",() async{
    print("----start-----");
    String json = "%register%:{\"code\":2000,\"state\":true,\"data\":{\"players\":[{\"status\":\"FREE\",\"ip\":\"0.0.0.0\",\"name\":\"Player-14444\",\"deviceId\":\"00000000724558dc724558dc00000000\",\"isFirst\":false},{\"status\":\"FREE\",\"ip\":\"0.0.0.0\",\"name\":\"Player-60102\",\"deviceId\":\"000000003198527d3198527d00000000\",\"isFirst\":false}]}}";
    RegisterResponse response = CommandParser.getInstance().parser<RegisterResponse>(json, "%register%:");
    print(response);
    
    
    print("---complate---");

  });
}