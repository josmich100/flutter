import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class JamarAboutUs extends StatefulWidget {
  @override
  _JamarAboutUsState createState() => new _JamarAboutUsState();
}

class _JamarAboutUsState extends State<JamarAboutUs> {
  BuildContext context;
  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  final googleSignIn = new GoogleSignIn();
  User user;
  FirebaseAuth _auth;
  String aboutUs =
      "Jamar eats is an e-commerce platform offering food delivery services.It enables you to order mouth watering food of your choice with just a click of a button.The food is ordered around Nyahururu from the restaurant of choice at an affordable price.Order now to get the best experience of your life.";

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  _getCurrentUser() async {
    try {
      user = _auth.currentUser;
    } catch (e) {
      print(e);
    }

    if (user != null) {
      setState(() {
        email = user.email;
        fullName = user.displayName;
        profileImgUrl = user.photoURL;
        //profileImgUrl = googleSignIn.currentUser.photoUrl;
      });
    }
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return new Scaffold(
        backgroundColor: MyApp.appColors,
        appBar: new AppBar(
          title: new GestureDetector(
            onLongPress: () {},
            child: new Text(
              "About Us",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: false,
        ),
        resizeToAvoidBottomPadding: false,
        body: new Container(
          constraints: const BoxConstraints(maxHeight: 500.0),
          margin: new EdgeInsets.all(5.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(new Radius.circular(20.0))),
          child: new Center(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                height: 50.0,
                child:
                    new Image.asset("assets/images/girlies_text_colored.png"),
              ),
              new SizedBox(
                height: 50.0,
                child: new Image.asset("assets/images/girlies_logo.png"),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text(
                  "Version 0.0.1",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                      fontStyle: FontStyle.normal),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(2.0),
                child: new Text(
                  "JAMAR EATS, Taste the Difference...",
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black26,
                      fontStyle: FontStyle.italic),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Text(
                  aboutUs,
                  style: new TextStyle(
                      fontSize: 15.0,
                      color: Colors.teal,
                      fontStyle: FontStyle.normal,
                      wordSpacing: 2.0),
                ),
              ),
            ],
          )),
        ));
  }
}
