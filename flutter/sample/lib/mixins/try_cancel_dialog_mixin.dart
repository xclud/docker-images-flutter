import 'package:flutter/material.dart';

mixin TryCancelDialogMixin<T extends StatefulWidget> on State<T> {
  Future<bool> showTryCancelDialog({
    Widget title,
    Widget content,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('تلاش دوباره'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('انصراف'),
          ),
        ],
      ),
    );
  }
}
