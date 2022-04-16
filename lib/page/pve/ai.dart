import 'package:flutter/material.dart';
import 'package:gobang/util/buffer_container.dart';
import 'package:gobang/widget/checker_board.dart' as game;
import 'dart:math' as math;
import 'package:gobang/util/util.dart';

import 'package:gobang/widget/checker_board.dart';

class AI {
  static const int WIN = 10000;

  static const int DEEP_DEATH2  = 2;
  static const int LOWER_DEATH2 = 4;

  static const int DEEP_DEATH3  = 3;
  static const int LOWER_DEATH3 = 6;

  static const int DEEP_DEATH4  = 4;
  static const int LOWER_DEATH4 = 32;

  static const int ALIVE2       = 10;
  static const int JUMP_ALIVE2  = 2;
  static const int ALIVE3       = 100;
  static const int JUMP_ALIVE3  = 10;
  static const int ALIVE4       = 5000;
  static const int JUMP_ALIVE4  = 90;

  static const int LINE_COUNT = game.LINE_COUNT;

  game.Player computerPlayer;
  List<Chessman> chessmanList;

  AI(this.computerPlayer){
    chessmanList ??= game.chessmanList;
  }

  AI.chessmanList(this.computerPlayer,this.chessmanList);

  Future<Offset> nextByAI({bool isPrintMsg = false}) async {
    Offset pos = urgent();
    if(pos!=null){
      return pos;
    }

    //优化思路,取我方,敌方 各5个最优点位置,
    // 防中带攻: 如果判断应该防守,则在敌方5个最优位置中找出我方优势最大的点落子
    // 攻中带防: 如果判断应该进攻,则在己方5个最优位置中找出敌方优势最大的点落子
    BufferMap<Offset> ourPositions   = ourBetterPosition();
    BufferMap<Offset> enemyPositions = enemyBetterPosition();

  Offset position = bestPosition(ourPositions,enemyPositions);
  assert(position!=null);
  return position;
  }

  Offset urgent(){
    BufferMap<Offset> enemy = enemyBetterPosition();
    Offset urgentPosition ;
    for(int key in enemy.keySet){
      if(key >= ALIVE4){
        urgentPosition = enemy[key];
        break;
      }
    }

    BufferMap<Offset> our = ourBetterPosition();
    for(int key in our.keySet){
      if(key >= ALIVE4){
        return our[key];
      }
    }
    return urgentPosition;
  }

  void updateChessmanList(List<Chessman> chessmanList){
    this.chessmanList = chessmanList;
  }

  ///我方下一步较好的${maxCount}个位置
  BufferMap<Offset> ourBetterPosition({maxCount = 5}){
    Offset offset = Offset.zero;
    BufferMap<Offset> ourMap = BufferMap.maxCount(maxCount);
    for (int i = 0; i <= LINE_COUNT; i++) {
      for (int j = 0; j <= LINE_COUNT; j++) {
        offset = Offset(i.toDouble(), j.toDouble());
        if (isBlankPosition(offset)) {
          int score = chessmanGrade(offset);
          if(ourMap.minKey() < score){
            ourMap.put(score, Offset(offset.dx, offset.dy));
          }

        }
      }
    }
    return ourMap;
  }

  ///敌方下一步较好的${maxCount}个位置
  BufferMap<Offset>  enemyBetterPosition({maxCount = 5}){
    Offset offset = Offset.zero;
    BufferMap<Offset> enemyMap = BufferMap.maxCount(5);
    log("查找敌方最优落子位置");

    int count = 0;
    for (int i = 0; i <= LINE_COUNT; i++) {
      for (int j = 0; j <= LINE_COUNT; j++) {
        offset = Offset(i.toDouble(), j.toDouble());
        if (isBlankPosition(offset)) {
          DateTime start = DateTime.now();
          int score = chessmanGrade(offset, ownerPlayer : computerPlayer == game.Player.BLACK ? game.Player.WHITE : game.Player.BLACK );
          DateTime end = DateTime.now();
          count++;
          int time = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
          if(time > 5){
            log("查找敌方最优落子位置耗时：$time");
          }
          if(enemyMap.minKey() < score){
            enemyMap.put(score, Offset(offset.dx, offset.dy));
          }
        }
      }
    }
    log("查找地方最优落子位置次数：$count");
    return enemyMap;
  }

