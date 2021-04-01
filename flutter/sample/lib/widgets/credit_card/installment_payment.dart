import 'package:flutter/material.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';

class InstallmentPayment extends StatelessWidget {
  InstallmentPayment({
    @required this.value,
    @required this.soodTashilat,
    @required this.sood,
    @required this.groupValue,
    @required this.label,
    @required this.due,
    @required this.total,
    @required this.paid,
    @required this.pay,
    @required this.previous,
    @required this.serviceFee,
    this.onChanged,
  });

  final int value;
  final int groupValue;
  final ValueChanged<int> onChanged;
  final String label;
  final String due;
  final int sood;
  final int soodTashilat;
  final int total;
  final int paid;
  final int pay;
  final int previous;
  final int serviceFee;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    children.add(
        DualListTile(start: Text('جمع کل خرید'), end: Text(toRials(total))));
    children.add(DualListTile(
        start: Text('جمع کارمزد'), end: Text(toRials(serviceFee))));
    children
        .add(DualListTile(start: Text('سود دوره'), end: Text(toRials(sood))));

    children.add(DualListTile(
        start: Text('قسط این دوره'), end: Text(toRials(pay ?? 0))));
    children.add(DualListTile(
        start: Text('سود تسهیلات'), end: Text(toRials(soodTashilat ?? 0))));
    children.add(DualListTile(
        start: Text('بدهی از قبل'), end: Text(toRials(previous ?? 0))));
    children.add(DualListTile(
        start: Text('مبلغ قابل پرداخت'), end: Text(toRials(paid ?? 0))));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}
