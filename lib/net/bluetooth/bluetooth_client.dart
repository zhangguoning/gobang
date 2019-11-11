import 'dart:async';

import 'package:flutter_blue/flutter_blue.dart';

class BlueToothManager{

  FlutterBlue flutterBlue = FlutterBlue.instance;

  BlueToothManager._();
  static BlueToothManager _instance;
  static BlueToothManager getInstance() {
    if (_instance == null ) {
      _instance = BlueToothManager._();
    }
    return _instance;
  }

  Stream<ScanResult> scan(){
    return flutterBlue.scan(timeout: Duration(seconds: 30));
  }

  Stream<bool> isScanning(){
    return flutterBlue.isScanning;
  }
  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) async{
    return device.discoverServices();
  }

  Future<void> connect(BluetoothDevice device,{Duration timeout = const Duration(seconds: 30)}) async{
    return device.connect(timeout :timeout,);
  }

  Future<List<BluetoothDevice>> allConnected() async{
    return await flutterBlue.connectedDevices;
  }

  Future<void> disconnect(StreamSubscription<BluetoothDeviceState> subscription) async {
    return await subscription.cancel();
  }
}