  Offset bestPosition(BufferMap<Offset> ourPositions , BufferMap<Offset> enemyPositions){
    Offset position;
    double maxScore = 0 ;

    ///魔法值 1.2 , 0.65 , 0.35
    if(enemyPositions.maxKey() / ourPositions.maxKey() > 1.2){
      for (int key in enemyPositions.keySet){
        int attackScore = chessmanGrade(enemyPositions[key]);
        double score = key * 1.0 + attackScore * 0.7;
        if(score >= maxScore){
          maxScore = score ;
          position = enemyPositions[key];
        }
      }
    }else{
      for (int key in ourPositions.keySet){
        int defenseScore = chessmanGrade(ourPositions[key]);
        double score = key * 1.0 + defenseScore * 0.7;
        if(score >= maxScore){
          maxScore = score ;
          position = ourPositions[key];
        }
      }
    }
    return position;
  }


  ///判断某个位置上是否有 {player} 的棋子
  bool existSpecificChessman(Offset position, game.Player player) {
    if (chessmanList != null && chessmanList.isNotEmpty) {
      var cm = chessmanList.firstWhere((game.Chessman c) {
        return c.position.dx == position.dx && c.position.dy == position.dy;
      }, orElse: () {
        return null;
      });
      return cm != null && cm.owner == player;
    }
    return false;
  }

  Offset nextChessman(Offset first, Offset second) {
    if (first.dy == second.dy) {
      return Offset(
          first.dx > second.dx ? second.dx - 1 : second.dx + 1, first.dy);
    } else if (first.dx == second.dx) {
      return Offset(
          first.dx, first.dy > second.dy ? second.dy - 1 : second.dy + 1);
    } else if (first.dx > second.dx) {
      if (first.dy > second.dy) {
        return Offset(second.dx - 1, second.dy - 1);
      } else {
        return Offset(second.dx - 1, second.dy + 1);
      }
    } else {
      if (first.dy > second.dy) {
        return Offset(second.dx + 1, second.dy - 1);
      } else {
        return Offset(second.dx + 1, second.dy + 1);
      }
    }
  }

