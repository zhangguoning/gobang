
import 'dart:ui';

import  'package:gobang/widget/checker_board.dart' show Player,Chessman,LINE_COUNT hide checkResult;

class GameUtil{

  static bool isGameOver(List<Chessman> list,{Chessman newChessman}){
    if(list.isEmpty || list.length < 9){
      //五子连珠时，棋盘上至少有9颗棋子
      return false;
    }
    if(list.length >= LINE_COUNT * LINE_COUNT){
      return true;
    }

    if(newChessman!=null){
      return checkResult(newChessman,list)!=null;
    }else{
      for(Chessman chessman in list){
        if(checkResult(chessman,list) != null){
          return true;
        }
      }
      return false;
    }
  }

  static Player getWinner(List<Chessman> list,{Chessman newChessman}){
    if(list.isEmpty || list.length < 9 || isFull(list)){
      return null;
    }
    if(newChessman!=null){
      return checkResult(newChessman,list)?.first?.owner ?? null;
    }else{
      for(Chessman chessman in list){
        List<Chessman>  win = checkResult(chessman,list);
        if(win!=null){
          return win.first.owner;
        }
      }
      return null;
    }


  }

  static bool isFull(List<Chessman> list){
    if(list.length >= LINE_COUNT * LINE_COUNT){
      return true;
    }
    return false;
  }

  static List<Chessman> checkResult(Chessman newChessman,List<Chessman> chessmanList) {

    List<Chessman> winResult = [];

//  Color color = newChessman.color;
    int currentX = newChessman.position.dx.toInt();
    int currentY = newChessman.position.dy.toInt();

    int count = 0;

    ///横
    /// o o o o o
    /// o o o o o
    /// x x x x x
    /// o o o o o
    /// o o o o o
    winResult..clear();
    for (int i = (currentX - 4 > 0 ? currentX - 4 : 0);
    i <= (currentX + 4 < LINE_COUNT ? currentX + 4 : LINE_COUNT);
    i++) {
      Offset position = Offset(i.toDouble(), currentY.toDouble());
      if (existSpecificChessman(position, newChessman.owner,chessmanList)) {
        winResult.add(Chessman(position, newChessman.owner));
        count++;
      } else {
        winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
        return winResult;
      }
    }

    ///竖
    /// o o x o o
    /// o o x o o
    /// o o x o o
    /// o o x o o
    /// o o x o o
    count = 0;
    winResult.clear();
    for (int j = (currentY - 4 > 0 ? currentY - 4 : 0);
    j <= (currentY + 4 > LINE_COUNT ? LINE_COUNT : currentY + 4);
    j++) {
      Offset position = Offset(currentX.toDouble(), j.toDouble());
      if (existSpecificChessman(position, newChessman.owner,chessmanList)) {
        winResult.add(Chessman(position, newChessman.owner));
        count++;
      } else {
        winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
        return winResult;
      }
    }

    ///正斜
    /// o o o o x
    /// o o o x o
    /// o o x o o
    /// o x o o o
    /// x o o o o
    count = 0;
    winResult.clear();
    Offset offset2 = Offset((currentX - 4).toDouble(), (currentY + 4).toDouble());
    for (int i = 0; i < 10; i++) {
      Offset position = Offset(offset2.dx + i, offset2.dy - i);
      if (existSpecificChessman(position, newChessman.owner,chessmanList)) {
        winResult.add(Chessman(position, newChessman.owner));
        count++;
      } else {
        winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
        return winResult;
      }
    }

    ///反斜
    /// x o o o o
    /// o x o o o
    /// o o x o o
    /// o o o x o
    /// o o o o x
    count = 0;
    winResult..clear();
    Offset offset = Offset((currentX - 4).toDouble(), (currentY - 4).toDouble());
    for (int i = 0; i < 10; i++) {
      Offset position = Offset(offset.dx + i, offset.dy + i);
      if (existSpecificChessman(position, newChessman.owner,chessmanList)) {
        winResult.add(Chessman(position, newChessman.owner));
        count++;
      } else {
        winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
        return winResult;
      }
    }
    winResult.clear();
    return null;
  }

  static bool existChessman(Offset position,List<Chessman> chessmanList) {
    if (chessmanList != null && chessmanList.isNotEmpty) {
      var cm = chessmanList.firstWhere((Chessman c) {
        return c.position.dx == position.dx && c.position.dy == position.dy;
      }, orElse: () {
        return null;
      });
      return cm != null;
    }
    return false;
  }

  static bool existSpecificChessman(Offset position, Player player,List<Chessman> chessmanList) {
    if (chessmanList != null && chessmanList.isNotEmpty) {
      var cm = chessmanList.firstWhere((Chessman c) {
        return c.position.dx == position.dx && c.position.dy == position.dy;
      }, orElse: () {
        return null;
      });
      return cm != null && cm.owner == player;
    }
    return false;
  }

  static bool existBlackChessman(Offset position, List<Chessman> chessmanList) {
    if (chessmanList != null && chessmanList.isNotEmpty) {
      Chessman cm = chessmanList.firstWhere((Chessman c) {
        return c.position.dx == position.dx && c.position.dy == position.dy;
      }, orElse: () {
        return null;
      });
      return cm != null && cm.owner == Player.BLACK;
    }
    return false;
  }

  static bool existWhiteChessman(Offset position, List<Chessman> chessmanList) {
    if (chessmanList != null && chessmanList.isNotEmpty) {
      Chessman cm = chessmanList.firstWhere((Chessman c) {
        return c.position.dx == position.dx && c.position.dy == position.dy;
      }, orElse: () {
        return null;
      });
      return cm != null && cm.owner == Player.WHITE;
    }
    return false;
  }
}