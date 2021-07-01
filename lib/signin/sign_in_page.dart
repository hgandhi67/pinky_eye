import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/modal_progress_indicator.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/home/home_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String username = '';
  String password = '';
  bool validateUserName;
  bool validatePassword;
  bool isLoading = false;

  final FocusNode _userNameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

//  static final FacebookLogin facebookSignIn = new FacebookLogin();
  GoogleSignInAccount googleAccount;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer.onTap =
        () => Navigator.of(context).pushNamed(AppRoutes.SIGN_UP);

    setSharedPref();
  }

  void setSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _userNameEditingController.dispose();
    _passwordEditingController.dispose();
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
                        Constants.LOGIN_NOW,
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
                        Constants.PLEASE_LOGIN_TEXT,
                        style: Styles.smallTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Constants.screenHeight * 0.04,
                      ),
                      _userNameWidget(),
                      SizedBox(
                        height: Constants.screenHeight * 0.02,
                      ),
                      _passwordWidget(),
                      SizedBox(
                        height: Constants.screenHeight * 0.03,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(AppRoutes.FORGOT_PASSWORD),
                          child: Text(
                            Constants.FORGOT,
                            style: Styles.subscriptionTextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w400,
                              color: Palette.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Constants.screenHeight * 0.03,
                      ),
                      _loginButton(),
                      SizedBox(
                        height: Constants.screenHeight * 0.05,
                      ),
                      Text(
                        Constants.LOGIN_WITH,
                        style: Styles.normalTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Constants.screenHeight * 0.03,
                      ),
                      _socialLoginWidget(),
                      Visibility(
                        visible: Platform.isIOS,
                        child: SizedBox(
                          height: Constants.screenHeight * 0.05,
                        ),
                      ),
                      Visibility(
                        visible: Platform.isIOS,
                        child: Column(
                          children: <Widget>[
                            AppleSignInButton(
                              style: ButtonStyle.black,
                              type: ButtonType.continueButton,
                              onPressed: appleLogIn,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Constants.screenHeight * 0.03,
                      ),
                      _noAccountLayout(),
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
    return SizedBox(
      width: Constants.screenWidth * 0.8,
      child: TextField(
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
        cursorColor: Palette.white,
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
      ),
    );
  }

  Widget _passwordWidget() {
    return SizedBox(
      width: Constants.screenWidth * 0.8,
      child: TextField(
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
        cursorColor: Palette.white,
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
      ),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      minWidth: Constants.screenWidth * 0.8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      onPressed: () {
        Provider.of<AppStateModel>(context).isInternetConnected().then((value) {
          if (value) {
            _loginUser();
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
        Constants.LOGIN.toUpperCase(),
        style: Styles.subscriptionTextStyle(
          color: Palette.darkButtonTextColor,
          fontSize: 19.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
      color: Palette.buttonOffWhite,
    );
  }

  Widget _socialLoginWidget() {
    return SizedBox(
      width: Constants.screenWidth * 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Image.asset(
//            'images/facebook.png',
//            height: 65.0,
//            width: 65.0,
//          ),
          const SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () => _getSignedInAccount(),
            child: Image.asset(
              'images/google.png',
              height: 65.0,
              width: 65.0,
            ),
          ),
          const SizedBox(
            width: 15.0,
          ),
          GestureDetector(
            onTap: () => _linkedInLogin(),
            child: Image.asset(
              'images/linkedin.png',
              height: 65.0,
              width: 65.0,
            ),
          ),
        ],
      ),
    );
  }

  void checkSubscription(String userId, bool isSocialLogin) {
    Firestore.instance
        .collection('account_subscription')
        .document(userId)
        .get(source: Source.server)
        .then((documents) {
      if (documents.data == null) {
        Firestore.instance
            .collection('account_subscription')
            .document(userId)
            .setData({
          'plan_type': '',
          'reviews_left': '0',
          'reviews_taken': '0',
          'active': 0,
          'expiry_date': '',
          'activation_date': '',
          'activation_type': '',
          'is_trial_utilised': false,
        }).then((_) {
          _stopLoading();
          Provider.of<AppStateModel>(context, listen: false)
              .currentSubscriptionPackage = new SubscriptionData(
            active: 0,
            activationDate: '',
            activationType: '',
            expiryDate: '',
            isTrialUtilised: false,
            planType: '',
            reviewsLeft: '0',
            reviewsTaken: '0',
          );
          Navigator.of(context).pushNamed(AppRoutes.SUBSCRIPTION, arguments: {
            AppRouteArgKeys.IS_PINKY_EYE_LOGIN: true,
            AppRouteArgKeys.IS_PINKY_SOCIAL_LOGIN: isSocialLogin,
            AppRouteArgKeys.LOGGED_IN_USER_ID: userId,
            AppRouteArgKeys.IS_TRIAL_UTILISED: false,
            AppRouteArgKeys.REVIEWS_TAKEN: '0',
            AppRouteArgKeys.SUBS_PAGE_FROM: 0,
          });
        });
      } else {
        print("The documents : ${documents.data}");
        _stopLoading();
        Provider.of<AppStateModel>(context, listen: false)
            .currentSubscriptionPackage = new SubscriptionData(
          active: documents['active'],
          activationDate: documents['activation_date'],
          activationType: documents['activation_type'],
          expiryDate: documents['expiry_date'],
          isTrialUtilised: documents['is_trial_utilised'],
          planType: documents['plan_type'],
          reviewsLeft: documents['reviews_left'],
          reviewsTaken: documents['reviews_taken'],
        );
        if (documents.data['active'] == 1) {
          sharedPreferences.setBool(Constants.IS_PINKY_EYE_LOGIN, true);
          sharedPreferences.setBool(
              Constants.IS_PINKY_SOCIAL_LOGIN, isSocialLogin);
          sharedPreferences.setString(Constants.LOGGED_IN_USER_ID, userId);

          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  settings: RouteSettings(name: AppRoutes.HOME_PAGE),
                  builder: (BuildContext context) => HomePage(),
                ),
                (Route<dynamic> route) => false);
          }
        } else {
          Navigator.of(context).pushNamed(AppRoutes.SUBSCRIPTION, arguments: {
            AppRouteArgKeys.IS_PINKY_EYE_LOGIN: true,
            AppRouteArgKeys.IS_PINKY_SOCIAL_LOGIN: isSocialLogin,
            AppRouteArgKeys.LOGGED_IN_USER_ID: userId,
            AppRouteArgKeys.IS_TRIAL_UTILISED:
                documents.data.containsKey('is_trial_utilised')
                    ? documents.data['is_trial_utilised']
                    : false,
            AppRouteArgKeys.REVIEWS_TAKEN:
                documents.data.containsKey('reviews_taken')
                    ? documents.data['reviews_taken']
                    : '',
            AppRouteArgKeys.SUBS_PAGE_FROM: 0,
          });
        }
      }
    }).catchError((onError) {
      print("The error is : ${onError.toString()}");
      _stopLoading();
    });
  }

  void _linkedInLogin() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LinkedInUserWidget(
          appBar: AppBar(
            title: Text('Pinky Eye'),
          ),
          redirectUrl: Constants.LINKED_IN_REDIRECT_URL,
          clientId: Constants.LINKED_IN_CLIENT_ID,
          clientSecret: Constants.LINKED_IN_CLIENT_SECRET,
          onGetUserProfile: (LinkedInUserModel linkedInUser) {
            print('Access token ${linkedInUser.token.accessToken}');
            print(
                "LINKED IN EMAIL :==> ${linkedInUser.email.elements[0].handleDeep.emailAddress}");
            if (linkedInUser != null) {
              Firestore.instance
                  .collection('users')
                  .document(linkedInUser.userId)
                  .setData({
                "email":
                    linkedInUser.email.elements[0].handleDeep.emailAddress ??
                        '',
                "name":
                    '${linkedInUser.firstName.localized.label} ${linkedInUser.lastName.localized.label}',
                "firstname": '${linkedInUser.firstName.localized.label}',
                "lastname": '${linkedInUser.lastName.localized.label}',
                "image": '',
                "dob": '',
                "type": "Linkedin",
                "zip": "",
                "user_uuid": linkedInUser.userId,
              }).then((value) async {
                checkSubscription(linkedInUser.userId, true);
              }).catchError((error) {
                _stopLoading();
                Toast.show('Unable to login, please try again later', context);
                print('Error------->>> ${error.toString()}');
              });
            }
          },
          catchError: (LinkedInErrorObject error) {
            print('Error description: ${error.description},'
                ' Error code: ${error.statusCode.toString()}');
            if (error.statusCode != 401) {
              Navigator.pop(context);
            }
          },
        ),
        fullscreenDialog: false,
      ),
    );
  }

  Widget _noAccountLayout() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: Constants.NO_ACCOUNT,
            style: Styles.extraSmallTextStyle,
          ),
          TextSpan(
            text: Constants.SIGN_UP,
            style: Styles.extraSmallTextWithBoldTextStyle,
            recognizer: _tapGestureRecognizer,
          )
        ],
      ),
    );
  }

  void _getSignedInAccount() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    googleAccount = await getSignedInAccount(googleSignIn);
    print('Google account $googleAccount');

    if (googleAccount != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      _startLoading();
      FirebaseAuth.instance.signInWithCredential(credential).then((user) async {
        print("HELLO ====> Signed in account : $user");
        if (user != null) {
          print('HERE it is ${user.user.email}');
          Firestore.instance
              .collection('users')
              .document(user.user.uid)
              .setData({
            "email": user.user.email,
            "name": user.user.displayName,
            "firstname": '${user.user.displayName.split(' ')[0].toString()}',
            "lastname": user.user.displayName.split(' ').length > 1
                ? '${user.user.displayName.split(' ')[1]}'
                : '',
            "image": googleAccount.photoUrl,
            "dob": '',
            "type": "Google",
            "user_uuid": user.user.uid,
          }).then((value) async {
            print('user---------value>>>');
//            sharedPreferences.setBool(Constants.IS_RASH_DECISION_LOGIN, true);
//            sharedPreferences.setBool(Constants.IS_RASH_SOCIAL_LOGIN, true);
//            sharedPreferences.setString(
//                Constants.LOGGED_IN_USER_ID, user.user.uid);
            await googleSignIn.disconnect();
            await FirebaseAuth.instance.signOut();
            checkSubscription(user.user.uid, true);
          }).catchError((error) {
            _stopLoading();
            Toast.show('Unable to login, please try again later', context);
            print('Error------->>> ${error.toString()}');
          });
        } else {
          Toast.show('Unable to login, please try again later', context);
          _stopLoading();
        }
      }).catchError((error) {
        Toast.show('${error.toString()}', context);
        _stopLoading();
      });
    }
  }

  Future<GoogleSignInAccount> getSignedInAccount(
      GoogleSignIn googleSignIn) async {
    GoogleSignInAccount account = googleSignIn.currentUser;
    if (account == null) {
      account = await googleSignIn.signInSilently();
    }
    return account;
  }

