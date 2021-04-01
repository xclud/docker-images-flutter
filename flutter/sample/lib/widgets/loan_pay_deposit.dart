import 'package:flutter/material.dart';
import 'package:novinpay/dialogs/loan_pay_confirm_dialog.dart';
import 'package:novinpay/mixins/account_selection.dart';
import 'package:novinpay/mixins/bank_login.dart';
import 'package:novinpay/mixins/loan_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class LoanPayDeposit extends StatefulWidget {
  @override
  _LoanPayDepositState createState() => _LoanPayDepositState();
}

class _LoanPayDepositState extends State<LoanPayDeposit>
    with BankLogin, MruSelectionMixin, AccountSelection, LoanSelection {
  final _formKey = GlobalKey<FormState>();
  final _loanController = TextEditingController();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Split(
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
      child: Form(
        key: _formKey,
        child: Expanded(
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  LoanTextFormField(
                    controller: _loanController,
                    showSelectionDialog: _showLoanSelectionDialog,
                  ),
                  Space(2),
                  AccountTextFormField(
                    controller: _accountController,
                    showSelectionDialog: _showAccountSelectionDialog,
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

  void _showAccountSelectionDialog() async {
    final data = await showSourceAccountSelectionDialog();
    if (data == null) {
      return;
    }

    _accountController.text = data.value;
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

    final source = _loanController.text;
    final destination = _accountController.text;
    final amount =
        int.tryParse(_amountController.text?.replaceAll(',', '') ?? '');

    final loginResult = await ensureBankLogin(routes.loan_pay);

    if (loginResult == null) {
      return;
    }

    final result = await showCustomDraggableBottomSheet<bool>(
      context: context,
      title: Text('پرداخت تسهیلات با حساب'),
      builder: (context, scrollController) => LoanPayConfirmDialog(
        source: source,
        destination: destination,
        amount: amount,
      ),
    );

    if (result != true) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.boomMarket.loanPaymentWithDeposit(
        loanNumber: _loanController.text,
        customDepositNumber: _accountController.text,
        paymentMethod: 'CUSTOM_DEPOSIT',
        amount: amount,
      ),
    );

    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(
          context,
          data.content.description,
          data.content.trackingCode,
          data.content.documentNumber,
          'پرداخت تسهیلات',
          amount);
      return;
    }
    nh.mru.addMru(type: MruType.loan, title: null, value: _loanController.text);
    nh.mru.addMru(
        type: MruType.sourceAccount,
        title: null,
        value: _accountController.text);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'تسهیلات',
          cardNumber: '',
          stan: data.content.trackingCode,
          rrn: data.content.documentNumber,
          topupPin: null,
          description: 'پرداخت تسهیلات برای شماره ${_loanController.text}',
          amount: amount,
          isShaparak: false,
        ),
      ),
    );
  }
}
