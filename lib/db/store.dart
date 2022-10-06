import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mytest/models/BorrowingOrders.dart';
import 'package:mytest/models/book.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/models/instructor.dart';
import 'package:mytest/models/locker.dart';
import 'package:mytest/models/test.dart';
import 'package:provider/provider.dart';
import 'package:mytest/db/auth_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Store extends ChangeNotifier{
  final Firestore _firestore = Firestore.instance;

// used in the add_book class
  void add_Book(context,Book book) async{
    String user_id = await Provider.of<AuthService>(context , listen: false).getCurrentUser();
    // user_id+book.bName.trim() is the id for the book in order to be unique
    _firestore.collection('Books').document(user_id+book.bName.trim()).setData({
      'provider_id': user_id,
      kBNameField :book.bName,
      kBAutherNameField :book.bAuther,
      kBDescriptionField :book.bDescription,
      kBURLField :book.bImageURL,
      kBCategoryField :book.bCategory,
      kBookAvailabilty :true,
    });
  }

// this method returns the list of books inside the collection  called 'Books'
  // used in the search screen
  Stream<QuerySnapshot> loadBooks()  {
    Stream<QuerySnapshot>  stream  =  _firestore.collection(kBooksCollection).snapshots();
    return stream;
  }
  //--------------------------------

  // used in the main screens of the provide orders
  Future inLocker(String providerId , String id , String bname , String password) async{
    CollectionReference s =  _firestore.collection('usersData/${providerId}/toProvideOrders');
    return await s.document(id).updateData({
      'bookRequested' : bname,
      'password' : password,
      'lockerStatus' :LockerStatus.IShared.toString(),
    });
  }

  // used also in the provide orders?
  Future notifyUser(String fromUser , String id , String bname , String password) async{
    CollectionReference s =  _firestore.collection('usersData/$fromUser/toBorrowOrders');
    return await s.document(id).updateData({
      'bookRequested' : bname,
      'password' : password,
      'lockerStatus' :LockerStatus.IBorrow.toString(),
    });
  }

  // used in the borrow requests main screens to update the time and the book
  Future setReturnDate(String borrower, String bname , String password , String date) async{
    CollectionReference s =  _firestore.collection('usersData/$borrower/toBorrowOrders');
    String id = bname+password;
    return await s.document(id).updateData({
      'bookRequested' : bname,
      'password' : password,
      'lockerStatus' :LockerStatus.IReceive.toString(),
      'returnDate': date
    });
  }

  // b or p is borrower or provider we invoke this and then we update the status for the b or p to maye IReturn or ICanGet back
  Future updateLockerStatus(String bOrP, String bname , String password, String lockerStatus , String collection) async{
    CollectionReference s =  _firestore.collection('usersData/$bOrP/$collection');
//    '${bookRequest['bookRequested']+bookRequest['password']}'
    String id = bname+password;
    // the id for the book
    return await s.document(id).updateData({
      'lockerStatus' :lockerStatus,
    });
  }

  // used in borrow requests and in provide requests
  Future setPoints(String userID, int point) async {
    // we reduce the coins for a particular user because it has exceeds the time it should return the book
    // we increase also the points
    CollectionReference s =  _firestore.collection('usersData');
    return await s.document(userID).updateData({
      'points': point
    });
  }

  // used in the add book
 increaseRate(String userID, double rate) async {
    var s =  _firestore.collection('usersData').document(userID).get();
    CollectionReference sS = _firestore.collection('usersData');
   var op = s.then((value) {
      var p = value.data['points'] + 2*rate;
      sS.document(userID).updateData({'points' : p});});
  }
  test(String id, BuildContext context) async {
    QuerySnapshot snapshot= await _firestore.collection('usersData/$id/toProvideOrders/').getDocuments();
    var prov = Provider.of<Test>(context, listen: false);
    snapshot.documents.forEach((element) {
      if(element.data['lockerStatus'] == LockerStatus.IRequest.toString()){
        prov.setN(1);
      }
    });
  }
