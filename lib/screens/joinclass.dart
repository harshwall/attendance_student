import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
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
											if (value.length != 8)
												return "Teacher's ID should be of length 8";
										},
										decoration: InputDecoration(
											labelText: "Teacher's ID",
											errorStyle: TextStyle(color: Colors.red),
											border: OutlineInputBorder(
												borderRadius: BorderRadius.circular(5.0))),
									),
								),
								Padding(
									padding: EdgeInsets.all(10.0),
									child: TextFormField(
										onSaved: (value) {
											_code = _code+value;
										},
										validator: (String value) {
											if (value.length != 6)
												return "Subject Code should be of length 6";
										},
										decoration: InputDecoration(
											labelText: "Subject Code",
											errorStyle: TextStyle(color: Colors.red),
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
										elevation: 10.0,
										onPressed: () {
											if (_createForm.currentState.validate()) {
												_createForm.currentState.save();
												setState(() {
													_isLoading=true;
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

	void sendCode() async {

		Map<String, String> map = Map<String,String>();
		map['docId'] = _student.documentId;

		var snapshot = await Firestore.instance.collection('stud').document(_student.documentId).collection('subject').where('subjectId', isEqualTo: _code.substring(8)).where('teacherId', isEqualTo: _code.substring(0,8)).getDocuments();

		if(snapshot.documents.length > 0) {
			toast('Bhadwa hai kya?');
			setState(() {
				_isLoading = false;
			});
			return;
		}

		snapshot = await Firestore.instance.collection('teach').where('teacherId', isEqualTo: _code.substring(0,8)).getDocuments();

		if(snapshot.documents.length > 0) {
			var subjectSnapshot = await Firestore.instance.collection('teach').document(snapshot.documents[0].documentID).collection('subject').where('subjectId',isEqualTo: _code.substring(8)).getDocuments();
			if(subjectSnapshot.documents.length > 0) {
				Firestore.instance.collection('teach').document(snapshot.documents[0].documentID).collection('subject').document(subjectSnapshot.documents[0].documentID).collection('studentsEnrolled').add(map);
				Map<String, String> addSubject = Map<String,String>();
				addSubject['subjectId'] = subjectSnapshot.documents[0].data['subjectId'];
				addSubject['subjectName'] = subjectSnapshot.documents[0].data['subjectName'];
				addSubject['teacherId'] = snapshot.documents[0].data['teacherId'];
				addSubject['absent'] = '0';
				addSubject['present'] = '0';
				Firestore.instance.collection('stud').document(_student.documentId).collection('subject').add(addSubject);
				Navigator.pop(context);
				toast('Class Added Successfully');
				return;
			}
			else {
				toast('Incorrect Joining Code');
				setState(() {
					_isLoading = false;
				});
			}
		}
		else {
			toast('Incorrect Joining Code');
			setState(() {
				_isLoading = false;
			});
		}
	}

}

