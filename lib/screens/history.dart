import 'package:attendance_student/classes/attendance.dart';
import 'package:attendance_student/classes/subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class History extends StatefulWidget {

	Subject _subject;

	History(this._subject);

	@override
  _HistoryState createState() => _HistoryState(_subject);
}

class _HistoryState extends State<History> {

	Subject _subject;

	_HistoryState(this._subject);

	@override
  Widget build(BuildContext context) {
    return Scaffold(
		appBar: AppBar(
			title: Text('History'),
		),
		body: getHistory(),
	);
  }


  //It returns the stream builder of that particular subject after running firebase queries.
  Widget getHistory() {
  	return StreamBuilder<QuerySnapshot> (
		stream: Firestore.instance.collection('stud').document(_subject.studentDocumentId).collection('subject').document(_subject.documentId).collection('attendance').orderBy("date", descending: true).snapshots(),
		builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
			if(!snapshot.hasData)
				return Text('Loading');
			return getHistoryList(snapshot);
		},
	);
  }

  //returns the attendance as a list view
  getHistoryList(AsyncSnapshot<QuerySnapshot> snapshot) {

		var listView = ListView.builder(itemBuilder: (context, index) {
			if(index<snapshot.data.documents.length) {
				var doc = snapshot.data.documents[index];
				Attendance attendance = Attendance.fromMapObject(doc);
				attendance.documentId = doc.documentID;
				attendance.studentDocumentId = _subject.studentDocumentId;
				attendance.subjectDocumentId = _subject.documentId;
				return Card(
					child: ListTile(
						leading: attendance.outcome == 'P' ?
						Container(
							margin: EdgeInsets.all(15.0),
							width: 10.0,
							height: 10.0,
							decoration: BoxDecoration(
								shape: BoxShape.circle,
								color: Colors.green
							),
						):
						Container(
							margin: EdgeInsets.all(15.0),
							width: 10.0,
							height: 10.0,
							decoration: BoxDecoration(
								shape: BoxShape.circle,
								color: Colors.red,
							),
						),
						title: Text(attendance.date),
						trailing: Text(attendance.duration+' Hours'),
					),
				);
			}
		});
		return listView;
  }
}
