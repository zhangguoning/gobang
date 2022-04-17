import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gobang/util/buffer_container.dart';
import 'package:gobang/util/util.dart';
import 'package:gobang/widget/checker_board.dart' hide chessmanList;
import 'dart:math' as math;

import 'ai.dart';

enum ChildType{
  /// 标记当前节点为对手节点，会选择使我方得分最小的走势
  MIN,
  /// 标记当前节点为我方节点，会选择使我方得分最大的走势
  MAX
}
class ChessNode{
  /// 当前节点的棋子
  Chessman current;
  /// 当前节点的父节点
  ChessNode parentNode;
  /// 当前节点的所有子节点
  List<ChessNode> childrenNode = [];
  /// 当前节点的值
  num value = double.nan;
  /// 当前节点的类型(我方/敌方)
  ChildType type;
  /// 当前节点值的上限
  num maxValue;
  /// 当前节点值的下限
  num minValue;
  /// 当前节点的层深度
  int depth = 0;
  /// 用于根节点记录选择的根下子节点
  Chessman checked;
}

class AB_AI extends AI {
  int maxDepth = 3;
  List<Chessman> tempChessList ;
  Player our ,enemy;

  AB_AI(Player computerPlayer) : super(computerPlayer){
    our = computerPlayer;
    enemy = our == Player.BLACK ? Player.WHITE : Player.BLACK;
  }

  int count = 0;

  Future<Offset> nextByAI({bool isPrintMsg = false}) async {
    Offset pos = urgent();
    if(pos!=null){
      return pos;
    }

    count = 0;
    DateTime start = DateTime.now();
    ChessNode root =  createGameTree();
    DateTime create = DateTime.now();
    print('创建博弈树耗时：${create.millisecondsSinceEpoch - start.millisecondsSinceEpoch}');
    // maxMinSearch(root);
    DateTime maxMinSearch = DateTime.now();
    print('MaxMin搜索耗时：${maxMinSearch.millisecondsSinceEpoch - create.millisecondsSinceEpoch}');
    alphaBetaSearch(root);
    DateTime search = DateTime.now();
    print('Alpha-Beta搜索耗时：${search.millisecondsSinceEpoch - maxMinSearch.millisecondsSinceEpoch}');


    print("查找次数: $count");
    return root.checked.position;
  }


  /// alpha-beta 剪枝算法
  num alphaBetaSearch(ChessNode current){
    count++;
    if(current.childrenNode.isEmpty){
      return current.value;
    }

    //该枝已被剪掉
    if(current.parentNode!=null && !current.parentNode.childrenNode.contains(current)){
      ChessNode parent = current.parentNode;
      return parent.type == ChildType.MAX ? parent.minValue : parent.maxValue;
    }

    List<ChessNode> children = current.childrenNode;
    if(current.type == ChildType.MIN){
      num parentMin = current.parentNode?.minValue ?? double.negativeInfinity;
      int index = 0;
      for (ChessNode node in children) {
        index ++;
        //当前节点node的父节点(current)为MIN节点，也就是取所有子节点值中最小的值，
        //换句话说：这个节点(node)产生的最大值不会高于所有子节点中的最小值，因此取两者间的最小值
        num newCurrentMax = math.min(current.maxValue, alphaBetaSearch(node));//K

        //current节点的值不能比current.parentNode的最小值还小，
        //若不符合这个条件则current节点没有继续搜索下去的必要
        //alpha剪枝
        if (newCurrentMax <= parentMin) { //V->J
          current.childrenNode = current.childrenNode.sublist(0, index);
          return parentMin;
        }

        //因为当前节点为MIN节点，如果发现一个比当前最大值还小的值，则更新当前节点的最大值为这个新值
        if (newCurrentMax < current.maxValue) {//A1->K
          current.maxValue = newCurrentMax;
          current.value = node.value;
          current.checked = node.current;
        }
      }
      //当遍历完成当前节点后，如果发现父节点的最小值小于当前节点的最大值，则更新父节点的最小值
      if(current.maxValue > parentMin){//K->E
        current.parentNode?.minValue = current.maxValue;
        current.parentNode?.value = current.value;
        current.parentNode?.checked = current.current;
      }
      return current.maxValue;
    }else{//beta(MAX节点)
      num parentMax = current.parentNode?.maxValue ?? double.infinity;
      int index = 0;
      for(ChessNode node in children) {
       index ++;
       //当前节点(node)的父节点(current)为MAX节点，也就是取所有子节点中最大的值
       //换句话说：这个父节点(current)所产生的最小值不会低于所有子节点中的最大值，因此取两者间的最大值
       num newCurrentMin = math.max(current.minValue, alphaBetaSearch(node));

       //current节点的父节点为MIN节点，如果current节点值的下界(current.minValue)比父节点(current.parentNode)的值的上界还大的话，
       //则父节点(current.parentNode)不会取当前节点current路径，故无需在搜索
       //beta剪枝
       if(parentMax < newCurrentMin){//M->G
         current.childrenNode = current.childrenNode.sublist(0,index);
         return parentMax;
       }

       //因为当前节点为MAX节点，如果发现一个比当前最小值还大的新值，则更新当前节点的最小值为这个新值
       if(newCurrentMin > current.minValue){
         current.minValue = newCurrentMin;
         current.value = node.value;
         current.checked = node.current;
       }
      }
      //当遍历完成当前节点后，如果发现当前节点的最小值比父节点的最大值还小的话，则更新父节点的最大值
      if(current.minValue < parentMax){//D->B
        current.parentNode?.maxValue = current.minValue;
        current.parentNode?.value = current.value;
        current.parentNode?.checked = current.current;
      }
      return current.minValue;
    }
  }

