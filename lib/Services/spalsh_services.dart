import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/View%20Model/auth/login_view_model.dart';
import 'package:firebase_tutorial/View%20Model/post/post_view_model.dart';
import 'package:flutter/material.dart';

class SplashServics {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PostViewModel()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginViewModel()));
      });
    }
  }
}
