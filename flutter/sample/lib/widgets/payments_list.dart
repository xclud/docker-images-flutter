import 'package:flutter/material.dart';
import 'package:novinpay/widgets/general/general.dart';

class PaymentList extends StatelessWidget {
  PaymentList({
    @required this.referenceCode,
    @required this.date,
    @required this.amount,
  });

  final String referenceCode;
  final String date;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            DualListTile(
              start: Text('کد مرجع', textAlign: TextAlign.end),
              end: Text(referenceCode, textAlign: TextAlign.end),
            )
          ],
        ),
        Row(
          children: [
            DualListTile(
              start: Text('تاریخ', textAlign: TextAlign.end),
              end: Text(date, textAlign: TextAlign.end),
            )
          ],
        ),
        Row(
          children: [
            DualListTile(
              start: Text('مبلغ', textAlign: TextAlign.end),
              end: Text(amount, textAlign: TextAlign.end),
            )
          ],
        ),
        Container(
          height: 1,
          color: Colors.grey,
        )
      ],
    );
  }
}
