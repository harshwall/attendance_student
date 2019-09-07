import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class JoinClass extends StatefulWidget {

	Student _student;


	JoinClass(this._student);

	@override
  _JoinClassState createState() => _JoinClassState(_student);
}

class _JoinClassState extends State<JoinClass> {

	Student _student;

	_JoinClassState(this._student);

	var _createForm = GlobalKey<FormState>();

	String _code="";
	bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
		appBar: AppBar(
			title: Text('Join Class'),
		),
		body: Container(
			padding: EdgeInsets.all(10.0),
			child: Form(
				key: _createForm,
				child: Center(
					child: Column(
						children: <Widget>[
							Padding(
								padding: EdgeInsets.all(10.0),
								child: TextFormField(
									onSaved: (value) {
										_code = value;
									},
									validator: (String value) {
										if (value.length != 12)
											return "Enter correct Code";
									},
									decoration: InputDecoration(
										labelText: "Joining Code",
										errorStyle: TextStyle(color: Colors.yellow),
										border: OutlineInputBorder(
											borderRadius: BorderRadius.circular(5.0))),
								),
							),
							Padding(
								padding: EdgeInsets.all(10.0),
								child: RaisedButton(
									child: _isLoading?Loading(indicator: BallPulseIndicator(), size: 20.0):Text('Create'),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(30.0),
									),
									elevation: 20.0,
									onPressed: () {
										if (_createForm.currentState.validate()) {
											_createForm.currentState.save();
											setState(() {
//												_isLoading=true;
											});
											sendCode();


										}
									}),
							),
						],
					),
				),
			),
		),
	);
  }
	void sendCode() {

  	Map<String, String> map = Map<String,String>();

  	map['studentId'] = _student.documentId;
  	map['studentName'] = _student.name;



  	bool flag = false;
		Firestore.instance.collection('teach').snapshots().listen((data) {
			for( var doc in data.documents) {
				Firestore.instance.collection('teach').document(doc.documentID).collection('subject').snapshots().listen((data2) {
					for( var sub in data2.documents) {
						if(sub['joiningCode'] == _code) {
							flag = true;
							Firestore.instance.collection('teach').document(doc.documentID).collection('subject').document(sub.documentID).collection('studentclass').add(map);
							Map<String, String> addSubject = Map<String,String>();
							addSubject['subjectId'] = sub['subjectId'];
							addSubject['subjectName'] = sub['subjectName'];
							addSubject['teacherId'] = doc['teacherId'];
							Firestore.instance.collection('stud').document(_student.documentId).collection('subject').add(addSubject);
							Navigator.pop(context);
							return;
						}
					}
				});
			}
		});
	}


	}

