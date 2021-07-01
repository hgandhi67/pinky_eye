import 'package:flutter/material.dart';
import 'package:pinky_eye/base/theme/palette.dart';

class Styles {
  static TextStyle mediumTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 25,
    fontWeight: FontWeight.w600,
  );

  static TextStyle normalTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 21,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
  );

  static TextStyle normalGreyColoredTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 18,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
  );

  static TextStyle smallTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 17,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle rashNormalTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 20,
    decoration: TextDecoration.underline,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle rashTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 17,
    decoration: TextDecoration.underline,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle extraSmallTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );
  static TextStyle aboutUsContentItalicTextStyle = TextStyle(
    color: Palette.homeScreenInfoTextColor,
    fontFamily: 'WorkSans',
    fontSize: 15,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w300,
  );
  static TextStyle tabsTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonTextStyle({Color color, double size: 18}) {
    return TextStyle(
      color: color,
      fontFamily: 'WorkSans',
      fontSize: size,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle smallButtonTextStyle({
    Color color,
    FontStyle fontStyle: FontStyle.normal,
  }) {
    return TextStyle(
      color: color,
      fontFamily: 'WorkSans',
      fontSize: 13,
      fontStyle: fontStyle,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle editTextHintTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle editTextsTextStyle = TextStyle(
    fontSize: 18,
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
  );

  static TextStyle homeScreenInfoTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
  );

  static TextStyle subscriptionTextStyle(
      {Color color: Palette.textColor,
      double fontSize: 15.0,
      FontWeight fontWeight: FontWeight.w300}) {
    return TextStyle(
      color: color,
      fontFamily: 'WorkSans',
      fontSize: fontSize,
      fontStyle: FontStyle.normal,
      fontWeight: fontWeight,
    );
  }

  static TextStyle drawerTextStyle = TextStyle(
    color: Palette.homeScreenInfoTextColor,
    fontFamily: 'WorkSans',
    fontSize: 16,
    wordSpacing: 0.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle drawerBoldTextStyle = TextStyle(
    color: Palette.textColor,
    fontFamily: 'WorkSans',
    fontSize: 16,
    wordSpacing: 0.0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle homeScreenInfoSmallTextStyle = TextStyle(
    color: Palette.grey1,
    fontFamily: 'WorkSans',
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle rashTileSmallTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 13,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle rashTileBoldSmallTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 13,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle dividerTextStyle = TextStyle(
    color: Palette.homeScreenInfoTextColor,
    fontFamily: 'WorkSans',
    fontSize: 21,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle normalTextWithBoldTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle extraSmallTextWithBoldTextStyle = TextStyle(
    color: Palette.white,
    fontFamily: 'WorkSans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );
  static TextStyle termsAndConditionsTextStyle = TextStyle(
    color: Palette.primaryColor,
    fontFamily: 'WorkSans',
    fontSize: 21,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w800,
  );
  static TextStyle termsAndConditionsHeadingTextStyle = TextStyle(
    color: Palette.primaryColor,
    fontFamily: 'WorkSans',
    fontSize: 20,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  static TextStyle contactEmailTextStyle = TextStyle(
    color: Palette.primaryColor,
    fontFamily: 'WorkSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle aboutUsContentTextStyle = TextStyle(
    color: Palette.homeScreenInfoTextColor,
    fontFamily: 'WorkSans',
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w300,
  );

  static TextStyle termsAndConditionsContextTextStyle = TextStyle(
//    color: Palette.editTextBgColor,
    color: Colors.black,
    fontFamily: 'WorkSans',
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static TextStyle workSans500({Color color}) {
    return TextStyle(
      color: color,
      fontFamily: 'WorkSans',
      fontSize: 14,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle workSans500New({Color color, double fontSize}) {
    return TextStyle(
      color: color,
      fontFamily: 'WorkSans',
      fontSize: fontSize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle workSans600({Color color, double fontSize}) {
    return TextStyle(
      color: color,
      fontFamily: 'WorkSans',
      fontSize: fontSize,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle profileTileTitleTextStyle = TextStyle(
    color: Palette.homeScreenInfoTextColor,
    fontFamily: 'WorkSans',
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  );

  static TextStyle profileTextStyle = TextStyle(
    color: Palette.primaryColor,
    fontFamily: 'WorkSans',
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );
}
