import 'package:flutter/material.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBarWidget {
  static const double _titleSpacing = -5;
  static const double _popupMenuOffset = 56;

  static Widget getAppBarWidgetWithLeading({
    BuildContext context,
    String appBarTitle,
    VoidCallback onTap,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      titleSpacing: _titleSpacing,
      elevation: 0,
      leading: IconButton(
        padding: const EdgeInsets.all(0),
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () => onTap == null ? Navigator.of(context).pop() : onTap(),
      ),
      title: Text(appBarTitle),
    );
  }

  static Widget getAppBarWidgetWithPopupMenu({
    BuildContext context,
    String appBarTitle,
    Color bgColor: Palette.appBarBgColor,
    bool isEditMenuAvailable: false,
    @required bool centerTitle,
    @required SharedPreferences sharedPreferences,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: centerTitle,
      title: Text(appBarTitle),
      leading: IconButton(
        onPressed: () => scaffoldKey.currentState.openDrawer(),
        icon: Image.asset(
          'images/sidebar_ic.png',
          height: 30,
          width: 30,
        ),
      ),
      actions: <Widget>[
        Visibility(
          visible: isEditMenuAvailable,
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              print("Edit profile clicked.");
              Navigator.of(context).pushNamed(AppRoutes.UPDATE_PROFILE);
            },
          ),
        ),
//        PopupMenuButton<String>(
//          onSelected: (selectedOption) {
//            switch (selectedOption) {
//              case 'About Us':
//                Navigator.of(context).pushNamed(AppRoutes.ABOUT_US);
//                break;
//              case 'Profile':
//                Navigator.of(context).pushNamed(AppRoutes.PROFILE_MAIN);
//                break;
//              case 'Logout':
//                print('logoutttt');
//                sharedPreferences.setBool(
//                    Constants.IS_RASH_DECISION_LOGIN, false);
//                sharedPreferences.setString(Constants.LOGGED_IN_USER_ID, null);
//                HomePage.list = List();
//                Provider.of<AppStateModel>(context).deleteCurrentEntry = "";
//                Navigator.of(context).pushNamedAndRemoveUntil(
//                    AppRoutes.SIGN_IN, (Route<dynamic> route) => false);
//                break;
//            }
//          },
//          offset: Offset(
//            _popupMenuOffset,
//            _popupMenuOffset,
//          ),
//          elevation: 5,
//          itemBuilder: (BuildContext context) {
//            return Constants.choices.map((String choice) {
//              return PopupMenuItem<String>(
//                value: choice,
//                child: Text(choice),
//              );
//            }).toList();
//          },
//        ),
      ],
    );
  }
}
