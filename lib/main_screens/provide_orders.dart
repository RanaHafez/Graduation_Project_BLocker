
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mytest/db/store.dart';
import 'package:mytest/models/instructor.dart';
import 'package:mytest/models/reusable_container.dart';
import 'package:mytest/models/use_guide.dart';
import 'package:mytest/models/users.dart';
import 'package:mytest/pages/rating.dart';
class ProvisionOrders extends StatefulWidget {
  @override
  _ProvisionOrdersState createState() => _ProvisionOrdersState();
}

class _ProvisionOrdersState extends State<ProvisionOrders> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User cuser;
  currentUser(FirebaseAuth auth) async {
    FirebaseUser loggedIn = await auth.currentUser();
    User user = User(uemail: loggedIn.email, id: loggedIn.uid);
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

  bool _isChecked = false;

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
        title: Text('please confirm sharing your book',),
        elevation: 0.6,
        leading: Icon(FontAwesomeIcons.book),
        backgroundColor: Colors.purple[700],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: Firestore.instance.collection(
              'usersData/${cuser.id}/toProvideOrders').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return SpinKitPouringHourglass(color: Colors.purple[900], size: 150.0,);
            }
            return ListView.builder(itemBuilder: (context, index) {
              DocumentSnapshot bookRequest = snapshot.data.documents[index];
              return Column(
                children: [
                  if(bookRequest['lockerStatus'] == LockerStatus.IShared.toString())
                     ListTile(
                    enabled: !_isChecked,
                    focusColor:Colors.purple[500],
                    leading: _isChecked ?Checkbox(
                      value: _isChecked,
                      onChanged: (value) async{
                        setState(() {
                          _isChecked = value;
                        });
                        Store().inLocker(cuser.id, '${bookRequest['bookRequested']+bookRequest['password']}' , bookRequest['bookRequested'] , bookRequest['password']);
                        Store().notifyUser(bookRequest['borrower'], '${bookRequest['bookRequested']+bookRequest['password']}' , bookRequest['bookRequested'] , bookRequest['password']);


                      },): null,
                      title: Text('${bookRequest['bookRequested']}' , style : TextStyle(decoration: TextDecoration.lineThrough)),
                      subtitle: Text(_isChecked
                        ? 'Book is shared'
                        : 'Locker password: ${bookRequest['password']}',),
                       trailing: Text('U can not get your book yet \n ${bookRequest['locker']}'),
                  ),
                  if(bookRequest['lockerStatus'] == LockerStatus.ICanGetBack.toString())
                    ListTile(
                      enabled: !_isChecked,
                      focusColor: Colors.purple[300],
                      title: Text('${bookRequest['bookRequested']}' , style : TextStyle(decoration: TextDecoration.lineThrough)),
                      subtitle: Text(_isChecked
                          ? 'Book is shared'
                          : 'Locker password: ${bookRequest['password']}',),
                      trailing: Text('book is ready confirm that you recieved\n ${bookRequest['locker']}'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RateReader(userID: bookRequest['borrower'], bookRequested: bookRequest['bookRequested'], userRateID: cuser.id,lockerName: bookRequest['locker'],))).then((value) {
                          Store().updateLockerStatus(cuser.id, bookRequest['bookRequested'], bookRequest['password'], LockerStatus.IGetBack.toString(), 'toProvideOrders');
                        cuser.upoint = cuser.upoint + 3;
                        // we increase the points of the reader that has shared their book and given the rate for the reader that borrowed the book
                        Store().setPoints(cuser.id, cuser.upoint);
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('THANK U the borrowing process has come to the end'), duration: Duration(seconds: 3),));
                        });
                      },
                    ),
                  if(bookRequest['lockerStatus'] == LockerStatus.IGetBack.toString())
                    ReusableContainer(
                      c: Colors.purple[400],
                      cardChild: ListTile(
                        title: Text('${bookRequest['bookRequested']}' , style : TextStyle(decoration: TextDecoration.lineThrough)),
                        subtitle: Text('Completed'),
                      ),
                    ),
                  if(bookRequest['lockerStatus'] == LockerStatus.IRequest.toString())
                    ListTile(
                     enabled: !_isChecked, focusColor:Colors.deepPurple[300],
                     leading: !_isChecked? Checkbox(
                      value: _isChecked,
                     onChanged: (value) async{
                     setState(() {
                     _isChecked = value;
                     });
                     Store().inLocker(cuser.id, '${bookRequest['bookRequested']+bookRequest['password']}' , bookRequest['bookRequested'] , bookRequest['password']);
                     Store().notifyUser(bookRequest['borrower'], '${bookRequest['bookRequested']+bookRequest['password']}' , bookRequest['bookRequested'] , bookRequest['password']);
                     Store().updateLockerStatus(cuser.id, bookRequest['bookRequested'], bookRequest['password'], LockerStatus.IShared.toString(), 'toProvideBooks');
                     Store().updateLockerStatus(bookRequest['borrower'], bookRequest['bookRequested'], bookRequest['password'], LockerStatus.IShared.toString(), 'toProvideBooks');
                     },): null,
                    title: Text('${bookRequest['bookRequested']}' , style : TextStyle(decoration: TextDecoration.lineThrough)), subtitle: Text(_isChecked
              ? 'Book is shared'
                  : 'Locker password: ${bookRequest['password']}',),
              trailing: Text('Confirm that book is shared\n ${bookRequest['locker']}'),
                    ),
                  Divider(
                    height: 20,
                  ),
                ],
              );
            }, itemCount: snapshot.data.documents.length,);
          },
        ),
      ),
    );
  }
}

