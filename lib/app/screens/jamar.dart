import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/accounts/login.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/progress.dart';
import 'package:jamar/app/screens/cart.dart';
import 'package:jamar/app/screens/jamar_item.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/base.dart';
import 'package:jamar/models/fbconn.dart';

class Jamar extends StatefulWidget {
  @override
  _JamarState createState() => new _JamarState();
}

class _JamarState extends State<Jamar> {
  //Base base = new Base.products();
  final categoryRef =
      FirebaseDatabase.instance.reference().child(AppData.categoriesDB);
  final productRef =
      FirebaseDatabase.instance.reference().child(AppData.productsDB);

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  var refreshMenuKey = GlobalKey<RefreshIndicatorState>();
  StreamSubscription<Event> _favoriteSubscription;
  String selectedCategory = "All";
  bool categorySelected = false;
  bool allCategorySelected = false;
  bool isFlitered = false;
  bool _isSignedIn = false;
  FbConn fbConn;
  FbConn fbConnFiltered;
  FbConn fbConnCat;
  FirebaseAuth _auth;
  int cartCount;

  @override
  void initState() {
    super.initState();
    setState(() {});
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
    _getProducts();
    _getCategory();
  }

  @override
  void dispose() {
    super.dispose();
    _favoriteSubscription.cancel();
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Please wait...',
  );

