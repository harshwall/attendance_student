import 'package:flutter/material.dart';

class Student {
	String _regNo;
	String _pass;
	String _name;
	String _father;
	String _gender;
	String _category;
	DateTime _dob;
	String _email;
	String _mobile;
	String _documentId;

	Student.loginPage(this._regNo, this._pass);


	Student.blank();

	Student(this._regNo, this._pass, this._name, this._father, this._gender,
		this._category, this._dob, this._email, this._mobile, this._documentId);

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

	DateTime get dob => _dob;

	set dob(DateTime value) {
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

	String get father => _father;

	set father(String value) {
		_father = value;
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

	Map<String, dynamic> toMap() {
		Map<String, dynamic> map;
		map['regNo'] =_regNo;
		map['pass'] = _pass;
		map['name'] = _name;
		map['father'] = _father;
		map['gender'] = _gender;
		map['category'] = _category;
		map['dob'] = _dob;
		map['email'] = _email;
		map['mobile'] = _mobile;

		return map;
	}

	Student.fromMapObject(Map<String, dynamic> map) {
		this._regNo = map['regNo'];
		this._pass = map['pass'];
		this._name = map['name'];
		this._father = map['father'];
		this._gender = map['gender'];
		this._category = map['category'];
		this._dob = map['dob'];
		this._email = map['email'];
		this._mobile = map['mobile'];
	}

}