  /// 极大值极小值算法
  num maxMinSearch(ChessNode root){
    if(root.childrenNode.isEmpty){
      return root.value;
    }
    List<ChessNode> children = root.childrenNode;
    if(root.type == ChildType.MIN){
      for(ChessNode node in children){
        if(maxMinSearch(node) < root.maxValue){
          //当前节点的父节点为MIN节点，也就是取所有子节点值中最小的值，
          //换句话说：这个父节点产生的最大值不会高于所有子节点中的最小值，因此更新父节点的maxValue
          root.maxValue = node.value;
          root.value = node.value;
          root.checked = node.current;
        }else{
          // 当前节点的值大于了父节点的最大值，由于父节点是MIN节点，因此不会取该值
          // 换句话说：当前为对手回合，对手已经有了一个可以让我方收益更低的选择，因此对手不会考虑一个比让我们当前收益更高的选择
          continue;
        }
      }
    }else{//beta
      for(ChessNode node in children){
        if(maxMinSearch(node) > root.minValue){
          // 当前节点的父节点为MAX节点，也就是取所有子节点中最大的值
          // 换句话说：这个父节点所产生的最小值不会低于所有子节点中的最大值，因此更新父节点的minValue
          root.minValue = node.value;
          root.value = node.value;
          root.checked = node.current;
        }else{
          // 当前节点的值小于父节点的最小值，由于父节点值MAX节点，因此不会取该值
          // 换句话说：当前为自己回合，已经有了一个可以使我方收益更高的选择，那么就不会再考虑比这个收益更低的选择了
          continue;
        }
      }
    }
    return root.value;
  }



  ChessNode createGameTree(){
    ChessNode root = ChessNode()
      ..depth = 0
      ..value = double.nan
      ..type = ChildType.MAX
      ..minValue = double.negativeInfinity
      ..maxValue = double.infinity;

    Player currentPlayer;
    if(chessmanList.isEmpty){
      currentPlayer = Player.BLACK;
    }else{
      currentPlayer = chessmanList.last.owner == Player.BLACK ? Player.WHITE : Player.BLACK;
    }


    // BufferChessmanList ourPosList = ourBestPosition();
    BufferChessmanList enemyPosList = enemyBestPosition(chessmanList,maxCount: 5);

    OffsetList list = OffsetList()
      // ..addAll(ourPosList.toList())
      ..addAll(enemyPosList.toList());
    List<Offset> result =  list.toList();

    int index = 0 ;
    for(Offset position in result){
      Chessman chessman = Chessman(position, currentPlayer);

      ChessNode node = new ChessNode()
        ..parentNode = root
        ..depth = root.depth + 1
        ..maxValue = root.maxValue
        ..minValue = root.minValue
        ..type = ChildType.MIN
        ..current = chessman;

      root.childrenNode.add(node);
      var start = DateTime.now();
      createChildren(node);
      var create = DateTime.now();

      log('创建第一层第$index个节点耗时：${create.millisecondsSinceEpoch - start.millisecondsSinceEpoch}');
      index++;
    }
    return root;
  }

