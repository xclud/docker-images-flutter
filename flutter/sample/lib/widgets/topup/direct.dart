import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/dismissible_round_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/radio_button.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/mobile_input.dart';
import 'package:persian/persian.dart';

class ChargeDirect extends StatefulWidget {
  ChargeDirect();

  @override
  _ChargeDirectState createState() => _ChargeDirectState();
}

class _ChargeDirectState extends State<ChargeDirect> {
  final _formKey = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _mobileNumberFocusNode = FocusNode();
  MobileOperator _operator;
  int _amount = 0;
  Color _colorOperatorActive;
  Color _colorOperatorInActive;
  Color _colorOperatorCard;
  Color _colorOperatorText;
  Image _operatorImage;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showGrid = _operator != null;

    void _setOperator(MobileOperator operator) {
      _colorOperatorActive = Utils.getOperatorActiveColor(operator);
      _colorOperatorInActive = Utils.getOperatorInactiveColor(operator);
      _colorOperatorCard = Utils.getOperatorCardColor(operator);
      _colorOperatorText = Utils.getOperatorTextColor(operator);

      if (operator == MobileOperator.irancell) {
        _operatorImage = Image.asset(
          'assets/logo/mtn.png',
          height: 48,
        );
      }
      if (operator == MobileOperator.rightel) {
        _operatorImage = Image.asset(
          'assets/logo/rightel.png',
          height: 48,
        );
      }
      if (operator == MobileOperator.mci) {
        _operatorImage = Image.asset(
          'assets/logo/mci.png',
          height: 48,
        );
      }
      _operator = operator;
      if (operator == MobileOperator.rightel) {
        _amount = 1000;
      } else {
        _amount = 2000;
      }
    }

    void _showList(String value) {
      _mobileNumberFocusNode.unfocus();
      _setOperator(Utils.getOperatorType(value));
      if (!_formKey.currentState.validate()) {
        return;
      } else {
        setState(() {});
      }
    }

    void _hideList() {
      setState(() {
        _amount = 0;
        _operator = null;
      });
    }

