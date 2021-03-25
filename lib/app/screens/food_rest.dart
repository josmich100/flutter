import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:jamar/app/data.dart';

class RestaurantDetails extends StatefulWidget {
  RestaurantDetails({Key key}) : super(key: key);

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  Query _ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ref = FirebaseDatabase.instance
        .reference()
        .child(AppData.productsDB)
        .orderByChild('keyID');
  }

  Widget _buildRestaurant({Map contact}) {
    return SingleChildScrollView(
      child: Container(
          height: 100,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                contact[AppData.categoryName],
                style: TextStyle(fontSize: 20, color: Colors.teal),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                contact[AppData.productName],
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                contact[AppData.productRestaurantsAvailable],
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              Divider(),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Restaurant Details",
          style: TextStyle(color: Colors.black38),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: _ref,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map contact = snapshot.value;
            return _buildRestaurant(contact: contact);
          },
        ),
      ),
    );
  }
}
