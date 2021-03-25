import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/base.dart';

class JamarOrderSearch extends StatefulWidget {
  @override
  _JamarRequestsState createState() => new _JamarRequestsState();
}

class _JamarRequestsState extends State<JamarOrderSearch> {
  Base orderModel = new Base.products();

  @override
  Widget build(BuildContext context) {
    final orderSummary = new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Container(
        margin: new EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
        child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "ITEMS (0)",
                style:
                    new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
              ),
              new Text(
                "TOTAL : KES. 0",
                style:
                    new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
              ),
            ]),
      ),
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
        centerTitle: true,
      ),
      bottomNavigationBar: new Container(
        height: 120.0,
        color: Colors.white,
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
      ),
      body: new RefreshIndicator(
        child: new ListView(
          children: <Widget>[
            orderSummary,
            new _OrderLists(
              orders: orderModel.buildDemoProducts(),
            ),
          ],
        ),
        onRefresh: () {},
      ),
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
