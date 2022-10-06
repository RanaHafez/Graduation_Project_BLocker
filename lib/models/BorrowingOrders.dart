import 'package:flutter/cupertino.dart';
import 'package:mytest/models/users.dart';

class BorrrowingOrder extends ChangeNotifier {
  String provider;
  List<Order> bookOrders = [];

  setProvider(String p) {
    this.provider = p;
    notifyListeners();
  }

  void addOrderToList(Order order) {
    bookOrders.add(order);
    notifyListeners();
  }

  void makeEmpty() {
    this.bookOrders = [];
    notifyListeners();
  }

  Order gettheOrderwher(String name , String provider){
    for (Order o in bookOrders){
      if(o.bookName == name && o.Orderprovider == provider){
        return o;
      }
    }
  }
}

class Order {
  String fromUser;
  String bookName;
  String password;
  bool inLocker = false;
  String Orderprovider;
  Order({this.fromUser , this.bookName , this.password , this.Orderprovider});

}