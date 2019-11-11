import 'dart:async';
import 'dart:convert';

import 'package:gobang/bean/accept_fighting.dart';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/player_list.dart';
import 'package:gobang/bean/request.dart';
import 'package:gobang/bean/response.dart';
import 'package:gobang/bean/bool_result.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/fighting.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/bean/send_chessman.dart';
import 'package:gobang/net/common/api.dart';
import 'package:gobang/net/common/command.dart';
import 'package:gobang/net/common/command_parser.dart';
import 'package:gobang/net/common/connect_listener.dart';
import 'package:web_socket_channel/io.dart';
import 'package:gobang/common/global_config.dart';

typedef OnData  = void Function(String data);

class WebSocketConnectApi implements Api {

  String hostUrl;
  Duration timeout = const Duration(seconds: Timer.TIME_OUT);

  IOWebSocketChannel channel;
  Stream<String> connectStream;
  bool isAlive = false ;

  OnData onDataListener;
  void Function() onReConnected;
  void Function() onDisConnected;

  WebSocketConnectApi._();
  static WebSocketConnectApi _instance;


  ///取得实例,并建立 WebSocket 连接,一般情况下这个方法只会在 ApiHelper 中使用.
  static Future<WebSocketConnectApi> getInstance(String hostUrl,{Duration timeout = const Duration(seconds: Timer.TIME_OUT)}) async{
    if (_instance == null || _instance.hostUrl != hostUrl) {
      _instance = WebSocketConnectApi._();
      await _instance._connect(hostUrl,timeout:timeout);
    }
    _instance.hostUrl = hostUrl;
    return _instance;
  }

  ///建立 WebSocket 连接
  Future<Stream<String>> _connect(String hostUrl,{Duration timeout = const Duration(seconds: Timer.TIME_OUT)}) async {
    channel = IOWebSocketChannel.connect(hostUrl,pingInterval: timeout);
    connectStream = channel.stream.asBroadcastStream().map<String>((data) {
      return data as String;
    });
    connectStream.listen(onData,onError: onError,onDone: onDone,);
    isAlive = true;
    return connectStream;
  }

  ///检查并确保 WebSocket 连接状态正常
  FutureOr<Stream<String>> _keepAlive() async{
    if(!isAlive || connectStream == null || channel == null || channel.sink == null){
     Stream<String> stream = await _connect(hostUrl,timeout:timeout);
     if(onReConnected!=null){
       onReConnected();
     }
      return stream;
    }else{
      return connectStream;
    }
  }

  ///断开 WebSocket 连接
  void close({void onClosed(Object data)}){
    if(channel!=null){
      channel.sink.close(-1,"disconnect websocket");
    }
    _instance = null;
  }

  void onError(var error ,var c){
    isAlive = false ;
    if(onDisConnected!=null){
      onDisConnected();
    }
  }

  void onDone(){
    isAlive = false;
    if(onDisConnected!=null){
      onDisConnected();
    }
  }

  ///相当于拦截器(每接收到数据时候触发)
  void onData(String data){
    print("websocket 拦截器, 数据接收:$data");
    if(onDataListener!=null){
      onDataListener(data);
    }
  }

  ///发送数据
  void sendData(String msg){
    channel.sink.add(msg);
  }

