
class Util{

   static const String REGEX_IP = "((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";

    static bool isIP(String string) {
     return RegExp(REGEX_IP).hasMatch(string);
   }
}

class StringUtil{

  static bool isEmpty(String str){
    return str == null || str.isEmpty ;
  }

  static bool isNotEmpty(String str){
    return !isEmpty(str);
  }

  static bool isAllNotEmpty(List<String> strings){
    if(strings == null || strings.isEmpty){
      return false ;
    }
    for(String s in strings){
      if(s == null || s.isEmpty){
        return false;
      }
    }
   return true;
  }

  ///在 [strings] 有且只有 [emptyCount] 个为空的元素
  static bool existEmpty(List<String> strings,{int emptyCount = 1}){
    if(strings == null || strings.isEmpty){
      return false ;
    }
    int count = 0;
    for(String s in strings){
      if(isEmpty(s)){
        count++;
        if(count > emptyCount){
          return false;
        }
      }
    }
    return count == emptyCount;
  }

}


