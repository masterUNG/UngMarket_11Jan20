import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungmarket/scaffold/my_service.dart';
import 'package:ungmarket/scaffold/register.dart';
import 'package:ungmarket/utility/my_style.dart';
import 'package:ungmarket/utility/normal_dialog.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Field
  String user = '', password = '';

  // Method
  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      routeToMyService();
    }
  }

  void routeToMyService() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyService();
    });
    Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
        (Route<dynamic> route) {
      return false;
    });
  }

  Widget signInButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: MyStyle().textColor,
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        print('user = $user, password = $password');
        checkAuthen();
      },
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth
        .signInWithEmailAndPassword(email: user, password: password)
        .then((response) {
          routeToMyService();
        }).catchError((response){
          print('resposne = $response');
          String title = response.code;
          String message = response.message;
          normalDialog(context, title, message);
        }); 
  }

  Widget signUpButton() {
    return OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      borderSide: BorderSide(color: MyStyle().textColor),
      child: Text(
        'Sign Up',
        style: TextStyle(color: MyStyle().textColor),
      ),
      onPressed: () {
        print('You Click SignUp');

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return Register();
        });
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        signInButton(),
        SizedBox(
          width: 5.0,
        ),
        signUpButton(),
      ],
    );
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          user = string.trim();
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyStyle().textColor)),
            prefixIcon: Icon(
              Icons.email,
              color: MyStyle().textColor,
            ),
            hintText: 'User :',
            hintStyle: TextStyle(color: MyStyle().textColor)),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          password = string.trim();
        },
        obscureText: true,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyStyle().textColor)),
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().textColor,
            ),
            hintText: 'Password :',
            hintStyle: TextStyle(color: MyStyle().textColor)),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'ตลาด อึ่ง',
      style: TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        color: MyStyle().textColor,
        fontFamily: 'Sriracha',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.5,
            colors: <Color>[Colors.white, MyStyle().mainColor],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showLogo(),
                showAppName(),
                userForm(),
                passwordForm(),
                SizedBox(
                  height: 10.0,
                ),
                showButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
