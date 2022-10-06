import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/admin/database_management.dart';
import 'package:mytest/models/instructor.dart';
class AddLocker extends StatefulWidget {
  @override
  _AddLockerState createState() => _AddLockerState();
}

class _AddLockerState extends State<AddLocker> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formkey = GlobalKey();
    TextEditingController _txC = TextEditingController();
    String d = '';

    void _lockerAlert() {
      var alert = AlertDialog(
        content: Form(
          key: _formkey,
          child: TextFormField(
            controller: _txC,
            validator: (value) {
              if (value.isEmpty) {
                return 'category cannot be empty';
              }
            },
            decoration: InputDecoration(hintText: 'Add Locker'),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              if (_txC.text != null) {
                DatabaseManagement().addLocker(_txC.text,d,d);
              }
              Fluttertoast.showToast(msg: 'Locker Created', backgroundColor: Colors.teal[300], textColor: Colors.black);
              Navigator.pop(context);
            },
            child: Text('add'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('cancel'),
          )
        ],
      );
      showDialog(context: context, builder: (_) => alert);
    }
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Add Locker'),
      ),
      body: SafeArea(
        child:ListView.builder(itemBuilder: (context, index){
          return FlatButton(
            onPressed: () {
              setState(() {
                d = disList[index];
              });
              _lockerAlert();
            },
              child: Text('${disList[index]}' ,
              ));
        }, itemCount: disList.length,) ,
      ),
    );
  }
}
