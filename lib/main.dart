import 'package:flutter/material.dart';
import 'package:ungmarket/scaffold/authen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
        ),
        primarySwatch: Colors.lightGreen,
        primaryIconTheme: IconThemeData(color: Colors.white),
      ),
      home: Authen(),
    );
  }
}
