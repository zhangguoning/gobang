import 'dart:ui';

import 'package:gobang/widget/checker_board.dart';

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

  num maxCount = 3;

  final Map<num,V> buffer = Map<num,V>();

  BufferMap();

  BufferMap.maxCount(this.maxCount);

  void put(num key , V value){
    buffer.update(key,  (V val){
      return value;
    },ifAbsent: (){
      return value;
    });
    _checkSize();
  }

  void putAll(BufferMap<V> map){
    for(Iterator it = map.keySet.iterator; it.moveNext();){
      int key = it.current;
      V value = map[key];
      put(key,value);
    }
  }

  void _checkSize(){
    List list = buffer.keys.toList()..sort((num a, num b){
      return b - a ;
    });
    while(buffer.length > maxCount){
      buffer.remove(list.last);
    }
  }



  Map<num,V> toMap(){
    return buffer;
  }

  Iterable<V> values(){
    return buffer.values;
  }

  int size(){
    return buffer.length;
  }

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write("{");
    for(int i  in  buffer.keys.toList()..sort((num a, num b){return b - a ;})){
      sb.write("[$i , ${buffer[i]}] ,");
    }

    return sb.toString().substring(0,sb.toString().length-2) + "}";
  }

  V get first =>
      buffer[buffer.keys.toList()
        ..sort((num a, num b) {
          return b - a;
        })
        ..first];

  num minKey(){
    if(buffer.isEmpty){
      return double.negativeInfinity;
    }
    List list =  buffer.keys.toList()
      ..sort((num a, num b) {
        return b - a;
      });
    return list.isNotEmpty ? list.last  : double.negativeInfinity;
  }


  MapEntry<num,V> min (){
    if(buffer.isEmpty){
      return null;
    }
   List list =  buffer.keys.toList()
      ..sort((num a, num b) {
        return b - a;
      });
   return list.isNotEmpty ? MapEntry(list.last,buffer[list.last])  : null ;
  }

  List<num> get keySet =>
      buffer.isEmpty ? null :
      buffer.keys.toList()
        ..sort((num a, num b) {
          return b - a;
        });

  V operator [](Object key){
    return buffer[key];
  }

  num maxKey(){
    if(buffer.isEmpty){
      return double.negativeInfinity;
    }
    List list =  buffer.keys.toList()
      ..sort((num a, num b) {
        return b - a;
      });
    return list.isNotEmpty ? list.first : 0;
  }

  MapEntry<num,V> max(){
    if(buffer.isEmpty){
      return null;
    }
    List list =  buffer.keys.toList()
      ..sort((num a, num b) {
        return b - a;
      });
    return list.isNotEmpty ? MapEntry(list.first,buffer[list.first]) : null;
  }
}
class OffsetList{

  final List<Offset> buffer = List.empty(growable: true);

  void add(Offset offset){
    for(Offset o in buffer){
      if(offset.dy == o.dy && offset.dx == o.dx){
        return ;
      }
    }
    buffer.add(offset);
  }

  void addAll(Iterable<Offset> list){
    if(list!=null && list.isNotEmpty){
      for(Offset o in list){
        add(o);
      }
    }
  }

  List<Offset> toList(){
    return buffer;
  }

  OffsetList();

}

class BufferChessmanList{
  final List<Chessman> buffer = List.empty(growable: true);
  int maxCount;

  void add(Chessman chessman){
    buffer.add(chessman);
    _checkSize();
  }

  BufferChessmanList.maxCount({maxCount = 5}){
    this.maxCount = maxCount;
  }

  void _checkSize(){
    buffer..sort((Chessman a, Chessman b){
      return b.score - a.score;
    });

    while(buffer.length > maxCount){
      buffer.remove(buffer.last);
    }
  }

  List<Offset> toList(){
    List<Offset> list = List.empty(growable: true);
    for(Chessman c in buffer){
      list.add(c.position);
    }
    return list;
  }

  num minScore(){
    if(buffer.isEmpty){
      return double.negativeInfinity;
    }
    buffer..sort((Chessman a, Chessman b){
      return b.score - a.score;
    });
    return buffer.last.score;
  }
}