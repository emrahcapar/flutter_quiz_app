import 'package:flutter/material.dart';
import 'package:quizmobileapp/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      home:  LoginScreen(),
    );
  }
}
