import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:gobang/net/bluetooth/bluetooth_client.dart' as client;

class BlueToothSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BlueToothSettingPageState();
  }
}

class _BlueToothSettingPageState extends State {
  bool scanning = false;
  List<ScanResult> result = List<ScanResult>();
  BluetoothDevice alreadyConnectedDevice;

  StreamSubscription<ScanResult> scanSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("蓝牙设置"),
        centerTitle: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: _scan,
            child: Container(
              child: Row(
                children: <Widget>[
                  Text("扫描"),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: scanning ? SizedBox(
                      width: 13,
                      height: 13,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ) ,
                    ): Container(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                  itemCount: result.length, itemBuilder: listViewItemBuilder),
            ),
          ),
        ],
      ),
    );
  }

  Widget listViewItemBuilder(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(left: 15,right: 15),
      color: index % 2 == 0 ? Colors.blue[100] : Colors.grey[300],
      child: Row(
        children: <Widget>[
          Text(result[index].device.name.isNotEmpty ? result[index].device.name : result[index].device.id.id),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: FlatButton(
                onPressed: (){_connect(result[index].device);},
                child: alreadyConnectedDevice==null ?Text("连接") : Text("断开连接")) ,
          ),
        ],
      ),
    );
  }

  bool addDevices(ScanResult scanResult) {
    bool flag = false;
    for (ScanResult sr in result) {
      if (sr.device.id.id == scanResult.device.id.id) {
        flag = true;
        break;
      }
    }
    if (!flag) {
      result
        ..add(scanResult)
        ..sort((a, b) {
          return a.toString().compareTo(b.toString());
        });
      return true;
    }
    return false;
  }

  void _scan() async {

    if (scanning) {
      return;
    }

    scanSubscription?.cancel();
    result.clear();
    scanning = true;
    invalidate();

    scanSubscription = client.BlueToothManager.getInstance().scan().
    where((_) {
      return _.device.name != null && _.device.name.isNotEmpty;
    }).
    listen((_) {
      print("bluetooth devices:[${_.device.name}, ${_.device.id}]");
      if (addDevices(_)) {
        invalidate();
      }
    })
      ..onDone(() {
        scanning = false;
        invalidate();
      })
      ..onError((error) {
        scanning = false;
        scanSubscription?.cancel();
        invalidate();
      });
  }

  void _connect(BluetoothDevice device) async{
    try{
      await client.BlueToothManager.getInstance().connect(device);
    }catch(e){
      print(e);
    }


    List<BluetoothDevice> list = await client.BlueToothManager.getInstance().allConnected();
    if(list.contains(device)){
      alreadyConnectedDevice = device ;
      print("连接成功!");
    }
  }


  void invalidate() {
    setState(() {});
  }
}
