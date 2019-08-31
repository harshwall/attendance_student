import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  var _loginForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      validator: (String value) {
                        if (value.length < 6) return 'Password too short';
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
                        elevation: 20.0,
                        onPressed: () {
                          setState(() {
                            if (_loginForm.currentState.validate()) {
                              _loginForm.currentState.save();
                            }
                          });
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RaisedButton(
                      child: Text(
                          'New User? Sign Up',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),
                      color: Colors.white,
                      onPressed: (){

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
