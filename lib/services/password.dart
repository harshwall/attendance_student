import 'package:password_hash/password_hash.dart';
class Password{
  static var _generator = new PBKDF2();
  static int _length=100;
  static var _salt = Salt.generateAsBase64String(_length);
  static String getHash(String inputPass){
    var hash = _generator.generateKey(inputPass, _salt, 1000, 32);
    String result=String.fromCharCodes(hash);
    return result;
  }
}