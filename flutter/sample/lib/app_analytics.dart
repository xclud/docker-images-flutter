import 'package:flutter/material.dart';

void sendNetworkLogEvent({@required String name, @required int statusCode}) {
  // firebase.observer.analytics
  //     .logEvent(name: name, parameters: {'statusCode': statusCode});
}

void logAppOpen() {
  // firebase.analytics.logAppOpen();
}

void logSignUp({@required String signUpMethod}) {
  // firebase.analytics.logSignUp(signUpMethod: signUpMethod);
}

void logShare(
    {@required String contentType, @required itemId, @required method}) {
  // firebase.analytics
  //     .logShare(contentType: contentType, itemId: itemId, method: method);
}

void logAddPass({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'add_pass', parameters: {'phoneNumber': phoneNumber});
}

void logRemovePass({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'remove_pass', parameters: {'phoneNumber': phoneNumber});
}

void logChangePass({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'change_pass', parameters: {'phoneNumber': phoneNumber});
}

void logPassType({@required String phoneNumber, @required String type}) {
  // firebase.analytics.logEvent(
  //     name: 'pass_type',
  //     parameters: {'phoneNumber': phoneNumber, 'type': type});
}

void logLock({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'lock', parameters: {'phoneNumber': phoneNumber});
}

void logUnlock({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'unlock', parameters: {'phoneNumber': phoneNumber});
}

void logForgetPass({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'forget_pass', parameters: {'phoneNumber': phoneNumber});
}

void logLogin({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'login', parameters: {'phoneNumber': phoneNumber});
}

void logLogout({@required String phoneNumber}) {
  // firebase.analytics
  //     .logEvent(name: 'logout', parameters: {'phoneNumber': phoneNumber});
}

void setUserProperty({@required String name, @required String value}) {
  // firebase.analytics.setUserProperty(name: name, value: value);
}

void setAgeUserProperty({@required String value}) {
  setUserProperty(name: 'sun_age', value: value);
}

void setProvinceUserProperty({@required String value}) {
  setUserProperty(name: 'sun_province', value: value);
}

void setCityUserProperty({@required String value}) {
  setUserProperty(name: 'sun_city', value: value);
}
