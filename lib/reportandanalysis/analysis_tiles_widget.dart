import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:android_intent/android_intent.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/model/GetPhoneNumberModel.dart';
import 'package:pinky_eye/model/disease_model.dart';
import 'package:pinky_eye/model/placeApiModel.dart';
import 'package:pinky_eye/reportandanalysis/report_analysis_page.dart';

class AnalysisWidget extends StatefulWidget {
  final Diseases diseases;
  final BuildContext context;

  List<Result> hospitalList;
  List<Result> medicalList;

  AnalysisWidget(
      {Key key,
      @required this.diseases,
      @required this.hospitalList,
      @required this.medicalList,
      @required this.context})
      : super(key: key);

  @override
  _AnalysisWidgetState createState() => _AnalysisWidgetState();
}

class _AnalysisWidgetState extends State<AnalysisWidget> {
  static const double HEIGHT = 55.0;

  List<Widget> itemsList = List();

  @override
  void initState() {
    super.initState();

//    if (widget.hospitalList?.isEmpty == true ||
//        widget.medicalList?.isEmpty == true) {
//      fetchLocation();
//    }
  }

  @override
  Widget build(BuildContext context) {
    itemsList = List();
    itemsList.add(_infoWidget(context));
    itemsList.add(_commonSymptomsWidget(widget.context));
    itemsList.add(_commonCausesWidget(widget.context));
    itemsList.add(_actionsWidget(widget.context));
//    itemsList.add(_remediesWidget(widget.context));
    itemsList.add(_pharmaCentersWidget(widget.context));
    itemsList.add(_medicalCentersWidget(widget.context));
    if (widget.diseases.images.length > 0) {
      itemsList.add(_imagesWidget(widget.context));
    }

    return CarouselSlider.builder(
      itemCount: itemsList.length,
      enableInfiniteScroll: false,
      enlargeCenterPage: true,
      reverse: false,
      autoPlay: false,
      height: MediaQuery.of(context).size.height * 0.4,
      itemBuilder: (context, index) {
        return itemsList[index];
      },
    );
  }

