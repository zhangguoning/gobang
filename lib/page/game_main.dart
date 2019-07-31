import 'package:flutter/material.dart';
import 'package:gobang/widget/checker_board.dart';

class GameMainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GameMainPageState();
  }
}

class _GameMainPageState extends State<GameMainPage> {
  @override
  Widget build(BuildContext context) {

    Checkerboard checkerboard = Checkerboard(key: UniqueKey());
    return NotificationListener<RefreshNotification>(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 100, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            checkerboard,
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    "Clear All",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  )),
              onTap: () {
                checkerboard.clear();
                setState(() {});
              },
            ),
          ],
        ),
      ),
      onNotification: (_){
        setState(() {});
        return false;
      },
    );

  }
}
