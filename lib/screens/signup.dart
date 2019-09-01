import 'dart:async';
import 'package:attendance_student/classes/student.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:validators/validators.dart';
import 'package:password/password.dart';


class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  var _signUpForm = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();


  Student student = Student.blank();

  int _genderValue = 0;

  final algorithm = PBKDF2();

  final dateFormat = DateFormat("yyyy-MM-dd");
  DateTime dateTime = DateTime.now();

  var categoryList = ['Open', 'OBC', 'SC/ST', 'Other'];
  var _currentCategorySelected = '';

  bool _saving = false;

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
                      student.pass = Password.hash(value, algorithm);
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
                  child: DateTimeField(
                    format: dateFormat,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          initialDate: dateTime,
                          firstDate: DateTime(1970),
                          lastDate: DateTime(2050));
                    },
                    onSaved: (value) {
                      student.dob = value.toString();
                    },
                    validator: (DateTime value) {
                      if(!isDate(value.toString()) || value == null || value.compareTo(DateTime.now().subtract(Duration(days: 1))) >= 0)
                        return 'Enter correct DOB';
                    },
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      errorStyle: TextStyle(color: Colors.yellow),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))
                    ),
                  )
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  onPressed: () {
                    setState(() {
                      if(_signUpForm.currentState.validate() ) {
                        _signUpForm.currentState.save();
                        student.gender = genderToString(_genderValue);
                        student.category = _currentCategorySelected;

//                        Fluttertoast.showToast(
//                            msg: student.name+' '+student.regNo+' '+student.pass+' '
//                                +student.father+' '+student.gender+' '+student.category+' '
//                                +student.dob+' '+student.email+' '+student.mobile,
//                            toastLength: Toast.LENGTH_SHORT,
//                            gravity: ToastGravity.CENTER,
//                            timeInSecForIos: 1,
//                            backgroundColor: Colors.red,
//                            textColor: Colors.white,
//                            fontSize: 16.0
//                        );

                        Firestore.instance.collection('stud').add(student.toMap());
                        Navigator.of(context).pop();
                      }
                    });
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
