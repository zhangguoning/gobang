import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef Task = void Function();
typedef OnData = void Function<T>(T data);

class ClientSocketManager {

  static const String HOST = "ws://172.18.81.240:9893";
  static IOWebSocketChannel channel ;

  OnData onData;

  ClientSocketManager._();
  static ClientSocketManager _instance;
  static ClientSocketManager getInstance(OnData onData) {
    if (_instance == null ) {
      _instance = ClientSocketManager._();
      _instance.onData = onData;
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
    }
  }

  Future<void> _init() async{
    channel = await IOWebSocketChannel.connect(HOST);
    channel.stream.listen((message){
      print("received data from server(listen-before): $message");
      onData(message);
      print("received data from server(listen-after): $message");
    });
  }

  void sendMsg(String msg) async{
    _checkState(task: (){
      channel.sink.add(msg);
    });
  }

}