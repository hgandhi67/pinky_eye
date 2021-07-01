import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:toast/toast.dart';

class ForgotPassPage extends StatefulWidget {
  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  bool validateUserName;
  bool isLoading = false;
  String username = '';
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final focus = FocusNode();

  final PageController controller = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
//      appBar: AppBarWidget.getAppBarWidgetWithLeading(
//        context: context,
//        appBarTitle: Constants.FORGOT_PASSWORD,
////          Forgot Password
//      ),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Image.asset(
            'images/splash_bg.png',
            fit: BoxFit.cover,
            height: Constants.screenHeight,
            width: Constants.screenWidth,
          ),
          Container(
            margin: const EdgeInsets.only(top: 28),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 56.0,
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
                        Constants.FORGOT_PASSWORD,
                        style: Styles.subscriptionTextStyle(
                          fontSize: 18.0,
                          color: Palette.white
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
          ),
          SizedBox(
            width: Constants.screenWidth * 0.8,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Text(
                    Constants.FORGOT_PASSWORD_HINT,
                    style: Styles.workSans500New(
                        color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _buildUsernameField(),
                ),
                SizedBox(
                  height: 15,
                ),
                _buildSendLinkField(),
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: AbsorbPointer(
              child: Container(
                color: Color(0x5FE3F2FF),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSendLinkField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        key: Key('sendLinkButton'),
        color: Palette.buttonOffWhite,
        onPressed: () {
          print('onPressed---------value>>>${username} && ${validateUserName}');
          if (validateUserName == null ||
              !validateUserName ||
              username.isEmpty) {
            Toast.show('Please enter a valid email ID.', context);
            setState(() {
              validateUserName = false;
            });
            return;
          }
          submit(validateUserName, username);
        },
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Text(
          'Send Link'.toUpperCase(),
          style: Styles.subscriptionTextStyle(
            color: Palette.darkButtonTextColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextField(
        textCapitalization: TextCapitalization.words,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        onSubmitted: (v) {
          FocusScope.of(context).requestFocus(focus);
        },
        style: Styles.editTextsTextStyle,
        cursorColor: Palette.white,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.email,
            color: Palette.white,
          ),
          contentPadding: EdgeInsets.all(18.0),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          errorText: (validateUserName == null || validateUserName)
              ? null
              : 'Please enter a valid email ID.',
          errorStyle: Styles.smallButtonTextStyle(
            color: Palette.white,
          ),
          filled: true,
          hintStyle: Styles.editTextHintTextStyle,
          hintText: Constants.EMAIL_ADDRESS,
          fillColor: Palette.editTextBgColor,
        ),
        keyboardType: TextInputType.emailAddress,
        onChanged: (changedField) {
          setState(() {
            username = changedField;
            if (Validator.emailValidator(username)) {
              validateUserName = true;
            } else {
              validateUserName = false;
            }
          });
        });
  }

  Future<String> submit(bool validateUserName, String username) async {
    print('submit-------------->>>');
    if (validateUserName && username.isNotEmpty && username != null) {
      if (mounted) {
        _startLoading();
        FocusScope.of(context).unfocus();
      }
      if (widget != null) {
        try {
          print('sendPasswordResetEmail-------------->>>');
          await FirebaseAuth.instance.sendPasswordResetEmail(email: username);
          if (context != null) {
            Navigator.pop(context);
          }
        } catch (error) {
          print('Error code:-> ' + error.code);
          switch (error.code) {
            case "ERROR_USER_NOT_FOUND":
              Toast.show("Email not registered.", context);
              break;
            case "ERROR_NETWORK_REQUEST_FAILED":
            case "FirebaseException":
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Please check your Internet connection.",
                          style: Styles.workSans500New(
                              color: Colors.black, fontSize: 16)),
//                content: Text("Please check your Internet connection."),
                      actions: <Widget>[
                        // usually buttons at the bottom of the dialog
                        new FlatButton(
                          child: new Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
//          Toast.show("Please check your Internet connection.", context,duration: 2);
              break;
          }
        }
      }
      _stopLoading();
    } else {
      _stopLoading();
    }

    return '';
  }

  void _startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void _stopLoading() {
    setState(() {
      isLoading = false;
    });
  }
}

class Validator {
  static bool emailValidator(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email))
      return false;
    else
      return true;
  }
}
