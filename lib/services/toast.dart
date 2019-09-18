import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//  Method to toast
void toast(String s){
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