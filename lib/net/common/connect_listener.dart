
import 'dart:async';

import 'package:gobang/bean/bool_result.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/fighting.dart';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/game_over.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/response.dart';
import 'package:gobang/net/common/command.dart';
import 'package:gobang/net/common/command_parser.dart';

abstract class OnReceivedDataListener{
  ///数据过滤
  bool test(String data);
  ///数据监听
  void onData(String data);
}

///接收这个指令意味着游戏已经匹配成功,即将开始游戏
class OnFightingConfirmListener implements OnReceivedDataListener{
  StreamSink<InviteFightingResult> _sink;
  OnFightingConfirmListener(this._sink);

  @override
  bool test(String data) {
    return  data?.startsWith(Command.FIGHTING) == true || data?.startsWith(Command.CALLBACK_INVITE_FIGHTING_RESULT) == true;
  }

  @override
  void onData(String data) {
    InviteFightingResultResponse response = CommandParser.getInstance().parserFightingConfirm(data);
    if(_sink == null || response.data == null){
      print("出错! _sink == null");
    }else{
      print(" _sink状态正常!");
    }
    _sink.add(response?.data);
  }
}

///接收到对方的落子,此时应该将对方的这个棋子绘制在棋盘上
class OnReceivedChessmanListener implements OnReceivedDataListener{
  StreamSink<Chessman> _sink;
  OnReceivedChessmanListener(this._sink);

  @override
  bool test(String data) {
    return data?.startsWith(Command.CALLBACK_RECEIVED_CHESSMAN) == true;
  }

  @override
  void onData(String data) {
    ReceivedChessmanResponse response = CommandParser.getInstance().parserReceivedChessman(data);
    _sink?.add(response?.data?.chessman);
  }
}

///接收到某个玩家的对战邀请,应该回复接受邀请或者拒绝邀请
class OnInviteFightingConfirmListener implements OnReceivedDataListener{
  StreamSink<FightingConfirm> _sink;

  OnInviteFightingConfirmListener(this._sink) ;

  @override
  void onData(String data) {
    FightingConfirmResponse response  = CommandParser.getInstance().parserInviteFightingConfirm(data);
    _sink?.add(response?.data);
  }

  @override
  bool test(String data) {
    return data?.startsWith(Command.CALLBACK_INVITE_FIGHTING_CONFIRM) == true;
  }

}

///接收到开始游戏指令
class OnStartGameListener implements OnReceivedDataListener{
  StreamSink<BoolResult> _sink;
  OnStartGameListener(this._sink);

  @override
  void onData(String data) {
    BoolResultResponse response = CommandParser.getInstance().parserStartGame(data);
    _sink?.add(response?.data);
  }

  @override
  bool test(String data) {
    return data?.startsWith(Command.CALLBACK_START_GAME) == true;
  }

}

class OnAdversaryQuitGameListener implements OnReceivedDataListener{
  StreamSink<BoolResult> _sink;

  OnAdversaryQuitGameListener(this._sink);
  @override
  void onData(String data) {
    BoolResultResponse response  = CommandParser.getInstance().parserQuitGame(data);
    _sink?.add(response?.data);
  }

  @override
  bool test(String data) {
    return data?.startsWith(Command.CALLBACK_QUIT_GAME) == true;
  }
}

class OnGameOverListener implements OnReceivedDataListener{
  StreamSink<GameOver> _sink;
  OnGameOverListener(this._sink);
  @override
  void onData(String data) {
    GameOverResponse response = CommandParser.getInstance().parserGameOver(data);
    _sink?.add(response?.data);
  }

  @override
  bool test(String data) {
    return data?.startsWith(Command.CALLBACK_GAME_OVER) == true;
  }

}