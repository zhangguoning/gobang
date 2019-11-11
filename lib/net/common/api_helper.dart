
import 'dart:async';

import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/game_over.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/player_list.dart';
import 'package:gobang/bean/bool_result.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/fighting.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/bean/send_chessman.dart';
import 'package:gobang/net/common/api.dart';
import 'package:gobang/net/common/connect_listener.dart';
import 'package:gobang/net/internet/websocket_connect_api.dart';
import 'package:gobang/net/localserver/socket_connect_api.dart';
import 'package:gobang/common/global_config.dart';


enum _ServerType{
  SOCKET,WEBSOCKET,
}

class ApiHelper implements Api{

  _ServerType _serverType;
  var _connectManager ; ///var 可能的类型: SocketConnectApi , WebSocketConnectApi

  List<OnReceivedDataListener> onDataListeners = List<OnReceivedDataListener>();

  StreamController<Chessman> _onReceivedChessmanStreamController;
  Stream<Chessman> onReceivedChessmanStream;

  StreamController<FightingConfirm> _fightingConfirmStreamController;
  Stream<FightingConfirm> onFightingConfirmStream;

  StreamController<InviteFightingResult> _fightingStreamController;
  Stream<InviteFightingResult> onFightingStream;

  StreamController<BoolResult> _quitGameStreamController;
  Stream<BoolResult> _quitGameStream;

  StreamController<GameOver> _gameOverStreamController;
  Stream<GameOver> _gameOverStream;

  StreamController<BoolResult> _startGameStreamController;
  Stream<BoolResult> _startGameStream;

  Player _cachePlayer ;

  static final Map<_ServerType, ApiHelper> _cache = <_ServerType, ApiHelper>{};

  ApiHelper._(this._serverType);

  factory ApiHelper.socket(){
    if(_cache[_ServerType.SOCKET] != null){
      return _cache[_ServerType.SOCKET];
    }else{
      ApiHelper apiHelper = ApiHelper._(_ServerType.SOCKET);
      _cache[_ServerType.SOCKET] = apiHelper;
      return apiHelper;
    }
  }

  factory ApiHelper.webSocket(){
    if(_cache[_ServerType.WEBSOCKET] != null){
      return _cache[_ServerType.WEBSOCKET];
    }else{
      ApiHelper apiHelper = ApiHelper._(_ServerType.WEBSOCKET);
      _cache[_ServerType.WEBSOCKET] = apiHelper;
      return apiHelper;
    }
  }

  void _initListener(){
    _fightingConfirmStreamController = new StreamController();
    onFightingConfirmStream = _fightingConfirmStreamController.stream.asBroadcastStream();

    _fightingStreamController = new StreamController();
    onFightingStream = _fightingStreamController.stream.asBroadcastStream();

    _onReceivedChessmanStreamController = new StreamController();
    onReceivedChessmanStream = _onReceivedChessmanStreamController.stream.asBroadcastStream();

    _quitGameStreamController = new StreamController();
    _quitGameStream = _quitGameStreamController.stream.asBroadcastStream();

    _gameOverStreamController = new StreamController();
    _gameOverStream = _gameOverStreamController.stream.asBroadcastStream();

    _startGameStreamController = new StreamController();
    _startGameStream = _startGameStreamController.stream.asBroadcastStream();

    ///don't check null value ,if any controller is null  ,throw Exception once!
    onDataListeners.add(OnInviteFightingConfirmListener(_fightingConfirmStreamController.sink));
    onDataListeners.add(OnFightingConfirmListener(_fightingStreamController.sink));
    onDataListeners.add(OnReceivedChessmanListener(_onReceivedChessmanStreamController.sink));
    onDataListeners.add(OnAdversaryQuitGameListener(_quitGameStreamController.sink));
    onDataListeners.add(OnStartGameListener(_startGameStreamController.sink));
    onDataListeners.add(OnGameOverListener(_gameOverStreamController.sink));
  }

  StreamSubscription<Chessman> listenReceivedChessman(void Function(Chessman chessman) onData){
    return onReceivedChessmanStream.listen(onData);
  }

