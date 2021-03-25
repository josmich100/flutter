import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/models/base.dart';
import 'package:jamar/models/fbconn.dart';

class SupportMessages extends StatefulWidget {
  @override
  _SupportMessagesState createState() => new _SupportMessagesState();
}

class _SupportMessagesState extends State<SupportMessages> {
  Base messageModel = new Base.messages();

  FbConn fbConn;

  // ignore: cancel_subscriptions
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String userid;
  String fullName;
  String email;
  String phone;
  String profileImgUrl;
  bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    _getUserMessages();
    new Timer.periodic(new Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(value),
    ));
  }

  Future _getUserMessages() async {
    /*  _messageSubscription = messageRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        cartCount = 0;
        setState(() {});
        return;
      }
      Map valFav = event.snapshot.value;
      FbConn fbConn = new FbConn(valFav);
      cartCount = fbConn.getDataSize();
      setState(() {});
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: new RefreshIndicator(
        child: new ListView(
          children: <Widget>[
            new _MessageList(
              messages: messageModel.buildDemoMessages(),
            ),
          ],
        ),
        onRefresh: () {},
      ),
    );
  }
}

class _MessageList extends StatefulWidget {
  final List<Base> messages;

  _MessageList({this.messages});

  /* @override
  _MessageListState createState() {
    return new _MessageListState();
  }*/
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<_MessageList> {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => new Column(
        children: <Widget>[
          new Divider(
            height: 10.0,
          ),
          new ListTile(
            leading: new CircleAvatar(
              foregroundColor: Theme.of(context).primaryColor,
              backgroundColor: Colors.grey,
              backgroundImage:
                  new NetworkImage(widget.messages[index].senderImgUrl),
            ),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(widget.messages[index].senderName,
                    style: new TextStyle(fontWeight: FontWeight.bold)),
                new Text(widget.messages[index].messageTime,
                    style: new TextStyle(color: Colors.grey, fontSize: 14.0)),
              ],
            ),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Text(widget.messages[index].messageSent,
                  style: new TextStyle(color: Colors.grey, fontSize: 15.0)),
            ),
          )
        ],
      ),
    );
  }
}
