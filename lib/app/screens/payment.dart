import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jamar/app/accounts/login.dart';
import 'package:jamar/app/alert_dialog.dart';
import 'package:jamar/app/data.dart';
import 'package:jamar/app/progress.dart';
import 'package:jamar/app/screens/jamar.dart';
import 'package:jamar/main.dart';
import 'package:jamar/models/base.dart';
import 'package:jamar/models/fbconn.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

class OrderSummary extends StatefulWidget {
  final cartTotal;
  final totalItems;

  OrderSummary({this.cartTotal, this.totalItems});

  @override
  _SupportOrdersState createState() => new _SupportOrdersState();
}

class _SupportOrdersState extends State<OrderSummary> {
  Base orderModel = new Base.products();
  double deliveryFee = 0.00;
  double discountFee = 0.00;
  double totalPayable;
  int groupValue;
  BuildContext context;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FbConn fbConn;
  String transaction = 'No transaction Yet';
  final TextEditingController phoneController = new TextEditingController();
  final TextEditingController addressController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future _getUserInfo() async {}

  @override
  Widget build(BuildContext context) {
    this.context = context;

    final deliveryOptions = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Text(
              "PAYMENT OPTIONS",
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
            ),
          ),
        ),*/
        new RadioListTile(
            value: 0,
            title: new Text("Pay now (Outside Nyahururu)"),
            groupValue: groupValue,
            onChanged: (int changed) {
              setPaymentMethod(changed);
            }),
        new RadioListTile(
            value: 1,
            title: new Text("Pay now (Nyahururu Only)"),
            groupValue: groupValue,
            onChanged: (int changed) {
              setPaymentMethod(changed);
            }),
        new RadioListTile(
            value: 2,
            title: new Text(
              "Pay on delivery  (Nyahururu Only)",
            ),
            groupValue: groupValue,
            onChanged: (int changed) {
              setPaymentMethod(changed);
            }),
        new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Container(
            margin: new EdgeInsets.only(top: 5.0),
            child: new Text(
              "PRICE DETAILS",
              style: new TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );

    final priceSummary = new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          color: Colors.white,
          margin: new EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Cart Total Items",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          widget.totalItems,
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Cart Total Amount",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          widget.cartTotal.toString(),
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Delivery Fee",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          deliveryFee == null
                              ? "KES.0"
                              : "KES." + deliveryFee.toString(),
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.teal[900]),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Discount",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          discountFee == null
                              ? "KES.0"
                              : "KES." + discountFee.toString(),
                          style: new TextStyle(
                              fontSize: 15.0, color: Colors.teal[900]),
                        ),
                      ]),
                ),
              ),
              new Divider(
                height: 10.0,
              ),
              new Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 5.0, top: 5.0),
                child: new Container(
                  height: 35.0,
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "Total Payable",
                          style: new TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                        new Text(
                          totalPayable == null
                              ? " KES" +
                                  (double.parse(widget.cartTotal) +
                                          discountFee +
                                          deliveryFee)
                                      .toString()
                              : "KES." + totalPayable.toString(),
                          style: new TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.w700),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
        new GestureDetector(
          onTap: () {
            groupValue != null && groupValue == 0
                ? payWithATM()
                : groupValue != null && groupValue == 1 || groupValue == 2
                    ? payWithATM()
                    : showInSnackBar("Please select a mode of payment.", false);
          },
          child: new Container(
            height: 50.0,
            margin: new EdgeInsets.only(left: 10.0, right: 10.0),
            decoration: new BoxDecoration(
                color: Colors.green[700],
                borderRadius: new BorderRadius.all(new Radius.circular(5.0))),
            child: new Center(
                child: new Text(
              "LIPA NA MPESA",
              style: new TextStyle(
                color: Colors.white,
              ),
            )),
          ),
        ),
        new Padding(padding: new EdgeInsets.all(8.0))
      ],
    );
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new GestureDetector(
          onLongPress: () {},
          child: new Text(
            "Cart Summary",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          /* new _OrderLists(
            orders: orderModel.buildDemoProducts(),
          ),*/
          deliveryOptions,
          priceSummary
        ],
      ),
    );
  }

  void setPaymentMethod(int changed) {
    setState(() {
      if (changed == 0) {
        groupValue = 0;
        deliveryFee = 350.00;
        totalPayable =
            double.parse(widget.cartTotal) + discountFee + deliveryFee;
      } else if (changed == 1) {
        groupValue = 1;
        deliveryFee = 50.00;
        totalPayable =
            double.parse(widget.cartTotal) + discountFee + deliveryFee;
      } else if (changed == 2) {
        groupValue = 2;
        deliveryFee = 50.00;
        totalPayable = discountFee + deliveryFee;
      }
    });
  }

  var progress = new ProgressBar(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: MyApp.appColors,
    borderRadius: 5.0,
    text: 'Processing wait....',
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

  Future payWithATM() async {
    final dialog = new AlertDialog(
      title: new Text("Please Enter M-Pesa No"),
      contentPadding: new EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: phoneController,
            autofocus: true,
            keyboardType: TextInputType.phone,
            maxLength: 12,
            decoration: new InputDecoration(
                labelText: "Enter Phone Number", hintText: "254xxxxxxxxx"),
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
          onPressed: () async {
            showAlertDialog();
          },
          child: new Text("Proceed"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  payWithCard() {
    if (fbConn.getState() == "" &&
        fbConn.getHomeAddress() == "" &&
        fbConn.getHomeDescription() == "") {
      showAlertDialog();
      return;
    }
    showProceedDialog();
  }

  showAlertDialog() {
    final dialog = new AlertDialog(
      title: new Text("Please Enter Address"),
      contentPadding: new EdgeInsets.all(16.0),
      content: new Row(
        children: <Widget>[
          new Expanded(
              child: new TextField(
            controller: addressController,
            autofocus: true,
            maxLength: 20,
            decoration: new InputDecoration(
                labelText: "delivery Address", hintText: "Amazing , Room 4"),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: new Text("Cancel")),
        new FlatButton(
          onPressed: () async {
            showProceedDialog();
          },
          child: new Text("Proceed"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
    // var alertDialog = new CustomAlertDialog(
    //   borderRadius: 5.0,
    //   setTitle: "Please specify",
    //   setMessage: 'Please setup your delivery address to proceed.',
    //   onProceed: () {
    //     Navigator.of(context).pop();
    //     Navigator.of(context).push(new CupertinoPageRoute(
    //         builder: (BuildContext context) => new JamarDeliveryAddress(
    //               fromPayment: true,
    //             )));
    //   },
    // );
    // showDialog(context: context, child: alertDialog);
  }

  showProceedDialog() {
    var alertDialog = new CustomAlertDialog(
      borderRadius: 5.0,
      setTitle: "Your Delivery Address?",
      btnText: "Pay: KES" + totalPayable.toString().toString(),
      setMessage: "Home: " +
          addressController.text +
          "\n MPesa no.: " +
          phoneController.text,
      // "\n" +
      // "Description: " +
      // fbConn.getHomeDescription(),
      onProceed: () {
        //checkOut(number: phoneController.text);
        cartTransferToAdmin();
      },
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  completeProccess() {
    showInSnackBar("Paying on delivery", false);
  }

  // Future openPaystackPortal() async {
  //   showDialog(
  //     context: context,
  //     child: progress,
  //   );
  //   String result;
  //   try {
  //     result = await JamarChannels.connectToPaystack({
  //       "NAME": "Your Name",
  //       "EMAIL": "you@email.com",
  //       "AMOUNT": 100,
  //       "CURRENCY": "NGN",
  //       "PAYMENT_FOR": "Testing API",
  //       "PAYSTACK_PUBLIC_KEY": paystack_pub_key,
  //       "BACKEND_URL": paystack_backend_url,
  //     });
  //   } on PlatformException catch (e) {
  //     result = e.message;
  //     print(e.message);
  //     Navigator.of(context).pop();
  //     showInSnackBar(e.message, false);
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     transcation = result;
  //     if (result == "UNSUCCESSFULL PAYSTACK PAYMENT") {
  //       Navigator.of(context).pop();
  //       showInSnackBar(result, false);
  //     }
  //   });
  // }
  Future<void> checkOut({String number}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return progress;
        });
    dynamic transactionInitialisation;
    //Wrap it with a try-catch
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: double.parse("1"),
          partyA: number,
          partyB: "174379",
          callBackURL: Uri.parse("https://sandbox.safaricom.co.ke/"),
          accountReference: "JAMAR EATS",
          phoneNumber: number,
          baseUri: Uri.parse("https://sandbox.safaricom.co.ke/"),
          transactionDesc: "Purchase",
          passKey:
              "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");

      //print("Transaction Successful" + transactionInitialisation().toString());
      //return transactionInitialisation;
    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      transactionInitialisation = e.message;
      print(e.message);
      Navigator.of(context).pop();
      showInSnackBar(e.message, false);
    }
    if (!mounted) return;

    setState(() {
      transaction = transactionInitialisation;
      if (transactionInitialisation == "UNSUCCESSFULL PAYSTACK PAYMENT") {
        Navigator.of(context).pop();
        showInSnackBar(transactionInitialisation, false);
      }
    });
  }

  Future cartTransferToAdmin() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return progress;
        });

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child(AppData.cartDB)
        .child(AppData.currentUserID);

    reference.once().then((snapshot) {
      Map cartData = snapshot.value;
      String requestKeyID = reference.push().key;
      //Map notifyAdmin = createAdminRequest(requestKeyID);
      showInSnackBar(cartData.toString(), true);
      //notify admin for new order request
      FirebaseDatabase.instance
          .reference()
          .child(AppData.notifyAdminOrderDB)
          .child(requestKeyID)
          .set(AppData.cartDB);
      //notify user of newly placed order
      FirebaseDatabase.instance
          .reference()
          .child(AppData.orderNotifyDB)
          .child(AppData.currentUserID)
          .child(requestKeyID)
          .set(AppData.cartDB);
      //notify admin
      //store request information into admin orders
      FirebaseDatabase.instance
          .reference()
          .child(AppData.adminOrdersDB)
          .child(requestKeyID)
          .set(AppData.cartDB)
          .whenComplete(() {
        checkOut(number: phoneController.text);
        //clear user cart after order has been placed and go home
        return clearToHome(reference);
      });
    });
  }

  Map createAdminRequest(String requestKeyID) {
    DateTime currentTime = new DateTime.now();
    int orderTime = currentTime.millisecondsSinceEpoch;

    int orderType = groupValue == 0
        ? AppData.TYPE_PAYNOW_OUTSIDE_NYAHURURU
        : groupValue == 1
            ? AppData.TYPE_PAYNOW_WITHIN_NYAHURURU
            : AppData.TYPE_PAYNOW_ONLY_NYAHURURU;

    Map request = new Map();
    request[AppData.orderSenderName] = fbConn.getFullName();
    request[AppData.orderSenderImg] = fbConn.getProfileImage();
    request[AppData.userID] = fbConn.getUserID();
    request[AppData.orderAmount] = totalPayable;
    request[AppData.noOforders] = widget.totalItems;
    request[AppData.orderType] = orderType;
    request[AppData.orderTime] = orderTime;
    request[AppData.orderStatus] = AppData.STATUS_PENDING;
    request[AppData.orderSeen] = false;
    request[AppData.orderRead] = false;
    request[AppData.keyID] = requestKeyID;
    return request;
  }

  Future clearToHome(DatabaseReference reference) async {
    reference.remove();
    Navigator.of(context).pushReplacement(
        new CupertinoPageRoute(builder: (BuildContext context) => new Jamar()));
    //Navigator.of(context).pop();
    // Navigator.of(context).pop();
//Navigator.of(context).pop();
    //  Navigator.of(context).pop();
    //  Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }
}

class MyThreeOptions extends StatefulWidget {
  @override
  _MyThreeOptionsState createState() => new _MyThreeOptionsState();
}

class _MyThreeOptionsState extends State<MyThreeOptions> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return new Wrap(
      children: new List<Widget>.generate(
        3,
        (int index) {
          return new ChoiceChip(
            label: new Text('Item $index'),
            selected: _value == index,
            onSelected: (bool selected) {
              _value = selected ? index : null;
            },
          );
        },
      ).toList(),
    );
  }
}
