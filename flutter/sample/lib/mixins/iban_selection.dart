import 'package:flutter/material.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';

mixin IbanSelection<T extends StatefulWidget> on MruSelectionMixin<T> {
  Future<MruItem> showSourceIbanSelectionDialog({
    Widget title = const Text('شباهای من'),
  }) =>
      showMruSelectionDialog(
        mru: MruType.sourceIban,
        title: title,
      );

  Future<MruItem> showDestinationIbanSelectionDialog({
    Widget title = const Text('شباهای مقصد'),
  }) =>
      showMruSelectionDialog(
        mru: MruType.destinationIban,
        title: title,
      );
}
