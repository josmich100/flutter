import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:jamar/app/girlies_app.dart';
import 'package:jamar/navigation.dart';
import 'package:jamar/app/screens/splashscreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jamar/support/jamar_support.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

void main() {
  MpesaFlutterPlugin.setConsumerKey("1Zdm4jID1nUlBDGErtJWpBGvzvLi6Hxl");
  MpesaFlutterPlugin.setConsumerSecret("XK96B5B1pzzcO8yO");
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(1000000000);
  FirebaseDatabase.instance.reference().keepSynced(true);
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(new MyApp());
}

var routes = <String, WidgetBuilder>{
  ScreenNavigator.login: (BuildContext context) {
    return null;
  },
  ScreenNavigator.signup: (BuildContext context) {
    return null;
  },
  ScreenNavigator.jamar: (BuildContext context) {
    return new JamarApp();
  },
  ScreenNavigator.support: (BuildContext context) {
    return JamarSupport();
  },
  ScreenNavigator.controller: (BuildContext context) {
    return null;
  },
};

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.teal,
    primaryColor: Color(0xFF004D40),
    primaryColorBrightness: Brightness.light);

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.cyan,
    accentColor: Color(0xFF006064),
    primaryColor: Color(0xFF00838F),
    splashColor: Colors.lightBlue[900]);

class MyApp extends StatelessWidget {
  /*keytool -list -v -keystore C:\Users\MAUGOST\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android*/
//  1D:70:80:2D:53:71:89:AB:D2:24:F0:FB:36:71:25:61

//  keytool -exportcert -alias androiddebugkey -keystore "C:\Users\MAUGOST\.android\debug.keystore" | "C:\Users\MAUGOST\Documents\openssl-0.9.8k_WIN32\bin\openssl" sha1 -binary | "C:\Users\MAUGOST\Documents\openssl-0.9.8k_WIN32\bin\openssl" base64

  static const appColors = ColorSwatch(0xFF00838F, {
    "appColor": Color(0xFF004D40),
    100: Color(0xFF00838F),
    200: Color(0xFF004D40),
    300: Color(0xFF004D40),
    400: Color(0xFF00838F),
    500: Color(0xFF004D40),
    600: Color(0xFF00838F),
    700: Color(0xFF004D40),
    800: Color(0xFF00838F),
    900: Color(0xFF00838F),
    1000: Color(0xFF004D40),
    0000: Color(0xFF000000),
  });
  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  // return new MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   title: 'JAMAR',
  //   theme: defaultTargetPlatform == TargetPlatform.iOS
  //       ? kIOSTheme
  //       : kDefaultTheme,
  //   home: new SplashScreen(),
  //   routes: routes,
  // );
  // }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'JAMAR',
            theme: defaultTargetPlatform == TargetPlatform.iOS
                ? kIOSTheme
                : kDefaultTheme,
            home: new SplashScreen(),
            routes: routes,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
