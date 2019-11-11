import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gobang/util/util.dart';

class NetSettingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _NetSettingPageState();
  }
}

class _NetSettingPageState extends State<NetSettingPage>{
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    if (controller == null) {
      controller = TextEditingController()
        ..addListener(() {
          print('input ${controller.text}');
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("网络设置"),
        centerTitle: true,
      ),
      body: _buildNetSettingPageState(context),
    );
  }

  Widget _buildNetSettingPageState(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.red[50],
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.w500),
              controller: controller,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter(RegExp(r'[\d.]')),
              ],
              decoration: InputDecoration(
                fillColor:  Colors.blue.shade100,
                filled: true,
                labelText: 'input server socket ip',
              ),
//                  enabled: inputEnable, //FIXME : for test
            ),
          ),
          GestureDetector(
            child: Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              color: Colors.grey[400],
//                  child: Text("测试",
              child: Text("未完成...",
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                  overflow: TextOverflow.ellipsis),
            ),
            onTap: (){
              if(Util.isIP(controller.text)){
                invalidate();
              }else{
                Fluttertoast.showToast(msg: "ip 格式错误!");
              }
            },
          ),
        ],
      ),
    );
  }



  void invalidate() {
    setState(() {});
  }
}