//used in the request handller
  //  does not check the availablity updates the locker value
  setLockerAvailability(var d , bool tORf, String lockerName) async {
    var documentID;
    print('setLockerAvailability'+ d);
    QuerySnapshot sd = await _firestore.collection('distrects/$d/lockers/').getDocuments();
    CollectionReference s =  _firestore.collection('distrects/$d/lockers');
      sd.documents.forEach((element) {
        if (element.data['name'] == lockerName && element.data['isAvailable'] != tORf) {
            print('yes');
            print('availability ${element.data['isAvailable']}');
            print('locker name ${element.data['name']}');
            print('lockerID  ${element.documentID}');
            s.document(element.documentID).updateData(<String,bool>{
              'isAvailable' : tORf,
            });
            print('after update');
        }
      });
  }
  getUserDistrict(String userRateID, String lockerName) async {
     DocumentSnapshot ds = await Firestore.instance.collection('usersData').document(userRateID).get();
     print(ds.data['distrect']);
     // only pass the locker
     setLockerAvailability(ds.data['distrect'], true , lockerName);
  }

  // used in request handler and the rating
  setBookAvailable(String id , bool isAvailable) async{
    try {
    var cr =  _firestore.collection('Books').document(id);
    cr.updateData({
      'isAvailable': isAvailable,
    });
    }catch(e){
      print(e);
    }
  }



// for theDistrect used in order to get the document from the colletion wher the book should be exchanged
   getLockers(String d) async {
    var firestorE = Firestore.instance;
    var qn = await firestorE.collection('$kDistrectsCollesction/$d/lockers').getDocuments();
    print(qn.documents.length);
  }

  Future<List<Locker>> loadLockers(String d) async{
    var snapshot = await _firestore.collection('$kDistrectsCollesction/$d/lockers').getDocuments();
    List<Locker> lockers = [];
    for (var doc in snapshot.documents){
      var data = doc.data;
      lockers.add(Locker(
        name: data['name'],
        isAvailable: data['isAvailable'],
      ));
    }
    return lockers;
  }

// used to add adocument in the collection called bookOrders to keep track of who borrowed what book from whom
  bookOrdering(String bookName , String borrower , String provider) {
    DocumentReference f = _firestore.collection('bookOrders').document('$provider');
    f.setData({
      'from' : borrower,
      'book' : bookName,
      'to' : provider
    }).whenComplete(() {print('sucess');} );
  }

  // used locally inside the store for craeting the order
  Future<String> _gettingCurrentUser(FirebaseAuth auth) async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }

  // add to the provider
  addToProviderRequest(String providerID,String borrowerID,Order order , String state, String district, String lockerName) {
    CollectionReference snapshot = Firestore().collection('usersData/$providerID/toProvideOrders');
    snapshot.document('${order.bookName+order.password}').setData({
      'bookRequested' : order.bookName,
      'password' : order.password,
      'lockerStatus' : state,
      'borrower':borrowerID,
      'district' : district,
      'locker' : lockerName,
    }).whenComplete(() => 'Done adding');
  }
  // add to the Borrower
  void addToBorrowerRequest(Order order , String state, String district, String lockerName) {
    CollectionReference snapshot = Firestore().collection('usersData/${order.fromUser}/toBorrowOrders');
    snapshot.document('${order.bookName+order.password}').setData({
      'bookRequested' : order.bookName,
      'password' : order.password,
      'lockerStatus' : state,
      'provider' : order.Orderprovider,
      'district': district,
      'locker': lockerName,
    }).whenComplete(() => 'Done adding');
  }


  // the method that is used to update the distrect
  updateDistrect(String userID, String newDistrect){
    DocumentReference usersDataDocumentReference = _firestore.collection('usersData').document(userID);
    usersDataDocumentReference.updateData({
      'distrect' : newDistrect
    });
  }

}
