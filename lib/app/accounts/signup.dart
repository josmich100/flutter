import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/progress.dart';
import 'package:jamar/main.dart';

class JamarSignUp extends StatefulWidget {
  @override
  _JamarSignUpState createState() => new _JamarSignUpState();
}

class _JamarSignUpState extends State<JamarSignUp> {
  BuildContext context;
  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  User user;
  FirebaseAuth _auth;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _mobileController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);

  List<TextEditingController> mTextEditingController;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  _getCurrentUser() async {
    final User user = _auth.currentUser;

    if (user != null) {
      setState(() {
        email = user.email;
        fullName = user.displayName;
        profileImgUrl = user.photoURL;
        AppData.currentUserID = user.uid;
        userid = user.uid;
      });
    }

    _auth.authStateChanges().listen((user) {
      if (user == null) {
        setState(() {
          AppData.currentUserID = null;
        });
      } else {
        AppData.currentUserID = user.uid;
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        key: scaffoldKey,
        backgroundColor: MyApp.appColors,
        appBar: new AppBar(
          backgroundColor: MyApp.appColors,
          title: new GestureDetector(
            onLongPress: () {},
            child: new Text(
              "SignUp",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: true,
        ),
        resizeToAvoidBottomPadding: true,
        body: new SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new Container(
                height: 120.0,
                child: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          margin: new EdgeInsets.only(top: 20.0, bottom: 0.0),
                          height: 40.0,
                          width: 40.0,
                          child: new Image.asset(
                              'assets/images/girlies_logo.png')),
                      new SizedBox(
                        height: 20.0,
                        child: new Image.asset(
                          "assets/images/girlies_text.png",
                          height: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                decoration: new BoxDecoration(
                    color: MyApp.appColors,
                    borderRadius: new BorderRadius.only(
                        bottomLeft: new Radius.circular(20.0),
                        bottomRight: new Radius.circular(20.0))),
              ),
              new Container(
                margin: new EdgeInsets.only(left: 5.0, right: 5.0),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(20.0),
                        topRight: new Radius.circular(20.0))),
                constraints: const BoxConstraints(maxHeight: 350.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 2.0),
                          height: 60.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: new TextFormField(
                            controller: _nameController,
                            style: new TextStyle(
                                color: MyApp.appColors[500], fontSize: 18.0),
                            decoration: new InputDecoration(
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Icon(
                                  Icons.person,
                                  size: 20.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                              labelText: "Full Name",
                              labelStyle: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 2.0),
                          height: 60.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: new TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            style: new TextStyle(
                                color: MyApp.appColors[500], fontSize: 18.0),
                            decoration: new InputDecoration(
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Icon(
                                  Icons.phone,
                                  size: 20.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                              labelText: "Mobile Number",
                              labelStyle: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 2.0),
                          height: 60.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: new TextFormField(
                            controller: _emailController,
                            style: new TextStyle(
                                color: MyApp.appColors[500], fontSize: 18.0),
                            decoration: new InputDecoration(
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Icon(
                                  Icons.email,
                                  size: 20.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                              labelText: "Email",
                              labelStyle: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(top: 5.0),
                      child: new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Container(
                          width: screenSize.width,
                          margin: new EdgeInsets.only(
                              left: 10.0, right: 10.0, bottom: 2.0),
                          height: 60.0,
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(20.0))),
                          child: new TextFormField(
                            controller: _passController,
                            obscureText: true,
                            style: new TextStyle(
                                color: MyApp.appColors[500], fontSize: 18.0),
                            decoration: new InputDecoration(
                              prefixIcon: new Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: new Icon(
                                  Icons.lock,
                                  size: 20.0,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(12.0),
                              labelText: "Password",
                              labelStyle: new TextStyle(
                                  fontSize: 20.0, color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black54)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        createUserAccount();
                      },
                      child: new Container(
                        height: 60.0,
                        margin: new EdgeInsets.only(top: 5.0),
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Container(
                            width: screenSize.width,
                            margin: new EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 2.0),
                            height: 60.0,
                            decoration: new BoxDecoration(
                                color: MyApp.appColors[400],
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(20.0))),
                            child: new Center(
                                child: new Text(
                              "Create Account",
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Creating Account....',
  );

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future createUserAccount() async {
    if (_nameController.text == "") {
      showInSnackBar("Name cannot be empty");
      return;
    }

    if (_mobileController.text == "") {
      showInSnackBar("Mobile cannot be empty");
      return;
    }

    if (_emailController.text == "") {
      showInSnackBar("Email cannot be empty");
      return;
    }

    if (_passController.text == "") {
      showInSnackBar("Password cannot be empty");
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return progress;
        });

    try {
      await _auth
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passController.text)
          .then((loggedUser) {
        Map userMap = new Map();
        userMap[AppData.fullName] = _nameController.text;
        userMap[AppData.phoneNumber] = _mobileController.text;
        userMap[AppData.email] = _emailController.text;
        userMap[AppData.password] = _passController.text;
        userMap[AppData.profileImgURL] = user.photoURL;
        userMap[AppData.deliveryAddress] = "";
        userMap[AppData.userID] = user.uid;
        userRef.child(user.uid).set(userMap);
        user = loggedUser.user;

        _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passController.text);
//        Navigator.of(context).pop();
//        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
      showInSnackBar(e.message);
    }

    setState(() {});
    if (user != null) {
      user.updateProfile(displayName: _nameController.text);
    }
  }
}
