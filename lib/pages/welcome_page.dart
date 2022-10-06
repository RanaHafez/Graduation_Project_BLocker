//Super Clean
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:mytest/admin/admin_home.dart';
import 'package:mytest/main_screens/user_profile.dart';
import 'package:mytest/models/constants.dart';
import 'auth_form.dart';

class WelcomePage extends StatefulWidget {
  static const id = 'WelcomePage';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  void _submitAuthForm(String email, String password, String distrect,
      bool isLogin, BuildContext ctx) async {
      AuthResult authResult;
    try {
      if (isLogin) {
        authResult = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        print('hello inside the sign in');
        print(' user ID ${authResult.user.uid}');
      } else {
        authResult = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        print('creating the user');
        if(authResult != null) {Firestore.instance.collection('usersData').document(authResult.user.uid).setData({kBDistrectField: distrect, 'email': email, 'points': 100, 'role': 'user'});}

      }

      firebaseAuth.currentUser().then((user){
        Firestore.instance.collection('usersData').document(authResult.user.uid).get().then((value){
          if(value.exists){
            if(value.data['role'] == 'admin'){
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context)=> AdminHome(),));
            }else{
              Navigator.push(context , MaterialPageRoute(builder: (context) => UserProfilePage(userID: authResult.user.uid,),),);
              }
          }
        });
      });

//      Navigator.push(context , MaterialPageRoute(builder: (context) => UserProfilePage(userID: authResult.user.uid,),),);
    } on PlatformException catch (e) {
      print('hello');
      var message = 'Enter them right man';
      if (e.message != null) {
        setState(() {
          message = e.message;
        });
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    } catch (e) {
      print('WTH');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthForm(submitFn: _submitAuthForm),
    );
  }
}




















// Auth form
/*
* Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(),
            ),
          ),
        ),
      ),*/

// if theings went wrong
/*
* Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Welcome'.toUpperCase(), textAlign: TextAlign.center, style: kWelcome,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Lets share books as we want and be a community',textAlign: TextAlign.center, style: kWords,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: MediaQuery.of(context).size.height/ 6,
                  child: Image(
                    image: ExactAssetImage('images/large_forrest-owl.png'),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  RoundedButton(color: Colors.deepOrangeAccent,text: 'Log in',onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthForm()));},),
                  SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(color: Colors.deepPurpleAccent, text: 'Register', onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=> RegisterPage()));},),
                  )
                ],
              )
            ],
          ),
        ),
      ),
*
* */
