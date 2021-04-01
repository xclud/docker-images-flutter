import 'package:flutter/material.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';

mixin AccountSelection<T extends StatefulWidget> on MruSelectionMixin<T> {
  Future<MruItem> showSourceAccountSelectionDialog({
    Widget title = const Text('حساب های من'),
  }) =>
      showMruSelectionDialog(
        mru: MruType.sourceAccount,
        title: title,
      );

  Future<MruItem> showDestinationAccountSelectionDialog({
    Widget title = const Text('حساب های مقصد'),
  }) =>
      showMruSelectionDialog(
        mru: MruType.destinationAccount,
        title: title,
      );
}
