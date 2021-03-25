import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/progress.dart';
import 'package:jamar/main.dart';
import 'package:image_picker/image_picker.dart';

class Products extends StatefulWidget {
  @override
  _GirliesBoutiqueState createState() => new _GirliesBoutiqueState();
}

class _GirliesBoutiqueState extends State<Products> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  TextEditingController productController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController sizeController = new TextEditingController();
  TextEditingController colorController = new TextEditingController();
  TextEditingController stockController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController categoryController = new TextEditingController();
  bool _canAddProduct = false;
  File productImage;
  bool isAdding = false;
  BuildContext context;
  static DatabaseReference dbRef = FirebaseDatabase.instance.reference();
  static final reference = dbRef.child(AppData.productsDB);
  String editText;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    reference.keepSynced(true);
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Saving....',
  );

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onTap: () {},
          child: new Text(
            "products",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new InkWell(
              onTap: () {
                setProductIMG();
              },
              child: new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: productImage == null
                      ? new CircleAvatar(
                          child: new Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        )
                      : new CircleAvatar(
                          backgroundImage: new FileImage(productImage),
                        )),
            ),
            // new Flexible(
            //   child: new TextField(
            //     controller: _textEditingController,
            //     onChanged: (String messageText) {
            //       setState(() {
            //         if (productImage != null)
            //           _canAddProduct = messageText.length > 0;
            //       });
            //     },
            //     onSubmitted: _textMessageSubmitted,
            //     decoration: new InputDecoration.collapsed(
            //       hintText: "Enter Product",
            //     ),
            //   ),
            // ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 5.0),
              child: new TextFormField(
                controller: categoryController,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "Category",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 5.0),
              child: new TextFormField(
                controller: productController,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "Product Name",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
              child: new TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "Set Price",
                  prefixText: "KES ",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 5.0, bottom: 0.0),
              child: new TextFormField(
                controller: sizeController,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "Spices Available",
                  hintText: "Eg. (chilly, salty, lemonated)",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
              child: new TextFormField(
                controller: colorController,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "Restaurants Available",
                  hintText: "Eg. (Panari, Diani, Hilton)",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 0.0, bottom: 10.0),
              child: new TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "amount available",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            new Container(
              height: 50.0,
              margin: new EdgeInsets.only(
                  left: 8.0, right: 8.0, top: 0.0, bottom: 50.0),
              child: new TextFormField(
                controller: descriptionController,
                maxLines: 4,
                style:
                    new TextStyle(color: MyApp.appColors[500], fontSize: 18.0),
                decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(12.0),
                  labelText: "Product Description",
                  labelStyle:
                      new TextStyle(fontSize: 20.0, color: Colors.black54),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: new BorderSide(color: Colors.black54)),
                ),
              ),
            ),
            //new Container(
            //  margin: const EdgeInsets.symmetric(horizontal: 4.0),
            //  child: Theme.of(context).platform == TargetPlatform.iOS
            //      ? getIOSSendButton()
            //      : getDefaultSendButton(),
            //),
            RaisedButton(
              onPressed: _createProduct,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child:
                    const Text('Add product', style: TextStyle(fontSize: 20)),
              ),
            )
          ],
          // children: <Widget>[
          //   new Container(
          //     decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          //     child: _buildProductAdder(),
          //   ),
          //   new Flexible(
          //       child: new FirebaseAnimatedList(
          //     defaultChild: new Center(
          //       child: new CircularProgressIndicator(),
          //     ),
          //     query: reference,
          //     padding: const EdgeInsets.all(8.0),
          //     reverse: false,
          //     sort: (a, b) {
          //       return b.key.compareTo(a.key);
          //     },
          //     itemBuilder: (BuildContext context, DataSnapshot snapshot,
          //         Animation animation, int index) {
          //       return new Container(
          //         height: 60.0,
          //         color: Colors.white,
          //         child: new Row(
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: <Widget>[
          //               new Padding(
          //                 padding: const EdgeInsets.all(5.0),
          //                 child: new Container(
          //                   child: new CircleAvatar(
          //                     backgroundImage: new NetworkImage(
          //                         snapshot.value[AppData.productImgURL]),
          //                   ),
          //                 ),
          //               ),
          //               new Padding(padding: new EdgeInsets.only(left: 10.0)),
          //               new Flexible(
          //                 fit: FlexFit.tight,
          //                 child: new Text(snapshot.value[AppData.productName]),
          //               ),
          //               new Container(
          //                 child: new Row(
          //                   children: <Widget>[
          //                     new IconButton(
          //                         icon: new Icon(
          //                           Icons.edit,
          //                           size: 20.0,
          //                           color: MyApp.appColors,
          //                         ),
          //                         onPressed: () {
          //                           _editProduct(snapshot: snapshot);
          //                         }),
          //                     new Container(
          //                       height: 30.0,
          //                       width: 1.0,
          //                       color: Colors.black12,
          //                       margin: const EdgeInsets.only(
          //                           left: 5.0, right: 5.0),
          //                     ),
          //                     new IconButton(
          //                         icon: new Icon(
          //                           Icons.delete_forever,
          //                           size: 20.0,
          //                           color: MyApp.appColors,
          //                         ),
          //                         onPressed: () {
          //                           _removeProduct(
          //                               refKey: snapshot.value[AppData.keyID]);
          //                         })
          //                   ],
          //                 ),
          //               )
          //             ]),
          //       );
          //     },
          //   )),
          // ],
        ),
      ),
    );
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Add"),
      onPressed: _canAddProduct
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.add_circle_outline),
      onPressed: _canAddProduct
          ? () {
              return _createProduct();
            }
          : null,
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    FocusScope.of(context).requestFocus(new FocusNode());

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return progress;
        });
    await _createProduct();
  }

  Future setProductIMG() async {
    File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      setState(() {
        productImage = imgFile;
      });
    }
  }

  Future _createProduct(
      {String productName,
      productPrice,
      categoryName,
      productSizesAvailable,
      productColorsAvailable,
      productNoInStock,
      productDescription}) async {
    String ref = reference.push().key;
    setState(() {
      isAdding = true;
    });
    StorageTaskSnapshot snapshot = await FirebaseStorage.instance
        .ref()
        .child(AppData.productsDB)
        .child(ref)
        .child(ref + ".jpg")
        .putFile(productImage)
        .onComplete;
    // StorageReference storageReference = FirebaseStorage.instance
    //     .ref()
    //     .child(AppData.productsDB)
    //     .child(refKey)
    //     .child(refKey + ".jpg");
    // StorageUploadTask uploadTask = storageReference.putFile(catergoryImage);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    FirebaseDatabase.instance
        .reference()
        .child(AppData.productsDB)
        .child(ref)
        .set({
      AppData.productImgURL: downloadUrl.toString(),
      AppData.productName: productController.text,
      AppData.productPrice: priceController.text,
      AppData.categoryName: categoryController.text,
      AppData.productSpicesAvailable: sizeController.text,
      AppData.productRestaurantsAvailable: colorController.text,
      AppData.productNoInStock: stockController.text,
      AppData.productDescription: descriptionController.text,
      AppData.keyID: ref,
    });
    setState(() {
      isAdding = false;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Successfully Added')));
    });

    // .then((_) {
    //   Scaffold.of(context)
    //       .showSnackBar(SnackBar(content: Text('Successfully Added')));
    //   catergoryImage = null;
    //   _textEditingController.clear();
    //   isAdding = false;
    //   Navigator.pop(context);
    // }).catchError((onError) {
    //   Scaffold.of(context).showSnackBar(SnackBar(content: Text(onError)));
    // });
  }
}
