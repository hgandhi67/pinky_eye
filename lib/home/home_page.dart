import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:launch_review/launch_review.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:package_info/package_info.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/ads/app_ads.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/drawer/app_drawer.dart';
import 'package:pinky_eye/base/modal_progress_indicator.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/model/disease_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldState> scaffoldKey =
    new GlobalKey<ScaffoldState>(debugLabel: 'home_screen');

class HomePage extends StatefulWidget {
  static List<HistoryData> list = List();
  bool isFirstLoad = false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPreferences sharedPreferences;
  static String appVersion = "0.0";
  SubscriptionData subscriptionData = SubscriptionData();
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    AppAds.init();
    AppAds.showBanner(
      anchorType: AnchorType.bottom,
      childDirected: true,
      listener: AppAds.bannerListener,
      size: AdSize.banner,
    );

//    scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: 'home_screen');
    subscriptionData = Provider.of<AppStateModel>(context, listen: false)
        .currentSubscriptionPackage;

    if (subscriptionData.planType == 'Yearly') {
      checkStatus();
    }
    setSharedPref().then((sharedPref) {
      setState(() {
        sharedPreferences = sharedPref;
      });

      _getSubscriptionData(sharedPreferences);
    });

    PackageInfo.fromPlatform().then((value) {
      appVersion = value.version;
      print("The app version is : $appVersion");
      getAppUpdateDetails();
    });
  }

  void checkStatus() async {
    print("HEREE");
    setSharedPref().then((sharedPreferences) async {
      final QueryPurchaseDetailsResponse purchaseResponse =
          await _connection.queryPastPurchases();
      if (purchaseResponse.error != null) {
        print(
            "HERE => 2 : The error is : ${purchaseResponse.error.toString()}");
      }
      if (purchaseResponse.pastPurchases.length == 0) {
        Firestore.instance
            .collection('account_subscription')
            .document(sharedPreferences.get(Constants.LOGGED_IN_USER_ID))
            .updateData({
          'active': 0,
          'expiry_date': new DateFormat("dd-MM-yyyy").format(DateTime.now()),
          'reviews_left': "0",
        }).then((_) {
          _getSubscriptionData(sharedPreferences);
          setState(() {
            isLoading = false;
          });
        });
      }

      print("The purchase length = ${purchaseResponse.pastPurchases.length}");

      for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
        if (purchase.productID == Constants.SUBSCRIPTION_YEARLY) {
          print(
              "Product is autorenewing : ${purchase.billingClientPurchase.isAutoRenewing}");
          if (purchase.billingClientPurchase.isAutoRenewing == false) {
            if (subscriptionData.planType == 'Yearly') {
              DateTime expiryDate = new DateFormat("dd-MM-yyyy")
                  .parse(subscriptionData.expiryDate);

              DateTime currentDate = DateTime.now();

              if (currentDate.isAfter(expiryDate)) {
                Firestore.instance
                    .collection('account_subscription')
                    .document(
                        sharedPreferences.get(Constants.LOGGED_IN_USER_ID))
                    .updateData({
                  'active': 0,
                  'expiry_date':
                      new DateFormat("dd-MM-yyyy").format(DateTime.now()),
                  'reviews_left': "0",
                }).then((_) {
                  setState(() {
                    isLoading = false;
                  });
                });
              }
              setState(() {
                isLoading = false;
              });
              _getSubscriptionData(sharedPreferences);
            }
          } else {
            DateTime expiryDate =
                new DateFormat("dd-MM-yyyy").parse(subscriptionData.expiryDate);
            DateTime currentDate = DateTime.now();
            if (currentDate.isAfter(expiryDate)) {
              DateTime newDate = DateTime(
                  expiryDate.year + 1, expiryDate.month, expiryDate.day);
              Firestore.instance
                  .collection('account_subscription')
                  .document(sharedPreferences.get(Constants.LOGGED_IN_USER_ID))
                  .updateData({
                'active': 1,
                'expiry_date': new DateFormat("dd-MM-yyyy").format(newDate),
                'reviews_left': "unlimited",
              }).then((_) {
                setState(() {
                  isLoading = false;
                });
                _getSubscriptionData(sharedPreferences);
              });
            } else {
              setState(() {
                isLoading = false;
              });
            }
          }
        }
      }
    });
  }

  void _getSubscriptionData(SharedPreferences sharedPreferences) {
    Firestore.instance
        .collection('account_subscription')
        .document(sharedPreferences.get(Constants.LOGGED_IN_USER_ID))
        .get(source: Source.server)
        .then((document) {
      print("The document at home page is : ${document.data}");
      Map<String, dynamic> docData = document.data;

      if (docData != null) {
        Provider.of<AppStateModel>(context, listen: false)
            .currentSubscriptionPackage = new SubscriptionData(
          active: docData['active'],
          activationDate: docData['activation_date'],
          activationType: docData['activation_type'],
          expiryDate: docData['expiry_date'],
          isTrialUtilised: docData['is_trial_utilised'],
          planType: docData['plan_type'],
          reviewsLeft: docData['reviews_left'],
          reviewsTaken: docData['reviews_taken'],
        );
      }
    });
  }

  void getAppUpdateDetails() {
    Firestore.instance
        .collection('app_version')
        .document('app_version')
        .get(source: Source.server)
        .then((document) {
      if (Platform.isAndroid) {
        if (appVersion != document.data['android_version']) {
          print('The app needs to be updated');
          if (Constants.VERSION_UPDATE == 0) {
            showUpdatePopup();
          }
        }
      } else if (Platform.isIOS) {
        if (appVersion != document.data['ios_version']) {
          print('The app needs to be updated');
          if (Constants.VERSION_UPDATE == 0) {
            showUpdatePopup();
          }
        }
      }
    });
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  void showUpdatePopup() {
    Constants.VERSION_UPDATE = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'There is a new update avaiable of the application',
                  style: Styles.subscriptionTextStyle(
                    fontSize: 18,
                    color: Palette.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        color: Palette.primaryColor,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'Cancel',
                          style: Styles.subscriptionTextStyle(
                            fontSize: 15,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(12),
                        onPressed: () {
                          Navigator.of(context).pop();
                          LaunchReview.launch(
                            androidAppId: 'com.data245.pinkyeye.app',
                            iOSAppId: 'com.data245.pinkyeye.app',
                          );
                        },
                        color: Palette.primaryColor,
                        child: Text(
                          'Update',
                          style: Styles.subscriptionTextStyle(
                            fontSize: 15,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Constants.latitude = position.latitude;
    Constants.longitude = position.longitude;
    print("position------position--->>$position");
  }

  void checkPermission() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.unknown) {
      await LocationPermissions().requestPermissions().then((status) {
        print("The permission status is : ==> $status");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    subscriptionData =
        Provider.of<AppStateModel>(context).currentSubscriptionPackage;

    if (isLoading) {
      if (subscriptionData.planType == 'Yearly') {
        checkStatus();
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(
        sharedPreferences: sharedPreferences,
      ),
      body: Builder(
        builder: (context) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'images/splash_bg.png',
                  fit: BoxFit.cover,
                  height: Constants.screenHeight,
                  width: Constants.screenWidth,
                ),
                SafeArea(
                  child: Column(
                    children: <Widget>[
                      _getActionBar(context),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _analyzeButtonLayout(),
                            _bottomLayout(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getActionBar(BuildContext context) {
    return Container(
      color: Palette.actionBarBgColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 56.0,
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                'images/sidebar_ic.png',
                height: 30,
                width: 30,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 56,
              child: Center(
                child: Text(
                  Constants.HOME_PAGE_TITLE,
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

  Widget _analyzeButtonLayout() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      width: Constants.screenWidth * 0.8,
      color: Palette.transparentColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Constants.DETECT_DESC,
            style: Styles.homeScreenInfoTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            Constants.HINT_TAKE_PICTURE,
            style: Styles.homeScreenInfoTextStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 18.0,
          ),
          MaterialButton(
            minWidth: Constants.screenWidth * 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            onPressed: () {
              if (subscriptionData.active == 1) {
                if (Platform.isAndroid) {
                  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                  deviceInfo.androidInfo.then((deviceInfo) {
                    print(
                        "The device version is : ${deviceInfo.version.sdkInt}");
                    int sdkInt = deviceInfo.version.sdkInt;
                    if (sdkInt < 21) {
                      getImage();
                    } else {
                      Navigator.of(context).pushNamed(AppRoutes.CAMERA_OVERLAY);
                    }
                  });
                } else {
                  Navigator.of(context).pushNamed(AppRoutes.CAMERA_OVERLAY);
                }
              } else {
                setSharedPref().then((prefs) {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.SUBSCRIPTION, arguments: {
                    AppRouteArgKeys.IS_PINKY_EYE_LOGIN: true,
                    AppRouteArgKeys.IS_PINKY_SOCIAL_LOGIN:
                        prefs.getBool(Constants.IS_PINKY_SOCIAL_LOGIN),
                    AppRouteArgKeys.LOGGED_IN_USER_ID:
                        prefs.getString(Constants.LOGGED_IN_USER_ID),
                    AppRouteArgKeys.IS_TRIAL_UTILISED:
                        subscriptionData.isTrialUtilised,
                    AppRouteArgKeys.REVIEWS_TAKEN:
                        subscriptionData.reviewsTaken,
                    AppRouteArgKeys.SUBS_PAGE_FROM: 1,
                  });
                });
              }
            },
            child: Text(
              Constants.TAKE_PICTURE,
              style: Styles.buttonTextStyle(
                color: Palette.white,
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            color: Palette.buttonDarkGrey,
          )
        ],
      ),
    );
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);

    Navigator.of(context).pushNamed(
      AppRoutes.REPORT_ANALYZING,
      arguments: {
        AppRouteArgKeys.REPORT_ANALYZING_IMAGE: image,
        AppRouteArgKeys.IS_FROM_DEPENDENT: 'Me',
      },
    );
  }

  Widget _bottomLayout() {
    return GestureDetector(
      onTap: () {
        //Navigator.of(context).pushNamed(AppRoutes.SUBSCRIPTION);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.all(5.0),
        child: Card(
          color: Palette.buttonOffWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your Current Subscription',
                  style: Styles.subscriptionTextStyle(
                    color: Palette.darkButtonTextColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      subscriptionData.planType != null
                          ? subscriptionData.planType
                          : '',
                      style: Styles.subscriptionTextStyle(
                        color: Palette.darkButtonTextColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Text(
                      '-',
                      style: Styles.subscriptionTextStyle(
                        color: Palette.darkButtonTextColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    RichText(
                      text: TextSpan(
                        text: subscriptionData.expiryDate != ''
                            ? '(Expires on '
                            : '',
                        style: Styles.subscriptionTextStyle(
                          color: Palette.darkButtonTextColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: subscriptionData.expiryDate != ''
                                ? subscriptionData.expiryDate
                                : '',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.darkButtonTextColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: subscriptionData.expiryDate != '' ? ')' : '',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.darkButtonTextColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Images Submitted',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.darkButtonTextColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            subscriptionData.reviewsTaken != null
                                ? subscriptionData.reviewsTaken
                                : '',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.darkButtonTextColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Submissions Left',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.darkButtonTextColor,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            subscriptionData.reviewsLeft != null
                                ? subscriptionData.reviewsLeft
                                : '',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.darkButtonTextColor,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubscriptionData {
  final String planType;
  final String reviewsLeft;
  final String reviewsTaken;
  final int active;
  final String expiryDate;
  final String activationDate;
  final String activationType;
  final bool isTrialUtilised;

  SubscriptionData(
      {this.planType,
      this.reviewsLeft,
      this.reviewsTaken,
      this.active,
      this.expiryDate,
      this.activationDate,
      this.activationType,
      this.isTrialUtilised});
}

class HistoryData {
  final Diseases diseases;
  final String timeStamp;
  final String imageUrl;
//  final String dependentName;
  final String imagePath;
  final bool active;
  final bool isOpened;
  final String cancer;
  final String diseasesName;

  HistoryData({
    this.diseases,
    this.timeStamp,
    this.imageUrl,
//    this.dependentName,
    this.imagePath,
    this.active,
    this.isOpened,
    this.cancer,
    this.diseasesName,
  });
}
