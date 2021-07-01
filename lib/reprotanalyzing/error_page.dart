import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/widgets/button_widget.dart';

class ErrorPage extends StatefulWidget {
  final File imageFile;

  const ErrorPage({Key key, this.imageFile}) : super(key: key);

  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  List<String> showImagesList = List();

  @override
  void initState() {
    super.initState();

    showImagesList.add('images/donts_1.jpg');
    showImagesList.add('images/donts_2.jpg');
    showImagesList.add('images/dos_1.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          _bgImage(),
          SafeArea(
            child: Column(
              children: <Widget>[
                _getActionBar(),
                Expanded(child: _mainLayout()),
                const SizedBox(height: 60)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bgImage() {
    return Image.asset(
      'images/splash_bg.png',
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.cover,
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
                Navigator.of(context)
                    .popUntil((r) => r.settings.name == 'HomePage');
              },
            ),
          ),
          Expanded(
            child: Container(
              height: 56,
              child: Center(
                child: Text(
                  'Error',
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

  Widget _mainLayout() {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(20.0),
      color: Palette.buttonOffWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              _circleCloseImage(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Text(
                Constants.error_page_text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Palette.lightRedColor,
                  fontFamily: 'WorkSans',
                  fontSize: 21,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Text(
                Constants.error_page_text2,
                textAlign: TextAlign.center,
                style: Styles.termsAndConditionsContextTextStyle,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              GestureDetector(
                onTap: () {
                  _showHowToTakeImages();
                },
                child: Text(
                  Constants.error_page_text3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Palette.lightRedColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Text(
                Constants.error_page_text4,
                textAlign: TextAlign.center,
                style: Styles.termsAndConditionsContextTextStyle,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              _buttonsLayout(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.LEGAL_INFORMATION,
                    arguments: {
                      AppRouteArgKeys.LEGAL_INFO_PAGE_TITLE:
                          Constants.terms_cond31,
                      AppRouteArgKeys.LEGAL_INFO_PAGE_DATA:
                          _getMedicalDisclaimerWidget(),
                    },
                  );
                },
                child: Text(
                  Constants.terms_cond31,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Palette.lightRedColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleCloseImage() {
    return CircleAvatar(
      radius: 50.0,
      backgroundColor: Palette.buttonDarkGrey,
      child: Icon(
        Icons.close,
        size: 30.0,
        color: Palette.white,
      ),
    );
  }

  Widget _buttonsLayout() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              child: ButtonWidget(
                name: Constants.RETAKE,
                bgColor: Palette.subscriptionBgColor,
                textColor: Palette.darkButtonTextColor,
              ),
              onTap: () {
                //camera
                Navigator.of(context).popAndPushNamed(AppRoutes.CAMERA_OVERLAY);
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: GestureDetector(
              child: ButtonWidget(
                name: Constants.CANCEL,
                bgColor: Palette.lightRedColor,
              ),
              onTap: () {
                //home page
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getMedicalDisclaimerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.terms_cond32,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond33,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond34,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond35,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond36,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond37,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond38,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond39,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond40,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond41,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            Constants.terms_cond42,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond43,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }

  void _showHowToTakeImages() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: Constants.screenHeight * 0.4,
            decoration: BoxDecoration(
              color: Palette.lightRedColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 1,
                  top: 1,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 15.0,
                      top: 15.0,
                    ),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset(
                        'images/close.png',
                        scale: 1.3,
                        width: 18,
                        color: Palette.white,
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      Constants.error_page_text3,
                      style: Styles.subscriptionTextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Palette.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Carousel(
                          autoplay: false,
                          dotBgColor: Colors.transparent,
                          dotColor: Palette.buttonOffWhite,
                          dotIncreasedColor: Palette.buttonOffWhite,
                          images: showImagesList.map((image) {
                            return Image.asset(image, fit: BoxFit.fill,);
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