  /// 生成博弈树子节点
  createChildren(ChessNode parent){
    if(parent == null){
      return null;
    }
    if(parent.depth > maxDepth){
      List<Chessman> list = createTempChessmanList(parent);
      var start = DateTime.now();
      parent.value = statusScore(our,list);
      var value = DateTime.now();
      log('棋局估值耗时：${value.millisecondsSinceEpoch - start.millisecondsSinceEpoch}');

      return ;
    }
    Player currentPlayer = parent.current.owner == Player.BLACK ? Player.WHITE : Player.BLACK;
    ChildType type = parent.type == ChildType.MAX ? ChildType.MIN : ChildType.MAX;
    var list = createTempChessmanList(parent);

    var start = DateTime.now();
    // BufferChessmanList ourPosList = ourBestPosition();
    BufferChessmanList enemyPosList = enemyBestPosition(list,maxCount: 5);
    var value = DateTime.now();

    log('查找高分落子位置耗时：${value.millisecondsSinceEpoch - start.millisecondsSinceEpoch}');


    OffsetList offsetList = OffsetList()
      // ..addAll(ourPosList.toList())
      ..addAll(enemyPosList.toList());
    List<Offset> result =  offsetList.toList();

    for(Offset position in result){
      Chessman chessman = Chessman(position, currentPlayer);

      ChessNode node = ChessNode()
        ..parentNode = parent
        ..current = chessman
        ..type = type
        ..depth = parent.depth + 1
        ..maxValue = parent.maxValue
        ..minValue = parent.minValue ;

      parent.childrenNode.add(node);
      createChildren(node);
    }
  }

  /// 生成临时棋局
  List<Chessman> createTempChessmanList(ChessNode node){
    List<Chessman> temp = List.from(chessmanList,growable: true);
    temp.add(node.current);

    ChessNode current = node.parentNode;
    while(current!=null && current.current !=null){
      temp.add(current.current);
      current = current.parentNode;
    }
    return temp;
  }

  /// 局势评估
  int situationValuation(Player player, List<Chessman> chessmanList){
    int result = 0 ;
    for(Chessman c in chessmanList){
      if(c.owner == player){
        result += chessmanGrade(c.position,ownerPlayer: player);
      }else{
        result -= chessmanGrade(c.position,ownerPlayer: player == Player.BLACK ? Player.WHITE : Player.BLACK);
      }

    }
    return result;
  }

  int statusScore(Player player, List<Chessman> chessmanList){
    int score = 0;
    for(Chessman c in chessmanList){
      score+= chessmanScore(c,chessmanList);
    }
    return score;
  }