  void showInSnackBar(String value, bool loggedIn) {
    loggedIn == true
        ? ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: new Text(value),
            action: new SnackBarAction(
                label: "Login",
                onPressed: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new JamarLogin()));
                }),
          ))
        : ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: new Text(value),
          ));
  }

  Future _getCurrentUser() async {
    if (_auth.currentUser != null) {
      setState(() {
        _isSignedIn = true;
        AppData.currentUserID = _auth.currentUser.uid;
      });
    }

    _auth.authStateChanges().listen((user) {
      if (user == null) {
        setState(() {
          _isSignedIn = false;
          AppData.currentUserID = null;
        });
      } else {
        _isSignedIn = true;
        AppData.currentUserID = user.uid;
      }
    });
  }

  Future _getProducts() async {
    await productRef.once().then((snapshot) {
      if (snapshot.value == null) {
        showInSnackBar("No Data Available!!!", false);
        return;
      }

      print(AppData.currentUserID);
      Map val = snapshot.value;
      fbConn = new FbConn(val);
      //AppData.boutiqueFbConn = new FbConn(val);

      fbConn.addIsFavorite(false);
      _checkIfFavorite(fbConn);

      setState(() {});
    }).catchError((e) {
      showInSnackBar("Error Occured : $e", false);
    });
  }

  Future _getCategory() async {
    await categoryRef.once().then((snapshot) {
      if (snapshot.value == null) {
        showInSnackBar("No Data Available!!!", false);
        return;
      }
      Map val = snapshot.value;
      fbConnCat = new FbConn(val);
      print(fbConnCat.toString());

      setState(() {});
    }).catchError((e) {
      showInSnackBar("Error Occured : $e", false);
    });
  }

  Future _checkIfFavorite(FbConn value) async {
    //refreshMenuKey.currentState.show();
    final favoriteRef = FirebaseDatabase.instance
        .reference()
        .child(AppData.favoriteDB)
        .child(AppData.currentUserID);

    _favoriteSubscription = favoriteRef.onValue.listen((event) {
      if (event.snapshot.value == null) {
        //showInSnackBar("No Update Data Available!!!", false);
        return;
      }
      //refreshMe();
      //refreshMenuKey.currentState.show();
      //showInSnackBar("Update Data Available!!!", false);
      Map valFav = event.snapshot.value;
      FbConn subFav = new FbConn(valFav);
      print(fbConn.getIsFavoriteAsList());

      for (int s = 0; s < subFav.getDataSize(); s++) {
        String key = subFav.getKeyIDasList()[s];
        fbConn.loadFavorite(key);
      }

      fbConn = new FbConn(value.getListMap());
      setState(() {});
      print(fbConn.getIsFavoriteAsList());
    });
  }

  Future<Null> refreshMe() async {
    refreshMenuKey.currentState.show();
//    fbConn = null;
//    setState(() {});
    await _getProducts();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //final Size screenSize = MediaQuery.of(context).size;

    var streamBuilderCat = new StreamBuilder(
      stream: FirebaseDatabase.instance
          .reference()
          .child(AppData.categoriesDB)
          .orderByValue()
          .onValue,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
          FbConn fbConnCat = new FbConn(map);
          int length = map == null ? 0 : map.keys.length;

          final categories = new SizedBox(
            height: 50.0,
            width: 100.0,
            child: new ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: length,
              itemExtent: 100.0,
              itemBuilder: (context, index) {
                return new Padding(
                  padding: const EdgeInsets.only(
                      left: 3.0, right: 3.0, top: 20.0, bottom: 60.0),
                  child: new GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory =
                            fbConnCat.getCategoryNameAsList()[index];
                        categorySelected = true;
                        filterFbConn(selectedCategory);
                      });
                    },
                    child: new Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: new DecorationImage(
                          image: new NetworkImage(
                              fbConnCat.getCategoryImageAsList()[index],
                              scale: 10.0),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(50.0)),
                        border: new Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
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
                      "You have no item in your banquet....",
                      style: new TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ],
              )),
            );
          } else {
            return categories;
          }
        } else {
          return new Center(
              child: new Center(child: new CircularProgressIndicator()));
        }
      },
    );

    return new Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: true,
        body: fbConn == null /*&& fbConnCat == null*/
            ? new Center(
                child: new CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              )
            : new RefreshIndicator(
                key: refreshMenuKey,
                onRefresh: refreshMe,
                child: new CustomScrollView(
                  slivers: <Widget>[
                    new SliverAppBar(
                      pinned: true,
                      expandedHeight: 200.0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: new Row(
                          children: <Widget>[
                            Text(
                              selectedCategory,
                              style: new TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800),
                            ),
                            new Padding(
                                padding: new EdgeInsets.only(right: 2.0)),
                            isFlitered == true
                                ? new InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = "All";
                                        allCategorySelected = true;
                                        isFlitered = false;
                                        //filterFbConn(selectedCategory);
                                      });
                                    },
                                    child: new Container(
                                      width: 80.0,
                                      margin: new EdgeInsets.only(
                                          left: 0.0,
                                          right: 2.0,
                                          bottom: 2.0,
                                          top: 2.0),
                                      height: 20.0,
                                      decoration: new BoxDecoration(
                                          color: MyApp.appColors[600],
                                          borderRadius: new BorderRadius.all(
                                              new Radius.circular(5.0))),
                                      child: new Center(
                                          child: new Text(
                                        "All",
                                        style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w100,
                                        ),
                                      )),
                                    ),
                                  )
                                : new Container(
                                    width: 100.0,
                                    height: 20.0,
                                    margin: new EdgeInsets.only(
                                        left: 2.0, right: 2.0, bottom: 2.0),
                                  )
                          ],
                        ),
                        background:
                            /*categories,*/ streamBuilderCat,
                      ),
                    ),
                    categorySelected == true
                        ? new SliverAppBar(
                            pinned: true,
                            backgroundColor: Colors.white,
                            expandedHeight: 400.0,
                            flexibleSpace: FlexibleSpaceBar(
                              background: new Center(
                                child: new CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                ),
                              ),
                            ),
                          )
                        : productLoader(
                            isFlitered == true ? fbConnFiltered : fbConn)
                  ],
                ),
              ),
        floatingActionButton: new Stack(
          children: <Widget>[
            new FloatingActionButton(
              mini: false,
              onPressed: () {
                cartCount == 0
                    ? showInSnackBar("Your cart is empty", false)
                    : _isSignedIn == false
                        ? showInSnackBar(
                            "Please login to view your cart!", true)
                        : Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                new JamarCart()));
              },
              tooltip: 'Your Cart',
              child: new Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
            new CircleAvatar(
              radius: 10.0,
              backgroundColor: Colors.red[900],
              child: _isSignedIn == false
                  ? new Text(
                      "0",
                      style: new TextStyle(color: Colors.white, fontSize: 9.0),
                    )
                  : new Text(
                      cartCount == null ? "0" : cartCount.toString(),
                      style: new TextStyle(color: Colors.white, fontSize: 9.0),
                    ),
            )
          ],
        ));
  }

  SliverGridProductList productLoader(FbConn fb) {
    return new SliverGridProductList(
      fbConn: fb,
    );
  }

  void filterFbConn(String selectedCategory) {
    Map altList = new Map();
    altList.addAll(fbConn.getListMap());
    FbConn fbConnSub = new FbConn(altList);
    List<String> sKey = [];
    for (int s = 0; s < fbConnSub.getDataSize(); s++) {
      if (fbConnSub.getProductCategoryAsList()[s] != selectedCategory) {
        String key = fbConnSub.getKeyIDasList()[s];
        sKey.add(key);
      }
    }

    for (int s = 0; s < sKey.length; s++) {
      fbConnSub.getListMap().remove(sKey[s]);
    }

    fbConnFiltered = fbConnSub;
    setState(() {
      isFlitered = true;
      categorySelected = false;
    });
  }
}

