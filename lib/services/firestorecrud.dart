import 'package:attendance_student/classes/student.dart';
import 'package:attendance_student/screens/dashboard.dart';
import 'package:attendance_student/services/password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirestoreCRUD{
    //  This function looks for the document for login
    static Future<QuerySnapshot> getDocsForLogin(Student student,String inputPass) async {
      return await Firestore.instance.collection('stud')
          .where('regNo', isEqualTo: student.regNo)
          .where('pass', isEqualTo: Password.getHash(inputPass)).getDocuments();
    }


    //This function is called for login
    static Future<bool> login(BuildContext context,Student incoming,Student student,inputPass) async {
      FirestoreCRUD.getDocsForLogin(student,inputPass)
        .then((QuerySnapshot docs) {
        try {
          incoming = Student.fromMapObject(docs.documents[0].data);
          incoming.documentId = docs.documents[0].documentID;
          student = incoming;
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Dashboard(student)), (Route<dynamic> route) => false);

        }
        catch(e){
          Fluttertoast.showToast(
              msg: 'Wrong Credentials',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 10.0
          );
        print(e);
        }
      });
      return false;
    }

}