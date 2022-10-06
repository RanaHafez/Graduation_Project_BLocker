import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/models/constants.dart';
class HowToUse extends StatelessWidget {
  static const String id = 'HowtoUse';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          )
        ),
        child: Column(
          children: [
            CircleAvatar(backgroundColor: Colors.purple[500],child: Icon(FontAwesomeIcons.question, size: 30.0,color: Colors.white,)),
            Text('As a Borrower' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0 , decoration: TextDecoration.underline), ),
            kHowToUseBorrow,
            Text('As a Provider' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0, decoration: TextDecoration.underline),),
            kHowtoUseProvide,
          ],
        ),
      ),
    );
  }
}
