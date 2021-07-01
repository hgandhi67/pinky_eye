import 'package:flutter/material.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class CurrentLocationCheck extends StatefulWidget {
  static bool isCurrentLocationChecked = true;

  @override
  _CurrentLocationCheckState createState() => _CurrentLocationCheckState();
}

class _CurrentLocationCheckState extends State<CurrentLocationCheck> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              CurrentLocationCheck.isCurrentLocationChecked =
                  !CurrentLocationCheck.isCurrentLocationChecked;
            });
          },
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Palette.primaryColor,
              ),
              color: Palette.darkGrey,
            ),
            child: CurrentLocationCheck.isCurrentLocationChecked
                ? Icon(
                    Icons.done,
                    color: Palette.white,
                    size: 18.0,
                  )
                : const SizedBox(),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  Constants.LOCATION_AGREE,
                  style: Styles.extraSmallTextStyle,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showDialog();
                },
                child: CircleAvatar(
                  backgroundColor: Palette.primaryColor,
                  radius: 10.0,
                  child: Text('?'),
                ),
              ),
            ],
          ),
        ),
      ],
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
              right: 8.0,
              left: 8.0,
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
                        Constants.CURRENT_LOCATION,
                        style: Styles.subscriptionTextStyle(
                          color: Palette.textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'You can see or edit your dependents from profile page',
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
}
