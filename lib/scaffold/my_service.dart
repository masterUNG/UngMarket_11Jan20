import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ungmarket/scaffold/authen.dart';
import 'package:ungmarket/utility/my_style.dart';
import 'package:ungmarket/widget/information.dart';
import 'package:ungmarket/widget/show_product.dart';

class MyService extends StatefulWidget {
  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Field
  String displayName = '', urlAvatar;
  Widget currentWidget = ShowProduct();

  // Method
  @override
  void initState() {
    super.initState();
    findDisplayAnAvatar();
  }

  Future<void> findDisplayAnAvatar() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    setState(() {
      displayName = firebaseUser.displayName;
      urlAvatar = firebaseUser.photoUrl;
    });
  }

  Widget showAvatar() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: urlAvatar == null
          ? Image.asset('images/avatar.png')
          : showNetworkAvatar(),
    );
  }

  Widget showNetworkAvatar() {
    return CircleAvatar(
      backgroundImage: NetworkImage(urlAvatar),
    );
  }

  Widget showAppName() {
    return Text(
      'Ung Market',
      style: MyStyle().h2Text,
    );
  }

  Widget showDisplayName() {
    return Text(
      'Login by $displayName',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget showHead() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          showAvatar(),
          showAppName(),
          showDisplayName(),
        ],
      ),
    );
  }

  Widget signOutMenu() {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Sign Out'),
      subtitle: Text('Click For Sign Out and Back to Authen Page'),
      onTap: () {
        signOutThread();
      },
    );
  }

  Future<void> signOutThread() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.signOut().then((response) {
      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext buildContext) {
        return Authen();
      });
      Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
          (Route<dynamic> route) {
        return false;
      });
    });
  }

  Widget menuHome() {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('List All Product'),
      subtitle: Text('Show All Product in Stock'),
      onTap: () {
        setState(() {
          currentWidget = ShowProduct();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuInfo() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Information'),
      subtitle: Text('Show Information or About Me'),
      onTap: () {
        setState(() {
          currentWidget = Information();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHead(),
          menuHome(),
          Divider(),
          menuInfo(),
          Divider(),
          signOutMenu(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
      body: currentWidget,
      
    );
  }
}