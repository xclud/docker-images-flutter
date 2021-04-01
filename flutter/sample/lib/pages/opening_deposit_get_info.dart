import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novinpay/dialogs/account_type_dialog.dart';
import 'package:novinpay/mixins/account_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class OpeningDepositGetInfoPage extends StatefulWidget {
  OpeningDepositGetInfoPage({
    @required this.branchCode,
    @required this.accountType,
  });

  final int branchCode;
  final AccountType accountType;

  @override
  _OpeningDepositGetInfoPageState createState() =>
      _OpeningDepositGetInfoPageState();
}

class _OpeningDepositGetInfoPageState extends State<OpeningDepositGetInfoPage>
    with MruSelectionMixin, AccountSelection {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _withdrawAccountController = TextEditingController();
  final _dayController = TextEditingController();
  final _interestAccountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _withdrawAccountController.dispose();
    _interestAccountController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  String _dayValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'لطفا روز واریز سود را وارد نمایید';
    }

    final i = int.tryParse(value);

    if (i == null || i > 31 || i < 1) {
      return 'عدد وارد شده صحیح نیست';
    }

    return null;
  }

  void _showWithdrawAccountSelectionDialog() async {
    final data = await showSourceAccountSelectionDialog();
    if (data == null) {
      return;
    }

    _withdrawAccountController.text = data.value;
  }

  void _showInterestAccountSelectionDialog() async {
    final data = await showSourceAccountSelectionDialog();
    if (data == null) {
      return;
    }

    _interestAccountController.text = data.value;
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('افتتاح حساب'),
      body: Form(
        key: _formKey,
        child: Split(
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('برداشت از حساب جهت افتتاح حساب'),
                  AccountTextFormField(
                    controller: _withdrawAccountController,
                    showSelectionDialog: _showWithdrawAccountSelectionDialog,
                  ),
                  Space(),
                  Text('شماره حساب جهت واریز سود'),
                  AccountTextFormField(
                      controller: _interestAccountController,
                      showSelectionDialog: _showInterestAccountSelectionDialog),
                  Space(2),
                  Row(
                    children: [
                      Expanded(
                        child: Text('روز واریز سود'),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          validator: _dayValidator,
                          controller: _dayController,
                          inputFormatters: digitsOnly(),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Space(2),
                  Text('مبلغ جهت افتتاح حساب (حداقل ۵۰۰,۰۰۰ ریال)'),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MoneyTextFormField(
                        minimum: 500000,
                        controller: _amountController,
                      ),
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      side: BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          footer: ConfirmButton(
            child: CustomText(
              strings.action_ok,
              textAlign: TextAlign.center,
            ),
            onPressed: _submit,
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.boomMarket.openingDeposit(
        depositBranchCode: widget.branchCode,
        withdrawableAmount:
            int.tryParse(_amountController.text.replaceAll(',', '')),
        withdrawableDeposit:
            _withdrawAccountController.text.replaceAll('-', ''),
        accountType: widget.accountType,
        interestSettlementDay: int.tryParse(_dayController.text),
      ),
    );

    if (!showError(context, data)) {
      return;
    }

    ToastUtils.showCustomToast(
      context,
      'حساب با موفقیت افتتاح گردید',
      Image.asset('assets/ok.png'),
    );
    nh.mru.addMru(
        type: MruType.sourceAccount,
        title: null,
        value: data.content.depositNumber);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('افتتاح حساب'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DualListTile(
              start: Text(strings.label_account_number),
              end: Text(data.content.depositNumber?.withPersianLetters() ?? ''),
            ),
            DualListTile(
              start: Text('پشتیبانی'),
              end: Text('${lrm}021-48320000'.withPersianNumbers()),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('بازگشت'),
          ),
          TextButton(
            onPressed: () async {
              await Clipboard.setData(
                  ClipboardData(text: data.content.depositNumber ?? ''));
              ToastUtils.showCustomToast(
                  context, 'کپی شد', Image.asset('assets/ok.png'));
            },
            child: Text('کپی'),
          ),
        ],
      ),
    );
  }
}