class SliverGridProductList extends StatefulWidget {
  final List<Base> products;
  final FbConn fbConn;

  SliverGridProductList({this.products, this.fbConn});

  @override
  _SliverGridProductListState createState() =>
      new _SliverGridProductListState();
}

class _SliverGridProductListState extends State<SliverGridProductList> {
  BuildContext context;
  FirebaseAuth _auth;
  bool _isSignedIn = false;
  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
  }

  void showInSnackBar(String value, bool loggedIn) {
    loggedIn == true
        ? ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: new Text(value),
            action: new SnackBarAction(
                label: "Login",
                onPressed: () {
                  Navigator.of(context).push(new CupertinoPageRoute(
                      builder: (BuildContext context) => new JamarLogin()));
                }),
          ))
        : ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
            content: new Text(value),
          ));
  }

  Future _getCurrentUser() async {
    if (_auth.currentUser != null) {
      setState(() {
        _isSignedIn = true;
        AppData.currentUserID = _auth.currentUser.uid;
      });
    }

    _auth.authStateChanges().listen((user) {
      if (user == null) {
        setState(() {
          _isSignedIn = false;
          AppData.currentUserID = null;
        });
      } else {
        _isSignedIn = true;
        AppData.currentUserID = user.uid;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new SliverGrid(
      gridDelegate: new SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 0.9,
      ),
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return new GestureDetector(
            onTap: () {
              Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new BoutiqueItem(
                        productCategory:
                            widget.fbConn.getProductCategoryAsList()[index],
                        productImage:
                            widget.fbConn.getDefaultIMGAsList()[index],
                        productPrice:
                            widget.fbConn.getProductPriceAsList()[index],
                        productList: widget.products,
                        productTitle:
                            widget.fbConn.getProductNameAsList()[index],
                        productQuantity: num.parse(
                            widget.fbConn.getProductNoInStockAsList()[index]),
                        fbConn: widget.fbConn,
                        sizesAvailable:
                            widget.fbConn.getProductSpicesAsList()[index],
                        colorsAvailable:
                            widget.fbConn.getProductRestaurantsAsList()[index],
                        itemKey: widget.fbConn.getKeyIDasList()[index],
                        index: index,
                        isInFavorite:
                            widget.fbConn.getIsFavoriteAsList()[index],
                      )));
            },
            child: new Card(
              child: new GridTile(
                  header: new Align(
                    alignment: Alignment.topRight,
                    child: new CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: _isSignedIn == false
                          ? new Icon(
                              Icons.favorite_border,
                              color: Colors.black54,
                            )
                          : widget.fbConn.getIsFavoriteAsList()[index] == false
                              ? new Icon(
                                  Icons.favorite_border,
                                  color: Colors.black54,
                                )
                              : new Icon(
                                  Icons.favorite,
                                  color: MyApp.appColors[600],
                                ),
                      onPressed: () {
                        _isSignedIn == false
                            ? showInSnackBar(
                                "Please login to view your add to favorites!",
                                true)
                            : widget.fbConn.getIsFavoriteAsList()[index] == true
                                ? setState(() {
                                    //widget.fbConn.addFavorite(false, index);
                                    widget.fbConn.removeFavorite(index);
                                    showInSnackBar(
                                        /*widget.fbConn
                                                .getProductNameAsList()[index] +*/
                                        "Removed from your favorite",
                                        false);
                                  })
                                : setState(() {
                                    widget.fbConn.addFavorite(true, index);
                                    showInSnackBar(
                                        /*widget.fbConn
                                                .getProductNameAsList()[index] +*/
                                        "Added to your favorite",
                                        false);
                                  });
                      },
                    ),
                  ),
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: new Image.network(
                          widget.fbConn.getDefaultIMGAsList()[index],
                          height: 110.0,
                        ),
                      ),
                      new Align(
                        alignment: Alignment.center,
                        child: new Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: new Text(
                            "KES." +
                                widget.fbConn.getProductPriceAsList()[index],
                          ),
                        ),
                      ),
                      new Align(
                        alignment: Alignment.center,
                        child: new Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: new Text(
                            widget.fbConn.getProductNameAsList()[index],
                          ),
                        ),
                      ),
                      new SizedBox(
                        height: 10,
                      )
                    ],
                  ) //just for testing, will fill with image later
                  ),
            ),
          );
        },
        childCount: widget.fbConn.getDataSize(),
      ),
    );
  }
}