/*Future<Null> getFacebookSignInAccount() async {
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final accessToken = result.accessToken.token;
        AuthCredential fbCredential =
            FacebookAuthProvider.getCredential(accessToken: accessToken);
        FirebaseAuth.instance
            .signInWithCredential(fbCredential)
            .then((user) async {
          print('user is : ' + user.user.email);
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print(
          'Something went wrong with the login process.\n'
          'Here\'s the error Facebook gave us: ${result.errorMessage}',
        );
        break;
    }
    return null;
  }*/

  void _loginUser() async {
    if (validateUserName == null ||
        validatePassword == null ||
        !validateUserName ||
        !validatePassword ||
        _userNameEditingController.text.isEmpty ||
        _passwordEditingController.text.isEmpty) {
      Toast.show('Please enter all the details.', context);
      setState(() {
        validateUserName = false;
        validatePassword = false;
      });
      return;
    }
    _startLoading();
    try {
      FirebaseUser user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _userNameEditingController.text,
        password: _passwordEditingController.text,
      ))
              .user;
      if (user.isEmailVerified) {
        if (user != null) {
          print('HERE it is ${user.displayName}');
//          sharedPreferences.setBool(Constants.IS_RASH_DECISION_LOGIN, true);
//          sharedPreferences.setBool(Constants.IS_RASH_SOCIAL_LOGIN, false);
//          sharedPreferences.setString(Constants.LOGGED_IN_USER_ID, user.uid);
          checkSubscription(user.uid, false);
        } else {
          _stopLoading();
          Toast.show('Unable to login, please try again later', context);
        }
      } else {
        await user.sendEmailVerification();
        _stopLoading();
        Toast.show('Please verify your email.', context);
      }
    } catch (error) {
      _stopLoading();
      print('Error code:-> ' + error.code);
      switch (error.code) {
        case "ERROR_USER_NOT_FOUND":
          Toast.show("Email not registered.", context, duration: 2);
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
            },
          );
