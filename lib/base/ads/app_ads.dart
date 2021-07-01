import 'dart:io';

import 'package:ads/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AppAds {
  static Ads ads;

  static final String appId = Platform.isAndroid
      ? 'ca-app-pub-5252835281622410~6140187466'
      : 'ca-app-pub-5252835281622410~8484167825';

  static final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-5252835281622410/4443962417'
      : 'ca-app-pub-5252835281622410/2233620098';

  static final String screenUnitId = Platform.isAndroid
      ? 'ca-app-pub-5252835281622410/8000064048'
      : 'ca-app-pub-5252835281622410/2747737365';

  static void showBanner({
    String adUnitId,
    AdSize size,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    MobileAdListener listener,
    State state,
    double anchorOffset,
    AnchorType anchorType,
  }) {
    ads?.showBannerAd(
      adUnitId: adUnitId,
      size: size,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
      listener: listener,
      state: state,
      anchorOffset: anchorOffset,
      anchorType: anchorType,
    )?.then((show){
      print("The banner is : $show");
    });
  }

  static void showScreenAds({
    String adUnitId,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    MobileAdListener listener,
    State state,
    double anchorOffset,
    AnchorType anchorType,
  }) =>
      ads?.showFullScreenAd(
          adUnitId: adUnitId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
          listener: listener,
          state: state,
          anchorType: anchorType,
          anchorOffset: anchorOffset);

  static void hideBanner() => ads?.closeBannerAd();

  static void hideFullScreen() => ads?.closeFullScreenAd();

  /// Call this static function in your State object's initState() function.
  static void init() => ads ??= Ads(
        appId,
        bannerUnitId: bannerUnitId,
        screenUnitId: screenUnitId,
        childDirected: true,
        testDevices: ['b6d79e84'],
        testing: false,
      );

  /// Remember to call this in the State object's dispose() function.
  static void dispose() => ads?.dispose();

  static MobileAdListener bannerListener = (MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        print("BANNER:===> An ad has loaded successfully in memory.");
        break;
      case MobileAdEvent.failedToLoad:
        print("BANNER:===> The ad failed to load into memory.");
        break;
      case MobileAdEvent.clicked:
        print("BANNER:===> The opened ad was clicked on.");
        break;
      case MobileAdEvent.impression:
        print(
            "BANNER:===> The user is still looking at the ad. A new ad came up.");
        break;
      case MobileAdEvent.opened:
        print("BANNER:===> The ad is now open.");
        break;
      case MobileAdEvent.leftApplication:
        print("BANNER:===> You've left the app after clicking the Ad.");
        break;
      case MobileAdEvent.closed:
        print("BANNER:===> You've closed the Ad and returned to the app.");
        break;
      default:
        print("BANNER:===> There's a 'new' MobileAdEvent?!");
    }
  };

  static MobileAdListener screenListener = (MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        print("FULLSCREEN ====> An ad has loaded successfully in memory.");
        break;
      case MobileAdEvent.failedToLoad:
        print("FULLSCREEN ====> The ad failed to load into memory.");
        break;
      case MobileAdEvent.clicked:
        print("FULLSCREEN ====> The opened ad was clicked on.");
        break;
      case MobileAdEvent.impression:
        print(
            "FULLSCREEN ====> The user is still looking at the ad. A new ad came up.");
        break;
      case MobileAdEvent.opened:
//        hideBanner();
        print("FULLSCREEN ====> The ad is now open.");
        break;
      case MobileAdEvent.leftApplication:
        print("FULLSCREEN ====> You've left the app after clicking the Ad.");
        break;
      case MobileAdEvent.closed:
//        showBanner(
//            anchorType: AnchorType.bottom,
//            childDirected: true,
//            listener: AppAds.bannerListener,
//            size: AdSize.fullBanner);
        print("FULLSCREEN ====> You've closed the Ad and returned to the app.");
        break;
      default:
        print("FULLSCREEN ====> There's a 'new' MobileAdEvent?!");
    }
  };
}
