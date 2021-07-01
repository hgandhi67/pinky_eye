import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinky_eye/base/AppStateModel.dart';
import 'package:pinky_eye/base/constants.dart';
import 'package:pinky_eye/base/routes.dart';
import 'package:pinky_eye/base/theme/palette.dart';
import 'package:pinky_eye/base/theme/styles.dart';
import 'package:pinky_eye/profile/models/user_dependency_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ViewDependencyPage extends StatefulWidget {
  @override
  _ViewDependencyPageState createState() => _ViewDependencyPageState();
}

class _ViewDependencyPageState extends State<ViewDependencyPage> {
  List<UserDependency> dependencyList = List();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setSharedPref().then((sharedPrefs) {
      _loadDependencies(sharedPrefs);
    });
  }

  Future<SharedPreferences> setSharedPref() async {
    return await SharedPreferences.getInstance();
  }

  void _loadDependencies(SharedPreferences sharedPreferences) async {
    dependencyList.clear();
    Firestore.instance
        .collection('dependency')
        .document(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .collection(sharedPreferences.getString(Constants.LOGGED_IN_USER_ID))
        .getDocuments()
        .then((docs) {
      if (docs.documents.length == 0) {
        setState(() {
          isLoading = false;
        });
      } else {
        docs.documents.forEach((singleDoc) {
          dependencyList.add(
            UserDependency(
              singleDoc.data['first_name'],
              singleDoc.data['last_name'],
              singleDoc.data['dob'],
              singleDoc.data['relation'],
              singleDoc.documentID,
            ),
          );

          if (dependencyList.length == docs.documents.length) {
            setState(() {
              isLoading = false;
            });
          }
        });
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      Toast.show('Error loading data', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<AppStateModel>(context).getDependencyAddedEvent()) {
      print('WE ARE HERE<<<<<');
      setSharedPref().then((sharedPref) {
        _loadDependencies(sharedPref);
        Provider.of<AppStateModel>(context).setDependencyAddedEvent(false);
      });
    }
    return Scaffold(
      backgroundColor: Palette.tabBg,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: dependencyList.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return DependencyItem(
                    name:
                        '${dependencyList[i].firstName ?? ''} ${dependencyList[i].lastName ?? ''}',
                    dob: dependencyList[i].dob,
                    relation: dependencyList[i].relation,
                    onEdit: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.UPDATE_DEPENDENCY,
                        arguments: {
                          AppRouteArgKeys.DEPENDENCY_FIRST_NAME:
                              dependencyList[i].firstName ?? '',
                          AppRouteArgKeys.DEPENDENCY_LAST_NAME:
                              dependencyList[i].lastName ?? '',
                          AppRouteArgKeys.DEPENDENCY_DOB: dependencyList[i].dob,
                          AppRouteArgKeys.DEPENDENCY_RELATION:
                              dependencyList[i].relation,
                          AppRouteArgKeys.DEPENDENCY_NAME:
                              dependencyList[i].docName,
                        },
                      );
                    },
                    onDelete: () {
                      print("HEllo");
                      _showDeleteDialog(context, i);
                    },
                  );
                },
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.ADD_DEPENDENCY,
                  arguments: {
                    AppRouteArgKeys.DEPENDENCY_ROUTE_TYPE: 1,
                    AppRouteArgKeys.DEPENDENCY_IMAGE_FILE: null,
                  },
                );
              },
              minWidth: MediaQuery.of(context).size.width * 0.7,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Palette.subscriptionBgColor,
              child: Text(
                'Add a New Dependent',
                style: Styles.subscriptionTextStyle(
                  fontSize: 16.0,
                  color: Palette.white,
                ),
              ),
            ),
            const SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int pos) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              top: 15.0,
              right: 8.0,
              left: 8.0,
              bottom: 12.0,
            ),
            width: Constants.screenWidth * 0.8,
            decoration: BoxDecoration(
              color: Palette.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Do you really want to delete this dependent?',
                    textAlign: TextAlign.center,
                    style: Styles.subscriptionTextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            setSharedPref().then((sharedPrefs) {
                              Firestore.instance
                                  .collection('dependency')
                                  .document(sharedPrefs
                                      .getString(Constants.LOGGED_IN_USER_ID))
                                  .collection(sharedPrefs
                                      .getString(Constants.LOGGED_IN_USER_ID))
                                  .document(
                                    dependencyList[pos].docName,
                                  )
                                  .delete()
                                  .then((_) {
                                setState(() {
                                  dependencyList.removeAt(pos);
                                  Navigator.of(context).pop();
                                });
                              });
                            });
                          },
                          child: Text(
                            'Yes',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.white,
                              fontSize: 16.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          color: Palette.subscriptionBgColor,
                        ),
                      ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      Expanded(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: Styles.subscriptionTextStyle(
                              color: Palette.white,
                              fontSize: 16.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          color: Palette.lightRedColor,
                        ),
                      )
                    ],
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

class DependencyItem extends StatefulWidget {
  final String name;
  final String dob;
  final String relation;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  DependencyItem({
    Key key,
    @required this.name,
    @required this.dob,
    @required this.relation,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  _DependencyItemState createState() => _DependencyItemState();
}

class _DependencyItemState extends State<DependencyItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 15.0,
            top: 15.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: Styles.workSans600(
                        color: Palette.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      'DOB: ${widget.dob}',
                      style: Styles.workSans500(
                        color: Palette.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Palette.lightRedColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        widget.relation,
                        style: Styles.workSans500(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Palette.grey6,
                  child: Icon(
                    Icons.edit,
                    color: Palette.iconColor,
                    size: 20,
                  ),
                ),
                onTap: () => widget.onEdit(),
              ),
              const SizedBox(
                width: 8.0,
              ),
              GestureDetector(
                child: CircleAvatar(
                  backgroundColor: Palette.grey6,
                  radius: 18,
                  child: Icon(
                    Icons.delete,
                    color: Palette.iconColor,
                    size: 20,
                  ),
                ),
                onTap: () => widget.onDelete(),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.grey[100],
          height: 1,
          margin: EdgeInsets.only(
            top: 10.0,
          ),
        ),
      ],
    );
  }
}
