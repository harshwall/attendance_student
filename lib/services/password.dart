import 'package:password/password.dart' as prefix0;
class Password{
  static String getHash(String inputPass){
    final algorithm=prefix0.PBKDF2();
    String result=prefix0.Password.hash(inputPass, algorithm);
    print(result);
    return result;
  }
}