import 'package:flutter/material.dart';
import 'package:ungmarket/utility/my_style.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'This is Information',
        style: MyStyle().h1Text,
      ),
    );
  }
}
