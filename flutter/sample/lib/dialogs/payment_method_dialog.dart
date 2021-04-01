import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/card_information_dialog.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

typedef PayCallback = Future<void> Function(PayInfo info);

class PaymentWithWalletDialog extends StatefulWidget {
  PaymentWithWalletDialog({
    @required this.amount,
    @required this.transactionType,
    @required this.acceptorName,
    @required this.acceptorId,
    this.children = const [],
    this.scrollController,
    this.enableWallet = true,
    this.showWallet = true,
    this.title,
    this.onPay,
  });

  final int amount;
  final List<Widget> children;
  final ScrollController scrollController;
  final TransactionType transactionType;
  final String acceptorName;
  final String acceptorId;
  final bool enableWallet;
  final bool showWallet;
  final Widget title;
  final PayCallback onPay;

  @override
  _PaymentWithWalletDialogState createState() =>
      _PaymentWithWalletDialogState();
}

class _PaymentWithWalletDialogState extends State<PaymentWithWalletDialog> {
  PaymentType _paymentType;
  int _balance;

  @override
  void initState() {
    _paymentType = PaymentType.normal;
    _onRefresh();
    super.initState();
  }

  void _onRefresh() async {
    final data = await nh.wallet.getBalance();

    if (data.hasErrors()) {
      return;
    }

    _balance = data.content.balance.toInt();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final _footer = Padding(
      padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
      child: ConfirmButton(
        child: CustomText(
          'تایید نوع پرداخت',
          textAlign: TextAlign.center,
          style: colors
              .tabStyle(context)
              .copyWith(color: colors.greyColor.shade50),
        ),
        onPressed: _submit,
      ),
    );

    final _onlinePayment = InkWell(
      onTap: () {
        setState(() {
          _paymentType = PaymentType.normal;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: _paymentType == PaymentType.normal
                  ? colors.primaryColor
                  : colors.greyColor.shade800,
              width: 2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                'assets/logo/sun.png',
                height: 28,
                width: 28,
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Text(
              'پرداخت با کارت شتابی',
              style: colors.boldStyle(context).copyWith(
                    color: colors.accentColor,
                  ),
            ),
          ],
        ),
      ),
    );

    Widget _walletPayment() {
      var wallet = Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: _paymentType == PaymentType.wallet
                ? colors.primaryColor
                : colors.greyColor.shade800,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(end: 8.0),
          child: DualListTile(
            padding: EdgeInsets.all(0.0),
            start: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 32,
                  color: widget.enableWallet
                      ? colors.accentColor
                      : colors.greyColor.shade800,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Text(
                  'پرداخت با کیف پول',
                  style: colors.boldStyle(context).copyWith(
                        color: widget.enableWallet
                            ? colors.accentColor
                            : colors.greyColor.shade800,
                      ),
                ),
              ],
            ),
            end: _balance == null
                ? Text(
                    strings.please_wait,
                    style: colors.boldStyle(context).copyWith(
                          color: widget.enableWallet
                              ? colors.accentColor
                              : colors.greyColor.shade800,
                        ),
                  )
                : Text(
                    toRials(_balance),
                    style: colors.boldStyle(context).copyWith(
                          color: widget.enableWallet
                              ? colors.accentColor
                              : colors.greyColor.shade800,
                        ),
                  ),
          ),
        ),
      );

      if (widget.enableWallet) {
        return InkWell(
          onTap: () {
            setState(() {
              _paymentType = PaymentType.wallet;
            });
          },
          child: wallet,
        );
      } else {
        return wallet;
      }
    }

    final _amount = Row(
      children: [
        Icon(
          SunIcons.bill,
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
              Text(
                toRials(widget.amount).withPersianNumbers(),
                textAlign: TextAlign.right,
                style: colors.boldStyle(context).copyWith(
                      color: colors.primaryColor,
                    ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(_getPersianAmount(),
                  textAlign: TextAlign.right,
                  style: colors
                      .bodyStyle(context)
                      .copyWith(color: colors.primaryColor))
            ],
          ),
        )
      ],
    );

    final _line = _pad(
      Container(height: 1.0, color: colors.primaryColor),
    );

    Widget _buildBody() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Space(),
            _pad(_onlinePayment),
            if (widget.showWallet == true) Space(2),
            if (widget.showWallet == true) _pad(_walletPayment()),
            Space(3),
            if (widget.children != null && widget.children.isNotEmpty) _line,
            if (widget.children != null && widget.children.isNotEmpty) Space(2),
            if (widget.children != null && widget.children.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 32.0, right: 32.0),
                child: DefaultTextStyle.merge(
                  style: colors
                      .boldStyle(context)
                      .copyWith(color: colors.primaryColor),
                  child: Column(
                    children: widget.children,
                  ),
                ),
              ),
            if (widget.children != null && widget.children.isNotEmpty) Space(2),
            _line,
            Space(3),
            Padding(
              padding: EdgeInsets.only(left: 32.0, right: 32.0),
              child: _amount,
            ),
          ],
        ),
      );
    }

    return HeadedPage(
      title: widget.title,
      body: Split(
        child: Expanded(child: _buildBody()),
        footer: _footer,
      ),
    );
  }

  void _submit() async {
    if (_paymentType == PaymentType.normal) {
      final payInfo = await Navigator.of(context).push<PayInfo>(
        MaterialPageRoute(
            builder: (context) => CardInformation(
                  amount: widget.amount,
                  transactionType: widget.transactionType,
                  acceptorName: widget.acceptorName,
                  acceptorId: widget.acceptorId,
                  scrollController: widget.scrollController,
                ),
            fullscreenDialog: true),
      );
      if (payInfo == null) {
        return;
      }
      Navigator.of(context).pop(payInfo);
    } else if (_paymentType == PaymentType.wallet) {
      if (_balance == null || _balance < widget.amount) {
        _showNoBalanceDialog('موجودی کیف پول کافی نمی باشد');
        return;
      }
      Navigator.of(context).pop(PayInfo.wallet());
    }
  }

  Widget _pad(Widget child) {
    return Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0),
      child: child,
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

  void _showNoBalanceDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('کیف پول'),
        content: CustomText(message ?? ''),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            child: Text('فهمیدم'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
