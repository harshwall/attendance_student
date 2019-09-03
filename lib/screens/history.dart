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
						title: Text(attendance.date),
						subtitle: Text(attendance.outcome),
					),
				);
			}
		});
		return listView;
  }
}