import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:pinky_eye/home/home_page.dart';

class AppStateModel extends ChangeNotifier {
  final BuildContext context;

  AppStateModel(this.context);

  int currentDeletedId = -1;
  String currentDeletedDateTime = "";
  String currentDependencyListChanged = '';
  bool dependencyAdded = false;
  bool history = false;

  SubscriptionData currentSubscriptionData = SubscriptionData();

  set currentSubscriptionPackage(SubscriptionData subscriptionData) {
    this.currentSubscriptionData = subscriptionData;
    notifyListeners();
  }

  get currentSubscriptionPackage {
    return currentSubscriptionData;
  }

  set deleteCurrentEntry(String dateTime) {
    // print('deleteCurrentEntry ${dateTime}');
    currentDeletedDateTime = dateTime;
    notifyListeners();
  }

  get deleteCurrentEntry {
    return currentDeletedDateTime;
  }

  set currentDependencyListChangedEvent(String value) {
    currentDependencyListChanged = value;
    notifyListeners();
  }

  get currentDependencyListChangedEvent {
    return currentDependencyListChanged;
  }

  void setDependencyAddedEvent(bool added) {
    dependencyAdded = added;
    notifyListeners();
  }

  bool getDependencyAddedEvent() {
    return dependencyAdded;
  }

  void setHistoryEvent(bool added) {
    history = added;
    notifyListeners();
  }

  bool getHistoryEvent() {
    return history;
  }

  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
