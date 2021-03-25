import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/progress.dart';
import 'package:jamar/app/screens/food_rest.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/fbconn.dart';

class Rest extends StatefulWidget {
  @override
  _BuilderState createState() => new _BuilderState();
}

class _BuilderState extends State<Rest> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;

  @override
  void initState() {
    super.initState();
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Please wait...',
  );

  listAlertDialog(String productKey) {
    var listDialog = new SimpleDialog(
      //title: const Text('Select assignment'),
      children: <Widget>[
        new SimpleDialogOption(
          onPressed: () {},
          child: const Text('Reviews'),
        ),
        new Divider(),
        new SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            //Navigator.of(context).push(new CupertinoPageRoute(
            //  builder: (BuildContext context) => new EditProducts(
            //        productKey: productKey,
            //     )));
          },
          child: const Text('Edit'),
        ),
        new Divider(),
        new SimpleDialogOption(
          onPressed: () {},
          child: const Text('Details'),
        ),
        new Divider(),
        new SimpleDialogOption(
          onPressed: () {},
          child: const Text('Ratings'),
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return listDialog;
        });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.restaurantsDB)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbConn = new FbConn(map);
          int length = map.keys.length;

          final storeItems = new GridView.builder(
            itemCount: length,
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                onLongPress: () {
                  listAlertDialog(fbConn.getKeyIDasList()[index]);
                },
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          new RestaurantDetails()));
                },
                child: new Card(
                  child: new GridTile(
                      child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Image.network(
                          fbConn.getRestaurantImageAsList()[index],
                          height: 100.0,
                        ),
                      ),
                      new Align(
                        alignment: Alignment.center,
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Text(
                            "Name: " + fbConn.getRestaurantAsList()[index],
                          ),
                        ),
                      ),
                      //buttons
                    ],
                  ) //just for testing, will fill with image later
                      ),
                ),
              );
            },
          );

          return storeItems;
        } else if (!snapshot.hasData) {
          return new Container(
            constraints: const BoxConstraints(maxHeight: 500.0),
            child: new Center(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    margin: new EdgeInsets.only(top: 00.0, bottom: 0.0),
                    height: 150.0,
                    width: 150.0,
                    child: new Image.asset(
                        'assets/images/no_internet_access.png')),
                new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Text(
                    "No internet access..",
                    style: new TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
              ],
            )),
          );
        } else {
          return new Center(child: new CircularProgressIndicator());
        }
      },
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Restaurants",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
          onTap: () => Navigator.of(context).push(new CupertinoPageRoute(
              builder: (BuildContext context) => new RestaurantDetails())),
          child: streamBuilder),
    );
  }
}
