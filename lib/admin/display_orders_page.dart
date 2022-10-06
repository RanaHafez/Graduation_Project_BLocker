import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytest/admin/database_management.dart';
import 'package:mytest/models/BorrowingOrders.dart';
class DisplayOrder extends StatefulWidget {
  @override
  _DisplayOrderState createState() => _DisplayOrderState();
}

class _DisplayOrderState extends State<DisplayOrder> {
  Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: Text('Book Orders'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Order>>(
          future: DatabaseManagement().loadBookOrders(),
          builder: (context, snapshot){
            return ListView.builder(itemBuilder: (context, index){
              return Column(
                children: [
                  Container(
                    color: Colors.teal[100],
                    child: ListTile(
                      leading: Text('${snapshot.data[index].bookName}\n from ${snapshot.data[index].fromUser}\n to${snapshot.data[index].Orderprovider}'),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              );},
            itemCount: snapshot.data.length,

            );
          },
        ),
      ),
    );
  }
}
