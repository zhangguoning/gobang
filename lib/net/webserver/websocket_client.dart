import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef Task = void Function();
typedef OnData = void Function(String data);

class ClientSocketManager {

  static const String HOST = "ws://172.18.81.240:9893";
  IOWebSocketChannel channel ;

  List<OnData> _listeners = List<OnData>();

  ClientSocketManager._();
  static ClientSocketManager _instance;
  static Future<ClientSocketManager> getInstance() async{
    if (_instance == null ) {
      _instance = ClientSocketManager._();
     await _instance._init();
    }
    return _instance;
  }


  void _checkState({Task task}){
    if(channel == null || channel.sink == null){
      _init().then((_){
        if(task!=null){
          task();
        }
      });
    }else{
      task();
    }
  }

  Future<void> _init() async{
    if(channel == null || channel.sink == null){
      channel = await IOWebSocketChannel.connect(HOST);
      channel.stream.listen((message){
        for(OnData onData in _listeners){
          onData(message);
        }
      });
    }
  }

  void addListener(OnData onData) async {
    if(!_listeners.contains(onData)){
      _listeners.add(onData);
    }
  }

  void removeListener(OnData onData){
    if(onData == null){
      _listeners.clear();
    }else{
      _listeners.remove(onData);
    }
  }

  void close({void onClosed(Object data)}){
    if(channel!=null){
      channel.sink.close(-1,"连接关闭!");
    }
  }

  void sendMsg(String msg) async{
    _checkState(task: (){
      channel.sink.add(msg);
    });
  }

}