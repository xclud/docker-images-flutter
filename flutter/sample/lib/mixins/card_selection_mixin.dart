import 'package:flutter/material.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';

mixin CardSelectionMixin<T extends StatefulWidget> on MruSelectionMixin<T> {
  Future<MruItem> showSourceCardSelectionDialog({
    Widget title = const Text('کارت های من'),
  }) =>
      showMruSelectionDialog(
        mru: MruType.sourceCard,
        title: title,
      );

  Future<MruItem> showDestinationCardSelectionDialog({
    Widget title = const Text('کارت های مقصد'),
  }) =>
      showMruSelectionDialog(
        mru: MruType.destinationCard,
        title: title,
      );
}
