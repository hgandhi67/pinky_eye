import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/modal_progress_indicator.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/home/home_page.dart';
import 'package:pinky_eye/widgets/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ReportAnalyzingPage extends StatefulWidget {
  final File imageFile;
  final String fromDependant;

  const ReportAnalyzingPage({Key key, this.imageFile, this.fromDependant})
      : super(key: key);

  @override
  _ReportAnalyzingPageState createState() => _ReportAnalyzingPageState();
}

class _ReportAnalyzingPageState extends State<ReportAnalyzingPage> {
  String dropdownValue = 'Me';
  File imageFile;
  List<String> relationsList = List();
  bool isLoading = false;
  String currentName = '';
  SubscriptionData subscriptionData = SubscriptionData();
  bool willPopScope = true;

  int type = -1;
  int type0Selected = -1;
  int type1Selected = -1;
  int type2Selected = -1;

  @override
  void dispose() {
//    AppAds.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
//    Future.delayed(Duration(seconds: 3), (){
//      AppAds.init();
//      AppAds.showBanner(
//        anchorType: AnchorType.bottom,
//        childDirected: true,
//        listener: AppAds.bannerListener,
//        size: AdSize.fullBanner,
//      );
//    });

    dropdownValue =
        widget.fromDependant.isNotEmpty ? widget.fromDependant : 'Me';
    imageFile = widget.imageFile;
    setState(() {
      relationsList.add(dropdownValue);
      if (dropdownValue != 'Me') {
        relationsList.add('Me');
      }
    });

    subscriptionData = Provider.of<AppStateModel>(context, listen: false)
        .currentSubscriptionPackage;
    validateImage();
    setSharedPref().then((sharedPrefs) {
      Firestore.instance
          .collection('users')
          .document(sharedPrefs.getString(Constants.LOGGED_IN_USER_ID))
          .snapshots()
          .listen((doc) {
        print("HERE I AM");
        if (doc.data != null) {
          setState(() {
            currentName = doc.data['name'];
            print('currentName-->> $currentName');
          });
        }
      });

//      _getRelationData(sharedPrefs);
    });
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  void _getRelationData(SharedPreferences sharedPreferences) {
    Firestore.instance
        .collection('dependency')
        .document(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .collection(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .getDocuments()
        .then((docs) {
      for (int i = 0; i < docs.documents.length; i++) {
        print("The docs are : ==> ${docs.documents[i].data}");
        Map<String, dynamic> dataMap = docs.documents[i].data;
        if ('${dataMap['first_name']} ${dataMap['last_name']}' !=
            dropdownValue) {
          relationsList.add('${dataMap['first_name']} ${dataMap['last_name']}');
        }
        if (i == docs.documents.length - 1) {
          setState(() {
            //just refresh
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String newValue =
        Provider.of<AppStateModel>(context).currentDependencyListChanged;
    if (newValue.isNotEmpty) {
      print('The new value is : ===$newValue===');
      relationsList.clear();
      dropdownValue = newValue;
      setState(() {
        relationsList.add(dropdownValue);
        if (dropdownValue != 'Me') {
          relationsList.add('Me');
        }
      });
      setSharedPref().then((sharedPrefs) {
        _getRelationData(sharedPrefs);
      });
      Provider.of<AppStateModel>(context).currentDependencyListChanged = '';
    } else {
      print('The new value 23445 is : ===$newValue===');
    }
    return WillPopScope(
      onWillPop: () => Future.value(willPopScope),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
//        appBar: AppBarWidget.getAppBarWidgetWithLeading(
//          appBarTitle: Constants.RASH_ANALYZING,
//          context: context,
//        ),
        body: ModalProgressHUD(
          isAnimated: true,
          inAsyncCall: isLoading,
          child: Stack(
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
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(
                                  height: 5.0,
                                ),
                                _getImageLayout(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: _questionsLayout(),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
//                                _getWhoseImageLayout(),
//                                SizedBox(
//                                  height: 10.0,
//                                ),
//                                _getDependentDropDown(),
//                                SizedBox(
//                                  height: 20.0,
//                                ),
//                                _addDependentButton(),
//                                SizedBox(
//                                  height: 20.0,
//                                ),
                                _submitRetakeLayout(),
                              ],
                            ),
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
        ),
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
                  Constants.ANALYSIS,
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

  Widget _getImageLayout() {
    return Container(
      width: Constants.screenWidth * 0.6,
      height: Constants.screenWidth * 0.6,
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(12.0),
        child: Image.file(
          imageFile,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _questionsLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Please provide a few details',
          style: Styles.subscriptionTextStyle(
            color: Palette.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          'Itching?',
          style: Styles.subscriptionTextStyle(
            color: Palette.white,
            fontWeight: FontWeight.normal,
            fontSize: 17.0,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        _yesNoLayout(type0Selected, 0),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          'Eyes discharge?',
          style: Styles.subscriptionTextStyle(
            color: Palette.white,
            fontWeight: FontWeight.normal,
            fontSize: 17.0,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        _yesNoLayout(type1Selected, 1),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          'Painful and/or blurred vision?',
          style: Styles.subscriptionTextStyle(
            color: Palette.white,
            fontWeight: FontWeight.normal,
            fontSize: 17.0,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        _yesNoLayout(type2Selected, 2),
      ],
    );
  }

  Widget _yesNoLayout(int selectedIndex, int type) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (selectedIndex == 0 || selectedIndex == -1) {
              setState(() {
                switch (type) {
                  case 0:
                    type0Selected = 1;
                    break;
                  case 1:
                    type1Selected = 1;
                    break;
                  case 2:
                    type2Selected = 1;
                    break;
                }
              });
            }
          },
          child: Image.asset(
            selectedIndex == 0 || selectedIndex == -1
                ? 'images/radiobtn.png'
                : 'images/radiobtn_checked.png',
            height: 25.0,
            width: 25.0,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          'Yes',
          style: Styles.subscriptionTextStyle(
            color: Palette.white,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
        GestureDetector(
          onTap: () {
            if (selectedIndex == 1 || selectedIndex == -1) {
              setState(() {
                switch (type) {
                  case 0:
                    type0Selected = 0;
                    break;
                  case 1:
                    type1Selected = 0;
                    break;
                  case 2:
                    type2Selected = 0;
                    break;
                }
              });
            }
          },
          child: Image.asset(
            selectedIndex == 1 || selectedIndex == -1
                ? 'images/radiobtn.png'
                : 'images/radiobtn_checked.png',
            height: 25.0,
            width: 25.0,
          ),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          'No',
          style: Styles.subscriptionTextStyle(
            color: Palette.white,
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
          ),
        ),
      ],
    );
  }

  Widget _getWhoseImageLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            Constants.REPORT_FOR,
            style: Styles.buttonTextStyle(
              color: Palette.white,
              size: 16.0,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _showDialog();
          },
          child: CircleAvatar(
            backgroundColor: Palette.lightRedColor,
            radius: 15.0,
            child: Text(
              '?',
              style: Styles.buttonTextStyle(
                color: Palette.white,
                size: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getDependentDropDown() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Palette.grey5,
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: Container(
          decoration: ShapeDecoration(
            color: Palette.buttonOffWhite,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.0,
                style: BorderStyle.solid,
                color: Palette.buttonDarkGrey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              iconSize: 30,
              iconEnabledColor: Palette.darkButtonTextColor,
              elevation: 10,
              focusColor: Colors.white,
              style: TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (String data) {
                setState(() {
                  dropdownValue = data;
                });
              },
              items: relationsList.isNotEmpty
                  ? relationsList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Styles.subscriptionTextStyle(
                              fontWeight: FontWeight.w500,
                              color: Palette.darkButtonTextColor),
                        ),
                      );
                    }).toList()
                  : 'Me',
            ),
          ),
        ),
      ),
    );
  }

  Widget _addDependentButton() {
    return MaterialButton(
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () => Navigator.of(context).pushNamed(
        AppRoutes.ADD_DEPENDENCY,
        arguments: {
          AppRouteArgKeys.DEPENDENCY_ROUTE_TYPE: 2,
          AppRouteArgKeys.DEPENDENCY_IMAGE_FILE: imageFile,
        },
      ),
      child: Text(
        'Add a new dependent here',
        style: Styles.buttonTextStyle(
          color: Palette.white,
        ),
      ),
      color: Palette.buttonDarkGrey,
      elevation: 2.0,
      padding: const EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }

  Widget _submitRetakeLayout() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 5,
          child: _submitButton(),
        ),
        SizedBox(
          width: Constants.screenWidth * 0.02,
        ),
        Expanded(
          child: _retakeButton(),
          flex: 4,
        ),
      ],
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      child: ButtonWidget(
        name: Constants.SUBMIT,
        bgColor: Palette.buttonOffWhite,
        textColor: Palette.darkButtonTextColor,
      ),
      onTap: () {
        Provider.of<AppStateModel>(context).isInternetConnected().then((value) {
          if (value) {
            submitImageData();
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Please check your Internet connection.",
                    style: Styles.workSans500New(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
      },
    );
  }

  Widget _retakeButton() {
    return GestureDetector(
      child: ButtonWidget(
        name: Constants.RETAKE,
        bgColor: Palette.lightRedColor,
      ),
      onTap: () {
        Navigator.of(context).popAndPushNamed(AppRoutes.CAMERA_OVERLAY);
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
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
                        height: 5.0,
                      ),
                      Text(
                        Constants.DEPENDENTS,
                        style: Styles.subscriptionTextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          color: Palette.lightRedColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'When you have added one or more dependents, you are able to keep track of image ownership by selecting \"me\" or a different name',
                        style: Styles.termsAndConditionsContextTextStyle,
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

  void _startLoading() {
    setState(() {
      willPopScope = false;
      isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      willPopScope = true;
      isLoading = false;
    });
  }

  void validateImage() async {
    _startLoading();

    FormData formData = FormData.fromMap({
      "imageUpload": await MultipartFile.fromFile(
        imageFile.path,
        filename: 'disease.png',
      ),
      "itching": 0,
      "discharge": 0,
      "pain_blur": 0,
    });

    final response = await Dio()
        .post(Constants.IMAGE_UPLOAD_URL, data: formData)
        .catchError((onError) {
      print("The error is : ${onError.toString()}");
      Toast.show('Error : ${onError.toString()}', context);
      _stopLoading();
      _openErrorPage();
    });

    final resultData = json.decode(response.toString());
    print("The result is : $resultData");
    if (resultData['result'].toString().toLowerCase() ==
        'Invalid Image'.toLowerCase()) {
      _stopLoading();
      _openErrorPage();
    } else {
      _stopLoading();
    }
//    else if (resultData['result'].toString().toLowerCase() ==
//        'Not a Pink Eye'.toLowerCase()) {
//      String reviewsTaken = subscriptionData.reviewsTaken != ''
//          ? (int.parse(subscriptionData.reviewsTaken) + 1).toString()
//          : '1';
//      String reviewsLeft = 'unlimited';
//      int active = 1;
//
//      if (subscriptionData.activationType != 'unlimited') {
//        reviewsLeft = (int.parse(subscriptionData.reviewsLeft) - 1).toString();
//
//        if (int.parse(reviewsLeft) == 0) {
//          active = 0;
//        }
//      }
//
//      SubscriptionData newData = SubscriptionData(
//        reviewsTaken: reviewsTaken,
//        reviewsLeft: reviewsLeft,
//        planType: subscriptionData.planType,
//        isTrialUtilised: subscriptionData.isTrialUtilised,
//        expiryDate: subscriptionData.expiryDate,
//        activationType: subscriptionData.activationType,
//        activationDate: subscriptionData.activationDate,
//        active: active,
//      );
//
//      Provider.of<AppStateModel>(context).currentSubscriptionPackage = newData;
//
//      setSharedPref().then((sharedPreferences) {
//        Firestore.instance
//            .collection('account_subscription')
//            .document(sharedPreferences.get(Constants.LOGGED_IN_USER_ID))
//            .setData({
//          'plan_type': newData.planType,
//          'reviews_left': newData.reviewsLeft,
//          'reviews_taken': newData.reviewsTaken,
//          'active': newData.active,
//          'expiry_date': newData.expiryDate,
//          'activation_date': newData.activationDate,
//          'activation_type': newData.activationType,
//          'is_trial_utilised': newData.isTrialUtilised,
//        }).then((_) {
//          _diseaseCancerous(resultData);
//        }).catchError((onError) {
//          _stopLoading();
//          Toast.show('Something went wrong, please try again', context);
//        });
//      });
//    }
  }

  void submitImageData() async {
    if (type0Selected == -1 || type1Selected == -1 || type2Selected == -1) {
      Toast.show('Please answer all the questions to continue.', context);
      return;
    }
    _startLoading();
    FormData formData = FormData.fromMap({
      "imageUpload": await MultipartFile.fromFile(
        imageFile.path,
        filename: 'disease.png',
      ),
      "itching": type0Selected,
      "discharge": type1Selected,
      "pain_blur": type2Selected,
    });

    final response = await Dio()
        .post(Constants.IMAGE_UPLOAD_URL, data: formData)
        .catchError((onError) {
      print("The error is : ${onError.toString()}");
      Toast.show('Error : ${onError.toString()}', context);
      _stopLoading();
      _openErrorPage();
    });

    try {
      final resultData = json.decode(response.toString());
      if (resultData != null) {
        print("The response is :===> ${resultData.toString()}");
        if (resultData['result'].toString().toLowerCase() !=
            'Invalid image'.toLowerCase()) {
          String reviewsTaken = subscriptionData.reviewsTaken != ''
              ? (int.parse(subscriptionData.reviewsTaken) + 1).toString()
              : '1';
          String reviewsLeft = 'unlimited';
          int active = 1;

          if (subscriptionData.activationType != 'unlimited') {
            reviewsLeft =
                (int.parse(subscriptionData.reviewsLeft) - 1).toString();

            if (int.parse(reviewsLeft) == 0) {
              active = 0;
            }
          }

          SubscriptionData newData = SubscriptionData(
            reviewsTaken: reviewsTaken,
            reviewsLeft: reviewsLeft,
            planType: subscriptionData.planType,
            isTrialUtilised: subscriptionData.isTrialUtilised,
            expiryDate: subscriptionData.expiryDate,
            activationType: subscriptionData.activationType,
            activationDate: subscriptionData.activationDate,
            active: active,
          );

          Provider.of<AppStateModel>(context).currentSubscriptionPackage =
              newData;

          setSharedPref().then((sharedPreferences) {
            Firestore.instance
                .collection('account_subscription')
                .document(sharedPreferences.get(Constants.LOGGED_IN_USER_ID))
                .setData({
              'plan_type': newData.planType,
              'reviews_left': newData.reviewsLeft,
              'reviews_taken': newData.reviewsTaken,
              'active': newData.active,
              'expiry_date': newData.expiryDate,
              'activation_date': newData.activationDate,
              'activation_type': newData.activationType,
              'is_trial_utilised': newData.isTrialUtilised,
            }).then((_) {
              _diseaseCancerous(resultData);
            }).catchError((onError) {
              _stopLoading();
              Toast.show('Something went wrong, please try again', context);
            });
          });
        } else {
          print("Validate is Non-skin..");
          _stopLoading();
          _openErrorPage();
        }
      } else {
        _stopLoading();
        _openErrorPage();
        Toast.show('Error : The api response is null', context);
      }
    } on Exception catch (e) {
      _stopLoading();
      _openErrorPage();
      Toast.show(
          'Error : The api response is : ${response.data.toString()}', context);
    }
  }

  void _diseaseCancerous(final resultData) {
    if (resultData['result'].toString().toLowerCase() ==
        'Not a Pink Eye'.toLowerCase()) {
      setSharedPref().then((sharedPreferences) {
        String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
        StorageReference ref = FirebaseStorage.instance
            .ref()
            .child(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
            .child('$dateTime.png');
        StorageUploadTask uploadTask = ref.putFile(imageFile);
        uploadTask.onComplete.then((value) {
          value.ref.getDownloadURL().then((url) {
            print("Getting the url : $url");
            Firestore.instance
                .collection('disease')
                .document(
                    sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
                .collection(
                    sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
                .document(dateTime)
                .setData({
              'id': Constants.diseaseList[0].id,
              'date_time': dateTime,
              'image_url': url,
//              'dependent': dropdownValue ?? '',
              'image_path': imageFile != null ? imageFile.path : '',
              'active': true,
              'is_opened': false,
              'cancer': '',
              'diseasesName': Constants.diseaseList[0].name,
            }).then((_) {
              _stopLoading();
              print("Data set --->");
              HomePage.list.add(HistoryData(
                  timeStamp: dateTime,
                  imageUrl: url,
//                  dependentName: dropdownValue ?? '',
                  diseases: Constants.diseaseList[0],
                  active: true));
              Navigator.of(context).pushReplacementNamed(
                AppRoutes.REPORT_ANALYSIS,
                arguments: {
                  AppRouteArgKeys.DISEASE_IMAGE_URL: url,
                  AppRouteArgKeys.DISEASE: Constants.diseaseList[0],
                  AppRouteArgKeys.DEPENDENT_NAME:
                      dropdownValue == 'Me' ? currentName : dropdownValue,
                  AppRouteArgKeys.REPORT_RASH_IMAGE_PATH: imageFile.path,
                },
              );
            }).catchError((onError) {
              _stopLoading();
              print("Data set error : ${onError.toString()}");
              Toast.show('Error : ${onError.toString()}', context);
              _openErrorPage();
            });
          }).catchError((onError) {
            _stopLoading();
            print("Error with getting url :=> ${onError.toString()}");
            Toast.show('Error : ${onError.toString()}', context);
            _openErrorPage();
          });
        }).catchError((onError) {
          _stopLoading();
          print("Error with completing :=> ${onError.toString()}");
          Toast.show('Error : ${onError.toString()}', context);
          _openErrorPage();
        });
      });
    } else {
      bool flag = true;
      for (int i = 0; i < Constants.diseaseList.length; i++) {
        if (resultData['disease'].toLowerCase() ==
            Constants.diseaseList[i].name.toLowerCase()) {
          flag = false;
          setSharedPref().then((sharedPreferences) {
            String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
            StorageReference ref = FirebaseStorage.instance
                .ref()
                .child(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
                .child('$dateTime.png');
            StorageUploadTask uploadTask = ref.putFile(imageFile);
            uploadTask.onComplete.then((value) {
              value.ref.getDownloadURL().then((url) {
                print("Getting the url : $url");
                Firestore.instance
                    .collection('disease')
                    .document(sharedPreferences
                        .getString(Constants.LOGGED_IN_USER_ID))
                    .collection(sharedPreferences
                        .getString(Constants.LOGGED_IN_USER_ID))
                    .document(dateTime)
                    .setData({
                  'id': Constants.diseaseList[i].id,
                  'date_time': dateTime,
                  'image_url': url,
//                  'dependent': dropdownValue ?? '',
                  'image_path': imageFile != null ? imageFile.path : '',
                  'active': true,
                  'is_opened': false,
                  'cancer': '',
                  'diseasesName': Constants.diseaseList[i].name,
                }).then((_) {
                  _stopLoading();
                  print("Data set --->");
                  HomePage.list.add(HistoryData(
                      timeStamp: dateTime,
                      imageUrl: url,
//                      dependentName: dropdownValue ?? '',
                      diseases: Constants.diseaseList[i],
                      active: true));
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.REPORT_ANALYSIS,
                    arguments: {
                      AppRouteArgKeys.DISEASE_IMAGE_URL: url,
                      AppRouteArgKeys.DISEASE: Constants.diseaseList[i],
                      AppRouteArgKeys.DEPENDENT_NAME:
                          dropdownValue == 'Me' ? currentName : dropdownValue,
                      AppRouteArgKeys.REPORT_RASH_IMAGE_PATH: imageFile.path,
                    },
                  );
                }).catchError((onError) {
                  _stopLoading();
                  print("Data set error : ${onError.toString()}");
                  Toast.show('Error : ${onError.toString()}', context);
                  _openErrorPage();
                });
              }).catchError((onError) {
                _stopLoading();
                print("Error with getting url :=> ${onError.toString()}");
                Toast.show('Error : ${onError.toString()}', context);
                _openErrorPage();
              });
            }).catchError((onError) {
              _stopLoading();
              print("Error with completing :=> ${onError.toString()}");
              Toast.show('Error : ${onError.toString()}', context);
              _openErrorPage();
            });
          });
          break;
        }
      }

      if (flag) {
        _stopLoading();
        print("New disease");
        Toast.show('Please try again with proper image', context);
      }
    }
  }

  void _openErrorPage() {
    Navigator.of(context)
        .pushReplacementNamed(AppRoutes.ERROR_PAGE, arguments: {
      AppRouteArgKeys.REPORT_ANALYZING_IMAGE: imageFile,
    });
  }
}
