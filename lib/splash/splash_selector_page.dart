import 'package:flutter/material.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class SplashSelectorPage extends StatefulWidget {
  @override
  _SplashSelectorPageState createState() => _SplashSelectorPageState();
}

class _SplashSelectorPageState extends State<SplashSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'images/splash_bg.png',
              fit: BoxFit.cover,
              height: Constants.screenHeight,
              width: Constants.screenWidth,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: Constants.screenWidth * 0.3,
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      Constants.WELCOME_TEXT,
                      style: Styles.mediumTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: Constants.screenHeight * 0.02,
                  ),
                  Image.asset(
                    'images/pinkylogo.png',
                    width: Constants.screenWidth * 0.5,
                  ),
                  SizedBox(
                    height: Constants.screenHeight * 0.02,
                  ),
                  Text(
                    Constants.EYES_DECISION,
                    style: Styles.subscriptionTextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Palette.white,
                    ),
                  ),
                  SizedBox(
                    height: Constants.screenHeight * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Text(
                      Constants.DETECT_TEXT,
                      style: Styles.smallTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _showDialog();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          Constants.WHAT_IS_PINKY,
                          style: Styles.rashTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    Constants.PLEASE_LOGIN_SIGN_UP_TEXT,
                    style: Styles.smallTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: Constants.screenHeight * 0.02,
                  ),
                  SafeArea(
                    child: SizedBox(
                      width: Constants.screenWidth * 0.7,
                      child: Row(
                        children: <Widget>[
                          _buttonWidget(
                            backgroundColor: Palette.white,
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutes.SIGN_IN),
                            text: Constants.LOGIN.toUpperCase(),
                            textColor: Palette.darkButtonTextColor,
                          ),
                          SizedBox(
                            width: Constants.screenWidth * 0.05,
                          ),
                          _buttonWidget(
                            backgroundColor: Palette.lightRedColor,
                            onTap: () => Navigator.of(context)
                                .pushNamed(AppRoutes.SIGN_UP),
                            text: Constants.SIGN_UP.toUpperCase(),
                            textColor: Palette.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Constants.screenHeight * 0.07,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonWidget({
    Color backgroundColor,
    Color textColor,
    String text,
    onTap,
  }) {
    return Expanded(
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: Styles.buttonTextStyle(
            color: textColor,
          ),
        ),
        padding: const EdgeInsets.all(15.0),
        color: backgroundColor,
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.only(
              top: 15.0,
              right: 15.0,
              left: 15.0,
              bottom: 25.0,
            ),
            width: Constants.screenWidth * 0.8,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        Constants.WHAT_IS_PINKY,
                        style: Styles.termsAndConditionsTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        Constants.ABOUT_US_DATA,
                        style: Styles.aboutUsContentTextStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Positioned(
                    right: 1,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset(
                        'images/close.png',
                        scale: 1.5,
                        width: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
