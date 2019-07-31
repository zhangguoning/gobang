
class Util{

   static const String REGEX_IP = "((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)";

    static bool isIP(String string) {
     return RegExp(REGEX_IP).hasMatch(string);
   }

}