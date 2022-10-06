import 'package:flutter/material.dart';


class ReusableContainer extends StatelessWidget {
  ReusableContainer( {this.c, this.cardChild,this.onPress} );
  final Color c ;
  final Widget cardChild ;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
