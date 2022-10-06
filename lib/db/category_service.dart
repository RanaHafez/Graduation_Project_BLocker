import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
class CategoryService{
  Firestore _firestore = Firestore.instance;
  // both of them are used
  void createCategory(String name){
    var id = Uuid();
    String categoryId = id.v1();
    _firestore.collection('categories').document(categoryId).setData({'category': name});
  }
  // used in the add_book class

  Future<List<DocumentSnapshot>> getCategoriesDocuments(){
    return _firestore.collection('categories').getDocuments().then((snaps){return snaps.documents;});
  }

  // related to category
  List<DropdownMenuItem<String>> getCategoriesDropdown(List<DocumentSnapshot> categories) {
    List<DropdownMenuItem<String>> item = new List();
    for (DocumentSnapshot category in categories) {
      item.add(new DropdownMenuItem(
        child: Text(
          category['category'],
        ),
        value: category['category'],
      ));
    }
    return item;
  }


}