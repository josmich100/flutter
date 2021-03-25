import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/progress.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/fbconn.dart';
import 'package:google_sign_in/google_sign_in.dart';

class JamarDeliveryAddress extends StatefulWidget {
  final bool fromPayment;
  JamarDeliveryAddress({this.fromPayment});
  @override
  _JamarDeliveryAddress createState() => new _JamarDeliveryAddress();
}

class _JamarDeliveryAddress extends State<JamarDeliveryAddress> {
  TextEditingController _descController = new TextEditingController();
  TextEditingController _stateController = new TextEditingController();
  TextEditingController _homeController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  final googleSignIn = new GoogleSignIn();
  User user;
  FbConn fbConn;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future _getUserInfo() async {}

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Saving Details....',
  );

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new GestureDetector(
            onLongPress: () {},
            child: new Text(
              "Delivery Address",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: false,
        ),
        resizeToAvoidBottomPadding: false,
        body: new SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
              child: new Column(
            children: <Widget>[
              new Padding(padding: new EdgeInsets.only(top: 10.0)),
              new Container(
                height: 50.0,
                margin: new EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 12.0, bottom: 5.0),
                child: new TextFormField(
                  controller: _stateController,
                  style: new TextStyle(
                      color: MyApp.appColors[500], fontSize: 18.0),
                  decoration: new InputDecoration(
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(
                        Icons.location_on,
                        size: 20.0,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(12.0),
                    labelText: "Town*",
                    labelStyle:
                        new TextStyle(fontSize: 20.0, color: Colors.black54),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: Colors.black54)),
                  ),
                ),
              ),
              new Container(
                height: 50.0,
                margin: new EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                child: new TextFormField(
                  controller: _homeController,
                  style: new TextStyle(
                      color: MyApp.appColors[500], fontSize: 18.0),
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(
                        Icons.home,
                        size: 20.0,
                      ),
                    ),
                    labelText: "Home Address*",
                    labelStyle:
                        new TextStyle(fontSize: 20.0, color: Colors.black54),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: Colors.black54)),
                  ),
                ),
              ),
              new Container(
                height: 50.0,
                margin: new EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
                child: new TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: new TextStyle(
                      color: MyApp.appColors[500], fontSize: 18.0),
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(12.0),
                    prefixIcon: new Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: new Icon(
                        Icons.assignment,
                        size: 20.0,
                      ),
                    ),
                    labelText: "Location Description*",
                    labelStyle:
                        new TextStyle(fontSize: 20.0, color: Colors.black54),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: Colors.black54)),
                  ),
                ),
              ),
              new InkWell(
                onTap: _saveProfile,
                child: new Container(
                  height: 60.0,
                  color: Colors.white,
                  margin: new EdgeInsets.only(top: 20.0),
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Container(
                      width: screenSize.width,
                      margin: new EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 2.0),
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: MyApp.appColors[400],
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(5.0))),
                      child: new Center(
                          child: new Text(
                        "Save",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                    ),
                  ),
                ),
              )
            ],
          )),
        ));
  }

  Future _saveProfile() async {
    if (_stateController.text == "") {
      showInSnackBar("State cannot be empty");
      return;
    }

    if (_homeController.text == "") {
      showInSnackBar("Home Address cannot be empty");
      return;
    }

    if (_descController.text == "") {
      showInSnackBar("Description your home location");
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return progress;
        });

    Map<dynamic, dynamic> userMap = new Map();
    userMap[AppData.state] = _stateController.text;
    userMap[AppData.homeAddress] = _homeController.text;
    userMap[AppData.homeDescription] = _descController.text;
    await userRef.child(userid).update(userMap);
    Navigator.of(context).pop();
    showInSnackBar("Profile Updated");
  }
}
