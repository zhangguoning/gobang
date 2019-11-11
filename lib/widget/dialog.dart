import 'package:flutter/material.dart';
import 'package:gobang/util/util.dart';

class BoolWrap {
  bool value;

  BoolWrap(this.value);
}

class LoadingDialog extends Dialog {
  final BuildContext context;
  final String message;
  final void Function() onDismiss;
  final BoolWrap cancelable = BoolWrap(true);
  final BoolWrap _isShowing = BoolWrap(false);

  LoadingDialog(this.context,
      {this.message = "", bool cancelable = true, this.onDismiss, Key key})
      : super(key: key) {
    if (cancelable != null) {
      this.cancelable..value = cancelable;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: 120.0,
            height: 120.0,
            child: new Container(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                color: Color(0xffffffff),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  message.isEmpty
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            message,
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setCancelable(bool cancelable) {
    if (cancelable != null) {
      this.cancelable..value = cancelable;
    }
  }

  Future<bool> onWillPop() async {
    if (cancelable.value) {
      _isShowing..value = false;
      if (onDismiss != null) {
        onDismiss();
      }
      return true;
    } else {
      return false;
    }
  }

  void show() {
    if (!_isShowing.value) {
      _isShowing..value = true;
      showDialog(context: context, builder: (context) => this);
    }
  }

  void dismiss() {
    if (_isShowing.value) {
      Navigator.of(context).pop();
      if (onDismiss != null) {
        onDismiss();
      }
      _isShowing..value = false;
    }
  }
}

class CustomDialog extends Dialog {
  final BuildContext context;
  final String title;
  final String content;
  final String leftButtonText;
  final String rightButtonText;
  final bool cancelable;
  final bool canceledOnTouchOutside;

  final void Function() onDismiss;
  final void Function() onBackPressedToCancel;
  final void Function() onLeftButtonClicked;
  final void Function() onRightButtonClicked;
  final BoolWrap _isShowing = BoolWrap(false);
  final GlobalKey rootViewKey = GlobalKey();

  CustomDialog(this.context,
      {this.title,
      @required this.content,
      this.leftButtonText,
      this.rightButtonText,
      this.cancelable = true,
      this.canceledOnTouchOutside = false,
      this.onBackPressedToCancel,
      this.onDismiss,
      this.onLeftButtonClicked,
      this.onRightButtonClicked,
      Key key})
      : super(key: key);

  Future<bool> _onWillPop() async {
    if (cancelable) {
      _isShowing..value = false;
      if (onBackPressedToCancel != null) {
        onBackPressedToCancel();
      }
      if (onDismiss != null) {
        onDismiss();
      }
      return true;
    } else {
      return false;
    }
  }

  void show() {
    if (!_isShowing.value) {
      _isShowing..value = true;
      showDialog(context: context, builder: (context) => this);
    }
  }

  void dismiss() {
    if (_isShowing.value) {
      Navigator.of(context).pop();
      if (onDismiss != null) {
        onDismiss();
      }
      _isShowing..value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: rootViewKey,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                child:  Container(
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                  margin: EdgeInsets.only(left: 30, right: 30),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                  child: Column(
                    children: <Widget>[
                      (title != null && title.isNotEmpty)
                          ? Container(
                        child: Center(
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      )
                          : Container(
                        width: 0,
                        height: 0,
                      ),
                      (title != null && title.isNotEmpty)
                          ? Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        color: Colors.grey[200],
                        height: 0.5,
                      )
                          : Container(
                        width: 0,
                        height: 0,
                      ),
                      Container(
                        constraints: BoxConstraints(
                          minHeight: 60,
                          maxHeight: 60,
                        ),
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: Text(
                            content,
                            style: TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5, top: 5),
                        color: Colors.grey[200],
                        height: 0.5,
                      ),
                      StringUtil.isAllNotEmpty([leftButtonText, rightButtonText])
                          ? Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                              child: Container(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 10,
                                      bottom: 10),
                                  child: Text(
                                    leftButtonText,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                              onPressed: onLeftButtonClicked),
                          FlatButton(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                    bottom: 10),
                                child: Text(rightButtonText,
                                    style: TextStyle(fontSize: 18.0)),
                                alignment: Alignment.center,
                              ),
                              onPressed: onRightButtonClicked),
                        ],
                      ),) : StringUtil.existEmpty([leftButtonText, rightButtonText],
                          emptyCount: 1)
                          ? Center(
                        child: FlatButton(
                            child: Container(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Text(
                                  StringUtil.isNotEmpty(leftButtonText)
                                      ? leftButtonText
                                      : rightButtonText,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                alignment: Alignment.center,
                              ),
                            ),
                            onPressed: StringUtil.isNotEmpty(leftButtonText)
                                ? onLeftButtonClicked
                                : onRightButtonClicked),
                      )
                          : Container(width: 0,height: 0,),
                    ],
                  ),
                ),
                onTapUp: _onInsideTapUp,
              ),

            ],
          ),
        ),
      ),
      onTapUp: _onOutsideTapUp,
    );
  }

  void _onInsideTapUp(TapUpDetails details){
    ///do nothing...
  }

  void _onOutsideTapUp(TapUpDetails details){
    if(canceledOnTouchOutside && cancelable){
      dismiss();
    }
  }
}
