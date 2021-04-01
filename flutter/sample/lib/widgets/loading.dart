import 'package:flutter/material.dart';
import 'package:novinpay/widgets/general/general.dart';

class Loading {
  static void _show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Widget loading = Center(
          child: Card(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Space(2),
                  CircularProgressIndicator(),
                  Space(2),
                  // Space(count: 4),
                  // Text('...لطفا شکیبا باشید')
                ],
              ),
            ),
          ),
        );

        return loading;
      },
    );
  }

  static Future<T> run<T>(BuildContext context, Future<T> future) async {
    assert(future != null);
    _show(context);
    final result = await future;
    try {
      _hide(context);
    } catch (exp) {
      //
    }

    return result;
  }

  static void _hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
