import 'dart:async';
import 'dart:io';
import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/services/password.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:validators/validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attendance_student/services/firestorecrud.dart';

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
  File _image;

  int _genderValue = 0;
  bool _isLoading=false;

  final dateFormat = DateFormat("yyyy-MM-dd");
  DateTime dateTime = DateTime.now();

  var categoryList = ['Open', 'OBC', 'SC/ST', 'Other'];
  var _currentCategorySelected = '';


  void initState() {
    super.initState();
    _currentCategorySelected = categoryList[0];
  }


  //UI part of sign up
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Form(
          key: _signUpForm,
          child: Center(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100.0,
                        backgroundColor: Colors.blueAccent,
                        child: ClipOval(
                          child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image!=null)?
                            Image.file(_image,fit: BoxFit.fill):
                            Image.network(
                              "https://d2x5ku95bkycr3.cloudfront.net/App_Themes/Common/images/profile/0_200.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),

                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 30.0,
                        ),
                        onPressed: _isLoading?null:() {
                          getImage();
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0, bottom: 5.0),
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
                  padding: EdgeInsets.all(5.0),
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
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    obscureText: true,
                    onSaved: (value) {
                      student.pass = value;
                    },
                    validator: (String value) {
                      if (value.length<6 || _passKey.currentState.value != value )
                        return "Passwords don't match";
                    },
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    onSaved: (value) {
                      student.regNo = value;
                    },
                    validator: (String value) {
                      if (value.length!=8) return 'Enter Registration Number';
                    },
                    decoration: InputDecoration(
                        labelText: 'Registration Number',
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: TextFormField(
                    onSaved: (value) {
                      student.classId = value;
                    },
                    validator: (String value) {
                      if (value.length != 5) return "Enter valid Class ID";
                    },
                    decoration: InputDecoration(
                        labelText: "Class Id",
                        errorStyle: TextStyle(color: Colors.yellow),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(5.0),
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
                  padding: EdgeInsets.all(5.0),
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
                  padding: EdgeInsets.all(5.0),
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
                  padding: EdgeInsets.all(5.0),
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
                  padding: EdgeInsets.all(5.0),
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

                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: 50.0,
                      ),
                    ),
                    RaisedButton(
                      child: _isLoading?Loading(indicator: BallPulseIndicator(), size: 20.0):Text('Submit'),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      onPressed: () {


                        //The Sign Up button checks for below parameters

                          if(_image!=null  && _signUpForm.currentState.validate() && _isLoading==false) {
                            setState(() {
                              _isLoading = true;
                            });

                            //forms state is saved
                            _signUpForm.currentState.save();
                            student.verify = 0;
                            student.gender = genderToString(_genderValue);
                            student.category = _currentCategorySelected;

                            //Method made signUp if new user
                            FirestoreCRUD.signUp(student,_image).then((bool b){
                              if(b==true){
                                toast('Registered successfully');
                                Navigator.of(context).pop();
                              }
                              else
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }
                          else if(_image==null){
                            toast('Select an image');
                          }
                          else if(_isLoading){
                            toast("Please wait");
                          }

                      },
                    ),
                    Expanded(
                      child: Container(
                        width: 50.0,
                      ),
                    )
                  ],
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


  //fetches image from gallery
  Future getImage() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery
    );

    setState(() {
      _image = image;
    });
  }







}
