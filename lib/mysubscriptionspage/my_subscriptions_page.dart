import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/home/home_page.dart';
import 'package:pinky_eye/subscriptionplans/consumables.dart';
import 'package:pinky_eye/subscriptionplans/subscription_plans_page.dart';
import 'package:pinky_eye/subscriptionplans/subscription_tile_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySubscriptionsPage extends StatefulWidget {
  final List<SubscriptionsPlan> othersList;
  final SubscriptionsPlan currentPlan;
  final SubscriptionData subscriptionData;

  const MySubscriptionsPage(
      {Key key, this.othersList, this.currentPlan, this.subscriptionData})
      : super(key: key);

  @override
  _MySubscriptionsPageState createState() => _MySubscriptionsPageState();
}

const List<String> _kProductIds = <String>[
  Constants.SUBSCRIPTION_PAY_AND_USE,
  Constants.SUBSCRIPTION_YEARLY,
];

class _MySubscriptionsPageState extends State<MySubscriptionsPage> {
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

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
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
    if (productDetailResponse.error != null) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'My Subscription',
              style: Styles.subscriptionTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15.0,
                color: Palette.white
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            SubscriptionTile(
              name: widget.currentPlan!=null ? widget.currentPlan.name : '',
              price: widget.currentPlan!=null ? widget.currentPlan.price : '',
              subsPlanColor: widget.currentPlan!=null ? widget.currentPlan.color : Colors.white,
              reviews: widget.currentPlan!=null ? widget.currentPlan.reviews : '',
              isSelected: false,
              isSelectionAvail: false,
            ),
            const SizedBox(
              height: 5.0,
            ),
            Visibility(
              visible: widget.currentPlan!=null ? widget.currentPlan.name != 'Yearly' : false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Subscription Options',
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Palette.white
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.othersList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              switch (widget.othersList[index].id) {
                                case 0:
                                  _updateDataToServer(
                                      'Free',
                                      '10',
                                      '',
                                      _getCurrentDate(DateTime.now()),
                                      'reviews',
                                      true);
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
//                                  for (int i = 0; i < _products.length; i++) {
//                                    if (_products[i].id ==
//                                        'com.rash.decision.app.monthly') {
//                                      _connection.buyNonConsumable(
//                                        purchaseParam: PurchaseParam(
//                                          productDetails: _products[i],
//                                          sandboxTesting: true,
//                                        ),
//                                      );
//                                      break;
//                                    }
//                                  }
                                  break;
                                case 3:
                                  for (int i = 0; i < _products.length; i++) {
                                    if (_products[i].id ==
                                        Constants.SUBSCRIPTION_YEARLY) {
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
                              }
                            },
                            child: SubscriptionTile(
                              name: widget.othersList[index].name,
                              price: widget.othersList[index].price,
                              subsPlanColor: widget.othersList[index].color,
                              reviews: widget.othersList[index].reviews,
                              isSelected: false,
                              isSelectionAvail: false,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
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
      _updateDataToServer(
          'Yearly',
          'unlimited',
          _getCurrentDate(expiryDate),
          _getCurrentDate(activationDate),
          'unlimited',
          widget.subscriptionData.isTrialUtilised);
    } else if (purchaseDetails.productID ==
        Constants.SUBSCRIPTION_PAY_AND_USE) {
      _updateDataToServer('Pay & Use', '3', '', _getCurrentDate(DateTime.now()),
          'reviews', widget.subscriptionData.isTrialUtilised);
    }
  }

  void handleError(IAPError error) {
    print('The IAPError is : ${error.details.toString()}');
    setState(() {
      _purchasePending = false;
    });
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
    setSharedPref().then((sharedPreferences) {
      Firestore.instance
          .collection('account_subscription')
          .document(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
          .setData({
        'plan_type': planType,
        'reviews_left': reviewsLeft,
        'reviews_taken': widget.subscriptionData.reviewsTaken,
        'active': 1,
        'expiry_date': expiryDate,
        'activation_date': activationDate,
        'activation_type': activationType,
        'is_trial_utilised': isTrialUtilised,
      }).then((_) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                settings: RouteSettings(name: AppRoutes.HOME_PAGE),
                builder: (BuildContext context) => HomePage(),
              ),
              (Route<dynamic> route) => false);
        }
      }).catchError((onError) {
        print("The error in subscription is : ${onError.toString()}");
      });
    });
  }
}
