import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamar/app/accounts/signup.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/progress.dart';
import 'package:jamar/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class JamarLogin extends StatefulWidget {
  @override
  _JamarLoginState createState() => new _JamarLoginState();
}

class _JamarLoginState extends State<JamarLogin> {
  BuildContext context;
  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  final googleSignIn = new GoogleSignIn();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  User user;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Logging In....',
  );

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
//        Map userMap = new Map();
//        userMap[AppData.fullName] = user.displayName;
//        userMap[AppData.phoneNumber] = "";
//        userMap[AppData.email] = user.email;
//        userMap[AppData.password] = "";
//        userMap[AppData.profileImgURL] = user.photoUrl;
//        userMap[AppData.deliveryAddress] = "";
//        userMap[AppData.userID] = user.uid;
//        userRef.child(user.uid).set(userMap);
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
              "Login",
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
                constraints: const BoxConstraints(maxHeight: 400.0),
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
                    new Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                            new JamarSignUp()));
                              },
                              child: new Text(
                                "SignUp",
                                style: new TextStyle(
                                    fontSize: 14.0, color: Colors.black),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new Text(
                              "Forgot Password?",
                              style: new TextStyle(
                                  fontSize: 14.0, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        loginWithEmail();
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
                              "Login",
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            )),
                          ),
                        ),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                            height: 1.0,
                            width: 100.0,
                            color: Colors.black26,
                          ),
                          new Text(
                            "Or login with",
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          new Container(
                            height: 1.0,
                            width: 100.0,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Column(
                          children: <Widget>[
                            new GestureDetector(
                              onTap: () {
                                loginWithGoogle();
                              },
                              child: new Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  color: Colors.yellow[800],
                                ),
                                child: new CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30.0,
                                  backgroundImage: new AssetImage(
                                      'assets/images/google_logo.png'),
                                ),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: new Text(
                                "Google",
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.yellow[800]),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future loginWithGoogle() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return progress;
        });

    GoogleSignInAccount signedInUser = googleSignIn.currentUser;
    if (signedInUser == null)
      signedInUser = await googleSignIn.signInSilently();
    if (signedInUser == null) {
      await googleSignIn.signIn();
      // analytics.logLogin();
    }
    //currentUserEmail = googleSignIn.currentUser.email;
    if (_auth.currentUser == null) {
      GoogleSignInAuthentication signInAuthentication =
          await googleSignIn.currentUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: signInAuthentication.accessToken,
          idToken: signInAuthentication.idToken);
      final authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
    }
  }

  Future loginWithEmail() async {
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
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passController.text)
          .then((loggedUser) {
        this.user = loggedUser.user;
        isLoggedIn = true;
      });
    } on PlatformException catch (e) {
      Navigator.of(context).pop();
      showInSnackBar(e.message);
    }
  }
}
