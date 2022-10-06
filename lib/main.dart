
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytest/db/auth_service.dart';
import 'package:mytest/main_screens/add_book.dart';
import 'package:mytest/main_screens/search_screen.dart';
import 'package:mytest/main_screens/user_profile.dart';
import 'package:mytest/models/BorrowingOrders.dart';
import 'package:mytest/models/test.dart';
import 'package:mytest/models/use_guide.dart';
import 'package:mytest/models/users.dart';
import 'package:mytest/pages/rating.dart';
import 'package:path/path.dart';
// import 'file:///C:/Users/menna/AndroidStudioProjects/my_test/lib/main_screens/borrow_requests.dart';
import 'pages/request_handeller.dart';
import 'pages/auth_form.dart';
import 'pages/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  // here i hae the provider in order to have the ordering content
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthService>(create: (context) => AuthService(),),
      ChangeNotifierProvider<BorrrowingOrder>(create: (context) => BorrrowingOrder(),),
      ChangeNotifierProvider<User>(create: (context) => User(),),
      ChangeNotifierProvider<Test>(create: (context) => Test(),),
    ],
    child: MaterialApp(
      theme: ThemeData.light(),
      home: WelcomePage(),

      routes:{
        AuthForm.id : (context) => AuthForm(),
        WelcomePage.id: (context) => WelcomePage(),
        ProvideBook.id : (context)=> ProvideBook(),
        SearchScreen.id : (context)=> SearchScreen(),
        RequestHandeller.id : (context)=> RequestHandeller(),
        RateReader.id : (context)=> RequestHandeller(),
        HowToUse.id : (context)=> HowToUse(),
      },
    ),
  ),);
}