import 'package:flutter/material.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/splash_bg.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                _getActionBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Palette.white,
                      padding: const EdgeInsets.only(
                        bottom: 25.0,
                        left: 15.0,
                        right: 15.0,
                        top: 20.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Constants.APP_NAME,
                            style: Styles.subscriptionTextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                              color: Palette.lightRedColor,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            Constants.ABOUT_US_DATA,
                            style: Styles.subscriptionTextStyle(
                              color: Palette.homeScreenInfoTextColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Center(
                            child: Column(
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    text: 'Contact email: ',
                                    style: Styles.contactEmailTextStyle,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'info@data245.com',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // can add more TextSpans here...
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Image.asset(
                                  'images/data_245.png',
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 150,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getActionBar() {
    return Container(
      color: Palette.actionBarBgColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 56.0,
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Palette.white,
                size: 18,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Expanded(
            child: Container(
              height: 56,
              child: Center(
                child: Text(
                  Constants.AboutUs,
                  style: Styles.subscriptionTextStyle(
                    fontSize: 18.0,
                    color: Palette.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 56,
          ),
        ],
      ),
    );
  }
}