  ///接口定义: queryPlayers
  StreamSubscription queryPlayersSubscription;
  @override
  Future<PlayerList> queryPlayers() async {
    await _keepAlive();

    Completer<PlayerList> c = new Completer<PlayerList>();
    queryPlayersSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.QUERY_PLAYERS) == true ){

        ///取消并回收该订阅者
        queryPlayersSubscription?.cancel();
        queryPlayersSubscription = null;

        ///解析并返回结果
        QueryPlayersResponse res = CommandParser.getInstance().parserQueryPlayers(data);
        c.complete(res?.data);
      }
    });

    sendData("${Command.QUERY_PLAYERS}");
    return c.future;
  }

  ///接口定义: register
  StreamSubscription registerSubscription;
  @override
  Future<PlayerList> register(Player player) async{
    await _keepAlive();

    Completer<PlayerList> c = new Completer<PlayerList>();
    registerSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.REGISTER) == true ){

        ///取消并回收该订阅者
        registerSubscription?.cancel();
        registerSubscription = null;

        ///解析并返回结果
        RegisterResponse res = CommandParser.getInstance().parserRegister(data);
        c.complete(res?.data);
      }
    });

    RegisterRequest request = RegisterRequest()
      ..time = DateTime.now().millisecondsSinceEpoch
      ..code = 1000
      ..data = player;

    sendData("${Command.REGISTER}${json.encode(request)}");
    return c.future;
  }

  ///接口定义: sendChessman
  StreamSubscription sendChessmanSubscription;
  @override
  Future<BoolResult> sendChessman(SendChessman sendChessman) async{
    await _keepAlive();

    Completer<BoolResult> c = new Completer<BoolResult>();
    sendChessmanSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.SEND_CHESSMAN) == true){
        ///取消并回收该订阅者
        sendChessmanSubscription?.cancel();
        sendChessmanSubscription = null;

        ///解析并返回结果
        BoolResultResponse res = CommandParser.getInstance().parserSendChessman(data);
        c.complete(res?.data);
      }
    });

    SendChessmanRequest request = SendChessmanRequest()
      ..code = 1000
      ..time = DateTime.now().millisecondsSinceEpoch
      ..data = sendChessman;
    sendData("${Command.SEND_CHESSMAN}${json.encode(request)}");
    return c.future;
  }

  ///接口定义: inviteFighting
  StreamSubscription inviteFightingSubscription;
  @override
  Future<FightingConfirm> inviteFighting(InviteFighting inviteFighting) async{
    await _keepAlive();

    Completer<FightingConfirm> c = new Completer<FightingConfirm>();
    inviteFightingSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.INVITE_FIGHTING) == true){
        ///取消并回收该订阅者
        inviteFightingSubscription?.cancel();
        inviteFightingSubscription = null;

        ///解析并返回结果
        FightingConfirmResponse res = CommandParser.getInstance().parserInviteFighting(data);
        c.complete(res?.data);
      }
    });

    InviteFightingRequest request = InviteFightingRequest()
      ..data = inviteFighting
      ..time = DateTime
          .now()
          .millisecondsSinceEpoch
      ..code = 1000;

    sendData("${Command.INVITE_FIGHTING}${json.encode(request)}");
    return c.future;
  }

  ///接口定义: acceptFighting
  StreamSubscription acceptFightingSubscription;
  @override
  Future<InviteFightingResult> acceptFighting(FightingConfirm confirm) async{
    await _keepAlive();

    Completer<InviteFightingResult> c = new Completer<InviteFightingResult>();
    acceptFightingSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.ACCEPT_FIGHTING) == true){
        ///取消并回收该订阅者
        acceptFightingSubscription?.cancel();
        acceptFightingSubscription = null;

        ///解析并返回结果
        InviteFightingResultResponse res = CommandParser.getInstance().parserFightingConfirm(data);
        c.complete(res?.data);
      }
    });
    AcceptFighting acceptFighting = AcceptFighting()
      ..confirm = confirm
      ..accept = true;
    AcceptFightingRequest request = new AcceptFightingRequest()

      ..time = DateTime
          .now()
          .millisecondsSinceEpoch
      ..code = 1000
      ..data = acceptFighting;

    sendData("${Command.ACCEPT_FIGHTING}${json.encode(request)}");
    return c.future;
  }

  ///接口定义: refuseFighting
  StreamSubscription refuseFightingSubscription;
  @override
  Future<InviteFightingResult> refuseFighting(FightingConfirm confirm) async {
    await _keepAlive();

    Completer<InviteFightingResult> c = new Completer<InviteFightingResult>();
    refuseFightingSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.ACCEPT_FIGHTING) == true){
        ///取消并回收该订阅者
        refuseFightingSubscription?.cancel();
        refuseFightingSubscription = null;

        ///解析并返回结果
        InviteFightingResultResponse res = CommandParser.getInstance().parserFightingConfirm(data);
        c.complete(res?.data);
      }
    });
    AcceptFighting acceptFighting = AcceptFighting()
      ..confirm = confirm
      ..accept = false;
    AcceptFightingRequest request = new AcceptFightingRequest()

      ..time = DateTime
          .now()
          .millisecondsSinceEpoch
      ..code = 1000
      ..data = acceptFighting;

    sendData("${Command.ACCEPT_FIGHTING}${json.encode(request)}");
    return c.future;
  }

  ///接口定义: startGame
  StreamSubscription startGameSubscription;
  @override
  Future<BoolResult> startGame(InviteFightingResult result) async{
    await _keepAlive();

    Completer<BoolResult> c = new Completer<BoolResult>();
    startGameSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.START_GAME) == true){
        ///取消并回收该订阅者
        startGameSubscription?.cancel();
        startGameSubscription = null;

        ///解析并返回结果
        BoolResultResponse res = CommandParser.getInstance().parserStartGame(data);
        c.complete(res?.data);
      }
    });
    StartGameRequest request = new StartGameRequest()
      ..time = DateTime
          .now()
          .millisecondsSinceEpoch
      ..code = 1000
      ..data = result;

    sendData("${Command.START_GAME}${json.encode(request)}");
    return c.future;
  }

  ///接口定义: quitGame
  StreamSubscription quitGameSubscription;
  @override
  Future<BoolResult> quitGame(Fighting fighting) async{
    await _keepAlive();

    Completer<BoolResult> c = new Completer<BoolResult>();
    startGameSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.QUIT_GAME) == true){
        ///取消并回收该订阅者
        quitGameSubscription?.cancel();
        quitGameSubscription = null;

        ///解析并返回结果
        BoolResultResponse res = CommandParser.getInstance().parserQuitGame(data);
        try{
          c.complete(res?.data);
       }catch(e,c){

        }


      }
    });

    QuitGameRequest request = new QuitGameRequest()
      ..time = DateTime
          .now()
          .millisecondsSinceEpoch
      ..code = 1000
      ..data = fighting;

    sendData("${Command.QUIT_GAME}${json.encode(request)}");
    return c.future;
  }

  ///接口定义: cancelInviteFighting
  StreamSubscription cancelInviteFightingSubscription;
  @override
  Future<BoolResult> cancelInviteFighting(FightingConfirm fightingConfirm) async{
    await _keepAlive();

    Completer<BoolResult> c = new Completer<BoolResult>();
    cancelInviteFightingSubscription = connectStream.listen((data){
      if(data?.startsWith(Command.QUIT_GAME) == true){
        ///取消并回收该订阅者
        cancelInviteFightingSubscription?.cancel();
        cancelInviteFightingSubscription = null;

        ///解析并返回结果
        BoolResultResponse res = CommandParser.getInstance().parserCancelInviteFighting(data);
        c.complete(res?.data);
      }
    });

    CancelInviteFightingRequest request = new CancelInviteFightingRequest()
      ..time = DateTime
          .now()
          .millisecondsSinceEpoch
      ..code = 1000
      ..data = fightingConfirm;

    sendData("${Command.CANCEL_INVITE_FIGHTING}${json.encode(request)}");
    return c.future;
  }

}