import 'package:flutter/foundation.dart';

class BillInfo {
  BillInfo({
    @required this.billId,
    @required this.paymentId,
    @required this.amount,
  });

  final String billId;
  final String paymentId;
  final int amount;
}
