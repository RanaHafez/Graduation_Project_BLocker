
const disList = [
  'Al-Murjan' , 'Al-Basateen' ,'Al-Mohamadiya','Ash-Shati',
  'An-Nahda', 'An-Naeem','An-Nozha',' Az-Zahraa'
  ,'As-Salamah'
 , 'Al-Bawadi'
  ,'Ar-Rabwa' ,
  'As-Safa',
 'Al-Khalidiya',
  'Ar-Rawdha',
  'Al-Faysaliya',
  ' Al-Andalus',
  'Al-Aziziya',
  ' Ar-Rihab',
  'Al-Hamraa',
  'Al-Mosharafa'
  'Ar-Roweis',
  'Ash-Sharafiya',
  'Bani Malik',
  ' Al-Woroud',
  'An-Naseem',
  ' Al-Baghdadiya Ash-Sharqiya',
  'Al-Amariya',
  'Al-Hindawiya',
  ' As-Saheifa',
   'Al-Kandra',
  'As-Sulaimaniya',
  'Al-Thaalba',
  'As-Sabeel',
  'Al-Qurayat',
  'Gholail',
  ' An-Nozla Al-Yamaniya',
  ' Al-Nozla Ash-Sharqiya' ,
   'Al-Taghr ',
  'Al-Jamaa',
  'Madayin Al-Fahad',
  'Ar-Rawabi',
 ' Al-Wazeeriya',
 ' Petromin',
  'Al-Mahjar',
  'Prince Abdel Majeed',
  'Obhour Al-Janobiya',
 ' Al-Marwa',
  'AL-Fayhaa',
  'King Abdul Al-Aziz University',
   'Al-Baghdadiya Al-Gharbiya',
   'Al-Balad',
   'Al-Ajwad',
   'Al-Manar',
  'As-Samer',
   'Abruq Ar-Roghama',
   'Madinat As-Sultan',
  ' Um Hablain',
   'Al-Hamdaniya',
   'Al-Salhiya',
  'Mokhatat Al-Aziziya',
  'Mokhatat Shamal Al-Matar',
  'Mokhatat Ar-Riyadh',
  'Mokhatat Al-Huda',
   'Braiman',
   'Al-Salam',
   'Al-Mostawdaat',
   'Al-Montazahat',
   'Kilo 14',
   'Al-Harazat',
   'Um As-Salam' ,
   'Mokhtat Zahrat Ash-Shamal',
   'Al-Majid',
   'Gowieza',
  ' Al-Gozain',
   'Al-Kuwait',
  'Al-Mahrogat',
   'Al-Masfa',
  'Al-Matar Al-Gadeem (old airport)',
   'Al-Bokhariya',
  'An-Nour',
  'Bab Shareif'
   ,'Bab Makkah'
   ,'Bahra'
   ,'Al-Amir Fawaz'
   ,'Wadi Fatma'
   ,'Obhour Shamaliya'
  ,'At-Tarhil (deportation)'
  ,'Al-Iskan Al-janoubi',
  'At-Tawfeeq',
   'Al-Goaid'
   ,'Al-Jawhara'
   ,'Al-Jamoum'
   ,'Al-Khumra'
   ,'Ad-Difaa Al-Jawi (Air Defense)'
   ,'Ad-Dageeg'
   ,'Ar-Robou'
   ,'Ar-Rabie'
   ,'Ar-Rehaily'
   ,'As-Salmiya'
   ,'As-Sanabil'
   ,'As-Sinaiya (Bawadi)'
   ,'Industrial City (Mahjar)'
   ,'Al-Adl'
   ,'Al-Olayia'
   ,'Al-Faihaa'
   ,'Al-Karanteena'
   ,'Al-Ajaweed'
   ,'Al-Ahmadiya'
   ,'Al-Mosadiya'
   ,'East Al-Khat As-Sarei'
   , 'Kilo 10'
   ,'King Faisal Navy Base'
   ,'Kilo 7'
   ,'Kilo 3'
   ,'King Faisal Guard City'
   ,'Kilo 11'
   ,'Thowal'
  ,' Kilo 13'
  ,'Al-Makarona'
   ,'Al-Layth'
  ,'Al-Gonfoda'
   ,'Rabegh'
   ,'Kilo 8'
   ,'Kilo 5'
   ,'Kilo 2'
   ,'Al-Mokhwa'
   ,'National Guard Residence'
  ,' As-Showag'
 , 'Air Defense Residence'
   ,'Al-Morsalat'
   ,'Ash-Shoola'
   ,'Al-Corniche'
   ,'Al-Waha'
   ,'Mokhatat Al-Haramain'
  ,'Kholais'
];

enum LockerStatus{
  IRequest ,
  IShared ,
  IBorrow ,
  IReceive,
  IReturn ,
  ICanGetBack,
  IGetBack ,
}

// for the side var
/*

import 'package:flutter/material.dart';
import 'file:///C:/Users/menna/AndroidStudioProjects/my_test/lib/main_screens/add_book.dart';
import 'file:///C:/Users/menna/AndroidStudioProjects/my_test/lib/main_screens/notifications.dart';
import '../main_screens/search_screen.dart';
import 'package:mytest/models/constants.dart';

class MainSideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 30.0,bottom: 10.0),
                    color: Color(0xFF4E4F62),
                    child:  CircleAvatar(
                      radius: 100.0,
                      backgroundImage: ExactAssetImage('images/second_profile.jpg'),
                    ),
                  ),
                  Text('Rana Hafez Said', style: kWords,),
                  Text('xx@Gmail.com' ,style:  kWords,),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.person, color: Color(0xFF1A1F2C),),
                          title: Text('Profile'),
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.add, color: Color(0xFF1A1F2C),),
                          title: Text('Provide a Book'),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProvideBook(),),);

                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.search, color: Color(0xFF1A1F2C),),
                          title: Text('Search'),
                          onTap: (){
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen(),),);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.notifications, color: Color(0xFF1A1F2C),),
                          title: Text('Notifications'),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsPage(),),);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

 */
/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytest/models/constants.dart';
class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser provider;
  FirebaseUser loggedInUser ;
  void getCurrentUser() async {
    try{
      final borrower= await _auth.currentUser();
      if (borrower!= null){
        loggedInUser = borrower;
        print(loggedInUser.email);
      }
    }catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
//                messagesStream();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.deepPurpleAccent,
                  ),

//                  MessageBubble(isMe: true, sender: 'Hello', text: 'no we are here',),
//                  Expanded(
//                    child: TextField(
//                      onChanged: (value) {
//                        //Do something with the user input.
////                        messageText = value;
//                      },
//                      decoration: kMessageTextFieldDecoration,
//                    ),
//                  ),
//                  FlatButton(
//                    onPressed: () {
////                      messageTextController.clear();
//                      //Implement send functionality.
////                      _fireStore.collection('messages').add({
////                        'sender': loggedInUser.email,
////                        'text': messageText,
////                        'created_at': FieldValue.serverTimestamp(),
////                      },);
//                    },
//                    child: Text(
//                      'Send',
//                      style: kSendButtonTextStyle,
//                    ),
//                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text ;
  final String sender;
  final bool isMe;
  MessageBubble({this.text,this.sender, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end: CrossAxisAlignment.start ,
        children: <Widget>[
          Text(sender , style: TextStyle(
            fontSize: 10.0,
            color: Colors.black54,
          ),),
          Material(
            elevation: 3,
            color: isMe ? Colors.lightBlueAccent: Colors.white,
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)) : BorderRadius.only(topRight: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)),
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
              child: Text('$text'),
            ),
          ),
        ],
      ),
    );
  }
}
*/
