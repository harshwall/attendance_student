//Class to uniquely create a subject in firestore

class Subject {

	String _subjectId;
	String _teacherId;
	String _subjectName;
	String _documentId;
	String _present;
	String _absent;
	String _studentDocumentId;

	Subject(this._subjectId, this._teacherId, this._subjectName);

	Subject.blank();


	String get present => _present;

	set present(String value) {
		_present = value;
	}

	String get absent => _absent;

	set absent(String value) {
		_absent = value;
	}

	String get subjectName => _subjectName;

	set subjectName(String value) {
		_subjectName = value;
	}

	String get teacherId => _teacherId;

	set teacherId(String value) {
		_teacherId = value;
	}

	String get subjectId => _subjectId;

	set subjectId(String value) {
		_subjectId = value;
	}


	String get documentId => _documentId;

	set documentId(String value) {
		_documentId = value;
	}


	String get studentDocumentId => _studentDocumentId;

	set studentDocumentId(String value) {
		_studentDocumentId = value;
	}

	//toMap method inserts data in firestore

	Map<String, String> toMap() {
		var map = Map<String, String>();
		map['subjectId'] = _subjectId;
		map['teacherId'] = _teacherId;
		map['subjectName'] = _subjectName;
		return map;
	}

	//fromMapObject method is used to define student after data is fetched from Firebase

	Subject.fromMapObject(var doc) {
		this._subjectId = doc.data['subjectId'];
		this._teacherId = doc.data['teacherId'];
		this._subjectName = doc.data['subjectName'];
		this._absent = doc.data['absent'];
		this._present = doc.data['present'];
	}


}