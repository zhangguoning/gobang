import 'package:bluetooth/bluetooth.dart';

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

  void scan({void onData(ScanResult result)}) async{
    flutterBlue.scan(timeout: Duration(seconds: 10)).listen((data){
      if(onData!=null){
        onData(data);
      }
    });
  }
}