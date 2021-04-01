import 'package:flutter/material.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/space.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class ChangePasswordWidget extends StatefulWidget {
  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  final _pass = FocusNode();
  final _confirm = FocusNode();
  final _button = FocusNode();
  final _oldPassWordController = TextEditingController();
  final _newPassWordController = TextEditingController();
  final _newPassWordConfirmController = TextEditingController();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PasswordTextFormField(
                    validator: _passWordValidator,
                    onEditingComplete: () {
                      _pass.unfocus();
                      _confirm.requestFocus();
                    },
                    // inputFormatters: digitsOnly(),
                    keyboardType: TextInputType.number,
                    controller: _oldPassWordController,
                    // obscureText: _obscureText,
                    textDirection: TextDirection.ltr,
                    // decoration: InputDecoration(
                    //     counterText: '',
                    //     suffixIcon: IconButton(
                    //       onPressed: _toggle,
                    //       icon: _obscureText
                    //           ? Icon(
                    //               Icons.remove_red_eye,
                    //               color: colors.accentColor.shade200,
                    //             )
                    //           : Icon(
                    //               Icons.remove_red_eye,
                    //               color: colors.accentColor,
                    //             ),
                    //     ),
                    //     hintTextDirection: TextDirection.rtl,
                    //     hintText: '1234'.withPersianNumbers(),
                    //     labelText: 'رمز قبلی'),
                    hintText: '1234'.withPersianNumbers(),
                    labelText: 'رمز قبلی',
                    maxLength: 4,
                  ),
                  Space(2),
                  PasswordTextFormField(
                    validator: _passWordValidator,
                    onEditingComplete: () {
                      _pass.unfocus();
                      _confirm.requestFocus();
                    },
                    // inputFormatters: digitsOnly(),
                    keyboardType: TextInputType.number,
                    controller: _newPassWordController,
                    // obscureText: _obscureText,
                    textDirection: TextDirection.ltr,
                    // decoration: InputDecoration(
                    //     counterText: '',
                    //     suffixIcon: IconButton(
                    //       onPressed: _toggle,
                    //       icon: _obscureText
                    //           ? Icon(
                    //               Icons.remove_red_eye,
                    //               color: colors.accentColor.shade200,
                    //             )
                    //           : Icon(
                    //               Icons.remove_red_eye,
                    //               color: colors.accentColor,
                    //             ),
                    //     ),
                    //     hintTextDirection: TextDirection.rtl,
                    //     hintText: '1234'.withPersianNumbers(),
                    //     labelText: 'رمز ورود جدید'),
                    hintText: '1234'.withPersianNumbers(),
                    labelText: 'رمز ورود جدید',
                    maxLength: 4,
                  ),
                  Space(2),
                  PasswordTextFormField(
                    validator: _passWordValidator,
                    onEditingComplete: () {
                      _confirm.unfocus();
                      _button.requestFocus();
                    },
                    controller: _newPassWordConfirmController,
                    keyboardType: TextInputType.number,
                    // obscureText: true,
                    textDirection: TextDirection.ltr,
                    hintText: '1234'.withPersianNumbers(),
                    labelText: 'تکرار رمز ورود جدید',
                    maxLength: 4,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 8.0, bottom: 24.0),
            child: ConfirmButton(
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  if (_newPassWordConfirmController.text ==
                      _newPassWordController.text) {
                    final response = await Loading.run(
                        context,
                        nh.profile.changePassword(
                          oldPassword: _oldPassWordController.text,
                          newPassword: _newPassWordController.text,
                          confirmNewPassword:
                              _newPassWordConfirmController.text,
                        ));
                    if (!showConnectionError(context, response)) {
                      return;
                    }

                    if (!response.content.status) {
                      ToastUtils.showCustomToast(
                          context, response.content.description);
                    } else {
                      ToastUtils.showCustomToast(
                          context, 'رمز عبور با موفقیت تغییر کرد');
                      await appState
                          .setUserPassword(_newPassWordController.text);
                      analytics.logChangePass(
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
                child: Text('تایید رمز عبور')),
          ),
        ],
      ),
    );
  }
}
