import 'package:flutter/material.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:persian/persian.dart';

class IntraTransferConfirmDialog extends StatefulWidget {
  IntraTransferConfirmDialog({
    @required this.source,
    @required this.destination,
    @required this.amount,
    @required this.description1,
    @required this.description2,
    @required this.name,
  });

  final String source;
  final String destination;
  final int amount;
  final String description1;
  final String description2;
  final String name;

  @override
  _IntraTransferConfirmDialogState createState() =>
      _IntraTransferConfirmDialogState();
}

class _IntraTransferConfirmDialogState
    extends State<IntraTransferConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
      child: Split(
        child: Column(
          children: [
            DualListTile(
              start: Text('پرداخت از'),
              end: Text(widget.source?.withPersianNumbers() ?? ''),
            ),
            DualListTile(
              start: Text('به شماره'),
              end: Text(widget.destination?.withPersianNumbers() ?? ''),
            ),
            DualListTile(
              start: Text('مبلغ قابل پرداخت'),
              end: Text(toRials(widget.amount)),
            ),
            Space(2),
          ],
        ),
        footer: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
}
