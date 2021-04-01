import 'package:flutter/material.dart';
import 'package:novinpay/dialogs/mru_selection_dialog.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/utils.dart';

mixin MruSelectionMixin<T extends StatefulWidget> on State<T> {
  Future<MruItem> showMruSelectionDialog({
    @required MruType mru,
    @required Widget title,
  }) {
    return showCustomDraggableBottomSheet<MruItem>(
      context: context,
      initialChildSize: 0.7,
      title: title,
      builder: (context, scrollController) => MruSelectionDialog(
        mru: mru,
        scrollController: scrollController,
      ),
    );
  }
}
