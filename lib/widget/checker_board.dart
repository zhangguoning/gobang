import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gobang/page/pve/ab_ai.dart';
import 'package:gobang/page/pve/ai.dart';
const int LINE_COUNT = 14;
class Checkerboard extends StatefulWidget {
  Checkerboard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CheckerboardState();
  }

  void clear() {
    continueByAI = false;
    chessmanList?.clear();
    winResult?.clear();
  }
}

class _CheckerboardState extends State<Checkerboard> {
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Center(
      child: GestureDetector(
        child: CustomPaint(
          painter: CBPaint(),
          size: Size(400, 400),
        ),
        onTapDown: (details) {
          onTapDown(details);
          setState(() {});
        },
      ),
    );
  }
}
BuildContext _context ;
Player firstPlayer = Player.BLACK;
List<Chessman> chessmanList = [];
List<Chessman> winResult = [];
double ceilWidth, ceilHeight;

bool addToChessmanList(Chessman chessman) {
  if (chessmanList != null && chessmanList.isNotEmpty) {
    var cm = chessmanList.firstWhere((Chessman c) {
      return c.position.dx == chessman.position.dx &&
          c.position.dy == chessman.position.dy;
    }, orElse: () {
      chessmanList.add(chessman);
      return null;
    });
    return cm == null;
  } else {
    chessmanList.add(chessman);
    return true;
  }
}

