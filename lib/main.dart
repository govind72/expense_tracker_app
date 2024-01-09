import 'package:expense_tracker_app/screens/home_page.dart';
import 'package:expense_tracker_app/screens/login_screen.dart';
import 'package:expense_tracker_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}