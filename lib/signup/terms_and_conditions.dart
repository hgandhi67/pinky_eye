import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class TermsAndConditions extends StatefulWidget {
  static bool isTermsAndConditionsChecked = false;

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  final TapGestureRecognizer _tapTcGestureRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();

    _tapTcGestureRecognizer.onTap = () {
      _showDialog(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTermsAndConditionsWidget(),
          _getMedicalDisclaimerWidget(),
        ],
      ));
    };
  }

  @override
  void dispose() {
    _tapTcGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              TermsAndConditions.isTermsAndConditionsChecked =
                  !TermsAndConditions.isTermsAndConditionsChecked;
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
            child: TermsAndConditions.isTermsAndConditionsChecked
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
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: Constants.AGREE_TEXT,
                    style: Styles.extraSmallTextStyle),
                TextSpan(
                  text: Constants.T_AND_C,
                  style: Styles.extraSmallTextWithBoldTextStyle,
                  recognizer: _tapTcGestureRecognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _getMedicalDisclaimerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 22.0,
        ),
        Text(
          Constants.terms_cond31.toUpperCase(),
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond32,
          style: Styles.subscriptionTextStyle(
            color: Palette.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 20.0,
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
          height: 30.0,
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
          height: 20.0,
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
          height: 30.0,
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
          height: 20.0,
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
          height: 30.0,
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
          height: 20.0,
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
          height: 30.0,
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
          height: 20.0,
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

  Widget _getTermsAndConditionsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 22.0,
        ),
        Text(
          Constants.TERMS.toUpperCase(),
          style: Styles.subscriptionTextStyle(
              color: Palette.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 20.0),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 45.0,
        ),
//                      Text(
//                        Constants.terms_cond1,
//                        style: Styles.subscriptionTextStyle(
//                            color: Palette.grey1,
//                            fontWeight: FontWeight.normal,
//                            fontSize: 15.0),
//                      ),
//                      const SizedBox(
//                        height: 10.0,
//                      ),
        Text(
          Constants.terms_cond2 +
              "\n\n\n" +
              Constants.terms_cond3 +
              "\n\n\n" +
              Constants.terms_cond4,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 28.0,
        ),
        Text(
          Constants.terms_cond5.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          'Personal information you disclose to us',
          style: Styles.termsAndConditionsContextTextStyle,
        ),
        const SizedBox(
          height: 4.0,
        ),
        Text(
          Constants.terms_cond6,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond7.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond8,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            "\n" + Constants.terms_cond8_1,
            style: Styles.aboutUsContentTextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          "\n" + Constants.terms_cond9,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond10.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond11 + "\n\n\n" + Constants.terms_cond12,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond13.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond14,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond15.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond16,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond17.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond18,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond19.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond20,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond21.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond22,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond23.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond24,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond25.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond26,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond27.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond28,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond29.toUpperCase(),
          style: Styles.termsAndConditionsHeadingTextStyle,
        ),
        const SizedBox(
          height: 30.0,
        ),
        Text(
          Constants.terms_cond30,
          style: Styles.aboutUsContentTextStyle,
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 8.0,
        )
      ],
    );
  }

  void _showDialog(Widget dataWidget) {
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
                  dataWidget,
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
