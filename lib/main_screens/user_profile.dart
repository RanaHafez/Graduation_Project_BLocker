// seems free from errors
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mytest/db/store.dart';
import 'package:mytest/main_screens/add_book.dart';
import 'package:mytest/main_screens/borrow_requests.dart';
import 'package:mytest/main_screens/provide_orders.dart';
import 'package:mytest/main_screens/search_screen.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/models/instructor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mytest/models/test.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatefulWidget {
  static const id = 'UserProfile';
  final String userID;
  UserProfilePage({this.userID});
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Firestore _firestore = Firestore.instance;
  bool doUpdate = false;
  String _distrect = disList[0];

  DropdownButton<String> Dropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String dis in disList) {
      var newItem = DropdownMenuItem(
        child: Text(dis),
        value: dis,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      dropdownColor: Colors.purple[100],
      value: _distrect,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          _distrect = value;
          Store().updateDistrect(widget.userID, _distrect);
          doUpdate = !doUpdate;
        });
      },
    );
  }

  // signout the user

  _signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  void initState(){
    // TODO: implement initState
    Store().test(widget.userID, context);
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text('BLocker', style: kWelcome,),
        leading: Icon(FontAwesomeIcons.bookReader),
        actions: [
          IconButton(icon: Icon(FontAwesomeIcons.signOutAlt), onPressed: (){ _signOut(); Navigator.pop(context);},)
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Text('${provv.n.toString()}'),
//      ),
      body:  SafeArea(
        child: FutureBuilder(
          future: _firestore.collection('usersData').document('${widget.userID}').get(),
          builder: (context , snapshot){
            if(snapshot.connectionState==ConnectionState.waiting)
              return SpinKitHourGlass(color: Colors.purple[900], size: 100.0,);
            if(snapshot.connectionState == ConnectionState.done)
              return SingleChildScrollView(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundColor: Colors.purple[100],
                            child: Image(image: ExactAssetImage('images/icons8-reading-unicorn-100.png'),),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                              child: ListTile(leading: Icon(Icons.email, color: Colors.purple[800],),
                                title: Text('${snapshot.data['email']}'),
                              ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.purple[100],
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.purple[100],
                            ),
                            child: ListTile(leading: Image(
                              image: ExactAssetImage('images/icons8-coins-64.png'),
                              height: 30.0,
                            ),
                              title: Text(
                              '${snapshot.data['points']}', style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Source Sans Pro',
                              color: Colors.black,
                            ),
                            ),
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.purple[100],
                            ),
                            child: ListTile(
                              leading: Icon(Icons.home),
                              title: Text(snapshot.data['distrect']),
                              trailing: FlatButton(
                                child: Text(!doUpdate?'Update': 'no', style: TextStyle(fontWeight: FontWeight.bold),),
                                onPressed: (){
                                  setState(() {
                                    doUpdate = !doUpdate;
                                  });
                                },
                            ),
                          ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          if(doUpdate)
                            Center(child: Dropdown()),
                        ],
                      ),
                      SizedBox(
                        height: 40.0,
                        child: Divider(
                        color: Colors.purple[700],
                      ),),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, ProvideBook.id);
                              },
                              color: Colors.purple[200],
                              child: Text('Add Book'),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            FlatButton(
                              color: Colors.purple[200],
                              onPressed: () {
                                if(snapshot.data['points'] > 10) {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SearchScreen(cUserID: widget.userID,)));
                                }else{
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('YOU ARE NOT ALLOWED TO BORROW ONLY until your points increase'),));
                                }
                                },
                              child: Text('Search a book'),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 12.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FlatButton(
                            color: Colors.purple[200],
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => BorrowRequest()));
                            },
                            child: Text('Your requests to borrow'),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FlatButton(
                            color: Colors.purple[200],
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => ProvisionOrders()));
                            },
                            child: Text('requests to provide'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
        ),
      );
  }
}
