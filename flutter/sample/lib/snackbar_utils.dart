import 'package:flutter/material.dart';

class SnackBarUtils {
  static void showSnackBar(BuildContext context, String message,
      {bool dismissable = false}) {
    final snackBar = SnackBar(
      content: Text(
        message ?? '',
        style: TextStyle(fontFamily: 'Shabnam'),
      ),
      action: dismissable != true
          ? null
          : SnackBarAction(
              label: 'باشه',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
