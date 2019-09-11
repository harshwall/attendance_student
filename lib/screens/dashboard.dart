import 'package:attendance_student/classes/attendance.dart';
import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/classes/subject.dart';
import 'package:attendance_student/screens/history.dart';
import 'package:attendance_student/screens/joinclass.dart';
import 'package:attendance_student/screens/profile.dart';
import 'package:attendance_student/screens/qrshow.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
	String _url;


	int present=0;
	int absent=0;

	void initState() {
		super.initState();
		getURL();
	}

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
																	child: _url!=null?Image.network(_url):
																	Image.network(
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
					if(_student.verify ==1)
						Navigator.push(context, MaterialPageRoute(builder: (context) {
							return JoinClass(_student);
						}));
					else
						toast('Your profile is not verified');

				},
				tooltip: 'Join New Class',
				backgroundColor: Colors.blueAccent,
			),

			drawer: Drawer(
				child: ListView(
					children: <Widget>[
						ListTile(
							title: Text('Profile'),
							onTap: () {
								Navigator.push(context, MaterialPageRoute(builder: (context) {
									return Profile(_student);
								}));
							},
						),
						ListTile(
							title: Text('QR Code'),
							onTap: () {
								Navigator.pop(context);
								Navigator.push(context, MaterialPageRoute(builder: (context) {
									return QrShow(_student);
								}));

							},
						),
						ListTile(
							title: Text('Sign Out'),
							onTap: () {

							},
						)
					],
				),
			),
		);
	}


	//Fetches subjects of the student fom the database
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
						Navigator.push(context, MaterialPageRoute(builder: (context) {
							return History(subject);
						}));

					},
					child: Card(
						child: ListTile(
							title: Text(subject.subjectId+'  '+subject.subjectName),
							subtitle: Text(subject.teacherId),
							trailing: getCount(subject),
						),
					),
				);
			}
		});

		return listView;
  }
  
  Widget getCount(Subject subject) {
		return Container(
			width: 50,
			child: Row(
				children: <Widget>[
					getPresentCount(subject),
					Container(
						width: 10,
					),
					getAbsentCount(subject)
				],
			),
		);
  }

  Widget getPresentCount(Subject subject) {
		return StreamBuilder<QuerySnapshot>(
			stream: Firestore.instance.collection('stud').document(_student.documentId).collection('subject').document(subject.documentId).collection('attendance').where('outcome', isEqualTo: 'P').snapshots(),
			builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
				if(!snapshot.hasData)
					return Text('0');
				present = snapshot.data.documents.length;
				return Text(snapshot.data.documents.length.toString());
			},
		);
  }

	Widget getAbsentCount(Subject subject) {
		return StreamBuilder<QuerySnapshot>(
			stream: Firestore.instance.collection('stud').document(_student.documentId).collection('subject').document(subject.documentId).collection('attendance').where('outcome', isEqualTo: 'A').snapshots(),
			builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
				if(!snapshot.hasData)
					return Text('0');
				absent = snapshot.data.documents.length;
				return Text(snapshot.data.documents.length.toString());
			},
		);
	}

  void getURL() async{
		String url;
	  StorageReference ref = FirebaseStorage.instance.ref().child(_student.regNo);
	  url = (await ref.getDownloadURL()).toString();
	  print(url);

	  setState(() {
	    _url = url;
	  });

  }
}