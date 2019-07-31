class BufferList<T>{

  int maxCount = 3;

  final List<T> buffer = List<T>();

  BufferList();

  BufferList.maxCount(this.maxCount);

  void add(T data){
    buffer.insert(0, data);
    _checkSize();
  }

  void _checkSize(){
    while(buffer.length > maxCount){
      buffer.removeLast();
    }
  }

  List<T> toList(){
    return buffer.toList(growable: false);
  }
}


class BufferMap<V>{

  int maxCount = 3;

  final Map<int,V> buffer = Map<int,V>();

  BufferMap();

  BufferMap.maxCount(this.maxCount);

  void put(int key , V value){
    buffer.putIfAbsent(key, (){
      return value;
    });
    _checkSize();
  }

  void _checkSize(){
    List list = buffer.keys.toList()..sort((int a, int b){
      return b - a ;
    });
    while(buffer.length > maxCount){
      buffer.remove(list.last);
    }
  }

  Map<int,V> toMap(){
    return buffer;
  }

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{");
    for(int i  in  buffer.keys.toList()..sort((int a, int b){return b - a ;})){
      sb.write("[$i , ${buffer[i]}] ,");
    }

    return sb.toString().substring(0,sb.toString().length-2) + "}";
  }

  V get first =>
      buffer[buffer.keys.toList()
        ..sort((int a, int b) {
          return b - a;
        })
        ..first];

  int minKey(){
    List list =  buffer.keys.toList()
      ..sort((int a, int b) {
        return b - a;
      });
    return list.isNotEmpty ? list.last  : 0;
  }


  MapEntry<int,V> min (){
   List list =  buffer.keys.toList()
      ..sort((int a, int b) {
        return b - a;
      });
   return list.isNotEmpty ? MapEntry(list.last,buffer[list.last])  : null ;
  }

  List<int> get keySet =>
      buffer.keys.toList()
        ..sort((int a, int b) {
          return b - a;
        });

  V operator [](Object key){
    return buffer[key];
  }

  int maxKey(){
    List list =  buffer.keys.toList()
      ..sort((int a, int b) {
        return b - a;
      });
    return list.isNotEmpty ? list.first : 0;
  }

  MapEntry<int,V> max(){
    List list =  buffer.keys.toList()
      ..sort((int a, int b) {
        return b - a;
      });
    return list.isNotEmpty ? MapEntry(list.first,buffer[list.first]) : null;
  }
}