  StreamSubscription<FightingConfirm> listenFightingConfirm(void Function(FightingConfirm confirm) onData){
    return onFightingConfirmStream.listen(onData);
  }

  StreamSubscription<InviteFightingResult> listenFighting(void Function(InviteFightingResult fighting) onData){
    return onFightingStream.listen(onData);
  }

  StreamSubscription<BoolResult> listenQuitGame(void Function(BoolResult result) onData){
    return _quitGameStream.listen(onData);
  }

  StreamSubscription<GameOver> listenGameOver(void Function(GameOver result) onData){
    return _gameOverStream.listen(onData);
  }

  StreamSubscription<BoolResult> listenStartGame(void Function(BoolResult result) onData){
    return _startGameStream.listen(onData);
  }



  Future<ApiHelper> connect(String host ,int port,{Duration timeout = const Duration(seconds: Timer.TIME_OUT)}) async{
    if(_connectManager!=null){
      return this;
    }
    _clearCallback();
    _initListener();

    void onData(String data){
      if(onDataListeners!=null && onDataListeners.isNotEmpty){
        for(OnReceivedDataListener listener in onDataListeners){
          bool test = listener.test(data);
          if(test){
            listener.onData(data);
          }
        }
      }
    }

    switch (_serverType) {
      case _ServerType.SOCKET:
        this._connectManager = await SocketConnectApi.getInstance(host, port, timeout: timeout)
          ..onDataListener = onData
          ..onDisConnected = _onDisConnected
          ..onReConnected = _onReConnected;
        break;

      case _ServerType.WEBSOCKET:
      /// hostUrl eg: "ws://172.18.81.240:9893"
        String hostUrl = "ws://$host:$port";
        this._connectManager = await WebSocketConnectApi.getInstance(hostUrl,timeout: timeout)
          ..onDataListener = onData
          ..onDisConnected = _onDisConnected
          ..onReConnected = _onReConnected;
        break;

      default:
      ///可在此扩展服务器类型
        throw Exception("unknown server type!");
    }
    return this;
  }

  ///链接断开
  void _onDisConnected(){

  }

  ///重新建立链接
  void _onReConnected(){
    this.register(_cachePlayer);
  }


  Future<void> close() async{
    _onReceivedChessmanStreamController?.close();
    _fightingConfirmStreamController?.close();
    _fightingStreamController?.close();
    _quitGameStreamController?.close();
    _startGameStreamController?.close();
    _gameOverStreamController?.close();

    onDataListeners?.clear();

    return await _connectManager.close();
  }

  void _clearCallback(){
    _onReceivedChessmanStreamController?.close();
    _fightingConfirmStreamController?.close();
    _fightingStreamController?.close();
    _quitGameStreamController?.close();
    _startGameStreamController?.close();
    _gameOverStreamController?.close();

    onDataListeners?.clear();
  }


  @override
  Future<PlayerList> register(Player player) async{
    _cachePlayer = player;
    return _connectManager.register(player);
  }

  @override
  Future<BoolResult> sendChessman(SendChessman sendChessman) async{
    return _connectManager.sendChessman(sendChessman);
  }


  @override
  Future<FightingConfirm> inviteFighting(InviteFighting inviteFighting) {
    return _connectManager.inviteFighting(inviteFighting);
  }

  @override
  Future<InviteFightingResult> acceptFighting(FightingConfirm confirm) {
    return _connectManager.acceptFighting(confirm);
  }

  Future<InviteFightingResult> refuseFighting(FightingConfirm confirm) {
    return _connectManager.refuseFighting(confirm);
  }

  @override
  Future<BoolResult> startGame(InviteFightingResult result) {
    return _connectManager.startGame(result);
  }

  @override
  Future<BoolResult> quitGame(Fighting fighting) {
    return _connectManager.quitGame(fighting);
  }

  @override
  Future<PlayerList> queryPlayers() {
    return _connectManager.queryPlayers();
  }

  @override
  Future<BoolResult> cancelInviteFighting(FightingConfirm fightingConfirm) {
    return _connectManager.cancelInviteFighting(fightingConfirm);
  }

}
