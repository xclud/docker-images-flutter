import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/utils.dart';
import 'package:persian/persian.dart';

class DarkCreditCard extends StatefulWidget {
  DarkCreditCard({
    @required this.pan,
    @required this.holder,
    @required this.debit,
    @required this.currentDebit,
    this.color,
  });

  final String pan;
  final String holder;
  final Color color;
  final int debit;
  final int currentDebit;

  @override
  _DarkCreditCardState createState() => _DarkCreditCardState();
}

class _DarkCreditCardState extends State<DarkCreditCard> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1600 / 850.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/card_dark.png',
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
                      child: Text(
                        widget.holder?.withPersianLetters() ?? '',
                        style: TextStyle(
                            color: colors.ternaryColor.shade300, fontSize: 14),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                        child: Text(
                          formatCardNumber(widget.pan, true)
                                  ?.withPersianNumbers() ??
                              '',
                          style: TextStyle(
                              color: colors.ternaryColor.shade300,
                              fontSize: 20),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 8, 0, 0),
                      child: Text(
                        'کل بدهی',
                        style: TextStyle(
                            color: colors.greyColor.shade50, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 24, 0),
                      child: Text(
                        toRials(widget.debit) ?? '',
                        style: TextStyle(color: colors.red, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 24),
                      child: Text(
                        'مبلغ قابل پرداخت تا کنون',
                        style: TextStyle(
                            color: colors.greyColor.shade50, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 24, 24),
                      child: Text(
                        toRials(widget.currentDebit) ?? '',
                        style: TextStyle(color: colors.red, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
