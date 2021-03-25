import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/accounts/login.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/screens/about_us.dart';
import 'package:jamar/app/screens/chat.dart';
import 'package:jamar/app/screens/jamar.dart';
import 'package:jamar/app/screens/order_history.dart';
import 'package:jamar/app/screens/order_notification.dart';
import 'package:jamar/app/screens/profile_settings.dart';
import 'package:jamar/app/screens/rest.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/fbconn.dart';
import 'package:jamar/support/jamar_support.dart';

class JamarApp extends StatefulWidget {
  @override
  _JamarSupportState createState() => new _JamarSupportState();
}

class _JamarSupportState extends State<JamarApp> {
  PageController _pageController;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  final userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<Event> _msgSubscription;
  BuildContext context;
  User user;
  FirebaseAuth _auth;
  int msgCount = 0;

  String fullName;
  String email;
  String phone;
  String userid;
  String profileImgUrl;
  bool isLoggedIn;
  bool _isSignedIn = false;
  String appLogo =
      "https://firebasestorage.googleapis.com/v0/b/almost-9bed3.appspot.com/o/girlies_text_small.png?alt=media&token=3ccab668-c795-4056-9b87-a249989457a1";
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _pageController = new PageController();
    _getCurrentUser();
  }

  Future _getCurrentUser() async {
    //_getCartCount();
    if (_auth.currentUser != null) {
      setState(() {
        _isSignedIn = true;
        email = user.email;
        fullName = user.displayName;
        profileImgUrl = user.photoURL;
        AppData.currentUserID = user.uid;
        user = user;
        //profileImgUrl = googleSignIn.currentUser.photoUrl;

//          UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
//          userUpdateInfo.photoUrl = "";
//          userUpdateInfo.displayName = "Esther Tony";
//          _auth.updateProfile(userUpdateInfo);
      });
    }

    setState(() {
      nameController.text = fullName;
    });

    _auth.authStateChanges().listen((user) {
      if (user == null) {
        setState(() {
          _isSignedIn = false;
          fullName = null;
          profileImgUrl = null;
          email = null;
          AppData.currentUserID = null;
          nameController.text = null;
        });
      } else {
        setState(() {
          _isSignedIn = true;
          email = user.email;
          fullName = user.displayName;
          profileImgUrl = user.photoURL;
          AppData.currentUserID = user.uid;
          nameController.text = fullName;
        });
      }
    });

    _getUnReadMSG();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future _getUnReadMSG() async {
    final msgRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.messagesDB)
        .child(AppData.currentUserID);

    /*_msgSubscription = await msgRef.once().then((snapshot) {
      if (snapshot.value == null) {
        msgCount = 0;
        setState(() {});
        return;
      }
      setState(() {
        msgCount = 0;
      });
      Map valFav = snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      for (int s = 0; s < fbConn.getDataSize(); s++) {
        if (fbConn.getMessageRead()[s] == false) {
          msgCount = msgCount + 1;
        }
      }

      if (msgCount > 0) {
        setState(() {
          createNotification();
          print(msgCount);
        });
      }
    });*/

    _msgSubscription = msgRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        msgCount = 0;
        setState(() {});
        return;
      }
      setState(() {
        msgCount = 0;
      });
      Map valFav = event.snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      for (int s = 0; s < fbConn.getDataSize(); s++) {
        if (fbConn.getMessageRead()[s] == false &&
            fbConn.getMessageSenderIDasList()[s] != AppData.currentUserID) {
          msgCount = msgCount + 1;
        }
      }

      if (msgCount > 0) {
        setState(() {
          // createNotification();
          print(msgCount);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _msgSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              decoration: new BoxDecoration(color: MyApp.appColors[600]),
              accountName: new Text(
                  fullName != null ? fullName : fullName = "Your Name"),
              accountEmail:
                  new Text(email != null ? email : email = "you@email.com"),
              currentAccountPicture: profileImgUrl != null
                  ? new CircleAvatar(
                      backgroundColor: Color(0xff7c94b6),
                      backgroundImage: new NetworkImage(profileImgUrl),
                    )
                  : profileImgUrl == null || profileImgUrl == ""
                      ? new CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage:
                              new AssetImage("assets/images/avatar.png"),
                        )
                      : new CircleAvatar(
                          backgroundColor: Colors.white,
                          child: new Text(
                            "Y",
                            style: new TextStyle(
                                color: MyApp.appColors,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
            ),
            new ListTile(
              title: new Text("Order Notifications"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new JamarOrder()));
              },
            ),
            new ListTile(
              title: new Text("Order History"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(Icons.history, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new JamarOrderHistory()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Restaurants"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Rest()));
              },
            ),
            /*new ListTile(
              title: new Text("Change Name"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                //Navigator.of(context).pop();
                final dialog = new AlertDialog(
                  title: new Text("Set Full Name"),
                  contentPadding: new EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new TextField(
                        controller: nameController,
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: "Full Name", hintText: "Full Name"),
                      ))
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text("Cancel")),
                    new FlatButton(
                        onPressed: () {
                          updateNameToFb();
                        },
                        child: new Text("Save")),
                  ],
                );

                _isSignedIn == false
                    ? Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new JamarLogin()))
                    : showDialog(context: context, child: dialog);
              },
            ),
            new ListTile(
              title: new Text("Change Number"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(Icons.phone_iphone, color: Colors.white),
              ),
              onTap: () {
                // Navigator.of(context).pop();

                final dialog = new AlertDialog(
                  title: new Text("Set Phone Number"),
                  contentPadding: new EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new TextField(
                        controller: phoneController,
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: "Phone Number",
                            hintText: "Phone Number"),
                      ))
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text("Cancel")),
                    new FlatButton(
                        onPressed: () {
                          updateNumberToFb();
                        },
                        child: new Text("Save")),
                  ],
                );

                _isSignedIn == false
                    ? Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new JamarLogin()))
                    : showDialog(context: context, child: dialog);
              },
            ),*/
            new ListTile(
              title: new Text("Profile Settings"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                _isSignedIn == false
                    ? Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new JamarLogin()))
                    : Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            new JamarProfileSettings()));
              },
            ),
            // new ListTile(
            //   title: new Text("Delivery Address"),
            //   leading: new CircleAvatar(
            //     backgroundColor: Colors.teal[900],
            //     child: new Icon(
            //       Icons.home,
            //       color: Colors.white,
            //     ),
            //   ),
            //   onTap: () {
            //     _isSignedIn == false
            //         ? Navigator.of(context).push(new CupertinoPageRoute(
            //             builder: (BuildContext context) => new JamarLogin()))
            //         : Navigator.of(context).push(new CupertinoPageRoute(
            //             builder: (BuildContext context) =>
            //                 new JamarDeliveryAddress()));
            //   },
            // ),
            new Divider(),
            new ListTile(
              title: new Text("About Us"),
              trailing: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.help,
                  color: Colors.white,
                ),
              ),
              onTap: () {
//                Navigator.of(context).pop();
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new JamarAboutUs()));
              },
            ),
            new ListTile(
              title: new Text(
                _isSignedIn == false ? "Login" : "Logout",
              ),
              trailing: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                _isSignedIn == false
                    ? Navigator.of(context).push(new CupertinoPageRoute(
                        builder: (BuildContext context) => new JamarLogin()))
                    : _signOut();
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              //Navigator.pushNamed(context, Base.favoriteScreen);
              _isSignedIn == false
                  ? showInSnackBar("Please login to view your favorites!")
                  : showInSnackBar("Failed to Fetch Favorites.");
              //: Navigator.of(context).push(new CupertinoPageRoute(
              //   builder: (BuildContext context) =>
              //     new JamarFavorites()));
            },
          ),
          new Stack(
            children: <Widget>[
              new IconButton(
                icon: new Icon(
                  Icons.chat,
                  color: Colors.white,
                ),
                onPressed: () {
                  //Navigator.pushNamed(context, Base.favoriteScreen);
                  _isSignedIn == false
                      ? showInSnackBar("Please login to view your messages!")
                      : Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              new JamarAppChat()));
                },
              ),
              new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new CircleAvatar(
                  radius: 8.0,
                  backgroundColor: Colors.red[900],
                  child: new Text(
                    msgCount == null ? "0" : msgCount.toString(),
                    style: new TextStyle(color: Colors.white, fontSize: 9.0),
                  ),
                ),
              )
            ],
          ),
        ],
        title: new GestureDetector(
          onLongPress: () {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new JamarSupport()));
          },
          child: new SizedBox(
            height: 40.0,
            child: new Image.asset(
              "assets/images/girlies_text.png",
              height: 20.0,
            ),
          )
          /*new Text(
            "Jamar",
            style: new TextStyle(color: Colors.white),
          )*/
          ,
        ),
        centerTitle: true,
      ),
      body: new Jamar(),
      /*new PageView(
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          new JamarBoutique(),
          new JamarOrder(),
          new JamarProfile(),
        ],
      )*/
    );
  }

  Future _signOut() async {
    await _auth.signOut();
    //googleSignIn.signOut();
    showInSnackBar('User logged out');
  }

  void onPageChanged(int page) {
    setState(() {
      _pageController.jumpToPage(page);
    });
  }

  // onNotificationClick(String payload) {
  //    // payload is "some payload"
  //  print('Running in background and received payload: $payload');
  //    FlutterLocalNotificationsPlugin.private(platform)(0);
  //  Navigator.of(context).push(new CupertinoPageRoute(
  //       builder: (BuildContext context) => new JamarAppChat()));
  //  }

  //  Future createNotification() async {
  //    await FlutterLocalNotificationsPlugin.notification(
  //      title: "New Message from Jamar",
  //        content: "You have $msgCount new messages.",
  //      id: 0,
  //    imageUrl: appLogo,
  //      onNotificationClick: new FlutterLocalNotificationsPlugin.show(
  //            actionText: null,
  //         callback: onNotificationClick,
  //           payload: "opening app chat"));
  // }
}
