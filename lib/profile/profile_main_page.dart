import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/drawer/app_drawer.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/home/home_page.dart';
import 'package:pinky_eye/home/eye_info_tile.dart';
import 'package:pinky_eye/mysubscriptionspage/my_subscriptions_page.dart';
import 'package:pinky_eye/profile/view_dependancy_page.dart';
import 'package:pinky_eye/subscriptionplans/subscription_plans_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileMainPage extends StatefulWidget {
  ProfileMainPage();

  static List<HistoryData> list = List();

  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

const List<String> _kProductIds = <String>[
  Constants.SUBSCRIPTION_PAY_AND_USE,
//  Constants.SUBSCRIPTION_YEARLY,
];

class _ProfileMainPageState extends State<ProfileMainPage>
    with SingleTickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  FirebaseUser currentLoggedUser;
  String fullName = '';
  String dob = '';
  final scaffoldKey2 =
      new GlobalKey<ScaffoldState>(debugLabel: 'profile_screen');

  Future<SharedPreferences> getSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  String currentLoggedUserId;
  String currentEmail = '';
  String currentName = '';
  String currentDob = '';
  String currentZip = '';
  String currentImage = '';

  TabController _tabController;
  List<SubscriptionsPlan> subsList = List();
  List<SubscriptionsPlan> othersList;
  SubscriptionsPlan currentPlan;
  SubscriptionData subscriptionData = SubscriptionData();

  @override
  void initState() {
    super.initState();
    subscriptionData = Provider.of<AppStateModel>(context, listen: false)
        .currentSubscriptionPackage;
    _tabController = new TabController(vsync: this, length:2);
    initStateDataSet();

    othersList = List();

    print("The subscriiption is : ${subscriptionData.planType}");
  }

  void initStateDataSet() async {
    final InAppPurchaseConnection _connection =
        InAppPurchaseConnection.instance;
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());

    subsList.add(
        SubscriptionsPlan(0, 'Free Trial', Palette.appBarBgColor, '0.00', '1'));
