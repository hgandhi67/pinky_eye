import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/modal_progress_indicator.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/signin/sign_in_page.dart';
import 'package:pinky_eye/signup/terms_and_conditions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String username = '';
  String password = '';
  String fullName = '';
  String lastName = '';
  String zipCode = '';
  String dob = '';
  bool validateUserName;
  bool validatePassword;
  bool validateFullName;
  bool validateZipCode;
  bool validateDob;
  bool isLoading = false;

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _zipFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _dobFocusNode = FocusNode();

  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _firstNameEditingController =
      TextEditingController();
  final TextEditingController _lastNameEditingController =
      TextEditingController();
  final TextEditingController _zipEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _dobEditingController = TextEditingController();

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer.onTap =
        () => Navigator.of(context).pushNamed(AppRoutes.SIGN_IN);

    setSharedPref();
  }

  void setSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    _userNameFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _zipFocusNode.dispose();
    _passwordFocusNode.dispose();
    _dobFocusNode.dispose();
    _userNameEditingController.dispose();
    _firstNameEditingController.dispose();
    _lastNameEditingController.dispose();
    _zipEditingController.dispose();
    _passwordEditingController.dispose();
    _dobEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: Palette.white,
        opacity: 0.6,
        child: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Image.asset(
                'images/splash_bg.png',
                fit: BoxFit.cover,
                height: Constants.screenHeight,
                width: Constants.screenWidth,
              ),
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  width: Constants.screenWidth * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: Constants.screenHeight * 0.10,
                      ),
                      Text(
                        Constants.SIGN_UP,
                        style: Styles.subscriptionTextStyle(
                          color: Palette.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(
                        height: Constants.screenHeight * 0.05,
                      ),
                      Text(
                        Constants.PLEASE_SIGN_UP_TEXT,
                        style: Styles.smallTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Constants.screenHeight * 0.05,
                      ),
                      _firstNameWidget(),
                      SizedBox(
                        height: Constants.screenHeight * 0.02,
                      ),
                      _lastNameWidget(),
                      SizedBox(
                        height: Constants.screenHeight * 0.02,
                      ),
                      _dobWidget(),
                      SizedBox(
                        height: Constants.screenWidth * 0.05,
                      ),
                      _zipWidget(),

                      SizedBox(
                        height: Constants.screenHeight * 0.02,
                      ),
                      _userNameWidget(),
                      SizedBox(
                        height: Constants.screenHeight * 0.02,
                      ),
                      _passwordWidget(),
//                    SizedBox(
//                      height: Constants.screenHeight * 0.02,
//                    ),
//                    CurrentLocationCheck(),
                      SizedBox(
                        height: Constants.screenHeight * 0.02,
                      ),
                      TermsAndConditions(),
                      SizedBox(
                        height: Constants.screenHeight * 0.03,
                      ),
                      _signUpButton(),
                      SizedBox(
                        height: Constants.screenHeight * 0.03,
                      ),
                      _alreadyAccountLayout(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userNameWidget() {
    return TextField(
      onChanged: (changedText) {
        setState(() {
          username = changedText;
          if (Validator.validateEmail(username)) {
            validateUserName = true;
          } else {
            validateUserName = false;
          }
        });
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      controller: _userNameEditingController,
      textInputAction: TextInputAction.next,
      focusNode: _userNameFocusNode,
      onSubmitted: (_) {
        _userNameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
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
    );
  }

  Widget _firstNameWidget() {
    return TextField(
      onChanged: (changedText) {
        fullName = changedText;
        if (Validator.validateFullName(fullName)) {
          validateFullName = true;
        } else {
          validateFullName = false;
        }
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      enableInteractiveSelection: false,
      cursorColor: Palette.white,
      controller: _firstNameEditingController,
      textInputAction: TextInputAction.next,
      focusNode: _firstNameFocusNode,
      onSubmitted: (_) {
        _firstNameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_lastNameFocusNode);
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.person,
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
        errorText: (validateFullName == null || validateFullName)
            ? null
            : 'Please enter first name',
        errorStyle: Styles.smallButtonTextStyle(
          color: Palette.white,
        ),
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.FIRST_NAME,
        fillColor: Palette.editTextBgColor,
      ),
    );
  }

  Widget _lastNameWidget() {
    return TextField(
      onChanged: (changedText) {
        lastName = changedText;
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      controller: _lastNameEditingController,
      textInputAction: TextInputAction.next,
      focusNode: _lastNameFocusNode,
      onSubmitted: (_) {
        _lastNameFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_dobFocusNode);
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.person,
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
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.LAST_NAME,
        fillColor: Palette.editTextBgColor,
      ),
    );
  }

  Widget _zipWidget() {
    return TextField(
      onChanged: (changedText) {
        zipCode = changedText;
        if (Validator.validateZipCode(zipCode)) {
          validateZipCode = true;
        } else {
          validateZipCode = false;
        }
      },
      textAlign: TextAlign.start,
      keyboardType: TextInputType.number,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      controller: _zipEditingController,
      textInputAction: TextInputAction.next,
      focusNode: _zipFocusNode,
      onSubmitted: (_) {
        _zipFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_userNameFocusNode);
      },
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.location_on,
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
        errorText: (validateZipCode == null || validateZipCode)
            ? null
            : 'Please enter a valid zip code',
        errorStyle: Styles.smallButtonTextStyle(
          color: Palette.white,
        ),
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.ZIP_CODE,
        fillColor: Palette.editTextBgColor,
      ),
    );
  }

  Widget _passwordWidget() {
    return TextField(
      onChanged: (changedText) {
        setState(() {
          password = changedText;
          if (Validator.validatePassword(password)) {
            validatePassword = true;
          } else {
            validatePassword = false;
          }
        });
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      controller: _passwordEditingController,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      focusNode: _passwordFocusNode,
      onSubmitted: (_) {
        _passwordFocusNode.unfocus();
      },
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.lock,
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
        errorText: (validatePassword == null || validatePassword)
            ? null
            : 'Please enter a valid password.',
        errorStyle: Styles.smallButtonTextStyle(
          color: Palette.white,
        ),
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.PASSWORD,
        fillColor: Palette.editTextBgColor,
      ),
    );
  }

  Widget _dobWidget() {
    return TextField(
      onTap: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: DateTime(1900, 1, 1),
          maxTime: DateTime.now(),
          onConfirm: (date) {
            setState(() {
              dob = '${date.day}/${date.month}/${date.year}';
              _dobEditingController.text = dob;
              validateDob = true;
            });
          },
          locale: LocaleType.en,
        );
      },
      textAlign: TextAlign.start,
      style: Styles.editTextsTextStyle,
      autocorrect: false,
      enableInteractiveSelection: false,
      cursorColor: Palette.primaryColor,
      controller: _dobEditingController,
      textInputAction: TextInputAction.next,
      focusNode: _dobFocusNode,
      onSubmitted: (_) {
        _dobFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_zipFocusNode);
      },
      readOnly: true,
      decoration: InputDecoration(
        suffixIcon: Icon(
          Icons.calendar_today,
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
        errorText: (validateDob == null || validateDob)
            ? null
            : 'Please select Date of Birth.',
        errorStyle: Styles.smallButtonTextStyle(
          color: Palette.white,
        ),
        filled: true,
        hintStyle: Styles.editTextHintTextStyle,
        hintText: Constants.DOB,
        fillColor: Palette.editTextBgColor,
      ),
    );
  }

  Widget _signUpButton() {
    return MaterialButton(
      minWidth: Constants.screenWidth,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      onPressed: () {
        Provider.of<AppStateModel>(context).isInternetConnected().then((value) {
          if (value) {
            _signUpUser();
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
      child: Text(
        Constants.SIGN_UP.toUpperCase(),
        style: Styles.subscriptionTextStyle(
          color: Palette.darkButtonTextColor,
          fontSize: 19.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
      color: Palette.buttonOffWhite,
    );
  }

  Widget _alreadyAccountLayout() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: Constants.ALREADY_ACCOUNT,
            style: Styles.smallTextStyle,
          ),
          TextSpan(
            text: Constants.LOGIN,
            style: Styles.extraSmallTextWithBoldTextStyle,
            recognizer: _tapGestureRecognizer,
          )
        ],
      ),
    );
  }

  void _signUpUser() async {
    if (validateFullName == null || !validateFullName) {
      Toast.show('Please enter a first name', context);
      setState(() {
        validateFullName = false;
      });
      return;
    } else if (validateDob == null || !validateDob) {
      Toast.show('Please select date of birth', context);
      setState(() {
        validateDob = false;
      });
      return;
    } else if (validateZipCode == null || !validateZipCode) {
      Toast.show('Please enter a valid zip code', context);
      setState(() {
        validateZipCode = false;
      });
      return;
    } else if (validateUserName == null || !validateUserName) {
      Toast.show('Please enter a valid email ID.', context);
      setState(() {
        validateUserName = false;
      });
      return;
    } else if (validatePassword == null || !validatePassword) {
      setState(() {
        Toast.show('Please enter a valid password.', context);
        validatePassword = false;
      });
      return;
    } else if (!TermsAndConditions.isTermsAndConditionsChecked) {
      setState(() {
        Toast.show('Please read the terms and conditions', context);
      });
      return;
    }

    _startLoading();
    try {
      FirebaseUser user =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _userNameEditingController.text,
        password: _passwordEditingController.text,
      ))
              .user;
      print('user--------->>>$user');
      try {
        await user.sendEmailVerification();
        _stopLoading();
        _showDialog(user);
      } catch (e) {
        print(
            "An error occured while trying to send email        verification");
        print(e.message);
      }
    } catch (error) {
      _stopLoading();
      print('Error code:-> ' + error.code);
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          Toast.show("Email already registered.", context);
          break;
        case "ERROR_NETWORK_REQUEST_FAILED":
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
//          Toast.show("Check your internet connection.", context);
          break;
        default:
          Toast.show("Something went wrong", context);
          break;
      }
    }
  }

  void _showDialog(FirebaseUser user) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'You will get email for verification, please check your mail.',
                  style: Styles.subscriptionTextStyle(
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 25.0,
                ),
                MaterialButton(
                  onPressed: () {
                    if (user != null) {
                      Firestore.instance
                          .collection('users')
                          .document(user.uid)
                          .setData({
                        "email": user.email,
                        "firstname": _firstNameEditingController.text,
                        "lastname": _lastNameEditingController.text,
                        "image": '',
                        "name": _firstNameEditingController.text +
                            " " +
                            _lastNameEditingController.text,
                        "dob": _dobEditingController.text,
                        "type": "Email",
                        "zip": _zipEditingController.text,
                        "user_uuid": user.uid,
                      }).then((value) async {
                        print('user---------value>>>');
                        if (mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      SignInPage()),
                              (Route<dynamic> route) => false);
                        }
                      }).catchError((error) {
                        _stopLoading();
                        Toast.show('Unable to signup, please try again later',
                            context);
                        print('Error------->>> ${error.toString()}');
                      });
                    } else {
                      _stopLoading();
                      Toast.show(
                          'Unable to login, please try again later', context);
                    }
                  },
                  color: Palette.subscriptionBgColor,
                  child: Text(
                    'Ok',
                    style: Styles.subscriptionTextStyle(
                      color: Palette.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
  static bool validateFullName(String fullName) {
    if (fullName == '' || fullName.isEmpty) {
      return false;
    }
    return true;
  }

  static bool validateZipCode(String zipCode) {
    if (DateTime.now().timeZoneName == 'IST') {
      if (zipCode == '' || zipCode.isEmpty || zipCode.length != 6) {
        return false;
      }
    } else {
      if (zipCode == '' || zipCode.isEmpty || zipCode.length != 5) {
        return false;
      }
    }
    return true;
  }

  static bool validateDOB(String dob) {
    if (dob == '' || dob.isEmpty) {
      return false;
    }
    return true;
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  static bool validatePassword(String password) {
    if (password == '' || password.isEmpty || password.length < 6) {
      return false;
    }
    return true;
  }
}
