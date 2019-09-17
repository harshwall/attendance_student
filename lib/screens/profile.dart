import 'dart:io';
import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/login.dart';
import 'package:attendance_student/services/firestorecrud.dart';
import 'package:attendance_student/services/password.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

class Profile extends StatefulWidget {

	Student _student;
	Profile(this._student);

	@override
	_ProfileState createState() => _ProfileState(_student);
}

class _ProfileState extends State<Profile> {

	var _profileForm = GlobalKey<FormState>();
	var _passKey = GlobalKey<FormFieldState>();

	Student _student;
	_ProfileState(this._student);
	File _image;
	String _url;

	int _genderValue;
	bool _isLoading=false;

	String inputPass;

	final dateFormat = DateFormat("yyyy-MM-dd");
	DateTime dateTime;

	var categoryList = ['Open', 'OBC', 'SC/ST', 'Other'];
	var _currentCategorySelected;

	@override
	void initState() {
		super.initState();
		dateTime = DateTime.parse(_student.dob);
		_currentCategorySelected = _student.category;
		_genderValue = stringToGender(_student.gender);
		getImageNetwork();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('SignUp'),
			),
			body: Container(
				padding: EdgeInsets.all(5.0),
				child: Form(
					key: _profileForm,
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
														child: (_image!=null)
															?Image.file(_image,fit: BoxFit.fill)
															:(_url==null? DecoratedBox(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/default.png'))))
															: Image.network(
															_url,
															fit: BoxFit.fill,
														))
														,
													),
												),
											),

										),
										Padding(
											padding: EdgeInsets.only(top: 60.0),
											child: _student.verify==1?Icon(Icons.block):IconButton(
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
										readOnly: _student.verify==1,
										initialValue: _student.name,
										onSaved: (value) {
											_student.name = value;
										},
										validator: (String value) {
											if (value.isEmpty)
												return 'Enter Name';
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Name',
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
										),
									),
								),
								Padding(
									padding: EdgeInsets.all(5.0),
									child: TextFormField(
										readOnly: _student.verify==1,
										obscureText: true,
										key: _passKey,
										onSaved: (value) {
										},
										validator: (String value) {
											if (value.length<6 && value.length>0)
												return 'Password too short';
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Password (Leave blank if not Using)',
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
										),
									),
								),
								Padding(
									padding: EdgeInsets.all(5.0),
									child: TextFormField(
										readOnly: _student.verify==1,
										obscureText: true,
										onSaved: (value) {
											inputPass = value;
										},
										validator: (String value) {
											if ((value.length<6 && value.length>0) || _passKey.currentState.value != value )
												return "Passwords don't match";
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Confirm Password',
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
										),
									),
								),
								Padding(
									padding: EdgeInsets.all(5.0),
									child: TextFormField(
										initialValue: _student.regNo,
										readOnly: true,
										onSaved: (value) {
											_student.regNo = value;
										},
										validator: (String value) {
											if (value.length!=8)
												return 'Enter Registration Number';
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Registration Number',
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
										),
									),
								),
								Padding(
									padding: EdgeInsets.all(5.0),
									child: TextFormField(
										initialValue: _student.classId,
										readOnly: true,
										onSaved: (value) {
											_student.classId = value;
										},
										validator: (String value) {
											if (value.length != 5)
												return "Enter valid Class ID";
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: "Class Id",
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
										),
									),
								),
								Padding(
									padding: EdgeInsets.all(5.0),
									child: TextFormField(
										readOnly: _student.verify==1,
										initialValue: _student.email,
										onSaved: (value) {
											_student.email = value;
										},
										validator: (String value) {
											if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
												return 'Enter Correct Email';
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Email',
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
										),
									),
								),
								Padding(
									padding: EdgeInsets.all(5.0),
									child: TextFormField(
										readOnly: _student.verify==1,
										initialValue: _student.mobile,
										keyboardType: TextInputType.number,
										onSaved: (value) {
											_student.mobile = value;
										},
										validator: (String value) {
											if (!RegExp("[0-9]").hasMatch(value) || value.length!=10)
												return 'Enter Mobile Number';
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Mobile Number',
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
										),
									),
								),
								Padding(
									padding: EdgeInsets.all(5.0),
									child: DateTimeField(
										readOnly: _student.verify==1,
										initialValue: DateTime.parse(_student.dob),
										format: dateFormat,
										onShowPicker: (context, currentValue) {
											return showDatePicker(
												context: context,
												initialDate: dateTime,
												firstDate: DateTime(1970),
												lastDate: DateTime(2050));
										},
										onSaved: (value) {
											_student.dob = value.toString();
										},
										validator: (DateTime value) {
											if(!isDate(value.toString()) || value == null || value.compareTo(DateTime.now().subtract(Duration(days: 1))) >= 0)
												return 'Enter correct DOB';
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Date of Birth',
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0)
											)
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
												onChanged: _student.verify==1?null:(int i) {
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
												onChanged: _student.verify==1?null:(int i) {
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
												onChanged: _student.verify==1?null:(int i) {
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
												hint: Text(_student.category),
												items: categoryList.map((String value) {
													return DropdownMenuItem<String>(
														value: value,
														child: Text(value)
													);
												}).toList(),
												value: _currentCategorySelected,
												onChanged: _student.verify==1?null:(String newValue ) {
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
										_student.verify==1?Icon(Icons.block):RaisedButton(
											color: Colors.black,
											child: _isLoading?Loading(indicator: BallPulseIndicator(), size: 20.0):Text('Submit', style: TextStyle(color: Colors.white)),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(30.0)
											),
											onPressed: () {
												//The Sign Up button checks for below parameters
												if(_profileForm.currentState.validate() && _isLoading==false) {
													setState(() {
														_isLoading = true;
													});

													//forms state is saved
													_profileForm.currentState.save();
													_student.verify = 0;
													_student.gender = genderToString(_genderValue);
													_student.category = _currentCategorySelected;

													//Method made signUp if new user
													if(inputPass.length==0) {
														FirestoreCRUD.profileUpdate(_student,_image, false).then((bool b){
															if(b==true){
																toast('Updated successfully');
																Navigator.of(context).pop();
															}
															else
																setState(() {
																	_isLoading = false;
																});
														});
														inputPass = '';
													}
													else {
														compute(Password.getHash,inputPass).then((hash) {
															_student.pass = hash;
															FirestoreCRUD.profileUpdate(_student,_image ,true).then((bool b){
																if(b==true){
																	toast('Updated successfully');
																	clearSharedPrefs(_student);
																	Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Login(false)), (Route<dynamic> route) => false);
																}
																else
																	setState(() {
																		_isLoading = false;
																	});
															});
														});

													}
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

	int stringToGender(String gender) {
		switch(gender) {
			case 'Male':
				return 0;
			case 'Female':
				return 1;
			default:
				return 2;
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

	void getImageNetwork() async {
		FirebaseStorage.instance.ref().child(_student.regNo).getDownloadURL().then((storedUrl) {
			setState(() {
				_url = storedUrl;
			});
		});
	}

	void clearSharedPrefs(Student student) async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		prefs.setString('storedObject', '');
		prefs.setString('storedId', '');
	}
}