//    subsList.add(SubscriptionsPlan(
//        2, 'Monthly', Palette.buttonGreen, '9.99', 'Unlimited'));
    for (int i = 0; i < productDetailResponse.productDetails.length; i++) {
      if (productDetailResponse.productDetails[i].id ==
          Constants.SUBSCRIPTION_PAY_AND_USE) {
        subsList.add(SubscriptionsPlan(1, 'Pay and Use', Palette.orangeColor,
            productDetailResponse.productDetails[i].price, '3'));
      }
//      else if (productDetailResponse.productDetails[i].id ==
//          Constants.SUBSCRIPTION_YEARLY) {
//        subsList.add(SubscriptionsPlan(3, 'Yearly', Palette.redColor,
//            productDetailResponse.productDetails[i].price, 'Unlimited'));
//      }

      if (i == productDetailResponse.productDetails.length - 1) {
        switch (subscriptionData.planType) {
          case 'Free':
            currentPlan = subsList[0];
            break;
          case 'Pay & Use':
            currentPlan = subsList[1];
            break;
//          case 'Yearly':
//            currentPlan = subsList[2];
//            break;
        }
        for (int i = 0; i < subsList.length; i++) {
          if (subsList[i].id != currentPlan.id) {
            if (subscriptionData.isTrialUtilised) {
              if (subsList[i].id == 0) {
                continue;
              }
            }
            othersList.add(subsList[i]);
          }
        }

        print(
            "The current plan is : ${currentPlan.name} and others list size is : ${othersList.length}");
        setState(() {
          //refresh
        });
      }
    }

    if(productDetailResponse.productDetails.length == 0){
      switch (subscriptionData.planType) {
        case 'Free':
          currentPlan = subsList[0];
          break;
        case 'Pay & Use':
          currentPlan = subsList[1];
          break;
//        case 'The subscriiption isYearly':
//          currentPlan = subsList[2];
//          break;
      }
      for (int i = 0; i < subsList.length; i++) {
        if (subsList[i].id != currentPlan.id) {
          if (subscriptionData.isTrialUtilised) {
            if (subsList[i].id == 0) {
              continue;
            }
          }
          othersList.add(subsList[i]);
        }
      }

      print(
          "The current plan is : ${currentPlan.name} and others list size is : ${othersList.length}");
      setState(() {
        //refresh
      });
    }

    setSharedPref();
    getSharedPref().then((sharedPrefs) {
      _loadHistoryData(sharedPrefs);
      currentLoggedUserId = sharedPrefs.getString(Constants.LOGGED_IN_USER_ID);
      Firestore.instance
          .collection('users')
          .document(currentLoggedUserId)
          .snapshots()
          .listen((doc) {
        print("HERE I AM");
        if (doc.data != null) {
          if (this.mounted) {
            setState(() {
              currentEmail = doc.data['email'];
              currentName = doc.data['name'];
              currentDob = doc.data['dob'];
              currentZip = doc.data['zip'];
              currentImage = doc.data['image'];

              print('currentName-->> $currentName');
            });
          }
        }
      });
    });
    currentUser().then((user) {
      if (user == null) return;
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .get()
          .then((doc) {
        if (doc.data != null) {
          setState(() {
            currentLoggedUser = user;
          });
        }
      });
    });
  }

  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  void setSharedPref() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    subscriptionData =
        Provider.of<AppStateModel>(context).currentSubscriptionPackage;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'images/splash_bg.png',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Scaffold(
            key: scaffoldKey2,
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomPadding: false,
            drawer: AppDrawer(
              sharedPreferences: sharedPreferences,
            ),
            body: Builder(builder: (context) {
              return _getProfileMainLayout(context);
            }),
          )
        ],
      ),
    );
  }

  Widget _getActionBar(BuildContext context) {
    return Container(
      color: Palette.transparentColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 56.0,
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Image.asset(
                'images/sidebar_ic.png',
                height: 30,
                width: 30,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 56,
              child: Center(
                child: Text(
                  Constants.Profile,
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
            height: 56.0,
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Palette.white,
              ),
              onPressed: () {
                print("Edit profile clicked.");
                Navigator.of(context).pushNamed(AppRoutes.UPDATE_PROFILE);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProfileMainLayout(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Image.asset(
                    'images/profile_eye.png',
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: SizedBox(),
                  flex: 4,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                _getActionBar(context),
                _getProfileHeader(),
                Expanded(child: _getTabLayout()),
                const SizedBox(
                  height: 60.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTabLayout() {
    return Column(
      children: <Widget>[
        Container(
          color: Palette.tabBgTransparent,
          child: TabBar(
            tabs: [
              new Tab(
                child: Text(
                  "History",
                  textAlign: TextAlign.center,
                  style: Styles.tabsTextStyle,
                ),
              ),
//              new Tab(
//                child: Text(
//                  "View Dependent",
//                  textAlign: TextAlign.center,
//                  style: Styles.tabsTextStyle,
//                ),
//              ),
              new Tab(
                child: Text(
                  "My Subscriptions",
                  textAlign: TextAlign.center,
                  style: Styles.tabsTextStyle,
                ),
              ),
            ],
            controller: _tabController,
            indicatorColor: Colors.white,
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              Stack(
                children: <Widget>[
                  Image.asset(
                    'images/splash_bg.png',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
                  _bottomLayout(ProfileMainPage.list),
                ],
              ),
//              ViewDependencyPage(),
              Container(
                color: Palette.tabBg,
                child: MySubscriptionsPage(
                  currentPlan: currentPlan,
                  othersList: othersList,
                  subscriptionData: subscriptionData,
                ),
              ),
            ],
            controller: _tabController,
          ),
        ),
      ],
    );
  }

  Widget _getProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      width: MediaQuery.of(context).size.width,
      color: Palette.transparentColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(35.0),
              color: Colors.blueAccent,
              image: DecorationImage(
                image: (currentImage != null && currentImage.isNotEmpty)
                    ? NetworkImage(currentImage)
                    : AssetImage('images/profile_default.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Text(
            currentName,
            style: Styles.normalTextWithBoldTextStyle,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            currentEmail,
            style: Styles.extraSmallTextStyle,
          ),
        ],
      ),
    );
  }

  Widget nameWidget(List<String> names) {
    return Row(
      children: <Widget>[
        Expanded(
          child: tileLayout(
              tileTitle: 'First Name',
              tileChild: '${names.length > 0 ? names[0] ?? '' : ''}'),
        ),
        const SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: tileLayout(
              tileTitle: 'Last Name',
              tileChild: '${names.length > 1 ? names[1] ?? '' : ''}'),
        )
      ],
    );
  }

  Widget tileLayout({
    String tileTitle,
    String tileChild,
  }) {
    return Visibility(
      visible: tileChild?.isNotEmpty == true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            tileTitle,
            style: Styles.profileTileTitleTextStyle,
          ),
          Text(
            tileChild ?? '',
            style: Styles.profileTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _bottomLayout(List<HistoryData> infoList) {
    if (Provider.of<AppStateModel>(context).getHistoryEvent()) {
      Provider.of<AppStateModel>(context).setHistoryEvent(false);
      _loadHistoryData(sharedPreferences);
    }
    print(
        "_bottomLayout ===> infoList-->> ${ProfileMainPage.list.length} && ${Constants.IS_BACK}");

    Widget _screen = SizedBox();
    String dateTime = Provider.of<AppStateModel>(context).deleteCurrentEntry;
    //  print('deleteCurrentEntry 333333');
    print("HELLO ===> infoList-->> $dateTime");
    for (int i = 0; i < ProfileMainPage.list.length; i++) {
      print("HELLO ===> $dateTime &&& ${ProfileMainPage.list[i].timeStamp}");
      if (ProfileMainPage.list[i].timeStamp == dateTime) {
//        setState(() {
        ProfileMainPage.list.remove(ProfileMainPage.list[i]);
        print(
            "after removed ===> infoList-->> ${infoList.length} && homeList ${ProfileMainPage.list.length}");
//        });
        break;
      }
    }
    if (ProfileMainPage.list?.isNotEmpty == true) {
      print('currentName --->> ${currentName}');
      _screen = ListView.builder(
        itemCount: ProfileMainPage.list.length,
        itemBuilder: (context, index) {
          print(
              'infoList ${ProfileMainPage.list.length}  && index ${index} && rash name: ${ProfileMainPage.list[index].diseases.name}');
          print('is activer or not ${ProfileMainPage.list[index].active}');
          if (ProfileMainPage.list[index].active) {
            return EyeInfoTile(
              diseases: ProfileMainPage.list[index].diseases,
              imageUrl: ProfileMainPage.list[index].imageUrl,
              dateTime: ProfileMainPage.list[index].timeStamp,
//              rashName: ProfileMainPage.list[index].dependentName,
//              dependentName: ProfileMainPage.list[index].dependentName == 'Me'
//                  ? currentName
//                  : ProfileMainPage.list[index].dependentName,
              imagePath: ProfileMainPage.list[index].imagePath,
              isOpened: ProfileMainPage.list[index].isOpened,
              cancer: ProfileMainPage.list[index].cancer,
              diseasesName: ProfileMainPage.list[index].diseasesName,
            );
          } else {
            return SizedBox();
          }
        },
      );
    } else {
      _screen = Container(
        width: Constants.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/no_history.png',
              width: Constants.screenWidth * 0.3,
              height: Constants.screenWidth * 0.3,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              Constants.NO_HISTORY,
              style: Styles.rashTileSmallTextStyle,
            ),
          ],
        ),
      );
    }
    return _screen;
  }

  void _loadHistoryData(SharedPreferences sharedPreferences) {
    Firestore.instance
        .collection('disease')
        .document(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .collection(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .orderBy('date_time', descending: true)
        .getDocuments()
        .then((docs) {
      ProfileMainPage.list = List();
      print(
          "HELLLOOOOO ===> main ==> ${docs.documents.length} and constant ${Constants.diseaseList.length}");
      for (int i = 0; i < docs.documents.length; i++) {
        for (int j = 0; j < Constants.diseaseList.length; j++) {
          print("The data is : ${docs.documents[i].data}");
          if (docs.documents[i].data['id'] == Constants.diseaseList[j].id) {
            print(
                "HELLLOOOOO ===> active  ==>  ${docs.documents[i].data['active']}");
            if (docs.documents[i].data['active'] != null) {
              if (docs.documents[i].data['active']) {
                ProfileMainPage.list.add(HistoryData(
                  diseases: Constants.diseaseList[j],
//                  dependentName: docs.documents[i].data['dependent'],
                  imageUrl: docs.documents[i].data['image_url'],
                  timeStamp: docs.documents[i].data['date_time'],
                  imagePath: docs.documents[i].data['image_path'],
                  active: docs.documents[i].data['active'],
                  isOpened: docs.documents[i].data['is_opened'],
                  cancer: docs.documents[i].data['cancer'],
                  diseasesName: docs.documents[i].data['diseasesName'],
                ));
              }
            }
            break;
          }
        }

        if (i == docs.documents.length - 1) {
          print(
              "HELLLOOOOO ===> last ==> ${i} && ${docs.documents.length}");
          if (mounted) {
            setState(() {
              //just a refresh for data
            });
          }
        }
      }
    });
  }
}