  ///对棋局中的某个棋子打分
  int chessmanScore(Chessman chessman , List<Chessman> chessmanList){
    Offset current = chessman.position;
    List<Offset> score4 = List.empty(growable: true);
    List<Offset> score3 = List.empty(growable: true);

    //0°
    Offset right = Offset(current.dx + 1, current.dy);
    Offset right2 = Offset(current.dx + 2, current.dy);
    if(isEffectivePosition(right)){
      score4.add(right);
    }
    if(isEffectivePosition(right2)){
      score3.add(right2);
    }

    //45°方向
    Offset rightTop = Offset(current.dx + 1, current.dy - 1);
    Offset rightTop2 = Offset(current.dx + 2, current.dy - 2);
    if(isEffectivePosition(rightTop)){
      score4.add(rightTop);
    }
    if(isEffectivePosition(rightTop2)){
      score3.add(rightTop2);
    }


    //90°方向
    Offset centerTop = Offset(current.dx, current.dy - 1);
    Offset centerTop2 = Offset(current.dx, current.dy - 2);
    if(isEffectivePosition(centerTop)){
      score4.add(centerTop);
    }
    if(isEffectivePosition(centerTop2)){
      score3.add(centerTop2);
    }


    //135°
    Offset leftTop = Offset(current.dx - 1, current.dy - 1);
    Offset leftTop2 = Offset(current.dx - 2, current.dy - 2);
    if(isEffectivePosition(leftTop)){
      score4.add(leftTop);
    }
    if(isEffectivePosition(leftTop2)){
      score3.add(leftTop2);
    }


    //180°
    Offset left = Offset(current.dx - 1, current.dy );
    Offset left2 = Offset(current.dx - 2, current.dy);
    if(isEffectivePosition(left)){
      score4.add(left);
    }
    if(isEffectivePosition(left2)){
      score3.add(left2);
    }

    //225°
    Offset leftBottom = Offset(current.dx - 1, current.dy + 1);
    Offset leftBottom2 = Offset(current.dx - 2, current.dy + 2);
    if(isEffectivePosition(leftBottom)){
      score4.add(leftBottom);
    }
    if(isEffectivePosition(leftBottom2)){
      score3.add(leftBottom2);
    }

    //270°
    Offset bottom = Offset(current.dx, current.dy + 1);
    Offset bottom2 = Offset(current.dx, current.dy + 2);
    if(isEffectivePosition(bottom)){
      score4.add(bottom);
    }
    if(isEffectivePosition(bottom2)){
      score3.add(bottom2);
    }

    //315°
    Offset rightBottom = Offset(current.dx + 1, current.dy + 1);
    Offset rightBottom2 = Offset(current.dx + 1, current.dy + 2);
    if(isEffectivePosition(rightBottom)){
      score4.add(rightBottom);
    }
    if(isEffectivePosition(rightBottom2)){
      score3.add(rightBottom2);
    }

    int result = 0;
    for(Offset offset in score4){//chessman
      Player owner = getChessmanOwnerByPosition(offset,chessmanList);
      if(owner == null){
        //是个空位置
      }else if(owner == chessman.owner){
        //是自己的棋子
        result += 4;
      }else{
        //是对方的棋子
        result -= 4;
      }
    }

    for(Offset offset in score3){
      Player owner = getChessmanOwnerByPosition(offset,chessmanList);
      if(owner == null){
        //是个空位置
      }else if(owner == chessman.owner){
        //是自己的棋子
        result += 3;
      }else{
        //是对方的棋子
        result -= 3;
      }
    }
    return result;
  }

  BufferChessmanList ourBestPosition(List<Chessman> chessmanList,{maxCount = 5}){
    return highScorePosition(our,chessmanList);
  }

  BufferChessmanList highScorePosition(Player player , List<Chessman> currentChessmanList ,{maxCount = 5}){//高分
    BufferChessmanList list = BufferChessmanList.maxCount(maxCount: maxCount);
    for(int x = 0 ; x <= LINE_COUNT ; x++){
      for(int y = 0; y <= LINE_COUNT ; y++){
        Offset pos = Offset(x.toDouble(), y.toDouble());
        if(isBlankPosition(pos,chessmanList: currentChessmanList)){
          Chessman chessman = Chessman(pos, player);
          int chessScore = chessmanScore(chessman,currentChessmanList);
          int posScore = positionScore(pos);
          int score =  chessScore + posScore;
          if(list.minScore() < score){
            list.add(Chessman(pos,player)..score = score);
          }

        }
      }
    }
    return list;
  }

  BufferChessmanList  enemyBestPosition(List<Chessman> chessmanList,{maxCount = 5}){
    return highScorePosition(enemy,chessmanList);
  }

  bool isBlankPosition(Offset position, {List<Chessman> chessmanList}){
    if(!isEffectivePosition(position)){
      return false;
    }
    chessmanList ??= this.chessmanList;
    if(chessmanList.isEmpty){
      return true;
    }
    for(Chessman chessman in chessmanList){
      if(chessman.position.dx == position.dx && chessman.position.dy == position.dy){
        return false;
      }
    }
    return true;
  }


  bool isEffectivePosition(Offset pos){
    return pos.dx >= 0 && pos.dx <= LINE_COUNT && pos.dy >=0 && pos.dy <= LINE_COUNT;
  }

  Player getChessmanOwnerByPosition(Offset position, List<Chessman> chessmanList){
    for(Chessman c in chessmanList){
      if(c.position.dx == position.dx && c.position.dy == position.dy){
        return c.owner;
      }
    }
    return null;
  }


}
