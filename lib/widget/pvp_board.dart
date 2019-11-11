import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gobang/bean/chessman.dart';
import 'package:gobang/bean/player.dart';
import 'package:gobang/page/pvp/play_game.dart';
import 'package:gobang/user/current_player.dart';
import 'package:provider/provider.dart';
import 'package:gobang/bean/chessman_position.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class FieldWrap{
  StreamController<Chessman> onFallChessmanStreamController;
  Stream<Chessman> fallChessmanStream;
  Sink<Chessman> fallChessmanSink;



  FieldWrap(){
   onFallChessmanStreamController =  StreamController<Chessman>();
    fallChessmanStream = onFallChessmanStreamController.stream.asBroadcastStream();
    fallChessmanSink = onFallChessmanStreamController.sink;
  }

  void _reset(){
    fallChessmanSink?.close();
    onFallChessmanStreamController?.close();
  }

}

class PvpGobangBoardWidget extends StatefulWidget{
  final FieldWrap _fieldWrap = FieldWrap();

  final void Function(Chessman chessman) sendChessman;


  PvpGobangBoardWidget(this.sendChessman ,{Key key}) : super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _PvpGobangBoardWidgetState(_fieldWrap.onFallChessmanStreamController,_fieldWrap.fallChessmanStream,_fieldWrap.fallChessmanSink);
  }

  StreamSubscription<Chessman> listenFallChessman(void Function(Chessman chessman) onData){
    return _fieldWrap.fallChessmanStream.listen(onData);
  }

}

class _PvpGobangBoardWidgetState extends State<PvpGobangBoardWidget>{
  static const int LINE_COUNT = 14;
  StreamController<Chessman> onFallChessmanStreamController;
  Stream<Chessman> fallChessmanStream;
  Sink<Chessman> fallChessmanSink;

  bool gameOver = false;

  _PvpGobangBoardWidgetState(this.onFallChessmanStreamController,this.fallChessmanStream,this.fallChessmanSink);

  Player me;

  @override
  void initState() {
    super.initState();
    fallChessmanStream.listen((Chessman chessman){
      widget.sendChessman(chessman);
    });
  }

  @override
  void dispose() {
    super.dispose();
    fallChessmanSink?.close();
    onFallChessmanStreamController?.close();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    me = Provider.of<CurrentPlayer>(context).user;
  }


  void onTapDown(TapDownDetails details) {
    if(gameOver){
      return ;
    }
    double clickX = details.localPosition.dx;
    int floorX = clickX ~/ CBPaint.ceilWidth;
    double offsetFloorX = floorX * CBPaint.ceilWidth + CBPaint.ceilWidth / 2;
    int x = offsetFloorX > clickX ? floorX : ++floorX;

    double clickY = details.localPosition.dy;
    int floorY = clickY ~/ CBPaint.ceilHeight;
    double offsetFloorY = floorY * CBPaint.ceilHeight + CBPaint.ceilHeight / 2;
    int y = offsetFloorY > clickY ? floorY : ++floorY;

    ///落子
    Chessman chessman = new Chessman(me, ChessmanPosition(x,y), GameDataWidget.of(context).gameData.chessmanList.length);
//    fallChessmanSink.add(chessman);
    fallChessman(chessman);
  }


  void fallChessman(Chessman newChessman){
    if(GameDataWidget.of(context).gameData.currentPlayer.deviceId != newChessman.owner.deviceId){
      return ;
    }
    bool can = addToChessmanList(newChessman);
    if(can){
      gameOver = checkResult(newChessman : newChessman);
      if(newChessman.owner.deviceId == me.deviceId){
        fallChessmanSink.add(newChessman);
      }
      invalidate();
      if(!gameOver && !isHaveAvailablePosition()){
        Fluttertoast.showToast(msg:"和棋!");
      }
    }else{
      Fluttertoast.showToast(msg:"不能在此处落子!");
    }
  }
  bool existSpecificChessman(Offset position, Player player) {
    if (GameDataWidget.of(context).gameData.chessmanList.isNotEmpty) {
      var cm = GameDataWidget.of(context).gameData.chessmanList.firstWhere((Chessman c) {
        return c.position.x == position.dx && c.position.y == position.dy;
      }, orElse: () {
        return null;
      });
      return cm != null && cm.owner.deviceId == player.deviceId;
    }
    return false;
  }

