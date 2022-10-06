import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytest/models/BorrowingOrders.dart';
import 'package:mytest/models/locker.dart';
import 'package:uuid/uuid.dart';
class DatabaseManagement{
  Firestore _firestore = Firestore.instance;
  // c
  void addLocker(String name, String districtId, String d){
    var id = Uuid();
    String lockerId = id.v1();
    _firestore.collection('distrects').document(districtId).setData({'name': d});
    _firestore.collection('distrects/$districtId/lockers').document(lockerId).setData({'name': name , 'isAvailable':true});
  }
  // method for displaying all the book orders
  Future<List<Order>> loadBookOrders() async {
         var snapshot = await _firestore.collection('bookOrders').getDocuments();

         List<Order> orders = [];

         for (var doc in snapshot.documents){
           orders.add(Order(
             bookName: doc.data['book'],
             fromUser: doc.data['from'],
             Orderprovider: doc.data['to'],
           ));
         }

         return orders;
     }

     getDistricts(){
       return _firestore.collection('distrects').snapshots();
     }

     Future<List<DocumentSnapshot>> getLockersDocuments(String id) async{
       var doc = await _firestore.collection('distrects/$id/lockers').getDocuments().then((snaps) => snaps.documents);
     }

//    loadDistrictsAndLockers(String id,String district) async {
//       List<Locker> lockers = [];
//       List<DropdownMenuItem<String>> item = new List();
//       var doc = await _firestore.collection('distrects/$id/lockers').getDocuments();
//       for (var d in doc.documents){
//            List dd = d.data.values.toList();
//            print(dd);
//            lockers.add(Locker(
//              isAvailable: dd[0],
//              name: dd[1],
//            ));
//       }
//       getLockersDropdown(lockers);
//     }

  List<DropdownMenuItem<String>> getLockersDropdown(List<DocumentSnapshot> lockers) {
    List<DropdownMenuItem<String>> item = new List();
    for (DocumentSnapshot locker in lockers) {
      item.add(new DropdownMenuItem(
        child: Text(
          locker['name'],
        ),
        value: locker['name'],
      ));
    }
    return item;
  }
}