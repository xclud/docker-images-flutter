import 'package:flutter/material.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/card_to_card_dialog.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:persian/persian.dart';

class CartToCardConfirm extends StatefulWidget {
  CartToCardConfirm({
    @required this.sourceCardNumber,
    @required this.sourceCardId,
    @required this.destinationCardNumber,
    @required this.destinationCardId,
    @required this.holderName,
    @required this.amount,
    @required this.expDateMonth,
    @required this.expDateYear,
  });

  final String sourceCardNumber;
  final int sourceCardId;
  final String destinationCardNumber;
  final int destinationCardId;
  final String holderName;
  final int amount;
  final String expDateMonth;
  final String expDateYear;

  @override
  _CartToCardConfirmState createState() => _CartToCardConfirmState();
}

class _CartToCardConfirmState extends State<CartToCardConfirm> {
  bool _saveCardInfo;

  @override
  void initState() {
    super.initState();
    _saveCardInfo = widget.destinationCardId == null;
  }

  @override
  Widget build(BuildContext context) {
    final _footer = Column(
      children: [
        if (widget.destinationCardId == null)
          Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: ThemeData(
                  unselectedWidgetColor: colors.ternaryColor,
                  primarySwatch: Colors.yellow,
                  fontFamily: 'Shabnam'),
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 8.0),
                child: CheckboxListTile(
                  title: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'ذخیره کارت در کارت های پر کاربرد',
                      style: colors.tabStyle(context).copyWith(
                            color: colors.ternaryColor,
                          ),
                    ),
                  ),
                  value: _saveCardInfo,
                  onChanged: (value) {
                    setState(() {
                      _saveCardInfo = value;
                    });
                  },
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
          child: ConfirmButton(
            child: CustomText(
              'تایید پرداخت',
              style: colors.tabStyle(context).copyWith(
                    color: colors.greyColor.shade50,
                  ),
              textAlign: TextAlign.center,
            ),
            onPressed: _submit,
          ),
        ),
      ],
    );

    return HeadedPage(
      title: Text('کارت به کارت'),
      body: Split(
        footer: _footer,
        child: Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 24.0, left: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Space(2),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          Utils.getBankLogo(widget.sourceCardNumber),
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                Utils.getBankName(widget.sourceCardNumber),
                                textAlign: TextAlign.right,
                                style: colors
                                    .boldStyle(context)
                                    .copyWith(color: colors.primaryColor),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              CustomText(
                                '$lrm${widget.sourceCardNumber.withPersianNumbers()}' ??
                                    '',
                                textAlign: TextAlign.right,
                                style: colors
                                    .bodyStyle(context)
                                    .copyWith(color: colors.primaryColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Space(2),
                  Padding(
                    padding: const EdgeInsets.only(right: 26.0),
                    child: Column(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: colors.primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: colors.primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  Space(2),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        Image.asset(
                          Utils.getBankLogo(widget.destinationCardNumber),
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                widget.holderName,
                                textAlign: TextAlign.right,
                                style: colors
                                    .boldStyle(context)
                                    .copyWith(color: colors.primaryColor),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              CustomText(
                                '$lrm${widget.destinationCardNumber.withPersianNumbers()}' ??
                                    '',
                                textAlign: TextAlign.right,
                                style: colors
                                    .bodyStyle(context)
                                    .copyWith(color: colors.primaryColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Space(3),
                  Container(
                    height: 1.0,
                    color: colors.primaryColor.shade500,
                  ),
                  Space(3),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.receipt,
                          size: 30,
                          color: colors.primaryColor,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                toRials(widget.amount).withPersianNumbers(),
                                textAlign: TextAlign.right,
                                style: colors
                                    .boldStyle(context)
                                    .copyWith(color: colors.primaryColor),
                              ),
                              SizedBox(
                                height: 4.0,
                              ),
                              CustomText(
                                _getPersianAmount(),
                                textAlign: TextAlign.right,
                                style: colors
                                    .bodyStyle(context)
                                    .copyWith(color: colors.primaryColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getPersianAmount() {
    final amount = widget.amount;
    if (amount == null) {
      return '';
    }
    final toman = (amount ~/ 10).toPersianString();
    return '$toman تومان';
  }

  void _submit() async {
    final cardInfo = await showCustomBottomSheet<CardInfo>(
      context: context,
      child: CardToCardDialog(
          sourceCardNumber: widget.sourceCardNumber,
          sourceCardId: widget.sourceCardId,
          destinationCardNumber: widget.destinationCardNumber,
          destinationCardId: widget.destinationCardId,
          amount: widget.amount,
          expDateMonth: widget.expDateMonth,
          expDateYear: widget.expDateYear,
          saveCardInfo: _saveCardInfo),
    );
    if (cardInfo == null) {
      return;
    }

    Navigator.of(context).pop(cardInfo);
  }
}
