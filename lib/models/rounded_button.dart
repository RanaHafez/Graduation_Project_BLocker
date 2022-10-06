import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;

  RoundedButton ({this.text,this.color,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Colors.lightBlueAccent , log in , Navigator.pushNamed(context, LoginScreen.id );
      // Colors.blueAccent , Navigator.pushNamed(context,RegistrationScreen.id ); , register
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
          ),
        ),
      ),
    );
  }
}