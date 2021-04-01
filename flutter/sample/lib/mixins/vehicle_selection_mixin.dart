import 'package:flutter/material.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';

mixin VehicleSelectionMixin<T extends StatefulWidget> on MruSelectionMixin<T> {
  Future<MruItem> showVehicleSelectionDialog(
          {Widget title = const Text('خودرو های من')}) =>
      showMruSelectionDialog(mru: MruType.vehicleId, title: title);
}
