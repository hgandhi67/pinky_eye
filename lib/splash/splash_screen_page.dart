import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/splash/splash_selector_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  SharedPreferences sharedPreferences;
  bool loginState = false;

  Future<bool> setSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(Constants.IS_PINKY_EYE_LOGIN);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      Constants.screenHeight = MediaQuery.of(context).size.height;
      Constants.screenWidth = MediaQuery.of(context).size.width;
    }
  }

  @override
  void initState() {
    super.initState();
    setSharedPref().then((value) {
      print('The value is : $value');
      if (value == null) {
        value = false;
      }
      loginState = value;
      Future.delayed(Duration(seconds: 3), () {
        if (loginState) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.HOME_PAGE);
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SplashSelectorPage(),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          Image.asset(
//            'images/splash_bg.png',
//            fit: BoxFit.cover,
//            height: Constants.screenHeight,
//            width: Constants.screenWidth,
//          ),
          Image.asset(
            'images/splash.png',
            fit: BoxFit.cover,
            height: Constants.screenHeight,
            width: Constants.screenWidth,
          ),
//          Positioned(
//            top: MediaQuery.of(context).size.width * 0.3,
//            child: Container(
//              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//              child: Image.asset(
//                'images/pinky_logo.png',
//                fit: BoxFit.cover,
//                height: Constants.screenWidth * 0.5,
//                width: Constants.screenWidth * 0.5,
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
