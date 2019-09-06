import 'package:password/password.dart' as prefix0;
import 'package:password_hash/password_hash.dart';
import 'package:password/password.dart';
class Password{
//  static var _generator = new PBKDF2();
//  static int _length=15;
//  static var _salt = Salt.generateAsBase64String(_length);
//  static var _salt="anythingyouwant";
  static String getHash(String inputPass){
//    var hash = _generator.generateKey(inputPass, _salt, 1000, 32);
//    String result=String.fromCharCodes(hash);
    final algorithm=prefix0.PBKDF2();
    String result=prefix0.Password.hash(inputPass, algorithm);
    print(result);
    return result;
  }
}