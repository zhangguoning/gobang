import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/net/common/command.dart';
import 'package:gobang/user/current_player.dart';
import 'package:provider/provider.dart';

typedef OnServerReceived  = void Function(String data);
typedef OnClientReceived  = void Function(String data);

class LocalServer {

  final OnServerReceived onServerReceived ;
  final OnClientReceived onClientReceived;

  LocalServer({this.onServerReceived,this.onClientReceived}){
    initServerSocket();
  }


  static const String LOCAL_IP = '127.0.0.1';
  static const int PORT = 8613;
  static ServerSocket serverSocket;


  int serverCount = 0 ;

  Future<void> initServerSocket() async {
    if (serverSocket == null) {
      serverSocket = await ServerSocket.bind(LOCAL_IP, PORT);
      serverSocket.listen((socket) {
        socket.transform(utf8.decoder).listen((data) {
          onServerReceived("接收到来自 ${socket.address.host} 的消息:$data");
          socket.writeln('hello cilent! , this msg from server! count = ${++serverCount}');
        });
      });
    }
  }

  int count = 0 ;
  void testServer() {
    initServerSocket().whenComplete(() {
      Socket.connect(LOCAL_IP, PORT).then((socket) {
        print("客户端发送消息! ->${++count}");
        socket.writeln('Hello, World! -> $count');
        socket.flush();
      });
    });
  }

  Socket socket ;

  void sendMsg(BuildContext context ,String ip) async {
    if(socket == null || socket.address.host != ip){
      socket = await Socket.connect(ip, PORT);

      socket.transform(utf8.decoder).listen((data){
        onClientReceived(data);
        print("客户端接收到消息:$data");
      },onError: (error){
        print(error);
        socket.destroy();
        socket = null ;
      });
    }
    try{
      socket.writeln("${Command.QUERY_PLAYERS}");
//    socket.writeln("${Command.SET_USERINFO}:${(Provider.of<CurrentPlayer>(context).user as Player).toJsonString()}");
      socket.flush();
    }catch(e){
      socket.destroy();
      socket = null ;
    }

  }
}
