import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungmarket/scaffold/my_service.dart';
import 'package:ungmarket/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Field
  File file;
  String name, email, password, urlAvarar;
  final formKey = GlobalKey<FormState>();

  // Method
  Widget nameForm() {
    Color color = Colors.purple;
    return TextFormField(
      onSaved: (String string) {
        name = string.trim();
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        helperText: 'Type Your Name In Blank',
        helperStyle: TextStyle(color: color),
        labelText: 'Display Name :',
        labelStyle: TextStyle(color: color),
        icon: Icon(
          Icons.face,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget emailForm() {
    Color color = Colors.orange.shade900;
    return TextFormField(
      onSaved: (String string) {
        email = string.trim();
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        helperText: 'Type Your Email In Blank',
        helperStyle: TextStyle(color: color),
        labelText: 'Email :',
        labelStyle: TextStyle(color: color),
        icon: Icon(
          Icons.email,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget passwordForm() {
    Color color = Colors.blue;
    return TextFormField(
      onSaved: (String string) {
        password = string.trim();
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: color),
        ),
        helperText: 'Type Your Passowrd In Blank',
        helperStyle: TextStyle(color: color),
        labelText: 'Password :',
        labelStyle: TextStyle(color: color),
        icon: Icon(
          Icons.lock,
          size: 36.0,
          color: color,
        ),
      ),
    );
  }

  Widget cameraButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_a_photo),
      label: Text('Camera'),
      onPressed: () {
        cameraAnGallery(ImageSource.camera);
      },
    );
  }

  Future<void> cameraAnGallery(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 600.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return OutlineButton.icon(
      icon: Icon(Icons.add_photo_alternate),
      label: Text('Gallery'),
      onPressed: () {
        cameraAnGallery(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showAvatar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.5,
      child: file == null ? Image.asset('images/avatar.png') : Image.file(file),
    );
  }

  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.cloud_upload),
      onPressed: () {
        formKey.currentState.save();
        print('name = $name, email = $email, password = $password');

        if (file == null) {
          normalDialog(
              context, 'Non Choose Image', 'Please Click Camera or Gallery');
        } else if (name.isEmpty || email.isEmpty || password.isEmpty) {
          normalDialog(context, 'Have Space', 'Please Fill Every Blank');
        } else {
          uploadImageToStorage();
        }
      },
    );
  }

  Future<void> uploadImageToStorage() async {
    Random random = Random();
    int i = random.nextInt(10000);
    String string = 'avata$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Avatar/$string');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    urlAvarar = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('urlAvata = $urlAvarar');
    registerAuthen();
  }

  Future<void> registerAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((response) {
      print('Register Success');
      setupDisplayNameAnAvatar();
    }).catchError((response) {
      print('response = $response');
      String title = response.code;
      String message = response.message;
      normalDialog(context, title, message);
    });
  }

  Future<void> setupDisplayNameAnAvatar() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth.currentUser().then((response) {
      UserUpdateInfo userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = name;
      userUpdateInfo.photoUrl = urlAvarar;
      response.updateProfile(userUpdateInfo);

      MaterialPageRoute materialPageRoute =
          MaterialPageRoute(builder: (BuildContext buildContext) {
        return MyService();
      });
      Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
          (Route<dynamic> route) {
        return false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[registerButton()],
        title: Text('Register'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            showAvatar(),
            showButton(),
            SizedBox(
              height: 10.0,
            ),
            nameForm(),
            emailForm(),
            passwordForm()
          ],
        ),
      ),
    );
  }
}
