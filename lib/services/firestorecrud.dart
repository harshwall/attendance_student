import 'dart:convert';
import 'dart:io';
import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/dashboard.dart';
import 'package:attendance_student/services/password.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase_widget.dart';

class FirestoreCRUD{
    //  This function looks for the document for login
    static Future<QuerySnapshot> getDocsForLogin(Student student,String inputPass) async {
        return await Firestore.instance.collection('stud')
            .where('regNo', isEqualTo: student.regNo)
            .where('pass', isEqualTo: await compute(Password.getHash,inputPass)).getDocuments();
    }

    //This function is called for loginresults[index].question,
    static Future<bool> login(BuildContext context,Student student,inputPass, bool getHelp) async {
        Student incoming = Student.blank();
        bool value=false;
        await FirestoreCRUD.getDocsForLogin(student,inputPass)
            .then((QuerySnapshot docs) {
            try {
                incoming = Student.fromMapObject(docs.documents[0].data);
                incoming.documentId = docs.documents[0].documentID;
                student = incoming;
                value=true;
                storeData(student);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ShowCaseWidget(child: Dashboard(student, getHelp))), (Route<dynamic> route) => false);
            }
            catch(e){
                toast('Wrong credentials');
                print(e);
                value=false;
            }
        });
        return value;
    }

    //This function is for sign up
    static Future<bool> signUp(Student student,File _image) async {
        int length=0;

        //checking if user already exists
        await Firestore.instance.collection('stud').where('regNo',isEqualTo: student.regNo).getDocuments().then((QuerySnapshot docs){
            length=docs.documents.length;
        });
        if(length>0) {
            toast('User already exists. Please login');
            return false;
        }
        student.pass=await compute(Password.getHash,student.pass);
        await uploadPic(student,_image);
        await Firestore.instance.collection('stud').add(student.toMap());
        return true;
    }

    static Future<bool> profileUpdate(Student student, File _image, bool newPassword) async {
        if(newPassword) {
            await Firestore.instance.collection('stud').document(student.documentId).updateData({'name': student.name, 'pass': student.pass, 'gender': student.gender, 'category': student.category, 'dob': student.dob, 'email': student.email, 'mobile': student.mobile});
        }
        else
            await Firestore.instance.collection('stud').document(student.documentId).updateData({'name': student.name, 'gender': student.gender, 'category': student.category, 'dob': student.dob, 'email': student.email, 'mobile': student.mobile});

        if(_image!=null)
            await uploadPic(student, _image);
        return true;
    }

    //This function uploads the image
    static Future uploadPic(Student student,File _image) async {
        String fileName = 'avatar_'+student.regNo;
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        toast(taskSnapshot.toString());
    }

    static void storeData(Student student) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('storedObject', json.encode(student.toMap()));
        prefs.setString('storedId', student.documentId);
    }
}