    final header = Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(top: 0, left: 24, right: 24),
        child: MobileWidget(
          controller: _phoneNumberController,
          focusNode: _mobileNumberFocusNode,
          showSimCard: false,
          onItemClicked: _showList,
          onChanged: (value) {
            setState(() {
              if (_phoneNumberController.text.length < 11 && showGrid) {
                _hideList();
              }
            });
          },
        ),
      ),
    );

    final message = Center(
      child: Text(
        'برای مشاهده مبالغ شارژ شماره مورد نظر خود را وارد کنید',
        style: colors
            .regularStyle(context)
            .copyWith(color: colors.greyColor.shade900),
        textAlign: TextAlign.center,
      ),
    );

    if (showGrid != true) {
      return Split(
        header: header,
        child: Expanded(child: message),
        footer: Container(
          padding: EdgeInsets.all(24),
          child: ConfirmButton(
              onPressed: () => _showList(_phoneNumberController.text),
              child: CustomText(
                'تایید',
                textAlign: TextAlign.center,
              )),
        ),
      );
    }

    final gv = Expanded(
      child: ListView(
        padding:
            EdgeInsetsDirectional.only(start: 24, end: 24, top: 0, bottom: 12),
        shrinkWrap: true,
        children: _getOperatorPinCards()
            .map(
              (e) => RadioButton<int>(
                value: e,
                groupValue: _amount,
                activeColor: _colorOperatorActive,
                inActiveColor: _colorOperatorInActive,
                onChanged: _onPinCardChanged,
                text: Text(toTomans(e),
                    style: colors
                        .boldStyle(context)
                        .copyWith(color: _colorOperatorText)),
                image: _operatorImage,
              ),
            )
            .toList(),
      ),
    );

    Widget _buildFooter() => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
          child: DismissibleRoundButton(
            onDismiss: () {
              setState(() {
                _amount = null;
              });
            },
            onPressed: _submit,
            color: _colorOperatorCard,
            buttonText: 'خرید',
            text: 'شارژ ${toTomans(_amount)}',
          ),
        );

    final children = <Widget>[];

    children.add(SizedBox(height: 24));
    children.add(gv);
    final showFooter = showGrid && _amount != null && _amount != 0;
    return Split(
      header: header,
      footer: showFooter ? _buildFooter() : Container(),
      child: Expanded(
        child: Column(
          children: children,
        ),
      ),
    );
  }

  void _onPinCardChanged(int value) {
    setState(() {
      _amount = value;
    });
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final phoneNumber = _phoneNumberController.text;

    final payInfo = await showPaymentBottomSheet(
      context: context,
      title: Text('خرید شارژ'),
      amount: _amount * 10,
      transactionType: TransactionType.buy,
      acceptorName: _phoneNumberController.text,
      acceptorId: '21',
      enableWallet: true,
      children: [
        DualListTile(
          start: Text(strings.label_mobile_number),
          end: Text(phoneNumber?.withPersianNumbers() ?? ''),
        ),
      ],
    );

    if (payInfo == null) {
      return;
    }
    if (payInfo.type == PaymentType.normal) {
      _normalPay(payInfo, phoneNumber);
    } else if (payInfo.type == PaymentType.wallet) {
      _walletPay(phoneNumber);
    }
  }

  void _normalPay(PayInfo payInfo, String destinationMobileNumber) async {
    final data = await Loading.run(
      context,
      nh.topup.mobileTopUp(
          cardInfo: payInfo.cardInfo,
          amount: _amount * 10,
          operatorName: _operator,
          destinationMobileNumber: destinationMobileNumber),
    );
    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(context, data.content.description,
          data.content.stan, data.content.rrn, 'شارژ مستقیم', _amount * 10);

      return;
    }
    nh.mru.addMru(
        type: MruType.mobile, title: null, value: destinationMobileNumber);
    nh.mru.addMru(
      type: MruType.sourceCard,
      title: Utils.getBankName(payInfo.cardInfo.pan),
      value: removeDash(payInfo.cardInfo.pan),
      expDate: payInfo.cardInfo.expire,
    );
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'شارژ مستقیم',
          cardNumber: payInfo.cardInfo.pan,
          stan: data.content.stan,
          rrn: data.content.rrn,
          description: 'خرید شارژ مستقیم برای شماره: $destinationMobileNumber',
          amount: _amount * 10,
          isShaparak: true,
        ),
      ),
    );
  }

  void _walletPay(String destinationMobileNumber) async {
    final balanceData = await Loading.run(context, nh.wallet.getBalance());

    if (!showError(context, balanceData)) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.wallet.topup(
        chargeAmount: _amount * 10,
        operatorName: _operator,
        balance: balanceData.content.balance.toInt(),
        destinationMobileNumber: destinationMobileNumber,
      ),
    );
    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(
          context,
          data.content.description,
          data.content.reserveNumber.toString(),
          data.content.referenceNumber.toString(),
          'شارژ مستقیم',
          _amount * 10);

      return;
    }
    nh.mru.addMru(
        type: MruType.mobile, title: null, value: destinationMobileNumber);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'شارژ مستقیم',
          cardNumber: null,
          stan: data.content.reserveNumber.toString(),
          rrn: data.content.referenceNumber.toString(),
          topupPin: null,
          description: 'خرید شارژ مستقیم برای شماره: $destinationMobileNumber',
          amount: _amount * 10,
          isShaparak: false,
        ),
      ),
    );
  }

  List<int> _getOperatorPinCards() {
    switch (_operator) {
      case MobileOperator.mci:
        return _getMCI().toList();
      case MobileOperator.irancell:
        return _getMTN().toList();
      case MobileOperator.rightel:
        return _getRightel().toList();
    }
    return [];
  }

  Iterable<int> _getMCI() sync* {
    //yield 1000;
    yield 2000;
    yield 5000;
    yield 10000;
    yield 50000;
    yield 100000;
  }

  Iterable<int> _getMTN() sync* {
    yield 2000;
    yield 5000;
    yield 10000;
    yield 20000;
  }

  Iterable<int> _getRightel() sync* {
    yield 1000;
    yield 2000;
    yield 5000;
    yield 10000;
    yield 50000;
  }
}
