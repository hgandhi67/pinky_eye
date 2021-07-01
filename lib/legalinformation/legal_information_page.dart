import 'package:flutter/material.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';

class LegalInformation extends StatefulWidget {
  final String pageTitle;
  final Widget pageData;

  const LegalInformation({
    Key key,
    @required this.pageTitle,
    @required this.pageData,
  }) : super(key: key);

  @override
  _LegalInformationPageState createState() => _LegalInformationPageState();
}

class _LegalInformationPageState extends State<LegalInformation> {
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
                      color: Palette.buttonOffWhite,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                        bottom: 25.0,
                        left: 15.0,
                        right: 15.0,
                        top: 20.0,
                      ),
                      child: widget.pageData,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60.0,
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
                  widget.pageTitle,
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
