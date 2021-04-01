import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/utils.dart';

class ToastUtils {
  static Timer toastTimer;

  static void showCustomToast(BuildContext context, String message,
      [Widget icon, String title]) {
    CustomSnackBar.showCustomSnackBar(
      context,
      title,
      message,
    );
  }
}

class CustomSnackBar {
  static void showCustomSnackBar(
      BuildContext context, String title, String message,
      [Widget icon]) {
    Get.snackbar(
      title ?? 'پیغام',
      '',
      icon: icon ?? Container(),
      backgroundColor: colors.greyColor.shade50,
      borderRadius: 8,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), //
          // changes position of shadow
        ),
      ],
      duration: Duration(seconds: 7),
      margin: EdgeInsets.all(16),
      shouldIconPulse: false,
      messageText: Container(
        child: Text(
          '$rlm$message$rlm' ?? '',
          textAlign: TextAlign.start,
        ),
        padding: EdgeInsets.only(left: 16, right: 0),
      ),
    );
  }
}
