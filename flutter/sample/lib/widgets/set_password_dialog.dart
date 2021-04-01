import 'package:flutter/material.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/models/profile.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/space.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class SetPasswordDialog extends StatefulWidget {
  @override
  _SetPasswordDialogState createState() => _SetPasswordDialogState();
}

class _SetPasswordDialogState extends State<SetPasswordDialog> {
  final _pass = FocusNode();
  final _confirm = FocusNode();
  final _button = FocusNode();
  final _passWordController = TextEditingController();
  final _passWordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _passWordValidator(String value) {
    if (value == null || value.isEmpty) {
      return strings.validation_should_not_be_empty;
    }
    if (value.length < 4 || value.length > 4) {
      return 'رمز عبور باید چهار رقمی باشد';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Space(1),
                PasswordTextFormField(
                  validator: _passWordValidator,
                  onEditingComplete: () {
                    _pass.unfocus();
                    _confirm.requestFocus();
                  },
                  keyboardType: TextInputType.number,
                  controller: _passWordController,
                  textDirection: TextDirection.ltr,
                  hintText: '1234'.withPersianNumbers(),
                  labelText: 'رمز ورود',
                  maxLength: 4,
                ),
                Space(2),
                PasswordTextFormField(
                  validator: _passWordValidator,
                  onEditingComplete: () {
                    _confirm.unfocus();
                    _button.requestFocus();
                  },
                  controller: _passWordConfirmController,
                  keyboardType: TextInputType.number,
                  textDirection: TextDirection.ltr,
                  hintText: '1234'.withPersianNumbers(),
                  labelText: 'تکرار رمز ورود',
                  maxLength: 4,
                ),
                Space(1),
              ],
            ),
          ),
          ConfirmButton(
              onPressed: () async {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                if (_passWordConfirmController.text ==
                    _passWordController.text) {
                  final response = await Loading.run(
                      context,
                      nh.profile.activeLogin(
                          password: _passWordController.text,
                          loginType: LoginType.password));
                  if (!showConnectionError(context, response)) {
                    return;
                  }

                  if (response.content.status != true) {
                    ToastUtils.showCustomToast(context, 'رمز ثبت نشد!');
                  }
                  if (response.content.status) {
                    ToastUtils.showCustomToast(
                        context, 'رمز عبور با موفقیت ثبت گردید');
                    await appState.setUserPassword(_passWordController.text);
                    analytics.logAddPass(
                        phoneNumber: await appState.getPhoneNumber());
                    Navigator.of(context).pop(true);
                  }
                } else {
                  ToastUtils.showCustomToast(
                      context,
                      'رمز عبور و تکرار آن با هم مطابقت ندارند',
                      Image.asset('assets/ic_error.png'),
                      'خطا');
                }
              },
              child: Text('تایید رمز عبور'))
        ],
      ),
    );
  }
}
