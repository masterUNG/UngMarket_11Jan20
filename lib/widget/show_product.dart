import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ungmarket/scaffold/add_product.dart';
import 'package:ungmarket/utility/my_style.dart';

class ShowProduct extends StatefulWidget {
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  // Field
  List<String> names = List();
  List<String> details = List();
  List<String> pathImages = List();

  // Method
  @override
  void initState() {
    super.initState();
    readFireStore();
  }

  Future<void> readFireStore() async {
    Firestore firestore = Firestore.instance;
    CollectionReference collectionReference = firestore.collection('Product');
    await collectionReference.snapshots().listen((response) {
      List<DocumentSnapshot> snapshops = response.documents;
      for (var map in snapshops) {
        setState(() {
          names.add(map.data['Name']);
          details.add(map.data['Detail']);
          pathImages.add(map.data['PathImage']);
        });
      }
    });
  }

  Widget addButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                bottom: 30.0,
                right: 30.0,
              ),
              child: FloatingActionButton(
                tooltip: 'Add Product',
                child: Icon(Icons.add),
                onPressed: () {
                  MaterialPageRoute materialPageRoute =
                      MaterialPageRoute(builder: (BuildContext buildContext) {
                    return AddProduct();
                  });
                  Navigator.of(context).push(materialPageRoute);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget showImage(int index) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Image.network(
        pathImages[index],
        fit: BoxFit.cover,
      ),
    );
  }

  Widget showText(int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          showName(index),
          showDetail(index),
        ],
      ),
    );
  }

  Widget showDetail(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          details[index],
          style: MyStyle().h2Text,
        ),
      ],
    );
  }

  Widget showName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          names[index],
          style: MyStyle().h1Text,
        ),
      ],
    );
  }

  Widget showListView() {
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (BuildContext buildContext, int index) {
        return Row(
          children: <Widget>[
            showImage(index),
            showText(index),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        showListView(),
        addButton(),
      ],
    );
  }
}
