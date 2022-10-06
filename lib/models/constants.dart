import 'package:flutter/material.dart';
import 'instructor.dart';
const kWelcome = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Pacifico',
);
const kWords = TextStyle(
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Source Sans Pro',
);

const kTextField = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon: Icon(Icons.location_city,
      size: 50.0,color: Colors.white,),
    hintText: 'Enter the Location',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
      borderSide: BorderSide.none,
    )
);
const kBooksCollection = 'Books';
const kBNameField = 'book name';
const kBAutherNameField = 'auther';
const kBCategoryField = 'category';
const kBDescriptionField = 'description';
const kBDistrectField = 'distrect';
const kBURLField = 'image url';
const kBookAvailabilty = 'isAvailable';
const kUserData= 'UserData';
const kDistrectsCollesction = 'distrects';
const kdname = 'distrect';

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kbookNamestyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Pacifico',
  fontSize: 18,
  fontStyle: FontStyle.italic,
);
const kbookdescriptionstyle = TextStyle(
    color: Colors.black54,
    fontFamily: 'Pacifico',
    fontSize: 14,
);
const kbookauthorstyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Source Sans Pro',
    fontSize: 12,
);
const kbookCategorystyle = TextStyle(
  color: Colors.purple,
  fontFamily: 'Source Sans Pro',
  fontSize: 13,
);

const kHowToUseBorrow = Text(
    'Be sure to press the icon on top of the book. \n Notify the provider.\n Wait until the provider gives U the book. \n book is ready!! Choose the date of returning the book by pressing long. \n when u want to return the book press long.'
     , style: TextStyle(
  color: Colors.black,
  fontFamily: 'Source Sans Pro',
  fontSize: 15,
));

const kHowtoUseProvide = Text('when there is a request go put the book in locker\n press long to confirm that the book is shared \n U can not get the book until the borrower return \n once returned go get the book and press long to confirm \n Do not forget to rate the borrower' , style: TextStyle(
  color: Colors.black,
  fontFamily: 'Source Sans Pro',
  fontSize: 15,
));