//the Rating code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/db/store.dart';
import 'package:mytest/models/reusable_container.dart';
import 'package:mytest/models/constants.dart';
class RateReader extends StatefulWidget {
  static const String id = 'Rate';
  // the rated user
  final String userID;
  final String bookRequested;
  // the user that rates
  final String userRateID;
  final String lockerName;
  RateReader({this.userID , this.bookRequested , this.userRateID, this.lockerName});
  @override
  _RateReaderState createState() => _RateReaderState();
}

class _RateReaderState extends State<RateReader> {
  var writtenAns = 'Could be better';
  var sliderVal = 0.0;
  IconData myFeedBack = FontAwesomeIcons.sadCry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.purple[700],
        title: Text('BLOCKER'),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Text(
                'Rate the User ',
                style: kWelcome,
                textAlign: TextAlign.center,
              ),
              Expanded(
                flex: 4,
                child: ReusableContainer(
                  c: Colors.purple[200],
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(myFeedBack, color: Colors.purple[700], size: 200.0,),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 20.0),
                          thumbColor: Colors.purple[200],
                          overlayShape: RoundSliderOverlayShape(
                              overlayRadius: 20.0),
                          overlayColor: Colors.purple[300],
                        ), child: Slider(
                        value: sliderVal,
                        inactiveColor: Colors.white,
                        activeColor: Colors.purple[300],
                        min: 0,
                        max: 5,
                        divisions: 5,
                        onChanged: (newVal) {
                          try {
                            if (mounted) {
                              setState(() {
                                sliderVal = newVal;
                                if (newVal == 0 || newVal == 1) {
                                  myFeedBack = FontAwesomeIcons.sadCry;
                                  writtenAns = 'OH GOD that is very bad';
                                } else if (newVal == 2 || newVal == 3) {
                                  myFeedBack = FontAwesomeIcons.sadTear;
                                  writtenAns = 'Could BE Better';
                                } else if (newVal == 4 || newVal == 5) {
                                  myFeedBack = FontAwesomeIcons.smile;
                                  writtenAns = 'Excellent';
                                }
                              });
                            }
                          } catch (e) {
                            print('the exception is from on changed $e');
                          }
                        },
                      ),
                      ),
                      Text(
                        'your Rate is $writtenAns', style: kWelcome,
                      )
                    ],
                  ),
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text('submit', style: kWelcome,),
                color: Colors.purple[200],
                onPressed: () async {
                  try {
                    if (sliderVal >= 3) {
                      increaseRate(widget.userID, sliderVal);
                    } else {
                      increaseRate(widget.userID, -sliderVal);
                    }
                    Store().getUserDistrict(widget.userRateID , widget.lockerName);
                    Store().setBookAvailable(widget.userRateID+widget.bookRequested.trim(), true);
//                    Store().setBookAvailable(, isAvailable)
                    Navigator.pop(context);
                  } catch (e) {
                    print('exeption is from the on pressed: $e');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// do not know what is this
increaseRate(String userID, double rate) async {
  Firestore _firestore = Firestore.instance;
  var s =  _firestore.collection('usersData').document(userID).get();
  CollectionReference sS = _firestore.collection('usersData');
  var op = s.then((value) {
    var p = value.data['points'] + 2*rate;
    sS.document(userID).updateData({'points' : p});});
}