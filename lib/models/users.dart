import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User extends ChangeNotifier{
  String upassword;
  String uemail;
  String id;
  String udistrect;
  int upoint = 100;

  User({this.upassword,this.uemail,this.id , this.udistrect});

}