import 'package:flutter/material.dart';
import 'package:novinpay/dialogs/paya_transfer_confirm_dialog.dart';
import 'package:novinpay/mixins/account_selection.dart';
import 'package:novinpay/mixins/bank_login.dart';
import 'package:novinpay/mixins/iban_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class PayaMoneyTransfer extends StatefulWidget {
  @override
  _PayaMoneyTransferState createState() => _PayaMoneyTransferState();
}

class _PayaMoneyTransferState extends State<PayaMoneyTransfer>
    with BankLogin, MruSelectionMixin, AccountSelection, IbanSelection {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _ibanController = TextEditingController();
  final _amountController = TextEditingController();
  final _inputTextFieldName = TextEditingController();
  final _descriptionController = TextEditingController();

  String _descriptionValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'توضیحات را وارد نمایید';
    }
    return null;
  }

  String _nameValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'نام را وارد نمایید.';
    }

    return null;
  }

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
      child: Expanded(
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  AccountTextFormField(
                    controller: _accountController,
                    showSelectionDialog: _showAccountSelectionDialog,
                  ),
                  Space(2),
                  IbanTextFormField(
                    labelText: 'شبای مقصد',
                    controller: _ibanController,
                    showSelectionDialog: _showIbanSelectionDialog,
                  ),
                  Space(2),
                  TextFormField(
                    controller: _inputTextFieldName,
                    validator: _nameValidator,
                    decoration: InputDecoration(
                      labelText: 'نام صاحب حساب',
                      counterText: '',
                    ),
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
                  Space(2),
                  TextFormField(
                    controller: _descriptionController,
                    validator: _descriptionValidator,
                    decoration: InputDecoration(
                      labelText: 'توضیحات',
                      hintText: 'توضیحات',
                      counterText: '',
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

  void _showIbanSelectionDialog() async {
    final data = await showSourceIbanSelectionDialog();
    if (data == null) {
      return;
    }

    _ibanController.text = data.value;
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final source = _accountController.text;
    final destination = _ibanController.text;
    final amount =
        int.tryParse(_amountController.text?.replaceAll(',', '') ?? '');
    var description = _descriptionController.text;
    if (description == null || description.isEmpty) {
      description = 'وب اپ سان';
    }

    final name = _inputTextFieldName.text;

    final result = await showCustomBottomSheet<bool>(
      context: context,
      title: Text('انتقال وجه پایا'),
      child: PayaTransferConfirmDialog(
        name: name,
        source: source,
        destination: destination,
        amount: amount,
        description: description,
      ),
    );

    if (result != true) {
      return;
    }

    final r2 = await ensureBankLogin(routes.money_transfer);
    if (r2 == null) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.boomMarket.payaTransfer(
        sourceDepositNumber: source,
        ibanNumber: destination,
        ownerName: name,
        description: description,
        amount: amount,
      ),
    );

    if (data.isError) {
      if (!data.isExpired) {
        ToastUtils.showCustomToast(
            context, data.error, Image.asset('assets/ic_error.png'), 'خطا');
      }
      return;
    }

    if (data.content.status != true) {
      ToastUtils.showCustomToast(context, data.content.description,
          Image.asset('assets/ic_error.png'));

      return;
    }
    nh.mru.addMru(type: MruType.sourceAccount, title: null, value: source);
    nh.mru
        .addMru(type: MruType.destinationIban, title: null, value: description);
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'انتقال پایا',
          cardNumber: source,
          stan: '',
          rrn: data.content.referenceId,
          topupPin: null,
          description: 'انتقال وجه پایا به شماره شبا: $destination',
          amount: amount,
          isShaparak: false,
        ),
      ),
    );
  }
}
