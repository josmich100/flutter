import 'dart:async';
import 'dart:io';

import 'package:jamar/support/screens/add_categories.dart';
import 'package:jamar/support/screens/addproducts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/base.dart';
import 'package:jamar/support/screens/account_recovery.dart';
import 'package:jamar/support/screens/addrestaurants.dart';
import 'package:jamar/support/screens/boutique_store.dart';
import 'package:jamar/support/screens/chat_screen.dart';
import 'package:jamar/support/screens/order_search.dart';
import 'package:jamar/support/screens/support_order_history.dart';
import 'package:jamar/support/screens/support_orders.dart';

class JamarSupport extends StatefulWidget {
  @override
  _JamarSupportState createState() => new _JamarSupportState();
}

class _JamarSupportState extends State<JamarSupport> {
  PageController _pageController;
  Base base = new Base.products();
  Base messageModel = new Base.messages();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  var userRef = FirebaseDatabase.instance.reference().child(AppData.userDB);
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;
  User user;
  int requestCount;

  String userid;
  bool isLoggedIn;

  File imageFile;

  String supportUID = "pse4Vkkzv2UgkqT29Cztqthj7sw2";
  String fullName = "JAMAR EATS";
  String email = "Jamar.suport@gmail.com";
  String phone = "08143733836";

  String profileImgUrl =
      "https://firebasestorage.googleapis.com/v0/b/almost-9bed3.appspot.com/o/girlies_text_small.png?alt=media&token=3ccab668-c795-4056-9b87-a249989457a1";

  @override
  void initState() {
    _pageController = new PageController();
    _getRequestCount();
    super.initState();
  }

  Future _getRequestCount() async {}

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  var listDialog = new SimpleDialog(
    //title: const Text('Select assignment'),
    children: <Widget>[
      new SimpleDialogOption(
        onPressed: () {},
        child: const Text('Copy'),
      ),
      new Divider(),
      new SimpleDialogOption(
        onPressed: () {},
        child: const Text('Edit'),
      ),
      new Divider(),
      new SimpleDialogOption(
        onPressed: () {},
        child: const Text('Hide'),
      ),
      new Divider(),
      new SimpleDialogOption(
        onPressed: () {},
        child: const Text('Delete'),
      ),
    ],
  );

  listAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return listDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: new Stack(
        children: <Widget>[
          new FloatingActionButton(
            heroTag: "float",
            mini: false,
            onPressed: () {
              Base orderModel = new Base.adminOrder();
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new SupportOrders(
                        orders: orderModel.buildDemoAdminOrder(),
                      )));
              //listAlertDialog();
            },
            tooltip: 'Your Requests',
            child: new Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          new CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.red[900],
            child: new Text(
              requestCount == null ? "0" : requestCount.toString(),
              style: new TextStyle(color: Colors.white, fontSize: 9.0),
            ),
          )
        ],
      ),
      endDrawer: new Drawer(
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
                  : email != null
                      ? new CircleAvatar(
                          backgroundColor: Colors.white,
                          child: new Text(
                            email.substring(0, 2).toUpperCase(),
                            style: new TextStyle(
                                color: MyApp.appColors,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700),
                          ),
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
              otherAccountsPictures: <Widget>[
                new CircleAvatar(
                  backgroundColor: Color(0xff7c94b6),
                  backgroundImage: new NetworkImage(profileImgUrl),
                )
              ],
            ),
            new ListTile(
              title: new Text("Find Order"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(Icons.search, color: Colors.white),
              ),
              onTap: () {
                //Navigator.of(context).pop();
                final dialog = new AlertDialog(
                  title: new Text("Find Order (Mobile No)"),
                  contentPadding: new EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new TextField(
                        controller: phoneController,
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        decoration: new InputDecoration(
                            labelText: "Enter Phone Number", hintText: ""),
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
                          findUserOrder();
                        },
                        child: new Text("Find")),
                  ],
                );
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return dialog;
                    });
              },
            ),
            new ListTile(
              title: new Text("Find Users"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(Icons.find_in_page, color: Colors.white),
              ),
              onTap: () {
                //Navigator.of(context).pop();
                final dialog = new AlertDialog(
                  title: new Text("Find User (Mobile No)"),
                  contentPadding: new EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new TextField(
                        controller: phoneController,
                        autofocus: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        decoration: new InputDecoration(
                            labelText: "Enter Phone Number", hintText: ""),
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
                          findUserOrder();
                        },
                        child: new Text("Find")),
                  ],
                );
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return dialog;
                    });
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
                        new JamarSupportOrderHistory()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("My Banquet"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.store,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new BoutiqueStore()));
              },
            ),
            new ListTile(
              title: new Text("Add Products"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Products()));
              },
            ),
            new ListTile(
              title: new Text("Add categories"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new ProductCategories()));
              },
            ),
            new ListTile(
              title: new Text("Add Restaurants"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) => new Restaurants()));
              },
            ),
            new Divider(),
            new ListTile(
              title: new Text("Account Handler"),
              leading: new CircleAvatar(
                backgroundColor: Colors.teal[900],
                child: new Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new SupportAccountRecovery()));
              },
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new SizedBox(
          height: 40.0,
          child: new Image.asset(
            "assets/images/girlies_text_support.png",
            height: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: new ChatScreen(
        messages: messageModel.buildDemoMessages(),
      ),
    );
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  void onPageChanged(int page) {
    setState(() {});
  }

  void findUserOrder() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new JamarOrderSearch()));
  }

  void findAllUserOrder() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new CupertinoPageRoute(
        builder: (BuildContext context) => new JamarOrderSearch()));
  }
}
