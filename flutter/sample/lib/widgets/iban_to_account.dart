import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/iban_selection.dart';
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

class IbanToAccount extends StatefulWidget {
  @override
  _IbanToAccountState createState() => _IbanToAccountState();
}

class _IbanToAccountState extends State<IbanToAccount>
    with MruSelectionMixin, IbanSelection {
  final _ibanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _hasAccount = false;

  String _account = '';

  @override
  Widget build(BuildContext context) {
    final form = Container(
      margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
      child: Form(
        key: _formKey,
        child: IbanTextFormField(
          controller: _ibanController,
          showSelectionDialog: _showIbanSelectionDialog,
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
                  strings.label_account_number,
                  style: colors.boldStyle(context),
                ),
                end: FlatButton(
                  color: colors.accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () => _saveIban(_account, null),
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
                padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                child: Text(
                  _account?.withPersianNumbers() ?? '',
                  style: colors.boldStyle(context),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                child: IconButton(
                  onPressed: () => _copy(_account),
                  icon: Icon(SunIcons.copy),
                ),
              )
            ],
          ),
        ],
      ),
    );

    final message = Center(
      child: Text(
        'لطفا شماره شبا خود را وارد نمایید.',
        style: colors
            .regularStyle(context)
            .copyWith(color: colors.greyColor.shade900),
      ),
    );

    return Split(
      header: form,
      child: Expanded(
        child: _hasAccount == true
            ? SingleChildScrollView(child: result)
            : message,
      ),
      footer: Container(
        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
        child: ConfirmButton(
          child: CustomText(
            strings.action_inquiry,
            textAlign: TextAlign.center,
          ),
          onPressed: _submit,
          color: colors.ternaryColor,
        ),
      ),
    );
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

    setState(() {
      _account = null;
      _hasAccount = false;
    });

    final data = await Loading.run(
      context,
      nh.boomMarket.getDeposit(
        iban: _ibanController.text,
      ),
    );

    if (!showError(context, data)) {
      return;
    }
    nh.mru.addMru(
        type: MruType.sourceIban, title: null, value: _ibanController.text);
    setState(() {
      _account = data.content.depositNumber;
      _hasAccount = true;
    });
  }

  void _copy(String data) {
    Clipboard.setData(ClipboardData(text: data ?? '')).then((value) =>
        ToastUtils.showCustomToast(
            context, 'کپی شد', Image.asset('assets/ok.png')));
  }

  void _saveIban(String iban, String title) {
    nh.mru.addMru(type: MruType.sourceAccount, title: title, value: iban);
    ToastUtils.showCustomToast(
        context, 'افزوده شد', Image.asset('assets/ok.png'));
  }
}
