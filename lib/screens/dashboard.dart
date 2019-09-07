import 'package:attendance_student/classes/attendance.dart';
import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/classes/subject.dart';
import 'package:attendance_student/screens/history.dart';
import 'package:attendance_student/screens/joinclass.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {

	Student _student;

	Dashboard(this._student);

	@override
	State<StatefulWidget> createState() {

		return DashboardState(_student);
	}

}

class DashboardState extends State<Dashboard> {

	Student _student;



	DashboardState(this._student);

	//UI part of the dashboard starts

	@override
	Widget build(BuildContext context) {

		return Scaffold(
			body: NestedScrollView(
				headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled) {
					return <Widget>[
						SliverOverlapAbsorber(
							handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
							child: SliverSafeArea(
								top: false,
								sliver: SliverAppBar(
									expandedHeight: 200.0,
									floating: true,
									pinned: true,
									flexibleSpace: FlexibleSpaceBar(
										centerTitle: true,
										title: Text('Dashboard'),
										background: Card(
											child: Row(
												mainAxisAlignment: MainAxisAlignment.spaceAround,
												children: <Widget>[
													Align(
														alignment: Alignment.center,
														child: CircleAvatar(
															radius: 50.0,
															backgroundColor: Colors.blueAccent,
															child: ClipOval(
																child: SizedBox(
																	width: 100.0,
																	height: 100.0,
																	child: Image.network(
																		"https://d2x5ku95bkycr3.cloudfront.net/App_Themes/Common/images/profile/0_200.png",
																		fit: BoxFit.fill,
																	),
																),
															),
														),

													),
													Column(
														mainAxisAlignment: MainAxisAlignment.center,
														children: <Widget>[
															Container(
																	child:Text(
																			_student.name,
																			textScaleFactor: 1.5,
																		),
																),
															Container(
																	child: Text(
																			_student.regNo,
																			textScaleFactor: 1.5,
																		),
																),
															Container(
																	child: Text(
																			"IT B",
																			textScaleFactor: 1.5,
																		),
																	),
														],
													)
												]

											),
										)
									),
								),
							),
						)

					];
				},
					//The dynnamic card view appBar ends here


					//Body shows the list of subjects student has
				body: getSubjects()
			),


			//Floating action button to join new class
			floatingActionButton: FloatingActionButton(
				child: Icon(Icons.add),
				onPressed: () {
					Navigator.push(context, MaterialPageRoute(builder: (context) {
						return JoinClass(_student);
					}));

				},
				tooltip: 'Join New Class',
				backgroundColor: Colors.blueAccent,
			),
		);
	}


	//Fetches subjects of th estudent fom the database
	Widget getSubjects() {
		return StreamBuilder<QuerySnapshot> (
			stream: Firestore.instance.collection('stud').document(_student.documentId).collection('subject').snapshots(),
			builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
				if(!snapshot.hasData)
					return Text('Loading');
				return getSubjectList(snapshot);
			},
		);
	}


	//This method returns a list view of subjects
  getSubjectList(AsyncSnapshot<QuerySnapshot> snapshot) {

		var listView = ListView.builder(itemBuilder: (context, index) {
			if(index<snapshot.data.documents.length) {
				var doc = snapshot.data.documents[index];
				Subject subject = Subject.fromMapObject(doc);
				subject.documentId = doc.documentID;
				subject.studentDocumentId = _student.documentId;
				return GestureDetector(
					onTap: () {


						//Simple toast

						toast(subject.subjectId+' '+subject.teacherId+ ' '+ subject.subjectName+ ' '+ subject.documentId);
						Navigator.push(context, MaterialPageRoute(builder: (context) {
							return History(subject);
						}));

					},
					child: Card(
						child: ListTile(
							title: Text(subject.subjectId),
							subtitle: Text(subject.subjectName),
						),
					),
				);
			}
		});

		return listView;
  }
}