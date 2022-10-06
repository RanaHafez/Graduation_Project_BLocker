
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/db/store.dart';
import 'package:mytest/models/book.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/models/users.dart';
import 'package:mytest/pages/request_handeller.dart';

class SearchScreen extends StatefulWidget {
  static const id = 'search';
  final String cUserID;
  SearchScreen({this.cUserID});
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Stream<QuerySnapshot> stream = Store().loadBooks();
//  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('Search for a Book' , style: kWelcome,),
        backgroundColor: Colors.purple[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Books').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text('Loading....'));
            } else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot book = snapshot.data.documents[index];
                  String _documentID = snapshot.data.documents[index].documentID;
                    return Stack(
                        children: [
                            Column(
                              children: [
                                // displaying only book that are available and do not belong to the user
                              if(book[kBookAvailabilty] && !_documentID.startsWith(widget.cUserID))
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  height: 350.0,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.0, left: 8.0),
                                    child: Material(
                                      color: Colors.purple[200],
                                      elevation: 14.0,
                                      shadowColor: Colors.grey,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100.0),),
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width,
                                                height: 200,
                                                child: Image(
                                                  image: NetworkImage(
                                                      '${book[kBURLField]}'),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              SizedBox(height: 20,),
                                              Text(
                                                  '${book[kBNameField]}' , style: kbookNamestyle,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(FontAwesomeIcons.bookOpen),
                                                  SizedBox(width: 12.0,),
                                                  Text('${book[kBCategoryField]}' , style: kbookCategorystyle,),
                                                ],
                                              ),
                                              SizedBox(height: 10,),
                                              Text(
                                                '${book[kBDescriptionField]}', style: kbookdescriptionstyle,),



                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          // displaying only available books and the books that do not belong to the user
                          if(book[kBookAvailabilty] && !_documentID.startsWith(widget.cUserID) )
                            Container(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                backgroundColor: Colors.purple[700],
                                child: IconButton(
                                  onPressed: () async {

                                      bool cool = false;
                                      Stream<QuerySnapshot> s =  Firestore.instance.collection('usersData').snapshots();
                                      s.listen((data) {
                                        data.documents.forEach((element) {
                                          if(element.documentID == book['provider_id']){
                                            var distect;
                                            setState(() {
                                              distect = element['distrect'];
                                              cool = !cool;
                                            });
                                            if (cool && distect != null){
                                              print('$distect');
                                              Navigator.push(context, MaterialPageRoute(
                                            builder: (context) =>
                                                RequestHandeller(
                                                    provider_id: book['provider_id'],
                                                    distrect_of_p : distect,
                                                    chosenBook: book[kBNameField])));
                                            }
                                          }
                                        });
                                      });
                                  },
                                  icon: Icon(Icons.book),
                                ),
                              ),
                            ),
                        ],
                    );
    }
              );
            }
          } //builder
          ),
    );
  }
}


