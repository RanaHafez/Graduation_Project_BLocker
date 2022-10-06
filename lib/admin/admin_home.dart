import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/admin/add_locker.dart';
import 'package:mytest/admin/display_orders_page.dart';

class AdminHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _signOut() async{
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Admin Profile'),
        leading: IconButton(icon: Icon(FontAwesomeIcons.signOutAlt),onPressed: _signOut,),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                color: Colors.teal[400],
                child: Text('Add Locker'),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context)=> AddLocker()));
                },
              ),
              RaisedButton(
                color: Colors.teal[400],
                child: Text('book Orders'),
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder:(BuildContext context)=> DisplayOrder()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
