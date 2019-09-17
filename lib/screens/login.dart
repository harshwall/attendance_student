import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/signup.dart';
import 'package:attendance_student/services/firestorecrud.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class Login extends StatefulWidget {

	bool getHelp;
	Login(this.getHelp);

	@override
	State<StatefulWidget> createState() {
		return LoginState(getHelp);
	}
}

class LoginState extends State<Login> {

	bool getHelp;
	LoginState(this.getHelp);

	var _loginForm = GlobalKey<FormState>();
	Student student = Student.blank();
	String inputPass="";
	bool _isLoading=false;

	//UI part of Login
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
										onSaved: (value) {
											student.regNo = value;
										},
										validator: (String value) {
											if (value.length != 8)
												return 'Incorrect Registration Number';
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Registration Number',
											errorStyle: TextStyle(color: Colors.red),
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
											else
												return null;
										},
										decoration: InputDecoration(
											labelText: 'Password',
											errorStyle: TextStyle(color: Colors.red),
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
										elevation: 10.0,
										onPressed: () {
											if (_loginForm.currentState.validate() && _isLoading==false) {
												_loginForm.currentState.save();
												//starting to load
												setState(() {
													_isLoading=true;
												});
												//An async is called to verify login
												FirestoreCRUD.login(context,student, inputPass, getHelp).then((bool value){
													setState(() {
														_isLoading=value;
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
											//Button shows the signup screen
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
			)
		);
	}
}