  Widget _infoWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 12.0,
                    ),
                    child: Text(
                      widget.diseases.infoTitle,
                      style: Styles.subscriptionTextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Palette.commonSymptomsColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.diseases.symptoms.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      widget.diseases.info,
                      style: Styles.subscriptionTextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Palette.homeScreenInfoTextColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commonSymptomsWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'images/tab_symptoms_large.png',
                  height: 37.0,
                  width: 37.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    "Common Symptoms",
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Palette.commonSymptomsColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.diseases.symptoms.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        children: [
                          TextSpan(
                            text: '⦿	 ',
                            style: Styles.subscriptionTextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff5E686B),
                            ),
                          ),
                          TextSpan(
                            text: widget.diseases.symptoms[index],
                            style: Styles.subscriptionTextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Palette.homeScreenInfoTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _commonCausesWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'images/tab_causes_large.png',
                  height: 37.0,
                  width: 37.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    "Common Causes",
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Palette.commonCausesColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.diseases.causes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        children: [
                          TextSpan(
                            text: '⦿	 ',
                            style: Styles.subscriptionTextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff5E686B),
                            ),
                          ),
                          TextSpan(
                            text: widget.diseases.causes[index],
                            style: Styles.subscriptionTextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Palette.homeScreenInfoTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionsWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'images/tab_selfcare_lg.png',
                  height: 37.0,
                  width: 37.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    "Actions/Self-Care",
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Palette.actionsColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.diseases.actions.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: RichText(
                      text: TextSpan(
                        text: '',
                        children: [
                          TextSpan(
                            text: '⦿	 ',
                            style: Styles.subscriptionTextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff5E686B),
                            ),
                          ),
                          TextSpan(
                            text: widget.diseases.actions[index],
                            style: Styles.subscriptionTextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              color: Palette.homeScreenInfoTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

//  Widget _remediesWidget(BuildContext context) {
//    return Container(
//      width: MediaQuery.of(context).size.width,
//      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
//      margin: const EdgeInsets.all(8.0),
//      decoration: BoxDecoration(
//        color: Palette.white,
//        borderRadius: BorderRadius.circular(8.0),
//      ),
//      child: SingleChildScrollView(
//        child: Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Image.asset(
//                  'images/tab_remedies_large.png',
//                  height: 37.0,
//                  width: 37.0,
//                ),
//                const SizedBox(
//                  width: 12.0,
//                ),
//                Expanded(
//                  child: Text(
//                    "Remedies",
//                    style: Styles.subscriptionTextStyle(
//                      fontWeight: FontWeight.w500,
//                      fontSize: 18.0,
//                      color: Palette.remediesColor,
//                    ),
//                  ),
//                )
//              ],
//            ),
//            const SizedBox(
//              height: 8.0,
//            ),
//            Padding(
//              padding: const EdgeInsets.only(
//                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
//              child: ListView.builder(
//                shrinkWrap: true,
//                physics: const NeverScrollableScrollPhysics(),
//                itemCount: widget.diseases.remedies_list.length,
//                itemBuilder: (BuildContext context, int index) {
//                  return Column(
//                    mainAxisSize: MainAxisSize.min,
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.all(5.0),
//                        child: RichText(
//                          text: TextSpan(
//                            text: '',
//                            children: [
//                              TextSpan(
//                                text: '⦿	 ',
//                                style: Styles.subscriptionTextStyle(
//                                  fontSize: 12.0,
//                                  fontWeight: FontWeight.w600,
//                                  color: Color(0xff5E686B),
//                                ),
//                              ),
//                              TextSpan(
//                                text:
//                                    widget.diseases.remedies_list[index].title,
//                                style: Styles.subscriptionTextStyle(
//                                  fontSize: 16.0,
//                                  fontWeight: FontWeight.normal,
//                                  color: Palette.homeScreenInfoTextColor,
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                      Visibility(
//                        visible:
//                            widget.diseases.remedies_list[index].description !=
//                                null,
//                        child: Padding(
//                          padding: const EdgeInsets.only(
//                              left: 12.0, top: 3, bottom: 3),
//                          child: Text(
//                            widget.diseases.remedies_list[index].description !=
//                                    null
//                                ? widget
//                                    .diseases.remedies_list[index].description
//                                : "",
//                            style: Styles.subscriptionTextStyle(
//                              fontSize: 13.0,
//                              fontWeight: FontWeight.normal,
//                              color: Palette.homeScreenInfoTextColor,
//                            ),
//                          ),
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.only(
//                            left: 12.0, top: 3, bottom: 3),
//                        child: ListView.builder(
//                          shrinkWrap: true,
//                          physics: const NeverScrollableScrollPhysics(),
//                          itemCount: widget
//                              .diseases.remedies_list[index].sub_list.length,
//                          itemBuilder: (BuildContext context, int indexNew) {
//                            return Column(
//                              mainAxisSize: MainAxisSize.min,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                RichText(
//                                  text: TextSpan(
//                                    text: '',
//                                    children: [
//                                      TextSpan(
//                                        text: '	•	 ',
//                                        style: Styles.subscriptionTextStyle(
//                                          fontSize: 12.0,
//                                          fontWeight: FontWeight.normal,
//                                          color:
//                                              Palette.homeScreenInfoTextColor,
//                                        ),
//                                      ),
//                                      TextSpan(
//                                        text: widget
//                                            .diseases
//                                            .remedies_list[index]
//                                            .sub_list[indexNew],
//                                        style: Styles.subscriptionTextStyle(
//                                          fontSize: 13.0,
//                                          fontWeight: FontWeight.normal,
//                                          color:
//                                              Palette.homeScreenInfoTextColor,
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              ],
//                            );
//                          },
//                        ),
//                      ),
//                    ],
//                  );
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  Widget _pharmaCentersWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'images/tab_medi_pharma_large.png',
                  height: 37.0,
                  width: 37.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    "Pharmacy Near You",
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Palette.pharmaColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
              child: widget.medicalList.length > 0
                  ? ListView.builder(
                      itemCount: widget.medicalList.length > 5
                          ? 5
                          : widget.medicalList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return MedicalItem(
                          name: widget.medicalList[i].name,
                          distance: (calculateDistance(
                                      Constants.latitude,
                                      Constants.longitude,
                                      widget
                                          .medicalList[i].geometry.location.lat,
                                      widget.medicalList[i].geometry.location
                                          .lng))
                                  .toStringAsFixed(2) +
                              ' Miles away',
                          lat: widget.medicalList[i].geometry.location.lat,
                          log: widget.medicalList[i].geometry.location.lng,
                          address: widget.medicalList[i].vicinity,
                          call: widget.medicalList[i].phone_number,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Fetching data, please wait..',
                        style: Styles.subscriptionTextStyle(
                          fontSize: 15.0,
                          color: Palette.subscriptionBgColor,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _medicalCentersWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'images/tab_medi_center_large.png',
                  height: 37.0,
                  width: 37.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    "Medical Center Near You",
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Palette.medicalColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
              child: widget.hospitalList.length > 0
                  ? ListView.builder(
                      itemCount: widget.hospitalList.length > 5
                          ? 5
                          : widget.hospitalList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return MedicalItem(
                          name: widget.hospitalList[i].name,
                          distance: (calculateDistance(
                                      Constants.latitude,
                                      Constants.longitude,
                                      widget.hospitalList[i].geometry.location
                                          .lat,
                                      widget.hospitalList[i].geometry.location
                                          .lng))
                                  .toStringAsFixed(2) +
                              ' Miles away',
                          lat: widget.hospitalList[i].geometry.location.lat,
                          log: widget.hospitalList[i].geometry.location.lng,
                          address: widget.hospitalList[i].vicinity,
                          call: widget.hospitalList[i].phone_number,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Fetching data, please wait..',
                        style: Styles.subscriptionTextStyle(
                          fontSize: 15.0,
                          color: Palette.subscriptionBgColor,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagesWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'images/tab_allergic_large.png',
                  height: 37.0,
                  width: 37.0,
                ),
                const SizedBox(
                  width: 12.0,
                ),
                Expanded(
                  child: Text(
                    "${widget.diseases.name} Images",
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Palette.pharmaColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 12.0, top: 12.0, bottom: 16.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: Constants.screenWidth * 0.4,
                child: Carousel(
                  autoplay: false,
                  dotBgColor: Colors.transparent,
                  dotColor: Palette.melanomaColor,
                  dotIncreasedColor: Palette.melanomaColor,
                  images: widget.diseases.images.map((image) {
                    return ExactAssetImage(image);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  void fetchLocation() async {
    await LocationPermissions().requestPermissions().then((status) async {
      if (status == PermissionStatus.denied) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          print('Permission has been denied');
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    content: Text(
                      'Please give location permissions from settings to use application functionalities',
                      textAlign: TextAlign.center,
                      style: Styles.workSans500New(
                          color: Colors.black, fontSize: 18),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          print('Permission has been denied okkkkkkkkkk');
                          Navigator.of(context).pop();
                          if (Platform.isAndroid) {
                            checkPermission();
                          } else {
                            LocationPermissions().openAppSettings();
                          }
                        },
                      ),
//                      FlatButton(
//                        child: Text('Cancel'),
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                      ),
                    ],
                  ));
          print('Permission has been denied show dialog');
        });
      } else {
        print('latlong--->> request -----granted-------->>>');
        bool isEnabled = await Geolocator().isLocationServiceEnabled();
        if (isEnabled) {
          Position position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          Constants.latitude = position.latitude;
          Constants.longitude = position.longitude;
          print('latlong--->> ${Constants.latitude}');
          getMedical();
          getPharmacy(widget);
        } else {
//            Toast.show('Please enable GPS and try again.', context);
          Future.delayed(const Duration(milliseconds: 1000), () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                      content: Text(
                        'Please enabled gps from settings to use application functionalities',
                        textAlign: TextAlign.center,
                        style: Styles.workSans500New(
                            color: Colors.black, fontSize: 18),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            print('Permission has been denied okkkkkkkkkk');
                            //Navigator.of(context).pop();
                            if (Platform.isAndroid) {
                              openLocationSetting();
                            }
                            Navigator.of(context).pop();
//                    else {
//                      LocationPermissions().openAppSettings();
//                    }
                          },
                        ),
                        FlatButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
          });
        }
      }
    }).catchError((onError) {
      print("The error we got is : ${onError.toString()}");
    });
  }

  void getMedical() async {
    try {
      Response response =
          await Dio().get(Constants.PLACE_SEARCH_API, queryParameters: {
        "key": Constants.PLACE_API_KEY,
        "fields": "name,rating",
        "type": "hospital",
        "keyword": 'Eye',
        "location": Constants.latitude.toString() +
            "," +
            Constants.longitude.toString(),
        "rankby": "distance",
//        "radius": "500",
      });

      final jsonData = json.decode(response.toString());
      var response1 = PlaceApiModel.fromJson(jsonData);
      if (response1.results.length > 0) {
        int totalSize;
        if (response1.results.length > 5) {
          totalSize = 5;
        } else {
          totalSize = response1.results.length;
        }

        for (int i = 0; i < totalSize; i++) {
          print('phone num id:--->>> ${response1.results[i].place_id}');
          Response responsePhone =
              await Dio().get(Constants.PLACE_GET_PHONE_API, queryParameters: {
            "key": Constants.PLACE_API_KEY,
            "fields": "name,rating,formatted_phone_number",
            "place_id": response1.results[i].place_id,
          }).catchError((onError) {
            print("The error in fetching phone : ${onError.toString()}");
          });
          final jsonData = json.decode(responsePhone.toString());
          var responseNew = GetPhoneNumberModel.fromJson(jsonData);
          print(
              "The added phone number is : ${responseNew.result.formatted_phone_number}");
          response1.results[i].phone_number =
              responseNew.result.formatted_phone_number;
        }

        setState(() {
          print("HELLO WORLD");
          widget.hospitalList = response1.results;
        });
      }
    } catch (e) {
      print("response:->>>> 0011111$e");
      print(e);
    }
  }

  void getPharmacy(AnalysisWidget widget) async {
    try {
      Response response =
          await Dio().get(Constants.PLACE_SEARCH_API, queryParameters: {
        "key": Constants.PLACE_API_KEY,
        "fields": "name,rating",
        "type": "pharmacy",
        "location": Constants.latitude.toString() +
            "," +
            Constants.longitude.toString(),
        "rankby": "distance",
//        "radius": "500",
      });

      final jsonData = json.decode(response.toString());
      var response1 = PlaceApiModel.fromJson(jsonData);
      if (response1.results.length > 0) {
        int totalSize;
        if (response1.results.length > 5) {
          totalSize = 5;
        } else {
          totalSize = response1.results.length;
        }

        for (int i = 0; i < totalSize; i++) {
          print('phone num id:--->>> ${response1.results[i].place_id}');
          Response responsePhone =
              await Dio().get(Constants.PLACE_GET_PHONE_API, queryParameters: {
            "key": Constants.PLACE_API_KEY,
            "fields": "name,rating,formatted_phone_number",
            "place_id": response1.results[i].place_id,
          });
          final jsonData = json.decode(responsePhone.toString());
          var responseNew = GetPhoneNumberModel.fromJson(jsonData);
          response1.results[i].phone_number =
              responseNew.result.formatted_phone_number;
        }

        setState(() {
          widget.medicalList = response1.results;
        });
      }
    } catch (e) {
      print("response:->>>> 0011111$e");
      print(e);
    }
  }

  void checkPermission() async {
    PermissionStatus permission =
        await LocationPermissions().checkPermissionStatus();
    print("Erorrhakjha ===> $permission");
    if (permission == PermissionStatus.granted) {
      bool isEnabled = await Geolocator().isLocationServiceEnabled();
      if (isEnabled) {
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        Constants.latitude = position.latitude;
        Constants.longitude = position.longitude;
        print('latlong--->> ${Constants.latitude}');
        getMedical();
        getPharmacy(widget);
      } else {
        Future.delayed(const Duration(milliseconds: 1000), () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                    content: Text(
                      'Please enabled gps from settings to use application functionalities',
                      textAlign: TextAlign.center,
                      style: Styles.workSans500New(
                          color: Colors.black, fontSize: 18),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          print('Permission has been denied okkkkkkkkkk');
                          //Navigator.of(context).pop();
                          if (Platform.isAndroid) {
                            openLocationSetting();
                          }
                          Navigator.of(context).pop();
//                    else {
//                      LocationPermissions().openAppSettings();
//                    }
                        },
                      ),
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ));
        });

//        Toast.show('Please enable GPS and try again.', context);
      }
    } else {
      await LocationPermissions().requestPermissions().then((status) async {
        print('latlong--->> request ------------->>>$status');
        if (status == PermissionStatus.denied) {
          print('latlong--->> request ----------denied--->>>');
          Future.delayed(const Duration(milliseconds: 1000), () {
            print('Permission has been denied');
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      content: Text(
                        'Please give location permissions from settings to use application functionalities',
                        textAlign: TextAlign.center,
                        style: Styles.workSans500New(
                            color: Colors.black, fontSize: 18),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            print('Permission has been denied okkkkkkkkkk');
                            Navigator.of(context).pop();
                            if (Platform.isAndroid) {
                              checkPermission();
                            } else {
                              LocationPermissions().openAppSettings();
                            }
                          },
                        ),
//                      FlatButton(
//                        child: Text('Cancel'),
//                        onPressed: () {
//                          Navigator.of(context).pop();
//                        },
//                      ),
                      ],
                    ));
            print('Permission has been denied show dialog');
          });
        } else if (status == PermissionStatus.granted) {
          print('latlong--->> request -----granted-------->>>');
          bool isEnabled = await Geolocator().isLocationServiceEnabled();
          if (isEnabled) {
            Position position = await Geolocator()
                .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            Constants.latitude = position.latitude;
            Constants.longitude = position.longitude;
            print('latlong--->> ${Constants.latitude}');
            getMedical();
            getPharmacy(widget);
          } else {
//            Toast.show('Please enable GPS and try again.', context);
            Future.delayed(const Duration(milliseconds: 1000), () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) => AlertDialog(
                        content: Text(
                          'Please enabled gps from settings to use application functionalities',
                          textAlign: TextAlign.center,
                          style: Styles.workSans500New(
                              color: Colors.black, fontSize: 18),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Ok'),
                            onPressed: () {
                              print('Permission has been denied okkkkkkkkkk');
                              //Navigator.of(context).pop();
                              if (Platform.isAndroid) {
                                openLocationSetting();
                              }
                              Navigator.of(context).pop();
//                    else {
//                      LocationPermissions().openAppSettings();
//                    }
                            },
                          ),
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ));
            });
          }
        }
      }).catchError((onError) {
        print("The error we got is : ${onError.toString()}");
      });
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    print('calculateDistance   ${lat1} &&&  ${lon1} &&& ${lat2} &&& ${lon2}');
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
