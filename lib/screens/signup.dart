import 'package:attendance_student/classes/student.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  var _signUpForm = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  DateTime dateTime = DateTime.now();

  Student student = Student.blank();
  int _genderValue = 0;

  var categoryList = ['Open', 'OBC', 'SC/ST', 'Other'];
  var _currentCategorySelected = '';

  void initState() {
    super.initState();
    _currentCategorySelected = categoryList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _signUpForm,
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    onSaved: (value) {
                      student.name = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) return 'Enter Name';
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    obscureText: true,
                    key: _passKey,
                    onSaved: (value) {
                    },
                    validator: (String value) {
                      if (value.length<6) return 'Password too short';
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
                  child: TextFormField(
                    obscureText: true,
                    onSaved: (value) {
                      student.pass = value;
                    },
                    validator: (String value) {
                      if (value.length<6 || _passKey.currentState.value != value )
                        return "Passwords doesn't match";
                    },
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    onSaved: (value) {
                      student.regNo = value;
                    },
                    validator: (String value) {
                      if (value.length!=8) return 'Enter Registeration Number';
                    },
                    decoration: InputDecoration(
                        labelText: 'Registeration Number',
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    onSaved: (value) {
                      student.father = value;
                    },
                    validator: (String value) {
                      if (value.isEmpty) return "Enter Father's Name";
                    },
                    decoration: InputDecoration(
                        labelText: "Father's Name",
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    onSaved: (value) {
                      student.email = value;
                    },
                    validator: (String value) {
                      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
                        return 'Enter Correct Email';
                    },
                    decoration: InputDecoration(
                        labelText: 'Email',
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      student.mobile = value;
                    },
                    validator: (String value) {
                      if (!RegExp("[0-9]").hasMatch(value) || value.length!=10)
                        return 'Enter Mobile Number';
                    },
                    decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                          'Gender',
                        textScaleFactor: 1.5,
                      ),
                      Container(
                        width: 15,
                      ),
                      Radio(
                        value: 0,
                        groupValue: _genderValue,
                        onChanged: (int i) {
                          setState(() {
                            _genderValue = i;
                          });
                        },
                      ),
                      Text(
                        'Male',
                        textScaleFactor: 1.2,
                      ),
                      Radio(
                        value: 1,
                        groupValue: _genderValue,
                        onChanged: (int i) {
                          setState(() {
                            _genderValue = i;
                          });
                        },
                      ),
                      Text(
                        'Female',
                        textScaleFactor: 1.2,
                      ),
                      Radio(
                        value: 2,
                        groupValue: _genderValue,
                        onChanged: (int i) {
                          setState(() {
                            _genderValue = i;
                          });
                        },
                      ),
                      Text(
                        'Other',
                        textScaleFactor: 1.2,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Category',
                        textScaleFactor: 1.5,
                      ),
                      Container(
                        width: 30.0,
                      ),
                      DropdownButton<String> (
                        items: categoryList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value)
                          );
                        }).toList(),
                        value: _currentCategorySelected,
                        onChanged: (String newValue ) {
                          setState(() {
                            this._currentCategorySelected = newValue;
                          });
                        },
                      )
                    ],
                  ),
                ),

                RaisedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if(_signUpForm.currentState.validate()) {
                      _signUpForm.currentState.save();
                      student.gender = genderToString(_genderValue);
                      student.category = _currentCategorySelected;
                    }
                  },
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  String genderToString(int no) {
    switch(no) {
      case 0:
        return 'Male';
      case 1:
        return 'Female';
      default:
        return 'Other';
    }
  }
}
