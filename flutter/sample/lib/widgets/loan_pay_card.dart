import 'package:flutter/material.dart';
import 'package:novinpay/mixins/loan_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class LoanPayCard extends StatefulWidget {
  @override
  _LoanPayCardState createState() => _LoanPayCardState();
}

class _LoanPayCardState extends State<LoanPayCard>
    with MruSelectionMixin, LoanSelection {
  final _formKey = GlobalKey<FormState>();
  final _loanController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Split(
      child: Expanded(
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LoanTextFormField(
                    controller: _loanController,
                    showSelectionDialog: _showLoanSelectionDialog,
                  ),
                  Space(2),
                  MoneyTextFormField(
                    controller: _amountController,
                    minimum: 1,
                    maximum: 2000000000,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  Space(2),
                  Text(_getPersianAmount()),
                ],
              ),
            ),
          ),
        ),
      ),
      footer: Container(
        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            textAlign: TextAlign.center,
          ),
          onPressed: _submit,
        ),
      ),
    );
  }

  String _getPersianAmount() {
    final text = _amountController.text?.replaceAll(',', '');
    final amount = int.tryParse(text ?? '');
    if (amount == null) {
      return '';
    }
    final toman = (amount ~/ 10).toPersianString();
    return '$toman تومان';
  }

  void _showLoanSelectionDialog() async {
    final data = await showLoanSelectionDialog();
    if (data == null) {
      return;
    }

    _loanController.text = data.value;
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final amount =
        int.tryParse(_amountController.text?.replaceAll(',', '') ?? '');

    final payInfo = await showPaymentBottomSheet(
      context: context,
      title: Text('پرداخت تسهیلات'),
      amount: amount,
      transactionType: TransactionType.buy,
      acceptorName: '',
      acceptorId: '12',
      children: [
        DualListTile(
          start: Text('شماره تسهیلات'),
          end: Text(_loanController.text ?? ''),
        ),
      ],
    );

    if (payInfo == null) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.boomMarket.loanPaymentWithCard(
        cardInfo: payInfo.cardInfo,
        loanNumber: _loanController.text,
        amount: amount,
      ),
    );
    nh.mru.addMru(type: MruType.loan, title: null, value: _loanController.text);

    if (!showError(context, data)) {
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
          title: 'تسهیلات',
          cardNumber: payInfo.cardInfo.pan,
          stan: data.content.trackingNumber,
          rrn: data.content.switchResponseRrn,
          topupPin: null,
          description: 'پرداخت تسهیلات برای شماره ${_loanController.text}',
          amount: int.parse(_amountController.text.replaceAll(',', '')),
          isShaparak: false,
        ),
      ),
    );
  }
}
