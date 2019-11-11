import 'dart:convert';
import 'package:gobang/bean/fighting_confirm.dart';
import 'package:gobang/bean/invite_fighting.dart';
import 'package:gobang/bean/response.dart';
import 'package:gobang/bean/bool_result.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/net/common/command.dart';


class CommandParser{

  CommandParser._();
  static CommandParser _instance;
  static CommandParser getInstance(){
    if (_instance == null ) {
      _instance = CommandParser._();
    }
    return _instance;
  }

  QueryPlayersResponse parserQueryPlayers(String result){
    if(result?.startsWith(Command.QUERY_PLAYERS) == true){
      String response = result.replaceFirst(new RegExp('${Command.QUERY_PLAYERS}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return QueryPlayersResponse.fromJson(ret);
    }
    return null;
  }
  
  T parser<T>(String result ,String cmd){
    if(result?.startsWith(cmd) == true){
      String response = result.replaceFirst(cmd, "");
      Map<String, dynamic> ret = json.decode(response);
      Invocation invocation = Invocation.method(Symbol("fromJson"), [ret]);

    }
    return null;
  }
  

  RegisterResponse parserRegister(String result){
    if(result?.startsWith(Command.REGISTER) == true){
      String response = result.replaceFirst(new RegExp('${Command.REGISTER}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return RegisterResponse.fromJson(ret);
    }
    return null;
  }

  FightingConfirmResponse parserInviteFighting(String result){
    if(result?.startsWith(Command.INVITE_FIGHTING) == true){
      String response = result.replaceFirst(new RegExp('${Command.INVITE_FIGHTING}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return FightingConfirmResponse.fromJson(ret);
    }
    return null;
  }

  FightingConfirmResponse parserInviteFightingConfirm(String result){
    if(result?.startsWith(Command.CALLBACK_INVITE_FIGHTING_CONFIRM) == true){
      String response = result.replaceFirst(new RegExp('${Command.CALLBACK_INVITE_FIGHTING_CONFIRM}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return FightingConfirmResponse.fromJson(ret);
    }
    return null;
  }


  BoolResultResponse parserCancelInviteFighting(String result){
    if(result?.startsWith(Command.CANCEL_INVITE_FIGHTING) == true){
      String response = result.replaceFirst(new RegExp('${Command.CANCEL_INVITE_FIGHTING}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return BoolResultResponse.fromJson(ret);
    }
    return null;
  }

  FightingResponse parserAcceptFighting(String result){
    if(result?.startsWith(Command.ACCEPT_FIGHTING) == true){
      String response = result.replaceFirst(new RegExp('${Command.ACCEPT_FIGHTING}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return FightingResponse.fromJson(ret);
    }
    return null;
  }

  FightingResponse parserFighting(String result){
    if(result?.startsWith(Command.FIGHTING) == true){
      String response = result.replaceFirst(new RegExp('${Command.FIGHTING}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return FightingResponse.fromJson(ret);
    }
    return null;
  }

  BoolResultResponse parserSendChessman(String result){
    if(result?.startsWith(Command.SEND_CHESSMAN) == true){
      String response = result.replaceFirst(new RegExp('${Command.SEND_CHESSMAN}'), "");

      Map<String, dynamic> ret = json.decode(response);
      return BoolResultResponse.fromJson(ret);
    }
    return null;
  }

  ReceivedChessmanResponse parserReceivedChessman(String result){
    if(result?.startsWith(Command.CALLBACK_RECEIVED_CHESSMAN) == true){
      String response = result.replaceFirst(new RegExp('${Command.CALLBACK_RECEIVED_CHESSMAN}'), "");

      Map<String, dynamic> ret = json.decode(response);
      return ReceivedChessmanResponse.fromJson(ret);
    }
    return null;
  }

  InviteFightingResultResponse parserFightingConfirm(String result) {
    if(result?.startsWith(Command.CALLBACK_INVITE_FIGHTING_RESULT) == true || result?.startsWith(Command.ACCEPT_FIGHTING) == true){
      String response = result.replaceFirst(new RegExp('${Command.CALLBACK_INVITE_FIGHTING_RESULT}'), "");
      response = response.replaceFirst(new RegExp('${Command.ACCEPT_FIGHTING}'), "");

      Map<String, dynamic> ret = json.decode(response);
      return InviteFightingResultResponse.fromJson(ret);
    }
    return null;
  }

  BoolResultResponse parserStartGame(String result) {
    if(result?.startsWith(Command.START_GAME) == true || result?.startsWith(Command.CALLBACK_START_GAME) == true){
      String response = result.replaceFirst(new RegExp('${Command.START_GAME}'), "");
      response = response.replaceFirst(new RegExp('${Command.CALLBACK_START_GAME}'), "");

      Map<String, dynamic> ret = json.decode(response);
      return BoolResultResponse.fromJson(ret);
    }
    return null;
  }

  BoolResultResponse parserQuitGame(String result) {
    if(result?.startsWith(Command.QUIT_GAME) == true || result?.startsWith(Command.CALLBACK_QUIT_GAME) == true){
      String response = result.replaceFirst(new RegExp('${Command.QUIT_GAME}'), "");
      response = response.replaceFirst(new RegExp('${Command.CALLBACK_QUIT_GAME}'), "");

      Map<String, dynamic> ret = json.decode(response);
      return BoolResultResponse.fromJson(ret);
    }
    return null;
  }

  GameOverResponse parserGameOver(String result){
    if(result?.startsWith(Command.CALLBACK_GAME_OVER) == true){
      String response = result.replaceFirst(new RegExp('${Command.CALLBACK_GAME_OVER}'), "");
      Map<String, dynamic> ret = json.decode(response);
      return GameOverResponse.fromJson(ret);
    }
    return null;
  }

}
