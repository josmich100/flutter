import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/base.dart';
import 'package:jamar/models/fbconn.dart';

class JamarRequests extends StatefulWidget {
  final String requestKey;
  JamarRequests({this.requestKey});
  @override
  _JamarRequestsState createState() => new _JamarRequestsState();
}

class _JamarRequestsState extends State<JamarRequests> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    var streamBuilder = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.adminOrdersDB)
          .child(widget.requestKey)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbconn = new FbConn(map);
          int length = map == null ? 0 : map.keys.length;

          final cartSummary = new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              margin: new EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      "ITEMS (${length == 0 ? "0" : fbconn.getDataSize().toString()})",
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w700),
                    ),
                    new Text(
                      "TOTAL : KES.${length == 0 ? "0" : fbconn.getTotalProductPrice().toString()}",
                      style: new TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.w700),
                    ),
                  ]),
            ),
          );

          final firstList = new Flexible(
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: length,
              itemBuilder: (context, index) {
                final row = new GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: new SafeArea(
                    top: false,
                    bottom: false,
                    child: new Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                      child: new Row(
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) {
                                    return new Material(
                                      color: Colors.black38,
                                      child: new Container(
                                        padding: const EdgeInsets.all(30.0),
                                        child: new GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: new Hero(
                                            child: new Image.network(
                                              fbconn
                                                  .getDefaultIMGAsList()[index],
                                              width: 300.0,
                                              height: 300.0,
                                              alignment: Alignment.center,
                                              fit: BoxFit.contain,
                                            ),
                                            tag: fbconn
                                                .getProductNameAsList()[index],
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                            },
                            child: new Hero(
                              tag: fbconn.getProductNameAsList()[index],
                              child: new Container(
                                height: 60.0,
                                width: 60.0,
                                decoration: new BoxDecoration(
                                  //color: color,
                                  image: new DecorationImage(
                                      image: new NetworkImage(
                                          fbconn.getDefaultIMGAsList()[index])),
                                  borderRadius: new BorderRadius.circular(8.0),
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
                                children: <Widget>[
                                  new Text(
                                      fbconn.getProductNameAsList()[index]),
                                  const Padding(
                                      padding: const EdgeInsets.only(top: 5.0)),
                                  new Text(
                                    "KES." +
                                        fbconn.getProductPriceAsList()[index],
                                    style: const TextStyle(
                                      color: const Color(0xFF8E8E93),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          new CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: new Icon(
                              CupertinoIcons.minus_circled,
                              color: MyApp.appColors[600],
                              semanticLabel: 'Substract',
                            ),
                            onPressed: () {
                              /*removeQuantity(fbconn.getKeyIDasList()[index],
                                  fbconn.getItemQuantityAsList()[index]);*/
                            },
                          ),
                          new Text(
                            fbconn.getItemQuantityAsList()[index].toString(),
                            style: const TextStyle(
                              color: const Color(0xFF8E8E93),
                              fontSize: 13.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          new CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: new Icon(
                              CupertinoIcons.plus_circled,
                              color: MyApp.appColors[600],
                              semanticLabel: 'Add',
                            ),
                            onPressed: () {
                              /*addQuantity(fbconn.getKeyIDasList()[index],
                                  fbconn.getItemQuantityAsList()[index]);*/
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                return new Container(
                  margin:
                      new EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
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
            ),
          );
          if (map == null) {
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
                      child: new Image.asset('assets/images/empty.png')),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: new Text(
                      "This order request is empty....",
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ],
              )),
            );
          } else {
            return new Column(
              children: <Widget>[
                cartSummary,
                firstList,
                new Container(
                  height: 120.0,
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new CircleAvatar(
                              radius: 25.0,
                              backgroundColor: MyApp.appColors[400],
                              child: new Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                            new CircleAvatar(
                              radius: 25.0,
                              backgroundColor: MyApp.appColors[400],
                              child: new Icon(
                                Icons.chat,
                                color: Colors.white,
                              ),
                            ),
                            new CircleAvatar(
                              radius: 25.0,
                              backgroundColor: MyApp.appColors[400],
                              child: new Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                            ),
                            new CircleAvatar(
                              radius: 25.0,
                              backgroundColor: MyApp.appColors[400],
                              child: new Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Container(
                            width: 160.0,
                            height: 50.0,
                            color: Colors.green[600],
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                                new Text(
                                  "ORDER COMPLETE",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          new Container(
                            width: 180.0,
                            height: 50.0,
                            color: MyApp.appColors[600],
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                                new Text(
                                  "PAY NOW",
                                  style: new TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            );
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
    );

    return Scaffold(
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Order Request",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: streamBuilder,
    );
  }
}

class _OrderLists extends StatefulWidget {
  final List<Base> orders;

  _OrderLists({this.orders});

  @override
  _OrderListsState createState() {
    return new _OrderListsState();
  }
}

class _OrderListsState extends State<_OrderLists> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new SizedBox(
      height: screenSize.height - 135,
      child: new ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.orders.length,
        itemBuilder: (context, index) {
          final row = new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: new SafeArea(
              top: false,
              bottom: false,
              child: new Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, top: 8.0, bottom: 8.0, right: 8.0),
                child: new Row(
                  children: <Widget>[
                    new GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) {
                              return new Material(
                                color: Colors.black38,
                                child: new Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: new GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: new Hero(
                                      child: new Image.network(
                                        widget.orders[index].productImgURL,
                                        width: 300.0,
                                        height: 300.0,
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain,
                                      ),
                                      tag: widget.orders[index].productTitle,
                                    ),
                                  ),
                                ),
                              );
                            }));
                      },
                      child: new Hero(
                        tag: widget.orders[index].productTitle,
                        child: new Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: new BoxDecoration(
                            //color: color,
                            image: new DecorationImage(
                                image: new NetworkImage(
                                    widget.orders[index].productImgURL)),
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(widget.orders[index].productTitle),
                            const Padding(
                                padding: const EdgeInsets.only(top: 5.0)),
                            new Text(
                              "KES. " +
                                  widget.orders[index].productPrice.toString(),
                              style: const TextStyle(
                                color: const Color(0xFF8E8E93),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    new CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: new Icon(
                        CupertinoIcons.minus_circled,
                        color: MyApp.appColors[600],
                        semanticLabel: 'Substract',
                      ),
                      onPressed: null,
                    ),
                    new Text(
                      widget.orders[index].itemQuantity.toString(),
                      style: const TextStyle(
                        color: const Color(0xFF8E8E93),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    new CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: new Icon(
                        CupertinoIcons.plus_circled,
                        color: MyApp.appColors[600],
                        semanticLabel: 'Add',
                      ),
                      onPressed: null,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
