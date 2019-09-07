class Attendance {

	String _date;
	String _outcome;
	String _documentId;
	String _studentDocumentId;
	String _subjectDocumentId;

	Attendance(this._date, this._outcome);

	Attendance.blank();

	String get documentId => _documentId;

	set documentId(String value) {
		_documentId = value;
	}

	String get outcome => _outcome;

	set outcome(String value) {
		_outcome = value;
	}

	String get date => _date;

	set date(String value) {
		_date = value;
	}


	String get studentDocumentId => _studentDocumentId;

	set studentDocumentId(String value) {
		_studentDocumentId = value;
	}

	String get subjectDocumentId => _subjectDocumentId;

	set subjectDocumentId(String value) {
		_subjectDocumentId = value;
	}

	//toMap method is used to insert data in firestore
	Map<String, String> toMap() {
		var map = Map<String, String>();
		map['date'] = _date;
		map['outcome'] = _outcome;
		return map;
	}

	//fromMapObject is used to define Attendance instance after fetching data
	Attendance.fromMapObject(var doc) {
		this._date = doc.data['date'];
		this._outcome = doc.data['outcome'];
	}


}