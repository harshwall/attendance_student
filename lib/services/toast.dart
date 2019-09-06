import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toast (String s){
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 10.0
  );
  return;
}