//          Toast.show("Please check your Internet connection.", context,duration: 2);
          break;
        case "ERROR_WRONG_PASSWORD":
          Toast.show("Invalid password.", context, duration: 2);
          break;
        default:
          Toast.show("Something went wrong", context, duration: 2);
          break;
      }
    }
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

  Future appleLogIn() async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.email); //A

          Firestore.instance
              .collection('users')
              .document(result.credential.user.toString())
              .setData({
            "email": result.credential.email ?? '',
            "name":
                '${result.credential.fullName.givenName} ${result.credential.fullName.familyName}',
            "firstname": '${result.credential.fullName.givenName}',
            "lastname": '${result.credential.fullName.familyName}',
            "image": '',
            "dob": '',
            "type": "Apple",
            "zip": "",
            "user_uuid": result.credential.user,
          }).then((value) async {
            print('user---------value>>>');
//            sharedPreferences.setBool(Constants.IS_RASH_DECISION_LOGIN, true);
//            sharedPreferences.setBool(Constants.IS_RASH_SOCIAL_LOGIN, true);
//            sharedPreferences.setString(Constants.LOGGED_IN_USER_ID,
//                result.credential.identityToken.toString());
            checkSubscription(result.credential.user, true);
          }).catchError((error) {
            _stopLoading();
            Toast.show('Unable to login, please try again later', context);
            print('Error------->>> ${error.toString()}');
          });

          break; // ll the required credentials
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
        default:
          Toast.show("Something went wrong", context, duration: 2);
          break;
      }
    }
  }
}

class Validator {
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
    } else {
      return true;
    }
  }
}
