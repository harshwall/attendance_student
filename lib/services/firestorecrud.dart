import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/dashboard.dart';
import 'package:attendance_student/services/password.dart';
import 'package:attendance_student/services/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirestoreCRUD{
    //  This function looks for the document for login
    static Future<QuerySnapshot> getDocsForLogin(Student student,String inputPass) async {
      return await Firestore.instance.collection('stud')
          .where('regNo', isEqualTo: student.regNo)
          .where('pass', isEqualTo: await compute(Password.getHash,inputPass)).getDocuments();
    }


    //This function is called for login
    static Future<void> login(BuildContext context,Student incoming,Student student,inputPass) async {
      await FirestoreCRUD.getDocsForLogin(student,inputPass)
        .then((QuerySnapshot docs) {
        try {
          incoming = Student.fromMapObject(docs.documents[0].data);
          incoming.documentId = docs.documents[0].documentID;
          student = incoming;
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Dashboard(student)), (Route<dynamic> route) => false);

        }
        catch(e){
          toast('Wrong credentials');
          print(e);
        }
      });
      return;
    }

    //This function is for sign up
    static Future<void> signUp(Student student) async {
      return await Firestore.instance.collection('stud').add(student.toMap());

    }

}