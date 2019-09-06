import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/signup.dart';
import 'package:attendance_student/services/firestorecrud.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';


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
  bool _isLoading=false;

//  final algorithm = PBKDF2();

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
                        child: _isLoading?Loading(indicator: BallPulseIndicator(), size: 20.0):Text('Login'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 20.0,
                        onPressed: () {
                          if (_loginForm.currentState.validate() && _isLoading==false) {
                            _loginForm.currentState.save();
                            //starting to load
                            setState(() {
                              _isLoading=true;
                            });
                            FirestoreCRUD.login(context, incoming, student, inputPass).then((void v){
                              setState(() {
                                _isLoading=false;
                              });
                            });
                          }
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      child: Text('New User? Sign Up',style: TextStyle(color: Colors.black)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      onPressed: _isLoading?null:() {
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
