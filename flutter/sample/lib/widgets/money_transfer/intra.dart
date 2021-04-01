import 'package:flutter/material.dart';
import 'package:novinpay/dialogs/intra_transfer_confirm_dialog.dart';
import 'package:novinpay/mixins/account_selection.dart';
import 'package:novinpay/mixins/bank_login.dart';
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

class IntraBankMoneyTransfer extends StatefulWidget {
  @override
  _IntraBankMoneyTransferState createState() => _IntraBankMoneyTransferState();
}

class _IntraBankMoneyTransferState extends State<IntraBankMoneyTransfer>
    with BankLogin, MruSelectionMixin, AccountSelection {
  final _formKey = GlobalKey<FormState>();
  final _accountSrcController = TextEditingController();
  final _accountDstController = TextEditingController();
  final _amountController = TextEditingController();
  final _sourceDescriptionController = TextEditingController();
  final _destinationDescriptioncontroller = TextEditingController();

  String _description1Validator(String value) {
    // if (value == null || value.isEmpty) {
    //   return 'توضیحات را وارد نمایید.';
    // }
    return null;
  }

  String _description2Validator(String value) {
    // if (value == null || value.isEmpty) {
    //   return 'توضیحات برای حساب مقصد را وارد نمایید.';
    // }
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
                    labelText: 'حساب مبدا',
                    controller: _accountSrcController,
                    showSelectionDialog: _showSourceSelectionDialog,
                  ),
                  Space(2),
                  AccountTextFormField(
                    labelText: 'حساب مقصد',
                    controller: _accountDstController,
                    showSelectionDialog: _showDestinationSelectionDialog,
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
                    validator: _description1Validator,
                    controller: _sourceDescriptionController,
                    decoration: InputDecoration(
                      hintText: 'توضیحات برای حساب مبدا',
                      labelText: 'توضیحات مبدا',
                    ),
                  ),
                  Space(2),
                  TextFormField(
                    controller: _destinationDescriptioncontroller,
                    validator: _description2Validator,
                    decoration: InputDecoration(
                      hintText: 'توضیحات برای حساب مقصد',
                      labelText: 'توضیحات مقصد',
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

  void _showSourceSelectionDialog() async {
    final data = await showSourceAccountSelectionDialog();
    if (data == null) {
      return;
    }

    _accountSrcController.text = data.value;
  }

  void _showDestinationSelectionDialog() async {
    final data = await showDestinationAccountSelectionDialog();
    if (data == null) {
      return;
    }

    _accountDstController.text = data.value;
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

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final source = _accountSrcController.text;
    final destination = _accountDstController.text;

    final amount =
        int.tryParse(_amountController.text?.replaceAll(',', '') ?? '');
    var description1 = _sourceDescriptionController.text;
    var description2 = _destinationDescriptioncontroller.text;

    if (description1 == null || description1.isEmpty) {
      description1 = 'وب اپ سان';
    }
    if (description2 == null || description2.isEmpty) {
      description2 = 'وب اپ سان';
    }

    final name = '';

    final result = await showCustomBottomSheet<bool>(
      context: context,
      child: IntraTransferConfirmDialog(
        name: name,
        source: source,
        destination: destination,
        amount: amount,
        description1: description1,
        description2: description2,
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
      nh.boomMarket.normalTransfer(
        sourceDeposit: source,
        destinationDeposit: destination,
        sourceComment: description1,
        destinationComment: description2,
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
    nh.mru.addMru(type: MruType.sourceAccount, title: null, value: source);
    nh.mru.addMru(
        type: MruType.destinationAccount, title: null, value: destination);

    if (data.content.status != true) {
      ToastUtils.showCustomToast(context, data.content.description,
          Image.asset('assets/ic_error.png'));

      return;
    }

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'انتقال درون بانکی',
          cardNumber: source,
          stan: data.content.trackingCode,
          topupPin: null,
          description: 'انتقال وجه درون بانکی به شماره حساب: $lrm$destination',
          amount: amount,
          isShaparak: false,
        ),
      ),
    );
  }
}
