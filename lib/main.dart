import 'dart:convert';
import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/dashboard.dart';
import 'package:attendance_student/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase_widget.dart';

//  The App starts from the void main()

void main() {

  //  Shared Preferences is being checked. If it's present then student object is saved.
  //  getHelp is used for ShowCase View.
  SharedPreferences.getInstance().then((prefs) {
    final String jsonObject = prefs.getString('storedObject');
    final String jsonId = prefs.getString('storedId');
    final String firstTime = prefs.getString('firstTime');
    prefs.setString('firstTime', 'false');
    bool getHelp;
    if(firstTime == null)
      getHelp = true;
    else
      getHelp = false;
    if(jsonObject != null && jsonObject.isNotEmpty) {
      Student student = Student.fromMapObject(json.decode(jsonObject));
      student.documentId = jsonId;
      return runApp(MyApp(true, student, getHelp));
    }
    else
      return runApp(MyApp(false, Student.blank(), getHelp));
  });

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application. The app UI starts from MaterialApp
  // check is used to decide if a user is already logged in or not.
  bool check;
  Student student;
  bool getHelp;
  MyApp(this.check, this.student, this.getHelp);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Student',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
      ),

      //  If the user is logged in already then Dashboard is called, else Login page will be opened.
      home: check?ShowCaseWidget(child: Dashboard(student, getHelp),):Login(getHelp),
    );
  }
}