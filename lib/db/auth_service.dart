

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytest/admin/admin_home.dart';
class AuthService extends ChangeNotifier{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //used in the store class
  Future<String> getCurrentUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  authorizeAccess(BuildContext context){
    _firebaseAuth.currentUser().then((user) {
      Firestore.instance.collection('usersData').getDocuments().then((value){
        if(value.documents[0].exists){
          if(value.documents[0].data['role'] == 'admin'){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> AdminHome()));
          }
        }});
    });
  }
}