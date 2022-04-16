import 'package:flutter_test/flutter_test.dart';
import 'package:gobang/bean/response.dart';
import 'package:gobang/net/common/command_parser.dart';
import 'package:gobang/page/pve/ab_ai.dart';
import 'package:gobang/page/pve/ai.dart';
import 'package:gobang/util/gameUtil.dart';
import 'package:gobang/widget/checker_board.dart';

void main() {
  
  
  test("testRex",() async{
    print("----start-----");
    String json = "%register%:{\"code\":2000,\"state\":true,\"data\":{\"players\":[{\"status\":\"FREE\",\"ip\":\"0.0.0.0\",\"name\":\"Player-14444\",\"deviceId\":\"00000000724558dc724558dc00000000\",\"isFirst\":false},{\"status\":\"FREE\",\"ip\":\"0.0.0.0\",\"name\":\"Player-60102\",\"deviceId\":\"000000003198527d3198527d00000000\",\"isFirst\":false}]}}";
    RegisterResponse response = CommandParser.getInstance().parser<RegisterResponse>(json, "%register%:");
    print(response);
    
    
    print("---complate---");

  });

  test("max-min-ai",() async{
    AB_AI ab_ai = new AB_AI(Player.BLACK);
    ChessNode root = ab_ai.createGameTree();

    ChessNode current = root;

    ab_ai.alphaBetaSearch(root);

    print(current);

  });

  //battle
  test("AI-vs-alphaBetaAI",() async{

    List<Chessman> chessmanList = List.empty(growable: true);
    AI ai = AI.chessmanList(Player.BLACK,chessmanList);
    AB_AI ab_ai = AB_AI(Player.WHITE);


    Offset  positionByAI = await ai.nextByAI();

    Chessman chessman = Chessman.black(positionByAI)..numberId = chessmanList.length;
    chessmanList.add(chessman);

    Chessman next = chessman;
    while(!GameUtil.isFull(chessmanList) && GameUtil.getWinner(chessmanList,newChessman: next) == null){
      ab_ai.updateChessmanList(chessmanList);
      Offset  positionByAB_AI = await ab_ai.nextByAI();
      Chessman chessman = Chessman.white(positionByAB_AI)..numberId = chessmanList.length;
      chessmanList.add(chessman);
      next = chessman;

      if(!GameUtil.isFull(chessmanList) && GameUtil.getWinner(chessmanList,newChessman: next) == null){
        ai.updateChessmanList(chessmanList);
        Offset  positionByAI = await ai.nextByAI();
        Chessman chessman = Chessman.black(positionByAI)..numberId = chessmanList.length;
        chessmanList.add(chessman);
        next = chessman;
      }else{
        break;
      }
      print("当前共有棋子：${chessmanList.length}");
    }

    Player winner = GameUtil.getWinner(chessmanList,newChessman: next);

    print(winner);
    print(chessmanList);

  });


  //battle
  test("alphaBetaAI-vs-AI",() async{

    List<Chessman> chessmanList = List.empty(growable: true);
    AB_AI ab_ai = AB_AI(Player.BLACK);
    AI ai = AI.chessmanList(Player.WHITE,chessmanList);


    Offset  positionByAB_AI = await ab_ai.nextByAI();
    Chessman chessman = Chessman.black(positionByAB_AI)..numberId = chessmanList.length;
    chessmanList.add(chessman);

    Chessman next = chessman;
    while(!GameUtil.isFull(chessmanList) && GameUtil.getWinner(chessmanList,newChessman: next) == null){
      ai.updateChessmanList(chessmanList);
      Offset  positionByAI = await ai.nextByAI();
      Chessman chessman = Chessman.white(positionByAI)..numberId = chessmanList.length;
      chessmanList.add(chessman);
      next = chessman;

      if(!GameUtil.isFull(chessmanList) && GameUtil.getWinner(chessmanList,newChessman: next) == null){
        ab_ai.updateChessmanList(chessmanList);
        Offset  position = await ab_ai.nextByAI();
        Chessman chessman = Chessman.black(position)..numberId = chessmanList.length;
        chessmanList.add(chessman);
        next = chessman;
      }else{
        break;
      }
      print("当前共有棋子：${chessmanList.length}");
    }
    Player winner = GameUtil.getWinner(chessmanList,newChessman: next);

    print(winner);
    print(chessmanList);

  });

}