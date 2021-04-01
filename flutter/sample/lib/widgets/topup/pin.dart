import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/radio_button.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';

class ChargePin extends StatefulWidget {
  @override
  _ChargePinState createState() => _ChargePinState();
}

class _ChargePinState extends State<ChargePin> with DisableManagerMixin {
  int _amount = 2000;
  MobileOperator _operator = MobileOperator.irancell;
  String _phoneNumber;
  Color _colorOperatorActive;
  Color _colorOperatorInActive;
  Color _colorOperatorCard;
  Color _colorOperatorText;
  Image _operatorImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _phoneNumber = await appState.getPhoneNumber();
      if (mounted) {
        setState(() {});
      }
      _changeOperator(MobileOperator.mci);
    });
  }

  @override
  Widget build(BuildContext context) {
    final String opName = Utils.getOperatorName(_operator);
    final bool showGrid = _operator != null;
    final operators = Container(
      margin: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                _changeOperator(MobileOperator.mci);
              },
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _operator == MobileOperator.mci
                      ? colors.mci_active
                      : colors.mci_inactive,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset('assets/logo/mci.png'),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _changeOperator(MobileOperator.irancell);
              },
              child: Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                decoration: BoxDecoration(
                  color: _operator == MobileOperator.irancell
                      ? colors.irancell_active
                      : colors.irancell_inactive,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset('assets/logo/mtn.png'),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _changeOperator(MobileOperator.rightel);
              },
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _operator == MobileOperator.rightel
                      ? colors.rightel_active
                      : colors.rightel_inactive,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset('assets/logo/rightel.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (!showGrid) {
      return SingleChildScrollView(
        child: operators,
      );
    }

    final lv = Expanded(
      child: ListView(
        shrinkWrap: true,
        padding:
            EdgeInsetsDirectional.only(start: 20, end: 20, top: 0, bottom: 12),
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

    Widget footer() => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
          child: DismissibleRoundButton(
            onDismiss: () {
              setState(() {
                _amount = null;
              });
            },
            color: _colorOperatorCard,
            text: 'شارژ ${toTomans(_amount)}',
            buttonText: 'خرید',
            onPressed: () async {
              final payInfo = await showPaymentBottomSheet(
                context: context,
                title: Text('خرید پین شارژ'),
                amount: (_amount ?? 0) * 10,
                transactionType: TransactionType.buy,
                acceptorName: _phoneNumber,
                enableWallet: true,
                acceptorId: '22',
                children: [
                  DualListTile(
                    start: Text('نوع اپراتور'),
                    end: Text(opName ?? ''),
                  ),
                ],
              );

              if (payInfo == null) {
                return;
              }
              if (payInfo.type == PaymentType.normal) {
                _normalPay(payInfo, opName);
              } else if (payInfo.type == PaymentType.wallet) {
                _walletPay(opName);
              }
            },
          ),
        );

    final children = <Widget>[
      operators,
    ];

    if (showGrid) {
      children.add(SizedBox(height: 24));
      children.add(lv);
    }

    final showFooter = showGrid == true && _amount != null && _amount > 0;

    if (!showFooter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    return Split(
      footer: footer(),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }

  void _normalPay(PayInfo payInfo, String opName) async {
    final data = await Loading.run(
      context,
      nh.topup.mobilePin(
        cardInfo: payInfo.cardInfo,
        amount: _amount * 10,
        operatorName: _operator,
      ),
    );

    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(context, data.content.description,
          data.content.stan, data.content.rrn, 'پین شارژ', _amount * 10);
      return;
    }
    nh.mru.addMru(
      type: MruType.sourceCard,
      title: Utils.getBankName(payInfo.cardInfo.pan),
      value: removeDash(payInfo.cardInfo.pan),
      expDate: payInfo.cardInfo.expire,
    );
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
            title: 'پین شارژ',
            cardNumber: payInfo.cardInfo.pan,
            stan: data.content.stan,
            rrn: data.content.rrn,
            topupPin: data.content.chargePin,
            description: 'خرید پین شارژ $opName',
            amount: _amount * 10,
            isShaparak: true),
      ),
    );
  }

  void _walletPay(String opName) async {
    final balanceData = await Loading.run(context, nh.wallet.getBalance());

    if (!showError(context, balanceData)) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.wallet.pinCharge(
        chargeAmount: _amount * 10,
        operatorName: _operator,
        balance: balanceData.content.balance,
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
          'پین شارژ',
          _amount * 10);
      return;
    }
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
            title: 'پین شارژ',
            cardNumber: null,
            stan: data.content.reserveNumber.toString(),
            rrn: data.content.referenceNumber.toString(),
            topupPin: data.content.chargePin,
            description: 'خرید پین شارژ $opName',
            amount: _amount * 10,
            isShaparak: false),
      ),
    );
  }

  void _onPinCardChanged(int value) {
    setState(() {
      _amount = value;
    });
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

  void _changeOperator(MobileOperator operator) {
    _colorOperatorActive = Utils.getOperatorActiveColor(operator);
    _colorOperatorInActive = Utils.getOperatorInactiveColor(operator);
    _colorOperatorCard = Utils.getOperatorCardColor(operator);
    _colorOperatorText = Utils.getOperatorTextColor(operator);
    if (operator == MobileOperator.irancell) {
      _operatorImage = Image.asset(
        'assets/logo/mtn.png',
        height: 50,
      );
    }
    if (operator == MobileOperator.rightel) {
      _operatorImage = Image.asset(
        'assets/logo/rightel.png',
        height: 50,
      );
    }
    if (operator == MobileOperator.mci) {
      _operatorImage = Image.asset(
        'assets/logo/mci.png',
        height: 50,
      );
    }

    setState(() {
      _operator = operator;
      if (operator == MobileOperator.rightel) {
        _amount = 1000;
      } else {
        _amount = 2000;
      }
    });
  }
}
