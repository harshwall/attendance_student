import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/classes/subject.dart';
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

	List<Subject> subjects;

	DashboardState(this._student);

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
												mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
																		"https://www.google.co.in/images/branding/googlelogo/1x/googlelogo_color_272x92dp.png",
																		fit: BoxFit.fill,
																	),
																),
															),
														),

													),
													Container(
														child: Card(
															child: Text(
																_student.name,
																textScaleFactor: 1.5,
															),
														),
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
				body: getSubjects()
			),
			floatingActionButton: FloatingActionButton(
				child: Icon(Icons.add),
				onPressed: () {

				},
				tooltip: 'Join New Class',
				backgroundColor: Colors.blueAccent,
			),
		);
	}
	
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

  getSubjectList(AsyncSnapshot<QuerySnapshot> snapshot) {

		var listView = ListView.builder(itemBuilder: (context, index) {
			if(index<snapshot.data.documents.length) {
				var doc = snapshot.data.documents[index];
				return ListTile(
					title: Text(doc.data['subjectId']),
					subtitle: Text(doc.data['teacherId']),
				);
			}
		});

//		List<ListTile> temp = snapshot.data.documents
//			.map((doc) {
//				ListTile(
//					title: Text(doc.data['subjectId']),
//					subtitle: Text(doc.data['teacherId']),
//			);
//				debugPrint(doc.data['subjectId']);
//				debugPrint(doc.documentID);
//			})
//			.toList();
		return listView;
  }
}