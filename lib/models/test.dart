
import 'package:flutter/cupertino.dart';

class Test extends ChangeNotifier{
  int n = 0;

  setN (int newN) {
    n = newN;
    notifyListeners();
  }
}