  bool checkResult({Chessman newChessman}) {


    newChessman ??=  GameDataWidget.of(context).gameData.chessmanList.isNotEmpty ? GameDataWidget.of(context).gameData.chessmanList.last : null;
    if(newChessman == null){
      return false;
    }
//  Color color = newChessman.color;
    int currentX = newChessman.position.x.toInt();
    int currentY = newChessman.position.y.toInt();

    int count = 0;

    ///横
    /// o o o o o
    /// o o o o o
    /// x x x x x
    /// o o o o o
    /// o o o o o
    GameDataWidget.of(context).gameData.winResult..clear();
    for (int i = (currentX - 4 > 0 ? currentX - 4 : 0);
    i <= (currentX + 4 < LINE_COUNT ? currentX + 4 : LINE_COUNT);
    i++) {
      Offset position = Offset(i.toDouble(), currentY.toDouble());
      if (existSpecificChessman(position, newChessman.owner)) {
        GameDataWidget.of(context).gameData.winResult.add(findChessmanByPosition(position));
        count++;
      } else {
        GameDataWidget.of(context).gameData.winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner .isFirst ? "黑色" :  "白色" }");
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
    GameDataWidget.of(context).gameData.winResult.clear();
    for (int j = (currentY - 4 > 0 ? currentY - 4 : 0);
    j <= (currentY + 4 > LINE_COUNT ? LINE_COUNT : currentY + 4);
    j++) {
      Offset position = Offset(currentX.toDouble(), j.toDouble());
      if (existSpecificChessman(position, newChessman.owner)) {
        GameDataWidget.of(context).gameData.winResult.add(findChessmanByPosition(position));
        count++;
      } else {
        GameDataWidget.of(context).gameData.winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner .isFirst ? "黑色" :  "白色" }");
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
    GameDataWidget.of(context).gameData.winResult.clear();
    Offset offset2 = Offset(
        (currentX - 4).toDouble(), (currentY + 4).toDouble());
    for (int i = 0; i < 10; i++) {
      Offset position = Offset(offset2.dx + i, offset2.dy - i);
      if (existSpecificChessman(position, newChessman.owner)) {
        GameDataWidget.of(context).gameData.winResult.add(findChessmanByPosition(position));
        count++;
      } else {
        GameDataWidget.of(context).gameData.winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner .isFirst ? "黑色" :  "白色" }");
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
    GameDataWidget.of(context).gameData.winResult..clear();
    Offset offset = Offset(
        (currentX - 4).toDouble(), (currentY - 4).toDouble());
    for (int i = 0; i < 10; i++) {
      Offset position = Offset(offset.dx + i, offset.dy + i);
      if (existSpecificChessman(position, newChessman.owner)) {
        GameDataWidget.of(context).gameData.winResult.add(findChessmanByPosition(position));
        count++;
      } else {
        GameDataWidget.of(context).gameData.winResult.clear();
        count = 0;
      }
      if (count >= 5) {
        print("胜利者产生: ${newChessman.owner .isFirst ? "黑色" :  "白色" }");
        return true;
      }
    }
    GameDataWidget.of(context).gameData.winResult.clear();
    return false;
  }


  Chessman findChessmanByPosition(Offset position){
    var cm = GameDataWidget.of(context).gameData.chessmanList.firstWhere((Chessman c) {
      return c.position.x == position.dx && c.position.y == position.dy;
    }, orElse: () {
      return null;
    });
    return cm;
  }


  bool isHaveAvailablePosition(){
    return GameDataWidget.of(context).gameData.chessmanList.length <= LINE_COUNT * LINE_COUNT ;
  }

  bool addToChessmanList(Chessman chessman) {
    if (GameDataWidget.of(context).gameData.chessmanList.isNotEmpty) {
      var cm = GameDataWidget.of(context).gameData.chessmanList.firstWhere((Chessman c) {
        return c.position.x == chessman.position.x &&
            c.position.y == chessman.position.y;
      }, orElse: () {
        GameDataWidget.of(context).gameData.chessmanList.add(chessman);
        return null;
      });
      return cm == null;
    } else {
      GameDataWidget.of(context).gameData.chessmanList.add(chessman);
      return true;
    }
  }


  @override
  Widget build(BuildContext context) {
    gameOver = checkResult();
    return Center(
      child: GestureDetector(
        child: CustomPaint(
          painter: CBPaint(context),
          size: Size(400, 400),
        ),
        onTapDown: (details) {
//          onTapStreamController.sink.add(details);
          onTapDown(details);
        },
      ),
    );
  }

  void invalidate() {
    setState(() {});
  }

}

class CBPaint extends CustomPainter {
  BuildContext context;
  static const int LINE_COUNT = 14;
  static double ceilWidth, ceilHeight;
  Canvas canvas;
  Paint painter;
  static const bool IS_DEBUG = true;

  CBPaint(this.context);

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
        _drawText(i.toString(),Offset(dx - _calcTrueTextSize(i.toString(),15.0).dx /2, -18));
//        _drawText((String.fromCharCode(i + 65)),Offset(dx - _calcTrueTextSize(String.fromCharCode(i + 65),15.0).dx /2, -18));
      }
    }
    _drawMarkPoints();

    if (GameDataWidget.of(context).gameData.chessmanList.isNotEmpty) {
      for (Chessman c in GameDataWidget.of(context).gameData.chessmanList) {
        _drawChessman(c);
      }
    }

    if (GameDataWidget.of(context).gameData.winResult.isNotEmpty) {
      painter
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;
      Offset start = Offset(GameDataWidget.of(context).gameData.winResult.first.position.x * ceilWidth,
          GameDataWidget.of(context).gameData.winResult.first.position.y * ceilHeight);
      Offset end = Offset(GameDataWidget.of(context).gameData.winResult.last.position.x * ceilWidth,
          GameDataWidget.of(context).gameData.winResult.last.position.y * ceilHeight);
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
      ..color = chessman.owner.isFirst?Colors.black: Colors.white;

    Offset center = Offset(chessman.position.x * ceilWidth, chessman.position.y * ceilHeight);
    canvas.drawCircle(center,
        math.min(ceilWidth / 2, ceilHeight / 2) - 2, painter);

    if(chessman.numberId == GameDataWidget.of(context).gameData.chessmanList.length - 1){
      painter
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawCircle(center,math.min(ceilWidth / 2, ceilHeight / 2) - 2, painter);
    }

    if(IS_DEBUG){
      double fontSize = 12.0;
      Offset textSize = _calcTrueTextSize(chessman.numberId.toString(),fontSize);
      _drawText(chessman.numberId.toString(),
          Offset(center.dx - (textSize.dx / 2), center.dy-(textSize.dy / 2)),
          color: chessman.owner.isFirst?Colors.white:Colors.black,
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
    return GameDataWidget.of(context).gameData.chessmanList != null && GameDataWidget.of(context).gameData.chessmanList.isNotEmpty;
  }


}