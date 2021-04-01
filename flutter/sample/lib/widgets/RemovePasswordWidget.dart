import 'package:flutter/material.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/space.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class RemovePasswordWidget extends StatefulWidget {
  @override
  _RemovePasswordWidgetState createState() => _RemovePasswordWidgetState();
}

class _RemovePasswordWidgetState extends State<RemovePasswordWidget>
    with AskYesNoMixin {
  final _pass = FocusNode();
  final _confirm = FocusNode();
  final _passWordController = TextEditingController();
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
          Expanded(
            child: Column(
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 8.0, bottom: 24.0),
            child: ConfirmButton(
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  final result = await askYesNo(
                    title: Text('حذف رمز عبور'),
                    content: Text('آیا از حذف رمز عبور اطمینان دارید؟'),
                  );

                  if (result != true) {
                    return;
                  }
                  final response = await Loading.run(
                      context,
                      nh.profile
                          .deActiveLogin(password: _passWordController.text));
                  if (!showConnectionError(context, response)) {
                    return;
                  }

                  if (response.content.status != true) {
                    ToastUtils.showCustomToast(
                        context, response.content.description);
                  }
                  if (response.content.status) {
                    ToastUtils.showCustomToast(context, 'رمز عبور حذف گردید');

                    await appState.setUserPassword(null);
                    analytics.logRemovePass(
                        phoneNumber: await appState.getPhoneNumber());
                    await appState.setFinger(false);
                    Navigator.of(context).pop(true);
                  }
                },
                child: Text('حذف رمز عبور')),
          )
        ],
      ),
    );
  }
}
