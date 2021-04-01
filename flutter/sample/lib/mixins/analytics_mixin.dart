import 'package:flutter/material.dart';

mixin AnalyticsMixin implements RouteAware {
  @override
  void didPush() {
    sendCurrentTabToAnalytics();
  }

  @override
  void didPop() {
    sendCurrentTabToAnalytics();
  }

  @override
  void didPushNext() {
    sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    sendCurrentTabToAnalytics();
  }

  void sendCurrentTabToAnalytics() {
    // firebase.observer.analytics.setCurrentScreen(
    //   screenName: '${getCurrentRoute()}?tab=${getCurrentTab()}',
    // );
  }

  String getCurrentRoute();

  int getCurrentTab();
}
