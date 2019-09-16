import 'dart:convert';

import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/dashboard.dart';
import 'package:attendance_student/screens/login.dart';
import 'package:attendance_student/screens/qrshow.dart';
import 'package:attendance_student/screens/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

//  final SharedPreferences prefs = SharedPreferences.getInstance();
  SharedPreferences.getInstance().then((prefs) {
    final String jsonObject = prefs.getString('storedObject');
    final String jsonId = prefs.getString('storedId');
    if(jsonObject != null && jsonObject.isNotEmpty) {
      Student student = Student.fromMapObject(json.decode(jsonObject));
      student.documentId = jsonId;
      return runApp(MyApp(true, student));
    }
    else
      return runApp(MyApp(false, Student.blank()));
  });




}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  bool check;
  Student student;
  MyApp(this.check, this.student);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
      ),
      home: check?Dashboard(student):Login(),//Currently user is directly thrown to the login page. Shared preferences will be checked here
    );
  }

//  checkPreferences() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    final String jsonObject = prefs.getString('storedObject');
//    final String jsonId = prefs.getString('storedId');
//    if(jsonObject != null && jsonObject.isNotEmpty) {
//      Student student = Student.fromMapObject(json.decode(jsonObject));
//      student.documentId = jsonId;
//      return Dashboard(student);
//    }
//    else
//      return Login();
//  }
}