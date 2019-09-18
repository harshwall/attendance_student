import 'package:attendance_student/classes/student.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

//	This screen is used to show the QrCode for attendance
class QrShow extends StatefulWidget {

	Student _student;
	QrShow(this._student);

	@override
	_QrShowState createState() => _QrShowState(_student);
}

class _QrShowState extends State<QrShow> {

	Student _student;
	_QrShowState(this._student);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('QR'),
			),
			body: Center(
				//	This widget outputs the qrCode for the Scanning with Student's documentId as unique Id
				child: QrImage(
					data: _student.documentId,
					version: QrVersions.auto,
					size: 300.0,
					backgroundColor: Colors.white,
				),
			)
		);
	}
}