  ///计算某个棋子对于 ownerPlayer 的分值
  int chessmanGrade(Offset chessmanPosition ,{game.Player ownerPlayer ,bool isCanPrintMsg = false}) {
    int score = 0;
    List<Offset> myChenssman = List<Offset>();
    Offset offset;
    Offset first = chessmanPosition;
    Player player = ownerPlayer;
    player ??= computerPlayer;

    ///横向
    //横向(左)
    offset = Offset(first.dx - 1, first.dy);
    myChenssman
      ..clear()
      ..add(first);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx - 1, offset.dy);
    }

    //横向(右)
    offset = Offset(first.dx + 1, first.dy);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx + 1, offset.dy);
    }
    myChenssman.sort((a, b) {
      return (a.dx - b.dx).toInt();
    });
    score += scoring(first ,myChenssman, player ,printMsg: "横向" ,isCanPrintMsg :isCanPrintMsg);

    ///竖向
    //竖向(上)
    myChenssman
      ..clear()
      ..add(first);
    offset = Offset(first.dx, first.dy - 1);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx, offset.dy - 1);
    }

    //竖向(下)
    offset = Offset(first.dx, first.dy + 1);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx, offset.dy + 1);
    }
    myChenssman.sort((a, b) {
      return (a.dy - b.dy).toInt();
    });
    score += scoring(first,myChenssman,player, printMsg: "竖向" ,isCanPrintMsg : isCanPrintMsg);

    ///正斜(第三象限 -> 第一象限)
    //正斜(第三象限)
    myChenssman
      ..clear()
      ..add(first);
    offset = Offset(first.dx - 1, first.dy + 1);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx - 1, offset.dy + 1);
    }

    //正斜(第一象限)
    offset = Offset(first.dx + 1, first.dy - 1);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx + 1, offset.dy - 1);
    }
    myChenssman.sort((a, b) {
      return (a.dx - b.dx).toInt() + (a.dy - b.dy).toInt();
    });
    score += scoring(first,myChenssman, player,printMsg: "正斜向" ,isCanPrintMsg : isCanPrintMsg);

    ///反斜(第二象限 -> 第四象限)
    //反斜(第二象限)
    myChenssman
      ..clear()
      ..add(first);
    offset = Offset(first.dx - 1, first.dy - 1);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx - 1, offset.dy - 1);
    }

    //反斜(第四象限)
    offset = Offset(first.dx + 1, first.dy + 1);
    while (existSpecificChessman(offset, player)) {
      myChenssman.add(offset);
      offset = Offset(offset.dx + 1, offset.dy + 1);
    }
    myChenssman.sort((a, b) {
      return (a.dx - b.dx).toInt() + (a.dy + b.dy).toInt();
    });
    score += scoring(first,myChenssman, player,printMsg: "反斜向" ,isCanPrintMsg : isCanPrintMsg);


    int ss = score + scoringAloneChessman(first);
    if(isCanPrintMsg){
      log("该子分值为: $ss ,其中单子得分:${scoringAloneChessman(first)}, 组合得分:$score");
    }

    int jumpAlive4Count = getJumpAlive4Count([first], player);
    int jumpAlive3Count = getJumpAlive3Count([first], player);
    int jumpAlive2Count = getJumpAlive2Count([first], player);
    score += limitMax(jumpAlive4Count) * JUMP_ALIVE4  + limitMax(jumpAlive3Count) * JUMP_ALIVE3 + limitMax(jumpAlive2Count) * JUMP_ALIVE2;


    return score + scoringAloneChessman(first);
  }

  int limitMax(int num){
    return num >= 2 ? 2 : num;
  }

  int scoring(Offset first ,List<Offset> myChenssman, game.Player player ,{String printMsg , bool isCanPrintMsg = false}) {
    if(myChenssman.length >= 5 ){
      return WIN;
    }

    int score = 0;
    switch (myChenssman.length) {

      case 1:

        break;
      case 2:
        if (isAlive2(myChenssman)) {
          score += ALIVE2;
          score += limitMax(getJumpAlive3Count(myChenssman, player)) * JUMP_ALIVE3 ;
          score += limitMax(getJumpAlive4Count(myChenssman, player)) * JUMP_ALIVE4 ;

          if(isCanPrintMsg){
            log("$printMsg 活2成立, 得分+$ALIVE2");
          }

        } else if (isLowerDeath2(myChenssman)) {
          score += LOWER_DEATH2;
          if(isCanPrintMsg){
            log("$printMsg 低级死2成立 ,得分+$LOWER_DEATH2");
          }

        } else {
          score += DEEP_DEATH2;
          if(isCanPrintMsg){
            log("$printMsg 死2成立 ,得分+$DEEP_DEATH2");
          }
        }
        break;
      case 3:
        if (isAlive3(myChenssman)) {
          score += ALIVE3;
          score += limitMax(getJumpAlive4Count(myChenssman, player)) * JUMP_ALIVE4 ;
          if(isCanPrintMsg){
            log("$printMsg 活3成立, 得分+$ALIVE3");
          }
        } else if (isLowerDeath3(myChenssman)) {
          score += LOWER_DEATH3;
          if(isCanPrintMsg){
            log("$printMsg 低级死3成立 ,得分+$LOWER_DEATH3");
          }
        } else {
          score += DEEP_DEATH3;
          if(isCanPrintMsg){
            log("$printMsg 死3成立 ,得分+$DEEP_DEATH3");
          }
        }
        break;

      case 4:
        if (isAlive4(myChenssman)) {
          score += ALIVE4;
          if(isCanPrintMsg){
            log("$printMsg 活4成立, 得分+$ALIVE4");
          }

        } else if (isLowerDeath4(myChenssman)) {
          score += LOWER_DEATH4;
          if(isCanPrintMsg){
            log("$printMsg 低级死4成立 ,得分+$LOWER_DEATH4");
          }

        } else {
          score += DEEP_DEATH4;
          if(isCanPrintMsg){
            log("$printMsg 死4成立 ,得分+$DEEP_DEATH4");
          }
        }
        break;

      case 5:
      default:
      score += WIN;
    }
    return score;
  }

  bool isEffectivePosition(Offset offset){
    return offset.dx >= 0 && offset.dx<=LINE_COUNT && offset.dy >=0 && offset.dy <=LINE_COUNT;
  }
  ///孤子价值
  int scoringAloneChessman(Offset offset) {
    int score = 0;
    List<Offset> list = [
      Offset(offset.dx - 1, offset.dy),
      Offset(offset.dx + 1, offset.dy),
      Offset(offset.dx, offset.dy + 1),
      Offset(offset.dx, offset.dy - 1),
      Offset(offset.dx - 1, offset.dy - 1),
      Offset(offset.dx - 1, offset.dy + 1),
      Offset(offset.dx + 1, offset.dy - 1),
      Offset(offset.dx + 1, offset.dy + 1),
    ];
    for (offset in list) {
      if (offset.dx > 0 && offset.dy > 0 && isBlankPosition(offset)) {
        score++;
      }
    }

    return score + positionScore(offset);
  }

  ///位置得分(越靠近中心得分越高)
  int positionScore(Offset offset){
    double z = -(math.pow(offset.dx - 7.5 ,2) + math.pow(offset.dy - 7.5 ,2)) + 112.5 ;
    z /= 10;
   return z.toInt();
  }

  bool isAlive2(List<Offset> list) {
    assert(list.length == 2);
    Offset offset1 = nextChessman(list[1], list[0]);
    Offset offset2 = nextChessman(list[0], list[1]);

    return isEffectivePosition(offset1) && isEffectivePosition(offset2) && isBlankPosition(offset1) && isBlankPosition(offset2);
  }

  bool isLowerDeath2(List<Offset> list) {
    assert(list.length == 2);
    Offset offset1 = nextChessman(list[1], list[0]);
    Offset offset2 = nextChessman(list[0], list[1]);
    return (isEffectivePosition(offset1) && isBlankPosition(offset1)) || (isEffectivePosition(offset2) && isBlankPosition(offset2));
  }

  bool isAlive3(List<Offset> list) {
    assert(list.length == 3);

    Offset offset1 = nextChessman(list[1], list[0]);
    Offset offset2 = nextChessman(list[1], list[2]);
    return (isEffectivePosition(offset1) && isBlankPosition(offset1)) && (isEffectivePosition(offset2) && isBlankPosition(offset2));
  }

  bool isLowerDeath3(List<Offset> list) {
    assert(list.length == 3);
    Offset offset1 = nextChessman(list[1], list[0]);
    Offset offset2 = nextChessman(list[1], list[2]);
    return (isEffectivePosition(offset1) && isBlankPosition(offset1)) || (isEffectivePosition(offset2) && isBlankPosition(offset2));

  }

  bool isAlive4(List<Offset> list) {
    assert(list.length == 4);
    Offset offset1 = nextChessman(list[1], list[0]);
    Offset offset2 = nextChessman(list[2], list[3]);
    return (isEffectivePosition(offset1) && isBlankPosition(offset1)) && (isEffectivePosition(offset2) && isBlankPosition(offset2));

  }

  bool isLowerDeath4(List<Offset> list) {
    assert(list.length == 4);
    Offset offset1 = nextChessman(list[1], list[0]);
    Offset offset2 = nextChessman(list[2], list[3]);
    return (isEffectivePosition(offset1) && isBlankPosition(offset1)) || (isEffectivePosition(offset2) && isBlankPosition(offset2));

  }

  int getJumpAlive2Count(List<Offset> list, game.Player player) {
    assert (list.length == 1);
    int count = 0;
    if (list.first.dx >= 3) { //棋盘边界
      Offset left = Offset(list.first.dx - 2, list.first.dy);
      count += existSpecificChessman(left, player)
          && isAllBlankPosition([Offset(list.first.dx + 1, list.first.dy),Offset(left.dx - 1, left.dy)])
          ? 1 : 0;
    }

    if (list.first.dx <= LINE_COUNT - 2) {
      Offset right = Offset(list.first.dx + 2, list.first.dy);
      count += existSpecificChessman(right, player)
          && isAllBlankPosition([Offset(list.first.dx - 1 ,list.first.dy),Offset(right.dx + 1,right.dy)])
          ? 1 : 0;
    }

    if(list.first.dy >= 3){
      Offset top = Offset(list.first.dx, list.first.dy - 2);
      count += existSpecificChessman(top, player)
          && isAllBlankPosition([Offset(list.first.dx ,list.first.dy +1),Offset(top.dx,top.dy -1)])
          ? 1 : 0 ;
    }

    if(list.first.dy <= LINE_COUNT -2){
      Offset bottom = Offset(list.first.dx, list.first.dy + 2);
      count += existSpecificChessman(bottom, player)
          && isAllBlankPosition([Offset(list.first.dx,list.first.dy -1) ,Offset(bottom.dx,bottom.dy+1)])
          ? 1 : 0 ;
    }

    if(list.first.dx >= 3 && list.first.dy >= 3){
      Offset leftTop = Offset(list.first.dx - 2, list.first.dy - 2);
      count += existSpecificChessman(leftTop, player)
          && isAllBlankPosition([Offset(list.first.dx +1,list.first.dy +1),Offset(leftTop.dx-1,leftTop.dy-1)])
          ? 1 : 0;
    }

    if(list.first.dx >= 3 && list.first.dy <= LINE_COUNT -2){
      Offset leftBottom = Offset(list.first.dx - 2, list.first.dy + 2);
      count += existSpecificChessman(leftBottom, player)
          && isAllBlankPosition([Offset(list.first.dx+1,list.first.dy-1),Offset(leftBottom.dx-1,leftBottom.dy+1)])
          ? 1 : 0;
    }

    if(list.first.dx <= LINE_COUNT -2 && list.first.dy >= 3){
      Offset rightTop = Offset(list.first.dx + 2, list.first.dy - 2);
      count += existSpecificChessman(rightTop, player)
          && isAllBlankPosition([Offset(list.first.dx -1 ,list.first.dy +1),Offset(rightTop.dx+1,rightTop.dy-1)])
          ? 1 : 0;
    }

    if(list.first.dx <= LINE_COUNT -2 && list.first.dy <= LINE_COUNT -2){
      Offset rightBottom = Offset(list.first.dx + 2, list.first.dy + 2);
      count += existSpecificChessman(rightBottom, player)
          && isAllBlankPosition([Offset(list.first.dx -1 ,list.first.dy -1),Offset(rightBottom.dx +1 ,rightBottom.dy+1)])
          ? 1 : 0;
    }
    return count;

  }

  int getJumpAlive3Count(List<Offset> list ,game.Player player){
    assert (list.length == 1 || list.length == 2);
    int count = 0;
    if(list.length == 1){//1跳2 活3
      /// leftBlank left2 left1 blank list.first rightBlank
      if (list.first.dx >= 4) { //棋盘边界
        Offset left1 = Offset(list.first.dx - 2, list.first.dy);
        Offset left2 = Offset(left1.dx - 1, list.first.dy);
        Offset blank = Offset(list.first.dx -1 , list.first.dy);
        Offset leftBlank = Offset(left2.dx - 1, list.first.dy);
        Offset rightBlank = Offset(list.first.dx  + 1, list.first.dy);

        count += existSpecificChessmanAll([left1,left2], player) && isAllBlankPosition([blank,leftBlank,rightBlank]) ? 1 : 0 ;
      }

      ///leftBlank list.first  blank right1  right2 rightBlank
      if(list.first.dx <= LINE_COUNT - 4){
        Offset leftBlank = Offset(list.first.dx -1, list.first.dy);
        Offset blank = Offset(list.first.dx +1, list.first.dy);
        Offset right1 = Offset(blank.dx +1, blank.dy);
        Offset right2 = Offset(right1.dx +1, blank.dy);
        Offset rightBlank = Offset(right2.dx +1, blank.dy);
        count += existSpecificChessmanAll([right1,right2], player) && isAllBlankPosition([leftBlank,blank,rightBlank]) ? 1 : 0 ;
      }

      /// topBlank
      /// top2
      /// top1
      /// blank
      /// list.first
      /// bottomBlank

      if(list.first.dy >= 4){
        Offset blank = Offset(list.first.dx, list.first.dy - 1);
        Offset top1 = Offset(list.first.dx, blank.dy - 1);
        Offset top2 = Offset(list.first.dx, top1.dy - 1);
        Offset topBlank = Offset(list.first.dx, top2.dy - 1);
        Offset bottomBlank = Offset(list.first.dx, list.first.dy + 1);
        count += existSpecificChessmanAll([top1,top2], player) && isAllBlankPosition([topBlank,blank,bottomBlank]) ? 1 : 0 ;
      }

      /// topBlank
      /// list.first
      /// blank
      /// top1
      /// top2
      /// bottomBlank
      if(list.first.dy <= LINE_COUNT - 4){
        Offset topBlank = Offset(list.first.dx, list.first.dy - 1);
        Offset blank = Offset(list.first.dx, list.first.dy + 1);
        Offset top1 = Offset(list.first.dx, blank.dy + 1);
        Offset top2 = Offset(list.first.dx, top1.dy + 1);
        Offset bottomBlank = Offset(list.first.dx, top2.dy + 1);
        count += existSpecificChessmanAll([top1,top2], player) && isAllBlankPosition([topBlank,blank,bottomBlank]) ? 1 : 0;
      }

      ///左上
      /// |leftTopBlank
      /// |          leftTop2
      /// |                   leftTop1
      /// |                           blank
      /// |                                 list.first
      /// |                                          rightBottomBlank
      if(list.first.dx >= 4 && list.first.dy >= 4){
        Offset rightBottomBlank = Offset(list.first.dx +1, list.first.dy +1);
        Offset blank = Offset(list.first.dx - 1, list.first.dy  - 1);
        Offset leftTop1 = Offset(blank.dx  - 1, blank.dy - 1);
        Offset leftTop2= Offset(leftTop1.dx  - 1, leftTop1.dy - 1);
        Offset leftTopBlank= Offset(leftTop2.dx  - 1, leftTop2.dy - 1);
        count += existSpecificChessmanAll([leftTop1,leftTop2], player) && isAllBlankPosition([rightBottomBlank,blank,leftTopBlank]) ? 1 : 0 ;
      }

      ///左下
      ///  |                                                 rightTopBlank
      ///  |                                       list.first
      ///  |                                   blank
      ///  |                        leftBottom1
      ///  |            leftBottom2
      ///  |leftBottomBlank
      if(list.first.dx >= 4 && list.first.dy <= LINE_COUNT - 4){
        Offset rightTopBlank = Offset(list.first.dx + 1, list.first.dy -1);
        Offset blank = Offset(list.first.dx -1, list.first.dy + 1);
        Offset leftBottom1 = Offset(blank.dx -1, blank.dy + 1);
        Offset leftBottom2 = Offset(leftBottom1.dx -1, leftBottom1.dy + 1);
        Offset leftBottomBlank = Offset(leftBottom2.dx -1, leftBottom2.dy + 1);
        count += existSpecificChessmanAll([leftBottom1,leftBottom2], player) && isAllBlankPosition([rightTopBlank,blank,leftBottomBlank]) ? 1 : 0 ;
      }

      ///右上
      ///                                             rightTopBlank|
      ///                                     rightTop2            |
      ///                             rightTop1                    |
      ///                         blank                            |
      ///               list.first                                 |
      /// leftBottomBlank                                          |
      if(list.first.dx <= LINE_COUNT - 4 && list.first.dy >= 4){
        Offset leftBottomBlank = Offset(list.first.dx -1, list.first.dy + 1);
        Offset blank = Offset(list.first.dx + 1, list.first.dy - 1);
        Offset rightTop1 = Offset(blank.dx -1, blank.dy + 1);
        Offset rightTop2 = Offset(rightTop1.dx -1, rightTop1.dy + 1);
        Offset rightTopBlank = Offset(rightTop2.dx -1, rightTop2.dy + 1);
        count += existSpecificChessmanAll([rightTop1,rightTop2], player) && isAllBlankPosition([leftBottomBlank,blank,rightTopBlank]) ? 1 : 0;
      }

      ///右下
      /// leftTopBlank                                       |
      ///             list.first                             |
      ///                       blank                        |
      ///                          leftTop1                  |
      ///                                 leftTop2           |
      ///                                        rightBottom |
      ///
      if(list.first.dx <= LINE_COUNT - 4 && list.first.dy <= LINE_COUNT - 4){
        Offset leftTopBlank = Offset(list.first.dx -1 , list.first.dy -1);
        Offset blank = Offset(list.first.dx + 1, list.first.dy + 1);
        Offset leftTop1 = Offset(blank.dx + 1, blank.dy + 1);
        Offset leftTop2 = Offset(leftTop1.dx + 1, leftTop1.dy + 1);
        Offset rightBottom = Offset(leftTop2.dx + 1, leftTop2.dy + 1);
        count += existSpecificChessmanAll([leftTop1,leftTop2], player) && isAllBlankPosition([leftTopBlank,blank,rightBottom]) ? 1 : 0 ;
      }

    }else if(list.length == 2){ //2跳1 活3
      /// next1Next1Blank next1 next1blank list[0] list[1] next2Blank next2 next2Next2Blank
      Offset next1blank = nextChessman(list[1], list[0]);
      Offset next1 = nextChessman(list[0], next1blank);
      Offset next1Next1Blank = nextChessman(next1blank, next1);
      Offset next2Blank = nextChessman(list[0], list[1]);
      Offset next2 = nextChessman(list[1], next2Blank);
      Offset next2Next2Blank = nextChessman(next2Blank, next2);

      count += existSpecificChessman(next1, player) && isAllBlankPosition([next1Next1Blank,next1blank,next2Blank]) ? 1 : 0 ;
      count += existSpecificChessman(next2,player) && isAllBlankPosition([next1blank,next2Blank,next2Next2Blank]) ? 1 : 0 ;
    }
    return count;
  }

  int getJumpAlive4Count(List<Offset> list ,game.Player player){
    assert(list.length > 0 && list.length < 4);
    int count = 0 ;

    if(list.length == 1){

      ///左
      ///leftBlank left3 left2 left1 blank list.first rightBlank
      if(list.first.dx >= 5){
        Offset rightBlank = Offset(list.first.dx + 1, list.first.dy);
        Offset blank = Offset(list.first.dx - 1, list.first.dy);
        Offset left1 = Offset(blank.dx - 1, list.first.dy);
        Offset left2 = Offset(left1.dx - 1, list.first.dy);
        Offset left3 = Offset(left2.dx - 1, list.first.dy);
        Offset leftBlank = Offset(left3.dx - 1, list.first.dy);
        count += existSpecificChessmanAll([left1,left2,left3], player) && isAllBlankPosition([rightBlank,blank,leftBlank]) ? 1: 0 ;
      }

      ///右
      ///leftBlank list.first blank right1 right2 right3 rightBlank
      if(list.first.dx <= LINE_COUNT - 5){
        Offset leftBlank = Offset(list.first.dx -1, list.first.dy);
        Offset blank = Offset(list.first.dx + 1, list.first.dy);
        Offset right1 = Offset(blank.dx + 1, blank.dy);
        Offset right2 = Offset(right1.dx + 1, blank.dy);
        Offset right3 = Offset(right2.dx + 1, blank.dy);
        Offset rightBlank = Offset(right3.dx + 1, blank.dy);
        count += existSpecificChessmanAll([right1,right2,right3], player) && isAllBlankPosition([leftBlank,blank,rightBlank]) ? 1 : 0;
      }

      ///上
      /// topBlank
      /// top3
      /// top2
      /// top1
      /// blank
      /// list.first
      /// bottomBlank
      if(list.first.dy >= 5){
        Offset bottomBlank = Offset(list.first.dx, list.first.dy+1);
        Offset blank = Offset(list.first.dx, list.first.dy - 1);
        Offset top1 = Offset(blank.dx, blank.dy - 1);
        Offset top2 = Offset(top1.dx, blank.dy - 1);
        Offset top3 = Offset(top2.dx, blank.dy - 1);
        Offset topBlank = Offset(top3.dx, blank.dy - 1);
        count += existSpecificChessmanAll([top1,top2,top3], player) && isAllBlankPosition([bottomBlank,blank,topBlank]) ? 1 :0 ;
      }

      /// 下
      /// topBlank
      /// list.first
      /// blank
      /// bottom1
      /// bottom2
      /// bottom3
      /// bottomBlank
      if(list.first.dy <= LINE_COUNT -5){
        Offset topBlank = Offset(list.first.dx, list.first.dy - 1);
        Offset blank = Offset(list.first.dx, list.first.dy + 1);
        Offset bottom1 = Offset(blank.dx, blank.dy + 1);
        Offset bottom2 = Offset(bottom1.dx, bottom1.dy + 1);
        Offset bottom3 = Offset(bottom2.dx, bottom2.dy + 1);
        Offset bottomBlank = Offset(bottom3.dx, bottom3.dy + 1);
        count += existSpecificChessmanAll([bottom1,bottom2,bottom3], player) && isAllBlankPosition([topBlank,blank,bottomBlank]) ? 1 : 0 ;
      }

      /// 左上
      /// leftTopBlank
      ///             leftTop3
      ///                    leftTop2
      ///                          leftTop1
      ///                                 blank
      ///                                     list.first
      ///                                             rightBottom

      if(list.first.dx >= 5 && list.first.dy >= 5){
        Offset rightBottom = Offset(list.first.dx + 1, list.first.dy + 1);
        Offset blank = Offset(list.first.dx - 1, list.first.dy - 1);
        Offset leftTop1 = Offset(blank.dx - 1, blank.dy - 1);
        Offset leftTop2 = Offset(leftTop1.dx - 1, leftTop1.dy - 1);
        Offset leftTop3 = Offset(leftTop2.dx - 1, leftTop2.dy - 1);
        Offset leftTopBlank = Offset(leftTop3.dx - 1, leftTop3.dy - 1);
        count += existSpecificChessmanAll([leftTop1,leftTop2,leftTop3], player) && isAllBlankPosition([rightBottom,blank,leftTopBlank]) ? 1 : 0 ;
      }


      ///左下
      ///                                                 rightTopBlank
      ///                                           list.first
      ///                                       blank
      ///                              leftBottom1
      ///                       leftBottom2
      ///               leftBottom3
      /// leftBottomBlank
      if(list.first.dx >= 5 && list.first.dy <= LINE_COUNT - 5){
        Offset rightTopBlank = Offset(list.first.dx + 1, list.first.dy -1);
        Offset blank = Offset(list.first.dx - 1, list.first.dy + 1);
        Offset leftBottom1 = Offset(blank.dx - 1, blank.dy + 1);
        Offset leftBottom2 = Offset(leftBottom1.dx - 1, leftBottom1.dy + 1);
        Offset leftBottom3 = Offset(leftBottom2.dx - 1, leftBottom2.dy + 1);
        Offset leftBottomBlank = Offset(leftBottom3.dx - 1, leftBottom3.dy + 1);
        count += existSpecificChessmanAll([leftBottom1,leftBottom2,leftBottom3], player) && isAllBlankPosition([rightTopBlank,blank,leftBottomBlank]) ? 1: 0;
      }


      /// 右上
      ///                                             rightTopBlank
      ///                                       rightTop3
      ///                                 rightTop2
      ///                         rightTop1
      ///                     blank
      ///             list.first
      /// leftBottomBlank
      if(list.first.dx <= LINE_COUNT - 5 && list.first.dy >= 5){
        Offset leftBottomBlank = Offset(list.first.dx -1 , list.first.dy + 1);
        Offset blank = Offset(list.first.dx  + 1 , list.first.dy - 1);
        Offset rightTop1 = Offset(blank.dx  + 1 , blank.dy - 1);
        Offset rightTop2 = Offset(rightTop1.dx  + 1 , rightTop1.dy - 1);
        Offset rightTop3 = Offset(rightTop2.dx  + 1 , rightTop2.dy - 1);
        Offset rightTopBlank = Offset(rightTop3.dx  + 1 , rightTop3.dy - 1);
        count += existSpecificChessmanAll([rightTop1,rightTop2,rightTop3], player) && isAllBlankPosition([leftBottomBlank,blank,rightTopBlank]) ? 1 : 0;
      }

      /// 右下
      /// leftTopBlank
      ///           list.first
      ///                    blank
      ///                        rightBottom1
      ///                               rightBottom2
      ///                                      rightBottom3
      ///                                            rightBottomBlank
      if(list.first.dx <= LINE_COUNT - 5 && list.first.dy <= LINE_COUNT - 5){
        Offset leftTopBlank = Offset(list.first.dx - 1 , list.first.dy - 1);
        Offset blank = Offset(list.first.dx + 1 , list.first.dy + 1);
        Offset rightBottom1 = Offset(blank.dx + 1 , blank.dy + 1);
        Offset rightBottom2 = Offset(rightBottom1.dx + 1 , rightBottom1.dy + 1);
        Offset rightBottom3 = Offset(rightBottom2.dx + 1 , rightBottom2.dy + 1);
        Offset rightBottomBlank = Offset(rightBottom3.dx + 1 , rightBottom3.dy + 1);
        count += existSpecificChessmanAll([rightBottom1,rightBottom2,rightBottom3], player) && isAllBlankPosition([leftTopBlank,blank,rightBottomBlank]) ? 1:0;
      }

    }else if(list.length == 2){
      /// next2Blank next2 next1 next1Blank list[0] list[1]  next3Blank next3 next4 next4Blank
      Offset next1Blank = nextChessman(list[1], list[0]);
      Offset next1 = nextChessman(list[0], next1Blank);
      Offset next2 = nextChessman(next1Blank, next1);
      Offset next2Blank = nextChessman(next1, next2);
      Offset next3Blank = nextChessman(list[0] , list[1]);
      Offset next3 = nextChessman(list[1], next3Blank);
      Offset next4 = nextChessman(next3Blank, next3);
      Offset next4Blank = nextChessman(next3, next4);

      count += existSpecificChessmanAll([next2,next1], player) && isAllBlankPosition([next2Blank ,next1Blank ,next3Blank]) ? 1 : 0;
      count += existSpecificChessmanAll([next3,next4], player) && isAllBlankPosition([next1Blank, next3Blank, next4Blank]) ? 1 : 0;

    }else if(list.length == 3){
      ///next1Next1Blank next1 next1Blank list[0] list[1] list[2] next2Blank next2 next2Next2Blank
      Offset next1Blank = nextChessman(list[1], list[0]);
      Offset next1 = nextChessman(list[0], next1Blank);
      Offset next1Next1Blank = nextChessman(next1Blank, next1);
      Offset next2Blank = nextChessman(list[1], list[2]);
      Offset next2 = nextChessman(list[2],next2Blank);
      Offset next2Next2Blank = nextChessman(next2Blank,next2);

      count += existSpecificChessman(next1, player) && isAllBlankPosition([next1Next1Blank,next1Blank,next2Blank]) ? 1 : 0;
      count += existSpecificChessman(next2, player) && isAllBlankPosition([next1Blank,next2Blank,next2Next2Blank]) ? 1 : 0 ;
    }
    return count ;
  }


  bool isJumpAlive3(List<Offset> list ,game.Player player){
    assert (list.length == 2);
    if(isAlive2(list)){
      Offset next1 = nextChessman(list[1], list[0]);
      Offset next2 = nextChessman(list[0], list[1]);

      Offset nextNext1 = nextChessman(list[0],next1);
      Offset nextNext2 = nextChessman(list[1],next2);

      return (isBlankPosition(nextNext1) && existSpecificChessman(nextNext2, player)) || (isBlankPosition(nextNext2) && existSpecificChessman(nextNext1, player));
    }

    return false;
  }




  bool existSpecificChessmanAll(List<Offset> positions, game.Player player) {
    if (positions == null || positions.isEmpty) {
      return false;
    }

    bool flag = true;
    for (Offset of in positions) {
      flag &= existSpecificChessman(of, player);
    }
    return flag;
  }

  ///判断某个位置上是否没有棋子
  bool isBlankPosition(Offset position) {
    if (chessmanList != null && chessmanList.isNotEmpty) {
      var cm = chessmanList.firstWhere((game.Chessman c) {
        return c.position.dx == position.dx && c.position.dy == position.dy;
      }, orElse: () {
        return null;
      });
      return cm == null;
    }
    return true;
  }

  bool isAllBlankPosition(List<Offset> list){
    for(Offset o in list){
      if(!isBlankPosition(o)){
        return false;
      }
    }
    return true;
  }

}
