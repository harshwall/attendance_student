import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/dashboard.dart';
import 'package:attendance_student/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:password/password.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  var _loginForm = GlobalKey<FormState>();

  Student student = Student.blank();
  String inputPass="";

  final algorithm = PBKDF2();

  @override
  Widget build(BuildContext context) {

    Student incoming = Student.blank();

    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _loginForm,
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      onSaved: (value) {
                        student.regNo = value;
                      },
                      validator: (String value) {
                        if (value.length != 8)
                          return 'Incorrect Registration Number';
                      },
                      decoration: InputDecoration(
                          labelText: 'Registration Number',
                          errorStyle: TextStyle(color: Colors.yellow),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      obscureText: true,
                      onSaved: (value) {
                        inputPass = value;
                      },
                      validator: (String value) {
                        if (value.length < 6)
                          return 'Password too short';
                      },
                      decoration: InputDecoration(
                          labelText: 'Password',
                          errorStyle: TextStyle(color: Colors.yellow),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                        child: Text('Login'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 20.0,
                        onPressed: () {

                          bool check=false;
                          if (_loginForm.currentState.validate()) {
                            _loginForm.currentState.save();


//                            check = checkLogin(incoming);
//                            if(check==true)
//                              student=incoming;


                          Firestore.instance.collection('stud')
                            .where('regNo', isEqualTo: student.regNo)
                            .where('pass', isEqualTo: Password.hash(inputPass, algorithm))
                            .getDocuments()
                            .then((QuerySnapshot docs) {
                              try {
                                incoming = Student.fromMapObject(docs.documents[0].data);
                                incoming.documentId = docs.documents[0].documentID;
                                check=true;
                                student = incoming;

                                Fluttertoast.showToast(
                                    msg: 'in try',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );

                                Navigator.pop(context);

                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return Dashboard(student);
                                }));


                              }
                              catch(e){
                                check=false;
                                Fluttertoast.showToast(
                                    msg: 'in catch',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                             setState(() {

                             });


//                             Fluttertoast.showToast(
//                                 msg: check.toString()+'  '+student.documentId,
//                                 toastLength: Toast.LENGTH_SHORT,
//                                 gravity: ToastGravity.CENTER,
//                                 timeInSecForIos: 1,
//                                 backgroundColor: Colors.red,
//                                 textColor: Colors.white,
//                                 fontSize: 16.0
//                             );
                          });
                          }


                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      child: Text(
                        'New User? Sign Up',
                        style: TextStyle(color: Colors.black),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SignUp();
                        }));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }


}
