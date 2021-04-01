import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/account_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class IbanFromAccount extends StatefulWidget {
  @override
  _IbanFromAccountState createState() => _IbanFromAccountState();
}

class _IbanFromAccountState extends State<IbanFromAccount>
    with MruSelectionMixin, AccountSelection {
  final _accountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasIBAN = false;

  String _iban = '';

  @override
  Widget build(BuildContext context) {
    final message = Center(
      child: Text(
        'لطفا شماره حساب خود را وارد نمایید.',
        style: colors
            .regularStyle(context)
            .copyWith(color: colors.greyColor.shade900),
      ),
    );

    final form = Container(
      margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
      child: Form(
        key: _formKey,
        child: AccountTextFormField(
          controller: _accountController,
          showSelectionDialog: _showAccountSelectionDialog,
        ),
      ),
    );

    final result = Container(
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: DualListTile(
                start: Text(
                  strings.label_iban_number,
                  style: colors.boldStyle(context),
                ),
                end: FlatButton(
                  color: colors.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () => _saveIban(_iban, null),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                    child: Text('ذخیره',
                        style: colors
                            .bodyStyle(context)
                            .copyWith(color: Colors.white)),
                  ),
                ),
              )),
          Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 8, 0, 8),
                child: Text(
                  _iban?.withPersianNumbers() ?? '',
                  style: colors.boldStyle(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 8, 8, 8),
                child: IconButton(
                  onPressed: () => _copy(_iban),
                  icon: Icon(SunIcons.copy),
                ),
              )
            ],
          ),
        ],
      ),
    );
    return Split(
      header: form,
      child: Expanded(
        child:
            _hasIBAN == true ? SingleChildScrollView(child: result) : message,
      ),
      footer: Container(
        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
        child: ConfirmButton(
          onPressed: _submit,
          child: CustomText(
            strings.action_inquiry,
            textAlign: TextAlign.center,
          ),
          color: colors.ternaryColor,
        ),
      ),
    );
  }

  void _copy(String data) {
    Clipboard.setData(ClipboardData(text: data ?? '')).then((value) =>
        ToastUtils.showCustomToast(
            context, 'کپی شد', Image.asset('assets/ok.png')));
  }

  void _saveIban(String iban, String title) {
    nh.mru.addMru(type: MruType.sourceIban, title: title, value: iban);
    ToastUtils.showCustomToast(
        context, 'افزوده شد', Image.asset('assets/ok.png'));
  }

  void _showAccountSelectionDialog() async {
    final data = await showSourceAccountSelectionDialog();
    if (data == null) {
      return;
    }

    _accountController.text = data.value;
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _iban = null;
      _hasIBAN = false;
    });

    final account = _accountController.text;

    final data = await Loading.run(
      context,
      nh.boomMarket.getIban(
        deposit: account,
      ),
    );

    if (!showError(context, data)) {
      return;
    }
    nh.mru.addMru(type: MruType.sourceAccount, title: null, value: account);
    setState(() {
      _iban = data.content.ibanNumber;
      _hasIBAN = true;
    });
  }
}
