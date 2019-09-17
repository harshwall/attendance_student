import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/classes/subject.dart';
import 'package:attendance_student/screens/history.dart';
import 'package:attendance_student/screens/joinclass.dart';
import 'package:attendance_student/screens/login.dart';
import 'package:attendance_student/screens/profile.dart';
import 'package:attendance_student/screens/qrshow.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

	void initState() {
		super.initState();
		getURL();
	}

	//UI part of the dashboard starts
	@override
	Widget build(BuildContext context) {

		var top = 0.0;

		return Scaffold(
			body: NestedScrollView(
				headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled) {
					return <Widget>[
						SliverOverlapAbsorber(
							handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
							child: SliverSafeArea(
								top: false,
								sliver: SliverAppBar(
									backgroundColor: Colors.teal,
									expandedHeight: 170.0,
									floating: true,
									pinned: true,
									flexibleSpace: LayoutBuilder(
										builder: (BuildContext context, BoxConstraints constraints) {
											top = constraints.biggest.height;
											return FlexibleSpaceBar(
												centerTitle: true,
												title: AnimatedOpacity(
													duration: Duration(milliseconds: 300),
													opacity: top < 90.0 ? 1.0: 0.0,
													child: Text('Dashboard'),
												),
												background: Card(
													elevation: 20.0,
													color: Colors.teal,
													child: Row(
														mainAxisAlignment: MainAxisAlignment.spaceEvenly,
														children: <Widget>[
															Align(
																alignment: Alignment.center,
																child: CircleAvatar(
																	radius: 50.0,
																	backgroundColor: Colors.teal,
																	child: ClipOval(
																		child: SizedBox(
																			width: 100.0,
																			height: 100.0,
																			child: _url!=null?Image.network(_url):
																			DecoratedBox(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/default.png'))))
																		),
																	),
																),
															),
															Column(
																mainAxisAlignment: MainAxisAlignment.center,
																crossAxisAlignment: CrossAxisAlignment.start,
																children: <Widget>[
																	Container(
																		child:Text(
																			_student.name,
																			textScaleFactor: 2,
																			style: TextStyle(color: Colors.white),
																		),
																	),
																	Container(
																		child: Text(
																			_student.regNo,
																			textScaleFactor: 1.5,
																			style: TextStyle(color: Colors.white),
																		),
																	),
																	Container(
																		child: Text(
																			_student.classId,
																			textScaleFactor: 1.5,
																			style: TextStyle(color: Colors.white),
																		),
																	),
																],
															)
														]
													),
												)
											);
										},
									)
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
				backgroundColor: Colors.teal,
			),
			drawer: Drawer(
				child: ListView(
					children: <Widget>[
						DrawerHeader(
							child: Icon(Icons.account_circle),
						),
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
								clearSharedPrefs(_student);
								Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Login()), (Route<dynamic> route) => false);
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

				double percent = getPercent(subject);
				return GestureDetector(
					onTap: () {
						Navigator.push(context, MaterialPageRoute(builder: (context) {
							return History(subject);
						}));

					},
					child: Card(
						child: ListTile(
							title: Text(subject.subjectId+'  '+subject.subjectName),
							subtitle: Text(predictFuture(subject)),
							trailing: CircularPercentIndicator(
								radius: 50.0,
								lineWidth: 5.0,
								percent: percent,
								center: Text((percent*100).toInt().toString()+'%'),
								progressColor: percent>=.75 ? Colors.green: Colors.red,
							)
						),
					),
				);
			}
		});
		return listView;
	}

	double getPercent(Subject subject) {
		if(int.parse(subject.present)+int.parse(subject.absent) == 0)
			return 0.0;
		return int.parse(subject.present)/(int.parse(subject.present)+int.parse(subject.absent));
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

	String predictFuture(Subject subject) {
		int p = int.parse(subject.present);
		int a = int.parse(subject.absent);
		if(p == 3*a)
			return "You can't miss the next class.";
		else if(p > 3*a) {
			int temp = (p/3-a).toInt();
			if(temp == 0)
				return "You can't miss the next class.";
			else if(temp == 1)
				return 'You may leave next '+temp.toString()+' class';
			else
				return 'You may leave next '+temp.toString()+' classes';
		}
		else {
			int temp = 3*a-p;
			return 'Attend next '+temp.toString()+' classes to get back on track';
		}
	}

	void clearSharedPrefs(Student student) async {
		final SharedPreferences prefs = await SharedPreferences.getInstance();
		prefs.setString('storedObject', '');
		prefs.setString('storedId', '');
	}
}