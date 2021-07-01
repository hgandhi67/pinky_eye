import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/home/home_page.dart';
import 'package:pinky_eye/subscriptionplans/consumables.dart';
import 'package:pinky_eye/subscriptionplans/subscription_tile_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SubscriptionsPage extends StatefulWidget {
  final bool isRashLogin;
  final bool isRashSocialLogin;
  final String loggedInUserId;
  final bool isTrialUtilised;
  final String reviewsTaken;
  final int subsPageFrom;

  const SubscriptionsPage({
    Key key,
    this.isRashLogin,
    this.isRashSocialLogin,
    this.loggedInUserId,
    this.isTrialUtilised,
    this.reviewsTaken,
    @required this.subsPageFrom,
  }) : super(key: key);

  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

const List<String> _kProductIds = <String>[
  Constants.SUBSCRIPTION_PAY_AND_USE,
//  Constants.SUBSCRIPTION_YEARLY,
];

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  static int selectedIndex = -1;
  List<SubscriptionsPlan> subsList = List();

  SharedPreferences sharedPreferences;

  //inapp
  final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = [];
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  List<String> _consumables = [];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String _queryProductError;

  SubscriptionData subscriptionsPlan;

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    subsList.add(
        SubscriptionsPlan(0, 'Free Trial', Palette.appBarBgColor, '0.00', '10'));
    print("The connection avaiability => : $isAvailable");
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = [];
        _purchases = [];
        _notFoundIds = [];
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
//    subsList.add(SubscriptionsPlan(
//        2, 'Monthly', Palette.buttonGreen, '9.99', 'Unlimited'));
    for (int i = 0; i < productDetailResponse.productDetails.length; i++) {
      if (productDetailResponse.productDetails[i].id ==
          Constants.SUBSCRIPTION_PAY_AND_USE) {
        subsList.add(SubscriptionsPlan(1, 'Pay and Use', Palette.orangeColor,
            productDetailResponse.productDetails[i].price, '3'));
        continue;
      }
//      else if (productDetailResponse.productDetails[i].id ==
//          Constants.SUBSCRIPTION_YEARLY) {
//        subsList.add(SubscriptionsPlan(3, 'Yearly', Palette.redColor,
//            productDetailResponse.productDetails[i].price, 'Unlimited'));
//        continue;
//      }

      if (i == productDetailResponse.productDetails.length - 1) {
        setState(() {
          //refresh
        });
      }
    }

    if (productDetailResponse.error != null) {
      subscriptionsPlan = Provider.of<AppStateModel>(context, listen: false)
          .currentSubscriptionPackage;

      setState(() {
        _queryProductError = productDetailResponse.error.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });

      return;
    }

    print("The sublist length is : ${subsList.length}");
    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = [];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _consumables = [];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final QueryPurchaseDetailsResponse purchaseResponse =
        await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      print("HERE => 2 : The error is : ${purchaseResponse.error.toString()}");
    }
    final List<PurchaseDetails> verifiedPurchases = [];
    for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
      if (await _verifyPurchase(purchase)) {
        if (Platform.isAndroid) {
          print("HEREEEEEEEEEEEEEEEEEEEE : ${purchase.productID}");
          if (purchase.productID == Constants.SUBSCRIPTION_PAY_AND_USE) {
            print("HEREEEEEEEEEEEEEEEEEEEE");
            await InAppPurchaseConnection.instance.consumePurchase(purchase);
          }
        }
        verifiedPurchases.add(purchase);
      }
    }
    List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _purchases = verifiedPurchases;
      _notFoundIds = productDetailResponse.notFoundIDs;
      _consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      print("HERE => 1 : The error is : ${error.toString()}");
    });
    initStoreInfo();

    super.initState();
  }

  String _getCurrentDate(DateTime dateTime) {
    final f = new DateFormat('dd-MM-yyyy');
    return f.format(dateTime);
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  void _updateDataToServer(
    String planType,
    String reviewsLeft,
    String expiryDate,
    String activationDate,
    String activationType,
    bool isTrialUtilised,
  ) {
    Firestore.instance
        .collection('account_subscription')
        .document(widget.loggedInUserId)
        .setData({
      'plan_type': planType,
      'reviews_left': reviewsLeft,
      'reviews_taken': widget.reviewsTaken,
      'active': 1,
      'expiry_date': expiryDate,
      'activation_date': activationDate,
      'activation_type': activationType,
      'is_trial_utilised': isTrialUtilised,
    }).then((_) {
      Provider.of<AppStateModel>(context, listen: false)
          .currentSubscriptionPackage = new SubscriptionData(
        active: 1,
        activationDate: activationDate,
        activationType: activationType,
        expiryDate: expiryDate,
        isTrialUtilised: isTrialUtilised,
        planType: planType,
        reviewsLeft: reviewsLeft,
        reviewsTaken: widget.reviewsTaken,
      );

      setSharedPref().then((sharedPreferences) {
        sharedPreferences.setBool(
            Constants.IS_PINKY_EYE_LOGIN, widget.isRashLogin);
        sharedPreferences.setBool(
            Constants.IS_PINKY_SOCIAL_LOGIN, widget.isRashSocialLogin);
        sharedPreferences.setString(
            Constants.LOGGED_IN_USER_ID, widget.loggedInUserId);

        if (mounted) {
          if (widget.subsPageFrom == 0) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute<void>(
                  settings: RouteSettings(name: AppRoutes.HOME_PAGE),
                  builder: (BuildContext context) => HomePage(),
                ),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context)
                .popUntil((r) => r.settings.name == 'HomePage');
          }
        }
      });
    }).catchError((onError) {
      print("The error in subscription is : ${onError.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Image.asset(
            'images/splash_bg.png',
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          _getSubscriptionLayout(),
        ],
      ),
    );
  }

  Widget _getSubscriptionLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        width: Constants.screenWidth * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: Constants.screenHeight * 0.10,
            ),
            Text(
              Constants.SUBSCRIPTION_PLANS,
              style: Styles.mediumTextStyle,
            ),
            SizedBox(
              height: Constants.screenHeight * 0.01,
            ),
            Text(
              Constants.CHOOSE_PLAN,
              style: Styles.smallTextStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: Constants.screenHeight * 0.05,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: subsList.length,
              itemBuilder: (context, index) {
//                if (widget.isTrialUtilised != null && widget.isTrialUtilised) {
//                  if (index == 0) {
//                    if (selectedIndex == 0) {
//                      selectedIndex = -1;
//                    }
//                    return Opacity(
//                      opacity: 0.8,
//                      child: SubscriptionTile(
//                        isSelected: false,
//                        isSelectionAvail: false,
//                        name: subsList[index].name,
//                        price: subsList[index].price,
//                        reviews: subsList[index].reviews,
//                        subsPlanColor: subsList[index].color,
//                      ),
//                    );
//                  }
//                }
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: SubscriptionTile(
                    isSelected: selectedIndex == index,
                    isSelectionAvail: true,
                    name: subsList[index].name,
                    price: subsList[index].price,
                    reviews: subsList[index].reviews,
                    subsPlanColor: subsList[index].color,
                  ),
                );
              },
            ),
            SizedBox(
              height: Constants.screenHeight * 0.03,
            ),
            MaterialButton(
              onPressed: () {
                print("The selected index is : $selectedIndex");
                if (selectedIndex == -1) {
                  Toast.show('Please select a plan to continue.', context);
                  return;
                }
                SubscriptionsPlan selectedPlan = subsList[selectedIndex];
                switch (selectedPlan.id) {
                  case 0:
                    _updateDataToServer('Free', '10', '',
                        _getCurrentDate(DateTime.now()), 'reviews', true);
                    break;
                  case 1:
                    for (int i = 0; i < _products.length; i++) {
                      if (_products[i].id ==
                          Constants.SUBSCRIPTION_PAY_AND_USE) {
                        _connection.buyNonConsumable(
                          purchaseParam: PurchaseParam(
                            productDetails: _products[i],
                            sandboxTesting: true,
                          ),
                        );
                        break;
                      }
                    }
                    break;
                  case 2:
//                  for (int i = 0; i < _products.length; i++) {
//                    if (_products[i].id == 'com.data245.pinkyeye.app.monthly') {
//                      _connection.buyNonConsumable(
//                        purchaseParam: PurchaseParam(
//                          productDetails: _products[i],
//                          sandboxTesting: true,
//                        ),
//                      );
//                      break;
//                    }
//                  }
                    break;
                  case 3:
//                    for (int i = 0; i < _products.length; i++) {
//                      if (_products[i].id == Constants.SUBSCRIPTION_YEARLY) {
//                        _connection.buyNonConsumable(
//                          purchaseParam: PurchaseParam(
//                            productDetails: _products[i],
//                            sandboxTesting: true,
//                          ),
//                        );
//                        break;
//                      }
//                    }
                    break;
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Text(
                'Continue',
                style: Styles.subscriptionTextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Palette.darkButtonTextColor,
                ),
              ),
              minWidth: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15.0),
              color: Palette.buttonOffWhite,
            ),
            SizedBox(
              height: Constants.screenHeight * 0.03,
            ),
            Visibility(
              visible: subscriptionsPlan != null
                  ? subscriptionsPlan.planType != '' ? true : false
                  : true,
              child: GestureDetector(
                onTap: () {
                  setSharedPref().then((sharedPreferences) {
                    sharedPreferences.setBool(
                        Constants.IS_PINKY_EYE_LOGIN, widget.isRashLogin);
                    sharedPreferences.setBool(Constants.IS_PINKY_SOCIAL_LOGIN,
                        widget.isRashSocialLogin);
                    sharedPreferences.setString(
                        Constants.LOGGED_IN_USER_ID, widget.loggedInUserId);

                    if (mounted) {
                      if (widget.subsPageFrom == 0) {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(
                              settings:
                                  RouteSettings(name: AppRoutes.HOME_PAGE),
                              builder: (BuildContext context) => HomePage(),
                            ),
                            (Route<dynamic> route) => false);
                      } else {
                        Navigator.of(context)
                            .popUntil((r) => r.settings.name == 'HomePage');
                      }
                    }
                  });
                },
                child: Text(
                  "Skip",
                  style: Styles.rashNormalTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    print("The purchase is invalid : ${purchaseDetails.productID}");
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        if (Platform.isAndroid) {
          print("HEREEEEEEEEEEEEEEEEEEEE : ${purchaseDetails.productID}");
          if (purchaseDetails.productID == Constants.SUBSCRIPTION_PAY_AND_USE) {
            print("HEREEEEEEEEEEEEEEEEEEEE");
            await InAppPurchaseConnection.instance
                .consumePurchase(purchaseDetails);
          }
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchaseConnection.instance
              .completePurchase(purchaseDetails);
        }
      }
    });
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    print("The purchase was successful with id : ${purchaseDetails.productID}");

    if (purchaseDetails.productID == Constants.SUBSCRIPTION_YEARLY) {
      DateTime activationDate = DateTime.fromMillisecondsSinceEpoch(
          int.parse(purchaseDetails.transactionDate));
      DateTime expiryDate = DateTime(
          activationDate.year + 1, activationDate.month, activationDate.day);
      _updateDataToServer('Yearly', 'unlimited', _getCurrentDate(expiryDate),
          _getCurrentDate(activationDate), 'unlimited', widget.isTrialUtilised);
    } else if (purchaseDetails.productID ==
        Constants.SUBSCRIPTION_PAY_AND_USE) {
      _updateDataToServer('Pay & Use', '3', '', _getCurrentDate(DateTime.now()),
          'reviews', widget.isTrialUtilised);
    }
  }

  void handleError(IAPError error) {
    print('The IAPError is : ${error.details.toString()}');
    setState(() {
      _purchasePending = false;
    });
  }
}

class SubscriptionsPlan {
  final int id;
  final String name;
  final Color color;
  final String price;
  final String reviews;

  SubscriptionsPlan(this.id, this.name, this.color, this.price, this.reviews);
}
