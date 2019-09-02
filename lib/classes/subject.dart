import 'package:flutter/material.dart';

class Subject {

	String _subjectId;
	String _teacherId;
	String _subjectName;

	Subject(this._subjectId, this._teacherId, this._subjectName);

	Subject.blank();

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

	Map<String, String> toMap() {
		var map = Map<String, String>();
		map['subjectId'] = _subjectId;
		map['teacherId'] = _teacherId;
		map['subjectName'] = _subjectName;
		return map;
	}

	Subject.fromMapObject(Map<String, String> map) {
		this._subjectId = map['subjectId'];
		this._teacherId = map['teacherId'];
		this._subjectName = map['subjectName'];
	}


}