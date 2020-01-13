import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ungmarket/utility/my_style.dart';
import 'package:ungmarket/utility/normal_dialog.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Field
  File file;
  String name = '', detail = '', namePost, pathImage;

  // Method
  @override
  void initState() {
    super.initState();
    findDisplayName();
  }

  Future<void> findDisplayName() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    namePost = firebaseUser.displayName;
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(30.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      child: GestureDetector(
        onTap: () {
          print('You Click Image');
          cameraThread();
        },
        child: file == null ? Image.asset('images/pic.png') : Image.file(file),
      ),
    );
  }

  Future<void> cameraThread() async {
    try {
      var object = await ImagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800.0,
        maxHeight: 600.0,
      );

      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  Widget addButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
            color: MyStyle().textColor,
            child: Text(
              'Add Product',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (file == null) {
                normalDialog(context, 'No Image', 'Please Click Image');
              } else if (name.isEmpty || detail.isEmpty) {
                normalDialog(context, 'Have Space', 'Please Fill Every Blank');
              } else {
                uploadPicture();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> uploadPicture() async {
    Random random = Random();
    int i = random.nextInt(10000);
    String string = 'product$i.jpg';

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Product/$string');
    StorageUploadTask storageUploadTask = storageReference.putFile(file);

    pathImage = await (await storageUploadTask.onComplete).ref.getDownloadURL();

    print(
        'name = $name, detail = $detail, post = $namePost, path = $pathImage');
        insertValueToFireStore();
  }

  Future<void> insertValueToFireStore() async {
    Map<String, dynamic> map = Map();
    map['Name'] = name;
    map['Detail'] = detail;
    map['PathImage'] = pathImage;
    map['Post'] = namePost;

    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Product');
    await collectionReference.document().setData(map).then((response) {
      Navigator.of(context).pop();
    }).catchError((response){
      normalDialog(context, 'Cannot Add Product', 'Please Try Again');
    });
  }

  Widget nameForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.black38,
      ),
      width: 250.0,
      height: 40.0,
      child: TextField(
        onChanged: (String string) {
          name = string.trim();
        },
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Name :',
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.image,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget detailForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.black38,
      ),
      width: 250.0,
      // height: 40.0,
      child: TextField(
        onChanged: (String string) {
          detail = string.trim();
        },
        maxLines: 3,
        keyboardType: TextInputType.multiline,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Detail :',
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.details,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          showImage(),
          nameForm(),
          SizedBox(
            height: 5.0,
          ),
          detailForm(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Stack(
        children: <Widget>[
          showContent(),
          addButton(),
        ],
      ),
    );
  }
}
