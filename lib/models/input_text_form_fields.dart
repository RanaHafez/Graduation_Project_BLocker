import 'package:flutter/material.dart';

class InputTextFormFields extends StatelessWidget{

  InputTextFormFields({this.onChange,
    this.textController,
    this.hint,
    this.lines,
    this.icon,
    this.validOrNot});
   @override
       final Function onChange;
       final TextEditingController textController;
       final String hint;
      final int lines;
      final  Icon icon;
      final Function validOrNot;
  Widget build(BuildContext context) {
    // TODO: implement build
     return Padding(
       padding: const EdgeInsets.all(12.0),
       child: Column(
         children: <Widget>[
           TextFormField(
             validator: validOrNot,
             onChanged: onChange,
             controller: textController,
             style: TextStyle(
               color: Colors.black,
             ),
             maxLines: lines,
             decoration: InputDecoration(
               filled: true,
               fillColor: Colors.white,
               icon: icon,
               hintText: hint,
               hintStyle: TextStyle(color: Colors.grey),
             ),
           )
         ],
       ),
     );
  }
}