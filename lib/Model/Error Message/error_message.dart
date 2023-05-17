import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorMessage {
  static toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepPurple.shade700,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
