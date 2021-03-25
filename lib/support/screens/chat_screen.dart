import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/models/base.dart';
import 'package:jamar/models/fbconn.dart';
import 'package:jamar/models/ref_time.dart';
import 'package:jamar/support/screens/support_chat.dart';

class ChatScreen extends StatefulWidget {
  final List<Base> messages;

  ChatScreen({this.messages});

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  FbConn fbConn;
  FbConn fbConnMessages;
  TimeAgo timeAgoo = new TimeAgo();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext context;

  String userid;
  String fullName;
  String email;
  String phone;
  String profileImgUrl;
  bool isLoggedIn;
  Timer timer;

  List<String> userIDS = [];

  @override
  void initState() {
    _getUserMessages();
    timer = new Timer.periodic(new Duration(seconds: 1), (_) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future _getUserMessages() async {}

  @override
  Widget build(BuildContext context) {
    this.context = context;

    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.conversationsDB)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbconn = new FbConn(map);
          int length = map.keys.length;

          final firstList = new ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: length,
            itemBuilder: (context, index) {
              final row = new GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: listAlertDialog,
                onTap: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new GirliesChats(
                            senderUID: fbconn.getMessageSenderIDasList()[
                                fbconn.getDataSize() - index - 1],
                            senderImage: fbconn.getSenderImageAsList()[
                                fbconn.getDataSize() - index - 1],
                            senderEmail: fbconn.getSenderEmailAsList()[
                                fbconn.getDataSize() - index - 1],
                            senderName: fbconn.getMessageSenderNameAsList()[
                                fbconn.getDataSize() - index - 1],
                            messageID: fbconn.getMessageIDasList()[
                                fbconn.getDataSize() - index - 1],
                            messageKeyID: fbconn.getMessageKeyIDasList()[
                                fbconn.getDataSize() - index - 1],
                          )));
                },
                child: new SafeArea(
                  top: false,
                  bottom: false,
                  child: new Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                    child: new Row(
                      children: <Widget>[
                        fbconn.getSenderImageAsList()[
                                    fbconn.getDataSize() - index - 1] ==
                                ""
                            ? new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                    image: new DecorationImage(
                                        image: new AssetImage(
                                            "assets/images/avatar.png"))),
                                /*child: new Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),*/
                              )
                            : new GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      new PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder:
                                              (BuildContext context, _, __) {
                                            return new Material(
                                              color: Colors.black38,
                                              child: new Container(
                                                padding:
                                                    const EdgeInsets.all(30.0),
                                                child: new GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: new Hero(
                                                    child: new Image.network(
                                                      fbconn.getSenderImageAsList()[
                                                          length - index - 1],
                                                      width: 300.0,
                                                      height: 300.0,
                                                      alignment:
                                                          Alignment.center,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    tag: fbconn
                                                            .getMessageSenderNameAsList()[
                                                        length - index - 1],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }));
                                },
                                child: new Hero(
                                  tag: fbconn.getMessageSenderNameAsList()[
                                      length - index - 1],
                                  child: new Container(
                                    height: 60.0,
                                    width: 60.0,
                                    decoration: new BoxDecoration(
                                      //color: color,

                                      image: new DecorationImage(
                                          image: new NetworkImage(
                                              fbconn.getSenderImageAsList()[
                                                  length - index - 1])),
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                        new Expanded(
                          child: new Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Text(
                                        fbconn.getMessageSenderNameAsList()[
                                            length - index - 1]),
                                    const Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0)),
                                    new Text(
                                      timeAgoo.timeUpdater(new DateTime
                                              .fromMillisecondsSinceEpoch(
                                          fbconn.getMessageTimeAsList()[
                                              length - index - 1])),
                                      style: new TextStyle(
                                        color: Colors.pink[400],
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                                /*const Padding(
                                    padding: const EdgeInsets.only(top: 5.0)),
                                new Text(
                                  timeAgoo.timeUpdater(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          fbconn.getMessageTimeAsList()[
                                              length - index - 1])),
                                  style: new TextStyle(
                                    color: Colors.pink[400],
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),*/
                                const Padding(
                                    padding: const EdgeInsets.only(top: 5.0)),
                                fbconn.getMessageRead()[length - index - 1] ==
                                        false
                                    ? new Text(
                                        fbconn.getMessageTextAsList()[
                                            length - index - 1],
                                        maxLines: 1,
                                        style: new TextStyle(
                                            color: Colors.pink[900],
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400))
                                    : new Text(
                                        fbconn.getMessageTextAsList()[
                                            length - index - 1],
                                        maxLines: 1,
                                        style: new TextStyle(
                                          color: new Color(0xFF8E8E93),
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w300,
                                        )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              return new Container(
                margin: new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    row,
                    new Container(
                      height: 1.0,
                      color: Colors.black12.withAlpha(10),
                    ),
                  ],
                ),
              );
            },
          );

          return firstList;
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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: streamBuilder,
    );
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
}
