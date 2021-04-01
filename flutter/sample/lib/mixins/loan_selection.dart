import 'package:flutter/material.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';

mixin LoanSelection<T extends StatefulWidget> on MruSelectionMixin<T> {
  Future<MruItem> showLoanSelectionDialog({
    Widget title = const Text('تسهیلات های من'),
  }) =>
      showMruSelectionDialog(
        mru: MruType.loan,
        title: title,
      );
}
