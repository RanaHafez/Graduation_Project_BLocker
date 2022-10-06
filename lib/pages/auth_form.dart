// Here we have implemented 2 classes that can be used late
// the first class is a statless and called UNCHANGED TEXT
// the seconf is called Take input

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/models/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:mytest/models/instructor.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthForm extends StatefulWidget {
  static const id = 'AuthPage';
  final void Function(String email, String password, String distrect,
      bool isLogin, BuildContext ctx) submitFn;
  AuthForm({this.submitFn});
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  var _isLogin = true;
  AnimationController controller;
  Animation animation;
  initState (){
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end:  Colors.white).animate(controller);
    controller.forward();

    controller.addListener((){
      setState(() {});
    });
  }

  void _trySubmit() {
    if (_formKey.currentState.validate()) {
      FocusScope.of(context).unfocus();
      _formKey.currentState.save();
      widget.submitFn(email, password, _distrect, _isLogin, context);
      print('inside the submit  success');
    } else {
      print('Failed submitting ');
    }
  }

  // for the authoeization
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showSpinner = false;
  // end of the vars

  String _distrect = disList[0];
  DropdownButton<String> Dropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String dis in disList) {
      var newItem = DropdownMenuItem(
        child: Text(dis),
        value: dis,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      dropdownColor: Colors.purple[100],
      value: _distrect,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          _distrect = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/icons8-book-stack-64.png'),
                      height: 60.0,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['BLocker'],
                    speed: Duration(milliseconds: 500),
                    textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Card(
                    color: Colors.purple[200],
                    margin: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _controllerEmail,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'should not be empty';
                                  } else if (!value.contains('@')) {
                                    return 'Should not miss the @';
                                  }
                                },
                                textAlign: TextAlign.center,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.purple[700],
                                    ),
                                  ),
                                ),
                                onSaved: (val) {
                                  email = val;
                                },
                              ),
                              Divider(
                                thickness: 4,
                                color: Colors.purple[700],
                              ),
                              TextFormField(
                                controller: _controllerPassword,
                                validator: (value) {
                                  if (value.length < 6) {
                                    return 'should not be less than 6';
                                  }
                                },
                                textAlign: TextAlign.center,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'password',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.purple[700],
                                    ),
                                  ),
                                ),
                                onSaved: (value) {
                                  password = value;
                                },
                              ),
                              if(!_isLogin)
                                Center(child: Dropdown()),
                              RoundedButton(
                                  text: _isLogin ? 'Log in' : 'Register',
                                  color: Colors.purple[700],
                                  onPressed: () {
                                    _trySubmit();
                                    print('i was pressed');
                                    _controllerPassword.clear();
                                    _controllerEmail.clear();
                                  }
                              ),
                              FlatButton(
                                child: Text(_isLogin
                                    ? 'Create an acount'
                                    : 'I already have an acount'),
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

}


class UnChangedTexts extends StatelessWidget {
  final String text;
  final TextStyle tS;

  UnChangedTexts({this.text, this.tS});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          text,
          style: tS,
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}

class TakeInput extends StatelessWidget {
  final String label;
  final bool obText;
  final Function onSaved;
  final Function validating;

  TakeInput({this.label, this.obText, this.onSaved, this.validating});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: validating,
            textAlign: TextAlign.center,
            obscureText: obText,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
              border: OutlineInputBorder(),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xE91E63),
                ),
              ),
            ),
            onSaved: onSaved,
          ),
          Divider(
            color: Colors.tealAccent,
            height: 10,
          )
        ],
      ),
    );
  }
}


// if I want to implement book details class
/*

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytest/db/store.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:mytest/models/constants.dart';
import 'package:mytest/models/book.dart';

class BookDetails extends StatefulWidget {
  static  const id = 'BookDetails';
  final Book selectedBook;
  BookDetails({this.selectedBook});
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: screenHeight,
            width: screenWidth,
            color: Colors.transparent,
          ),
          Container(
            height: screenHeight - screenHeight / 3,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.selectedBook.bImageURL),
              ),
            ),
          ),
          Positioned(
            top: screenHeight - screenHeight / 3 - 25.0,
            child: Container(
              padding: const EdgeInsets.only(left: 20.0),
              height: screenHeight / 3 + 25.0,
              width: screenWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.selectedBook.bName,
                    style: kWelcome,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Text(
                    'auther',
                    style: kWords,
                  ),
                  SizedBox(
                    height: 7.0,
                  ),
                  Row(
                    children: <Widget>[
                      Text(widget.selectedBook.bAuther),
                      SizedBox(
                        width: 4.0,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Description',
                    style: kWelcome,
                  ),
                  Text(
                    widget.selectedBook.bDescription,
                    style: kWords,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(widget.selectedBook.bCategory),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Color(0xFF1A1F2C),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 75.0,
              width: 100.0,
              child: Center(
                child: FlatButton(
                  child: Text(
                    'BORROW',
                    style: kWords,
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    print('here is the answer ${Store().getDistrect(widget.selectedBook.bprovider_id)}');
                    Future<String> d = Store().getDistrect(widget.selectedBook.bprovider_id);
//                    print('check availabilty ${Store().checkAvailability(d)}');
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "WARNINIG ALERT",
                      desc: "DO YOU WANT TO BORROW THIS?",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "COOL",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {},
                          color: Color.fromRGBO(0, 179, 134, 1.0),
                        ),
                        DialogButton(
                          child: Text(
                            "SORRY",
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
                  },
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                ),
                color: Colors.deepOrange,
              ),
            ),
          ),
          Positioned(
            top: screenHeight - screenHeight / 3 - 45.0,
            right: 25.0,
            child: Hero(
              tag: 'book pic',
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.selectedBook.bImageURL),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
*/
