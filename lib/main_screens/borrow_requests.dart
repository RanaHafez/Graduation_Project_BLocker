/*

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'file:///C:/Users/menna/AndroidStudioProjects/my_test/lib/main_screens/add_book.dart';
import 'file:///C:/Users/menna/AndroidStudioProjects/my_test/lib/main_screens/notifications.dart';
import 'file:///C:/Users/menna/AndroidStudioProjects/my_test/lib/main_screens/user_profile.dart';
import 'search_screen.dart';

class HomePage extends StatefulWidget {

  static const id = 'UserProPage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavBar = 0;
  final _auth = FirebaseAuth.instance;
  FirebaseUser LoggedInUser;
  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser();
      if(user !=null){
        LoggedInUser = user;
      }
    }
    catch(e) {
      print(e);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  PageController _pageController = PageController();
  List<Widget> _screens = [
    UserProfilePage(),
    SearchScreen(),
    ProvideBook(),
    NotificationsPage(),
  ];
  int _selectedIndex;
  void _onPageChanged(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onTapped(int selectedIndex){
    setState((){_bottomNavBar = selectedIndex;});
    _pageController.jumpToPage(selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _bottomNavBar,
        fixedColor: Colors.pink,
        onTap: _onTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text('profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Borrow Book'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Share Book'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            title: Text('Return Book'),
          ),
        ],
      ) ,
      appBar: AppBar(
        title: Text(
          'BLOCKER' , style: TextStyle(color: Colors.red),
        ),
       leading: IconButton(icon:  Icon(FontAwesomeIcons.signOutAlt), onPressed: (){_auth.signOut();Navigator.pop(context);},),
      ),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}



//        ],
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/db/store.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/models/instructor.dart';
import 'package:mytest/models/reusable_container.dart';
import 'package:mytest/models/use_guide.dart';
import 'package:mytest/models/users.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class BorrowRequest extends StatefulWidget {
  @override
  _BorrowRequestState createState() => _BorrowRequestState();
}

class _BorrowRequestState extends State<BorrowRequest> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User cuser;
  DateTime _dateReturn = DateTime.now();
  currentUser(FirebaseAuth auth) async{
    FirebaseUser loggedIn= await auth.currentUser();
    User user = User(uemail: loggedIn.email , id: loggedIn.uid);
    setState(() {
      cuser = user;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    currentUser(auth);
    super.initState();
  }
  bool _isChecked= false;

  Widget buildBottomSheet(BuildContext context)=>Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple[900],
        child: Icon(FontAwesomeIcons.question , color: Colors.white,),
        onPressed: (){
          showModalBottomSheet(context: context, builder: (BuildContext context) => HowToUse());
        },
      ),
      appBar: AppBar(
        title: Text('Please wait till the Provider confirm'),
        elevation: 0.6,
        leading: Icon(FontAwesomeIcons.bookOpen),
        backgroundColor: Colors.purple[700],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: Firestore().collection('usersData/${cuser.id}/toBorrowOrders').snapshots(),
            builder: (context , snapshot){
            try {
              if (snapshot.hasError || snapshot.data == null) {
                return Center(child: Text('Something went wrong',));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text('Loading.......'),);
              }
              if (!snapshot.hasData){
                return SpinKitPouringHourglass(color: Colors.purple[900], size: 150.0,);
              }
              if(
              snapshot.connectionState == ConnectionState.none
              ){
                return Center(child: Text('No data........'),);
              }
              var data = snapshot.data;
              if (snapshot.hasData)
                return ListView.builder(itemBuilder: (context, index) {
                  DocumentSnapshot bookRequest = snapshot.data.documents[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                          child: Text(
                        'Press long to complete the recieving',
                        style: kWords,)),
                      if(bookRequest['lockerStatus'] ==
                          LockerStatus.IBorrow.toString())
                        ListTile(
                          leading: Icon(FontAwesomeIcons.book),
                          title: Text(
                              '${bookRequest['bookRequested']} available in Locker \n ${bookRequest['locker']}'),
                          subtitle: Text(_isChecked
                              ? 'Book is yours'
                              : 'Locker password: ${bookRequest['password']}'),
                          onLongPress: () async {
                            DateTime x = await showDatePicker(context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(Duration(days: 1)),
                                lastDate: DateTime(2021),
                                helpText: 'Select booking Date',
                                cancelText: 'Not Now',
                                confirmText: 'Book',
                                builder: (context, child){
                                   return Theme(
                                     data: ThemeData.dark(),
                                     child: child,
                                   );
                                },
                            );
                            setState(() {
                              _dateReturn = x;
                            });
                            if (_dateReturn != null) {
                              await Store().setReturnDate(
                                  cuser.id, bookRequest['bookRequested'],
                                  bookRequest['password'],
                                  _dateReturn.toString());
                            } else {
                              print(null);
                            }
                          },
                        ),
                      // IREQUEST NO PROBLEMS
                      if(bookRequest['lockerStatus'] ==
                          LockerStatus.IRequest.toString())
                        ListTile(
                          title: Text('${bookRequest['bookRequested']}'),
                          subtitle: Text('Still not in Locker Waiting'),
                        ),
                      if(bookRequest['lockerStatus'] ==
                          LockerStatus.IReceive.toString())
                        ListTile(
                          leading: Icon(FontAwesomeIcons.book),
                          title: Text(
                              '${bookRequest['bookRequested']} is all yours \n ${bookRequest['locker']}'),
                          subtitle: Text(_isChecked
                              ? 'Book is yours'
                              : 'Locker password: ${bookRequest['password']}'),
                          trailing: Text(message(bookRequest['returnDate']),
                            style: TextStyle(color: Colors.red, fontSize: 10),),
                          onTap: () {
                            cuser.upoint = cuser.upoint - 3;
                            alertBeforeReturning(
                                password: bookRequest['password'],
                                p: bookRequest['provider'],
                                newPoint: cuser.upoint,
                                context: context,
                                name: bookRequest['bookRequested'],
                                b: cuser.id,
                                dater: bookRequest['returnDate']);
                          },
                        ),
                      if(bookRequest['lockerStatus'] ==
                          LockerStatus.IReturn.toString())
                        ReusableContainer(
                          c: Colors.deepPurple[200],
                          cardChild: ListTile(
                            leading: Icon(FontAwesomeIcons.book),
                            title: Text('${bookRequest['bookRequested']}',
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough)),
                            subtitle: Text(_isChecked
                                ? 'Book is yours'
                                : 'Locker password: ${bookRequest['password']}\n ${bookRequest['locker']}',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough),),
                          ),
                        ),
                    ],
                  );
                }
                , itemCount: snapshot.data.documents.length,
              );
            }catch(e){
              print(e);
            }
          },


        ),
      ),
    );
  }
}


String message(String s){
  var date = DateTime.parse(s);
  var duration = date.difference(DateTime.now());
  if(duration.isNegative) return 'URLATE BY ${duration.inDays} days and ${duration.inHours} hours left';
  else return 'U HAve ${duration.inDays} days and ${duration.inHours} hours left';
}

Widget alertBeforeReturning({String p ,String b,int newPoint, String name , String password , String dater, BuildContext context}){
  var date = DateTime.parse(dater);
  var duration = date.difference(DateTime.now());
     Alert(
      context: context,
      type: AlertType.warning,
      title: "WARNINIG ALERT",
      desc: "DO YOU WANT TO RETURN THIS?",
      buttons: [
        DialogButton(
          child: Text(
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            if(duration.isNegative){
              Store().setPoints(b, newPoint);
              // we reduce the coins for a particular user because it has exceeds the time it should return the book
            }
            // for the borrower
            Store().updateLockerStatus(b, name, password, LockerStatus.IReturn.toString() , 'toBorrowOrders');
            // for the provider
            Store().updateLockerStatus(p, name, password, LockerStatus.ICanGetBack.toString() , 'toProvideOrders');
            Navigator.pop(context);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('YOU HAVE CONFIRMED RETURNING THE BOOK THANK YOU') ,duration: Duration(seconds: 10),));
          },
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "NOPE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();

}

