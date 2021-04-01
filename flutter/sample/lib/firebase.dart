// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:novinpay/services/platform_helper.dart';

// FirebaseAnalyticsObserver _observer;
// final analytics = FirebaseAnalytics();
// final messaging = FirebaseMessaging();

// FirebaseAnalyticsObserver get observer {
//   if (_observer == null) {
//     final observer = FirebaseAnalyticsObserver(analytics: analytics);
//     _observer = observer;
//   }

//   return _observer;
// }

// Future<String> getFirebaseToken() async {
//   await Firebase.initializeApp();

//   if (getPlatform() == PlatformType.web) {
//     return null;
//   }

//   final token = await messaging.getToken();

//   return token;
// }
