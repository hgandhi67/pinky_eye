import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info/package_info.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/ads/app_ads.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const AppDrawer({
    Key key,
    @required this.sharedPreferences,
  }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  static String appVersion = "0.0";

  String currentLoggedUserId;
  String currentEmail = '';
  String currentName = '';
  String currentDob = '';
  String currentZip = '';
  String currentImage = '';

  bool isPaddingAvailable = true;

  Future<SharedPreferences> getSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    print('close');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("open");
    getSharedPref().then((sharedPrefs) {
      currentLoggedUserId = sharedPrefs.getString(Constants.LOGGED_IN_USER_ID);
      Firestore.instance
          .collection('users')
          .document(currentLoggedUserId)
          .get()
          .then((doc) {
        if (doc.data != null) {
          setState(() {
            currentEmail = doc.data['email'];
            currentName = doc.data['name'];
            sharedPrefs.setString(Constants.USER_FULLNAME, currentName);
            currentDob = doc.data['dob'];
            currentZip = doc.data['zip'];
            currentImage = doc.data['image'];

            print('currentName-->> ${currentImage}');
          });
        }
      });
    });
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        appVersion = value.version;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context).settings.name == null ||
        ModalRoute.of(context).settings.name == 'HomePage') {
      Constants.currentDrawerItem = 11;
    } else if (ModalRoute.of(context).settings.name == 'Profile') {
      Constants.currentDrawerItem = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: SafeArea(
        child: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _getDrawerHeader(),
                    const SizedBox(
                      height: 5,
                    ),
                    _singleHeadingLayout(
                      type: 11,
                      title: "Home",
                      image: "images/sidebar_home.png",
                      isBold: true,
                      dividerVisible: true,
                    ),
                    _singleHeadingLayout(
                      type: 0,
                      title: "Profile",
                      image: "images/sidebar_profile.png",
                      isBold: true,
                      dividerVisible: true,
                    ),
                    _getLegalInfoLayout(),
                    _getAboutUsLayout(),
                    _singleHeadingLayout(
                      type: 1,
                      title: "Rate Our App",
                      image: "images/sidebar_rating.png",
                      isBold: true,
                      dividerVisible: true,
                    ),
                    _singleHeadingLayout(
                      type: 2,
                      title: "Logout",
                      image: "images/sidebar_logout.png",
                      isBold: true,
                      dividerVisible: false,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Pinky Eye version $appVersion",
                  style: Styles.smallButtonTextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              Visibility(
                visible: isPaddingAvailable,
                child: const SizedBox(
                  height: 60.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLegalInfoLayout() {
    return Column(
      children: <Widget>[
        _singleHeadingLayout(
            dividerVisible: false,
            isBold: true,
            type: 3,
            image: "images/sidebar_legalinfo.png",
            title: "Legal Information"),
        _singleHeadingLayout(
            dividerVisible: false,
            isBold: false,
            type: 4,
            title: "Terms and Conditions"),
        _singleHeadingLayout(
            dividerVisible: false,
            isBold: false,
            type: 5,
            title: "Privacy Policy"),
        _singleHeadingLayout(
            dividerVisible: true,
            isBold: false,
            type: 6,
            title: "Medical Disclaimer"),
      ],
    );
  }

  Widget _getAboutUsLayout() {
    return Column(
      children: <Widget>[
        _singleHeadingLayout(
            dividerVisible: false,
            isBold: true,
            type: 7,
            image: "images/sidebar_aboutus.png",
            title: "About Us"),
        _singleHeadingLayout(
            dividerVisible: false,
            isBold: false,
            type: 8,
            title: "About Pinky Eye"),
        _singleHeadingLayout(
            dividerVisible: true,
            isBold: false,
            type: 10,
            title: "Visit Data245"),
      ],
    );
  }

  Widget _singleHeadingLayout({
    String image: "",
    String title,
    int type,
    bool isBold,
    bool dividerVisible: false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onCLick(
          sharedPreferences: widget.sharedPreferences,
          type: type,
        );
      },
      child: Column(
        children: <Widget>[
          Visibility(
            visible: isBold,
            child: const SizedBox(
              height: 4.0,
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 15.0,
              top: 6.0,
            ),
            child: Row(
              children: <Widget>[
                image.isEmpty
                    ? SizedBox(
                        height: 30,
                        width: 30,
                      )
                    : Image.asset(
                        image,
                        height: 30,
                        width: 30,
                        color: Palette.buttonDarkGrey,
                      ),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: isBold
                        ? Styles.drawerBoldTextStyle
                        : Styles.drawerTextStyle,
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: isBold,
            child: const SizedBox(
              height: 2.0,
            ),
          ),
          Visibility(
            visible: dividerVisible,
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 15.0,
                ),
                Divider(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDrawerHeader() {
    return Container(
      color: Palette.buttonDarkGrey,
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 85.0,
            width: 85.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30.0),
              color: Palette.subscriptionBgColor,
              image: DecorationImage(
                image: (currentImage != null && currentImage.isNotEmpty)
                    ? NetworkImage(currentImage)
                    : AssetImage('images/profile_default.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            currentName,
            style: Styles.normalTextWithBoldTextStyle,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            currentEmail,
            style: Styles.extraSmallTextStyle,
          ),
        ],
      ),
    );
  }

  void onCLick({
    int type,
    @required SharedPreferences sharedPreferences,
  }) {
    switch (type) {
      case 0:
        if (Constants.currentDrawerItem != 0) {
          Constants.currentDrawerItem = 0;
          Navigator.of(context).pushNamed(AppRoutes.PROFILE_MAIN);
        }
        break;
      case 1:
        //Rate our app
        LaunchReview.launch(
          androidAppId: 'com.data245.pinkyeye.app',
          iOSAppId: 'com.data245.pinkyeye.app',
        );
        break;
      case 2:
        AppAds.hideBanner();
        AppAds.dispose();
        sharedPreferences.setBool(Constants.IS_PINKY_EYE_LOGIN, false);
        sharedPreferences.setString(Constants.LOGGED_IN_USER_ID, null);
        HomePage.list = List();
        Provider.of<AppStateModel>(context).deleteCurrentEntry = "";
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.SIGN_IN, (Route<dynamic> route) => false);
        break;
      case 4:
        _launchLegalInfo(
          pageTitle: 'Terms and Conditions',
          pageData: _getTandCWidget(),
        );
        break;
      case 5:
        _launchLegalInfo(
          pageTitle: 'Privacy Policy',
          pageData: _getPrivacyPolicy(),
        );
        break;
      case 6:
        _launchLegalInfo(
            pageTitle: 'Medical Disclaimer',
            pageData: _getMedicalDisclaimerWidget());
        break;
      case 8:
        Navigator.of(context).pushNamed(AppRoutes.ABOUT_US);
        break;
      case 9:
        _aboutRashDecisionURL();
        break;
      case 10:
        _aboutData245URL();
        break;
      case 11:
        if (Constants.currentDrawerItem != 11) {
          Constants.currentDrawerItem = 11;
          Navigator.of(context).popUntil((r) => r.settings.name == 'HomePage');
        }
        break;
    }
  }

  Widget _getPrivacyPolicy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.terms_cond44,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 40.0,
        ),
        Text(
          Constants.terms_cond45,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          Constants.terms_cond46,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond47,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond48,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond49,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond50,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond51,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond52,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond53,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond54,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond55,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond56,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond57,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond58,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond59,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond60,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond61,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond62,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond63,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond64,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond65,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond66,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond67,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond68,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond69,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond70,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond71,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond72,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond73,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond74,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond75,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond76,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond77,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond78,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond79,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond80,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond81,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond82,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond83,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond84,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond85,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond86,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond87,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond88,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond89,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond90,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            Constants.terms_cond91,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond92,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond93,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond94,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond95,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond96,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond97,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond98,
          style: Styles.aboutUsContentItalicTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond99,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond100,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond101,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond102,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond103,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
      ],
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

  Widget _getTandCWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          Constants.terms_cond2 +
              "\n\n" +
              Constants.terms_cond3 +
              "\n\n" +
              Constants.terms_cond4,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond5.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond6,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond7.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond8 + "\n" + Constants.terms_cond9,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond10.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond11 + "\n" + Constants.terms_cond12,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond13.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond14,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond15.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond16,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond17.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond18,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond19.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond20,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond21.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond22,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond23.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond24,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond25.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond26,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond27.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond28,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 18.0,
        ),
        Text(
          Constants.terms_cond29.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          Constants.terms_cond30,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 8.0,
        ),
      ],
    );
  }

  _launchLegalInfo({
    @required String pageTitle,
    @required Widget pageData,
  }) {
    Navigator.of(context).pushNamed(
      AppRoutes.LEGAL_INFORMATION,
      arguments: {
        AppRouteArgKeys.LEGAL_INFO_PAGE_TITLE: pageTitle,
        AppRouteArgKeys.LEGAL_INFO_PAGE_DATA: pageData,
      },
    );
  }

  _aboutRashDecisionURL() async {
    const url = 'https://flutter.io';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _aboutData245URL() async {
    const url = 'https://www.data245.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
