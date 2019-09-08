import 'package:flutter/material.dart';

class Student {
	String _regNo;
	String _pass;
	String _name;
	String _classId;
	String _gender;
	String _category;
	String _dob;
	String _email;
	String _mobile;
	String _documentId;

	Student.loginPage(this._regNo, this._pass);


	Student.blank();

	Student(this._regNo, this._pass, this._name, this._classId, this._gender,
		this._category, this._dob, this._email, this._mobile);

	String get mobile => _mobile;

	set mobile(String value) {
		_mobile = value;
	}


	String get documentId => _documentId;

	set documentId(String value) {
		_documentId = value;
	}

	String get email => _email;

	set email(String value) {
		_email = value;
	}

	String get dob => _dob;

	set dob(String value) {
		_dob = value;
	}

	String get category => _category;

	set category(String value) {
		_category = value;
	}

	String get gender => _gender;

	set gender(String value) {
		_gender = value;
	}

	String get classId => _classId;

	set classId(String value) {
		_classId = value;
	}

	String get name => _name;

	set name(String value) {
		_name = value;
	}

	String get pass => _pass;

	set pass(String value) {
		_pass = value;
	}

	String get regNo => _regNo;

	set regNo(String value) {
		_regNo = value;
	}

	//toMap method inserts data in firestore

	Map<String, String> toMap() {
		var map = Map<String, String>();
		map['regNo'] =_regNo;
		map['pass'] = _pass;
		map['name'] = _name;
		map['classId'] = _classId;
		map['gender'] = _gender;
		map['category'] = _category;
		map['dob'] = _dob;
		map['email'] = _email;
		map['mobile'] = _mobile;

		return map;
	}

	//fromMapObject method is used to define student after data is fetched from Firebase

	Student.fromMapObject(Map<String, dynamic> map) {
		this._regNo = map['regNo'];
		this._pass = map['pass'];
		this._name = map['name'];
		this._classId = map['classId'];
		this._gender = map['gender'];
		this._category = map['category'];
		this._dob = map['dob'];
		this._email = map['email'];
		this._mobile = map['mobile'];
	}

}