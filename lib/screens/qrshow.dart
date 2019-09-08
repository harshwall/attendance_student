import 'package:attendance_student/classes/student.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
