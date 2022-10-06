import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mytest/db/store.dart';
import 'package:mytest/models/BorrowingOrders.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/models/instructor.dart';
import 'package:mytest/models/locker.dart';
import 'package:mytest/models/reusable_container.dart';
import 'package:mytest/models/users.dart';
import 'package:provider/provider.dart';
class RequestHandeller extends StatefulWidget {
  final String provider_id;
  final String chosenBook;
  final String distrect_of_p;
  RequestHandeller({this.provider_id , this.chosenBook , this.distrect_of_p});
  static const id = 'Register';
  @override
  _RequestHandellerState createState() => _RequestHandellerState();
}

class _RequestHandellerState extends State<RequestHandeller> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  User cuser;
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
  Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Borrowing Process' , style: kWelcome,),
        backgroundColor: Colors.purple[700],
      ),
      body: FutureBuilder<List<Locker>>  (
        future:  Store().loadLockers(widget.distrect_of_p),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return SpinKitPouringHourglass(color: Colors.purple[900],size: 150.0,);
          }
          if(snapshot.connectionState == ConnectionState.done){
            return ListView.builder(
              itemBuilder: (context,index){
                return Column(
                  children: [
                    Container(
                      color: snapshot.data[index].isAvailable?Colors.purple[100]:Colors.red[100],
                      child: ListTile(
                        trailing: Text('Lockers of ${widget.distrect_of_p}'),
                        title: Text(snapshot.data[index].name),
                        leading:Text(snapshot.data[index].isAvailable? 'Available': 'Not Available'),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 200,
                      width: 400,
                      color: Colors.purple[400],
                      child: Column(
                        children: [
                          Text(''),
                          Container(
                            child: Image.asset('images/icons8-reading-unicorn-100.png'),
                          ),
                          if(snapshot.data[index].isAvailable)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('the locker is available'),
                                Text('All you need to do is to Notify the book owner'),
                                FlatButton(
                                  child: Text('Notify User'),
                                  color: Colors.purple[300],
                                  onPressed: (){
                                    if(snapshot.data[index].isAvailable){
                                      var prov = Provider.of<BorrrowingOrder>(context , listen: false);
                                      Order _order = Order(bookName: widget.chosenBook, fromUser: cuser.id, password: Locker().generatePassword(true, true, true, true, 17) , Orderprovider: widget.provider_id);
                                      prov.setProvider(widget.provider_id);
                                      prov.addOrderToList(_order);
                                      Store().addToProviderRequest(prov.provider,cuser.id,_order , LockerStatus.IRequest.toString() , widget.distrect_of_p ,snapshot.data[index].name);
                                      Store().addToBorrowerRequest(_order ,  LockerStatus.IRequest.toString(),widget.distrect_of_p ,snapshot.data[index].name);
                                      Store().bookOrdering(widget.chosenBook, cuser.id, prov.provider);
                                      Store().setLockerAvailability(widget.distrect_of_p, false, snapshot.data[index].name);
                                      // setting the book availability
                                      Store().setBookAvailable(prov.provider+widget.chosenBook.trim(), false);
                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Provider has been notified')));
                                      Navigator.pop(context);
                                    }else{
                                      Fluttertoast.showToast(msg: 'not Available', backgroundColor: Colors.red[200], );
                                    }
                                  },
                                )
                              ],
                            ),
                          if(!snapshot.data[index].isAvailable)
                            Text('The locker is not availble right now try later'),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    )
                  ],
                );
              }, itemCount: snapshot.data.length,);
          }
        },
      )
    );
  }



}

/*
*
*  // ignore: unnecessary_statements
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Center(child: Text('NONE'));
            case ConnectionState.waiting:
              return Center(child: Text('Waiting'));
            case ConnectionState.done:
              print(snapshot.data[0]['isAvailable']);Locker _locker = Locker(isAvailable: snapshot.data[0]['isAvailable']);
              return Center(
                child: Container(
                  height: 300,
                  width: 400,
                  color: Colors.purple[200],
                  child: Center(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('${snapshot.data[0]['distrect']}'),
                        Container(
                          child: Image.asset('images/icons8-reading-unicorn-100.png'),
                        ),
                        if(snapshot.data[0]['isAvailable'])
                          Column(
                            children: [
                              Text('the locker is available'),
                              Text('All you need to do is to Notify the book owner'),
                              FlatButton(child: Text('Notify the provider'),
                                onPressed: (){
                                var prov = Provider.of<BorrrowingOrder>(context , listen: false);
                                // create an order with a random password
                                Order _order = Order(bookName: widget.chosenBook, fromUser: cuser.id, password: _locker.generatePassword(true, true, true, true, 17) , Orderprovider: widget.provider_id);
                                prov.setProvider(widget.provider_id);
                                prov.addOrderToList(_order);
                                Store().addToProviderRequest(prov.provider,cuser.id,_order , LockerStatus.IRequest.toString());
                                Store().addToBorrowerRequest(_order ,  LockerStatus.IRequest.toString());
                                Store().bookOrdering(widget.chosenBook, cuser.id, prov.provider);
                                // setting the locker availability
                               Store().setLockerAvailability(widget.distrect_of_p , false);
                                // setting the book availability
                               Store().setBookAvailable(prov.provider+widget.chosenBook.trim(), false);
                               // telling the Borrower that the Provider is notified
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Provider has been notified')));
                                Navigator.pop(context);
                              }, color: Colors.purple[700],),
                            ],
                          ),
                        if(!snapshot.data[0]['isAvailable'])
                          Text('The locker is not availble right now try later'),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return Text('default');
          }
        },*/