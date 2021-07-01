import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/appbar/app_bar.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/modal_progress_indicator.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:toast/toast.dart';

class ChangePassPage extends StatefulWidget {
  ChangePassPage();

  @override
  _ChangePassPageState createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  String currentPassword = '';
  String newPassword = '';
  String confirmNewPassword = '';
  bool validateCurrentPassword;
  bool validateNewPassword;
  bool validateConfirmNewPassword;
  bool isLoading = false;

  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final TextEditingController _currentPasswordEditingController =
      TextEditingController();
  final TextEditingController _newPasswordEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordEditingController =
      TextEditingController();
  FirebaseUser currentUserDetail;
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    currentUser().then((value) {
      setState(() {
        currentUserDetail = value;
        currentUserEmail = currentUserDetail.email;
      });
    });
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  void dispose() {
    _currentPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();

    _currentPasswordEditingController.dispose();
    _newPasswordEditingController.dispose();
    _confirmPasswordEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBarWidget.getAppBarWidgetWithLeading(
        context: context,
        appBarTitle: Constants.CHANGE_PASSWORD,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: Palette.white,
        opacity: 0.6,
        child: Stack(
          children: <Widget>[
            Image.asset(
              'images/splash_bg.png',
              fit: BoxFit.cover,
              height: Constants.screenHeight,
              width: Constants.screenWidth,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Text(
                      Constants.CHANGE_PASS_HINT,
                      style: Styles.workSans500New(
                          color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    'Email: ' + currentUserEmail,
                    style: Styles.workSans600(
                      color: Palette.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  _buildCurrentPassField(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  _buildNewPassField(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  _buildConfirmPassField(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  _buildSendLinkField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendLinkField() {
    return Container(
        width: MediaQuery.of(context).size.width,
//      margin: EdgeInsets.symmetric(horizontal: 30),
        child: MaterialButton(
          key: Key('saveButton'),
          color: Palette.white,
          onPressed: () {
            Provider.of<AppStateModel>(context).isInternetConnected().then((value){
              if(value){
                checkCurrentPass();
              }else{
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
                  },
                );
              }
            });
          },
          padding: EdgeInsets.all(15.0),
          child: Text(Constants.SUBMIT.toUpperCase(),
              style: Styles.buttonTextStyle(color: Palette.primaryColor)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(3.0),
            ),
          ),
        ));
  }

  checkCurrentPass() async {
    if (validateCurrentPassword == null || !validateCurrentPassword) {
      Toast.show('Please enter proper current password.', context);
      setState(() {
        validateCurrentPassword = false;
      });
      return;
    } else if (validateNewPassword == null || !validateNewPassword) {
      Toast.show('Please enter proper new password.', context);
      setState(() {
        validateNewPassword = false;
      });
      return;
    } else if (validateConfirmNewPassword == null ||
        !validateConfirmNewPassword) {
      Toast.show('Please enter proper new password.', context);
      setState(() {
        validateConfirmNewPassword = false;
      });
      return;
    } else if (_newPasswordEditingController.text !=
        _confirmPasswordEditingController.text) {
      Toast.show('Passwords don\'t match.', context);
      setState(() {
        validateConfirmNewPassword = false;
      });
      return;
    }

    _startLoading();
    try {
      FirebaseUser user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: currentUserDetail.email,
        password: _currentPasswordEditingController.text,
      ))
              .user;
      if (user != null) {
        print('HERE it is ${user.email}');
        user.updatePassword(_confirmPasswordEditingController.text).then((_) {
          _stopLoading();
          Toast.show('Password changed.', context);
          Navigator.of(context).pop();
        }).catchError((error) {
          _stopLoading();
          Toast.show(
              'Unable to change password, please try again later', context);
        });
      } else {
        _stopLoading();
        Toast.show(
            'Unable to change password, please try again later', context);
      }
    } catch (error) {
      _stopLoading();
      print('Error code:-> ' + error.code);
      switch (error.code) {
        case "ERROR_NETWORK_REQUEST_FAILED":
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text("Please check your Internet connection.",style: Styles.workSans500New(color:Colors.black,fontSize: 16)),
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
              }
          );
//          Toast.show("Check your internet connection.", context);
          break;
        case "ERROR_WRONG_PASSWORD":
          Toast.show("Current password is invalid.", context);
          break;
        default:
          Toast.show("Something went wrong", context);
          break;
      }
    }
  }

  Widget _buildCurrentPassField() {
    return TextField(
      onChanged: (changedText) {
        setState(() {
          currentPassword = changedText;
          if (Validator.validatePassword(currentPassword)) {
            validateCurrentPassword = true;
          } else {
            validateCurrentPassword = false;
          }
        });
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      controller: _currentPasswordEditingController,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      focusNode: _currentPasswordFocusNode,
      onSubmitted: (_) {
        _currentPasswordFocusNode.unfocus();
        Focus.of(context).requestFocus(_newPasswordFocusNode);
      },
      obscureText: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.lock,
          color: Palette.textHintGrey,
        ),
        contentPadding: EdgeInsets.all(15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Palette.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Palette.primaryColor,
          ),
        ),
        errorText: (validateCurrentPassword == null || validateCurrentPassword)
            ? null
            : 'Please enter proper password.',
        errorStyle: Styles.smallButtonTextStyle(
          color: Palette.redColor,
        ),
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.CURRENT_PASSWORD,
      ),
    );
  }

  Widget _buildNewPassField() {
    return TextField(
      onChanged: (changedText) {
        setState(() {
          newPassword = changedText;
          if (Validator.validatePassword(newPassword)) {
            validateNewPassword = true;
          } else {
            validateNewPassword = false;
          }
        });
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      controller: _newPasswordEditingController,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      focusNode: _newPasswordFocusNode,
      onSubmitted: (_) {
        _newPasswordFocusNode.unfocus();
        Focus.of(context).requestFocus(_confirmPasswordFocusNode);
      },
      obscureText: true,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.lock,
          color: Palette.textHintGrey,
        ),
        contentPadding: EdgeInsets.all(15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Palette.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Palette.primaryColor,
          ),
        ),
        errorText: (validateNewPassword == null || validateNewPassword)
            ? null
            : 'Please enter proper password.',
        errorStyle: Styles.smallButtonTextStyle(
          color: Palette.redColor,
        ),
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.NEW_PASSWORD,
      ),
    );
  }

  Widget _buildConfirmPassField() {
    return TextField(
      onChanged: (changedText) {
        setState(() {
          confirmNewPassword = changedText;
          if (Validator.validatePassword(confirmNewPassword)) {
            validateConfirmNewPassword = true;
          } else {
            validateConfirmNewPassword = false;
          }
        });
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      controller: _confirmPasswordEditingController,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      focusNode: _confirmPasswordFocusNode,
      onSubmitted: (_) {
        _confirmPasswordFocusNode.unfocus();
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.lock,
          color: Palette.textHintGrey,
        ),
        contentPadding: EdgeInsets.all(15.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Palette.primaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(
            color: Palette.primaryColor,
          ),
        ),
        errorText:
            (validateConfirmNewPassword == null || validateConfirmNewPassword)
                ? null
                : 'Please enter proper password.',
        errorStyle: Styles.smallButtonTextStyle(
          color: Palette.redColor,
        ),
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.CONFIRM_PASSWORD,
      ),
    );
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
  static bool validatePassword(String password) {
    if (password == '' || password.isEmpty || password.length < 6) {
      return false;
    }
    return true;
  }
}