bool existChessman(Offset position) {
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

bool existSpecificChessman(Offset position, Player player) {
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

bool existBlackChessman(Offset position) {
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

bool existWhiteChessman(Offset position) {
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

void onTapDown(TapDownDetails details) {
  if (winResult != null && winResult.isNotEmpty) {
    return;
  }

  double clickX = details.localPosition.dx;
  int floorX = clickX ~/ ceilWidth;
  double offsetFloorX = floorX * ceilWidth + ceilWidth / 2;
  int x = offsetFloorX > clickX ? floorX : ++floorX;

  double clickY = details.localPosition.dy;
  int floorY = clickY ~/ ceilHeight;
  double offsetFloorY = floorY * ceilHeight + ceilHeight / 2;
  int y = offsetFloorY > clickY ? floorY : ++floorY;

  ///落子
  fallChessman(Offset(x.toDouble(),y.toDouble()));
}

AB_AI ai = AB_AI(Player.WHITE);
int  computeChessmanValue(int x , int y , bool isPlayer){
  return isPlayer ? ai.chessmanGrade(Offset(x.toDouble(), y.toDouble()), ownerPlayer: Player.BLACK) : ai.chessmanGrade(Offset(x.toDouble(), y.toDouble()));
}

void fallChessman(Offset position,{bool isPlayer}){
  if(winResult.isNotEmpty){
    continueByAI = false;
    return ;
  }
  Chessman newChessman;
  if (chessmanList == null ||
      chessmanList.isEmpty ||
      chessmanList.length % 2 == 0) {
    newChessman = firstPlayer == Player.BLACK
        ? Chessman.black(position)
        : Chessman.white(position);
  } else {
    newChessman = firstPlayer == Player.BLACK
        ? Chessman.white(position)
        : Chessman.black(position);
  }

  bool can = addToChessmanList(newChessman);
  if(can){
    printFallChessmanInfo(newChessman);
    int score = ai.chessmanGrade(newChessman.position);
    int enemy = ai.chessmanGrade(newChessman.position,ownerPlayer : Player.BLACK);
    print("[${newChessman.owner == Player.WHITE ? "电脑" : "玩家"}落子(${newChessman.owner == Player.WHITE ? "白方" : "黑方"})] 该子价值评估: 己方-$score, 敌方-$enemy");

    print("\n");

    bool result = checkResult(newChessman);
    if(!result && !isHaveAvailablePosition()){
      print("和棋!");
      return ;
    }
    if(!result && newChessman.owner!=Player.WHITE ){
      Future.delayed(Duration(milliseconds: 20),(){
       Future<Offset> position = ai.nextByAI();
       position.then((position){
         fallChessman(position);
         RefreshNotification().dispatch(_context);
         if(continueByAI){
           trusteeship();
         }
       });
      });
    }
  }else{
    print("不能在此处落子!");
  }
}

bool continueByAI = false;

void trusteeship(){
  Future.delayed(Duration(milliseconds: 20),(){
    Future<Offset> position =  AI(Player.BLACK).nextByAI();
    position.then((position){
      fallChessman(position);
      RefreshNotification().dispatch(_context);

    });
  });
}

bool isHaveAvailablePosition(){
  return chessmanList.length <= 255 ;
}

void printFallChessmanInfo(Chessman newChessman){
  print("[落子成功], 棋子序号:${newChessman.numberId} ,颜色:${newChessman.owner == Player.WHITE ? "白色" : "黑色"} , 位置 :(${newChessman.position.dx.toInt()} , ${newChessman.position.dy.toInt()})");

}


bool checkResult(Chessman newChessman) {

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
    if (existSpecificChessman(position, newChessman.owner)) {
      winResult.add(Chessman(position, newChessman.owner));
      count++;
    } else {
      winResult.clear();
      count = 0;
    }
    if (count >= 5) {
      print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
      return true;
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
    if (existSpecificChessman(position, newChessman.owner)) {
      winResult.add(Chessman(position, newChessman.owner));
      count++;
    } else {
      winResult.clear();
      count = 0;
    }
    if (count >= 5) {
      print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
      return true;
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
    if (existSpecificChessman(position, newChessman.owner)) {
      winResult.add(Chessman(position, newChessman.owner));
      count++;
    } else {
      winResult.clear();
      count = 0;
    }
    if (count >= 5) {
      print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
      return true;
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
    if (existSpecificChessman(position, newChessman.owner)) {
      winResult.add(Chessman(position, newChessman.owner));
      count++;
    } else {
      winResult.clear();
      count = 0;
    }
    if (count >= 5) {
      print("胜利者产生: ${newChessman.owner == Player.WHITE ? "白色" : "黑色"}");
      return true;
    }
  }
  winResult.clear();
  return false;
}

class CBPaint extends CustomPainter {
  Canvas canvas;
  Paint painter;
  static const bool IS_DEBUG = true;

  @override
  void paint(Canvas canvas, Size size) {
    this.canvas = canvas;
    ceilWidth = size.width / LINE_COUNT;
    ceilHeight = size.height / LINE_COUNT;

    painter = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.fill
      ..color = Color(0x77cdb175);
    canvas.drawRect(Offset.zero & size, painter);

    painter
      ..style = PaintingStyle.stroke
      ..color = Colors.black87
      ..strokeWidth = 1.0;

    for (int i = 0; i <= LINE_COUNT; ++i) {
      double dy = ceilHeight * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), painter);
      if(IS_DEBUG){
        _drawText((i.toString()),Offset(-19, dy - _calcTrueTextSize(i.toString(),15.0).dy / 2));
      }
    }

    for (int i = 0; i <= LINE_COUNT; ++i) {
      double dx = ceilWidth * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), painter);
      if(IS_DEBUG){
        // _drawText(i.toString(),Offset(dx - _calcTrueTextSize(i.toString(),15.0).dx /2, -18));
       _drawText((String.fromCharCode(i + 65)),Offset(dx - _calcTrueTextSize(String.fromCharCode(i + 65),15.0).dx /2, -18));
      }
    }
    _drawMarkPoints();

    if (chessmanList != null && chessmanList.isNotEmpty) {
      for (Chessman c in chessmanList) {
        _drawChessman(c);
      }
    }

    if (winResult != null && winResult.isNotEmpty) {
      painter
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      Offset start = Offset(winResult.first.position.dx * ceilWidth,
          winResult.first.position.dy * ceilHeight);
      Offset end = Offset(winResult.last.position.dx * ceilWidth,
          winResult.last.position.dy * ceilHeight);
      canvas.drawLine(start, end, painter);
    }

  }
  void _drawMarkPoints(){
    _drawMarkPoint(Offset(7.0, 7.0));
    _drawMarkPoint(Offset(3.0, 3.0));
    _drawMarkPoint(Offset(3.0, 11.0));
    _drawMarkPoint(Offset(11.0, 3.0));
    _drawMarkPoint(Offset(11.0, 11.0));
  }

  void _drawMarkPoint(Offset offset){
    painter
      ..style = PaintingStyle.fill
      ..color = Colors.black;
    Offset center = Offset(offset.dx * ceilWidth, offset.dy * ceilHeight);
    canvas.drawCircle(center,3, painter);
  }


  void _drawChessman(Chessman chessman) {
    painter
      ..style = PaintingStyle.fill
      ..color = chessman.owner.color;

    Offset center = Offset(chessman.position.dx * ceilWidth, chessman.position.dy * ceilHeight);
    canvas.drawCircle(center,
        min(ceilWidth / 2, ceilHeight / 2) - 2, painter);

    if(chessman.numberId == chessmanList.length - 1){
      painter
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(center,min(ceilWidth / 2, ceilHeight / 2) - 2, painter);
    }

    if(IS_DEBUG){
      double fontSize = 12.0;
      Offset textSize = _calcTrueTextSize(chessman.numberId.toString(),fontSize);
      _drawText(chessman.numberId.toString(),
          Offset(center.dx - (textSize.dx / 2), center.dy-(textSize.dy / 2)),
          color: chessman.owner==Player.BLACK?Colors.white:Colors.black,
        textSize: fontSize

      );
    }

  }

  Offset _calcTrueTextSize(String text ,double textSize) {
    var paragraph = ui.ParagraphBuilder(ui.ParagraphStyle(fontSize: textSize))
      ..addText(text);
    var p = paragraph.build()
      ..layout(ui.ParagraphConstraints(width: double.infinity));
    return Offset(p.minIntrinsicWidth,p.height);
  }

  void _drawText(String text , Offset offset ,{Color color ,double textSize}){
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      ellipsis: '...',
      maxLines: 1,


    ));
    builder.pushStyle(ui.TextStyle(color: color ?? Colors.red,fontSize: textSize ?? 15.0));
    builder.addText(text);


    ui.Paragraph  paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: double.infinity));
    canvas.drawParagraph(paragraph, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return chessmanList != null && chessmanList.isNotEmpty;
  }
}
class Chessman {
  Offset position;
  Player owner;
  int numberId = chessmanList.length;
  int score;

  Chessman(this.position ,this.owner);

  Chessman.white(this.position) {
    owner = Player.WHITE;
  }

  Chessman.whiteXY(double x, double y) {
    this.position = Offset(x, y);
    owner = Player.WHITE;
  }

  Chessman.black(this.position) {
    owner = Player.BLACK;
  }

  Chessman.blackXY(double x, double y) {
    this.position = Offset(x, y);
    owner = Player.BLACK;
  }

  @override
  String toString() {
    return 'Chessman{position: (${position.dx},${position.dy}), owner: ${owner == Player.BLACK ? "BLANK" : "WHITE"}, score: $score, numberId: $numberId}';
  }
}

class Player {
  // ignore: non_constant_identifier_names
  static final Player BLACK = Player(Colors.black);
  // ignore: non_constant_identifier_names
  static final Player WHITE = Player(Colors.white);

  Color color ;
  Player(this.color);

  @override
  String toString() {
    return 'Player{${this == BLACK ? "BLACK" : "WHITE"}}';
  }
}
class RefreshNotification extends Notification{
  RefreshNotification();
}
