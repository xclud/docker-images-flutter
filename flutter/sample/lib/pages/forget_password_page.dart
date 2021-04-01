import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

enum ForgetPasswordStatus {
  getMobileNumber,
  getNewPassword,
}

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() {
    return _ForgetPasswordState();
  }
}

class _ForgetPasswordState extends State<ForgetPassword>
    with DisableManagerMixin, AskYesNoMixin {
  final _verifyFormKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmNewPassController = TextEditingController();

  DateTime _insertedTime;

  bool _isTimerActive = false;
  String _timerText;
  Timer _currentTimer;
  String phoneNumber = '';

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'وارد نمایید';
    }

    if (value.length != 4) {
      return 'معتبر نیست';
    }
    return null;
  }

  String _otpValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'وارد نمایید';
    }

    if (value.length != 6) {
      return 'معتبر نیست';
    }
    return null;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _getPhoneNumber();
      _submitRequestOTP();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      hasAppBar: false,
      body: SafeArea(
        child: _buildGetNewPasswordForm(),
      ),
    );
  }

  Widget _buildGetNewPasswordForm() {
    return Form(
      key: _verifyFormKey,
      child: Split(
        child: Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Space(3),
                Image.asset('assets/logo/sun.png'),
                Space(4),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 240,
                    ),
                    child: CustomText(
                      'لطفا کد تایید ارسال شده به شماره $phoneNumber را وارد نمایید.'
                          .withPersianNumbers()
                          .withPersianNumbers(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Space(4),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 240,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: PasswordTextFormField(
                      validator: _otpValidator,
                      enabled: enabled,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      controller: _codeController,
                      labelText: 'کد تایید',
                      hintText: '۱۲۳۴۵۶',
                    ),
                  ),
                ),
                Space(2),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 240,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: PasswordTextFormField(
                      validator: _validator,
                      enabled: enabled,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      controller: _newPassController,
                      labelText: 'رمز ورود جدید',
                      hintText: '۱۲۳۴',
                    ),
                  ),
                ),
                Space(2),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 240,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: PasswordTextFormField(
                      validator: _validator,
                      enabled: enabled,
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      controller: _confirmNewPassController,
                      labelText: 'تایید رمز ورود',
                      hintText: '۱۲۳۴',
                    ),
                  ),
                ),
                Space(2),
                if (_isTimerActive == true) Text(_timerText ?? ''),
                if (_isTimerActive != true)
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 240,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FutureOutlineButton(
                        child: Text('ارسال مجدد'),
                        color: colors.ternaryColor,
                        onPressed: enabled
                            ? () async {
                                await nh.novinPay.application.requestToken(
                                  mobileNumber: phoneNumber,
                                );

                                _startTimer();
                              }
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ConfirmButton(
            color: colors.ternaryColor,
            onPressed: enabled
                ? () {
                    if (_verifyFormKey.currentState.validate()) {
                      _submitVerifyOTP();
                    }
                  }
                : null,
            child: CustomText(
              'تایید',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _submitVerifyOTP() async {
    if (_newPassController.text != _confirmNewPassController.text) {
      ToastUtils.showCustomToast(context, 'تایید رمز مطابقت ندارد',
          Image.asset('assets/ic_error.png'), 'خطا');
    } else {
      disable();

      final data = await nh.novinPay.application.forgetPassword(
        otp: _codeController.text,
        newPassword: _newPassController.text,
        confirmNewPassword: _confirmNewPassController.text,
      );

      if (!showError(context, data)) {
        setState(() {
          _codeController.clear();
          enable();
          _isTimerActive = false;
        });
        return;
      }
      if (data.content.status) {
        ToastUtils.showCustomToast(context, 'رمز عبور با موفقیت تغییر کرد');
        analytics.logForgetPass(phoneNumber: await appState.getPhoneNumber());
        await appState.setUserPassword(_newPassController.text);
        await Navigator.of(context).pushReplacementNamed(routes.password);
      }
    }
  }

  Future<void> _getPhoneNumber() async {
    phoneNumber = await appState.getPhoneNumber();
    setState(() {});
  }

  Future<void> _submitRequestOTP() async {
    if (phoneNumber != null &&
        _insertedTime != null &&
        DateTime.now().difference(_insertedTime).inMinutes < 2) {
      enable();
      setState(() {});
      return;
    }

    final data = await Loading.run(
      context,
      nh.novinPay.application.requestToken(
        mobileNumber: phoneNumber,
      ),
    );

    if (!showError(context, data)) {
      return;
    }
    if (data.content.status != null && data.content.status != true) {
      ToastUtils.showCustomToast(
          context, 'خطا در ارسال کد تایید لطفا مجدد اقدام کنید');
    }
    if (data.content.status) {
      enable();
      ToastUtils.showCustomToast(context, 'کد تایید با موفقیت ارسال شد');
      _insertedTime = DateTime.now();
      _startTimer();
      setState(() {
        _isTimerActive = true;
        _insertedTime = DateTime.now();
      });
    }
  }

  void _startTimer() {
    _isTimerActive = true;
    if (mounted) {
      setState(() {});
    }

    _currentTimer?.cancel();

    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final wait = Duration(seconds: 120);

    final end = DateTime.now().add(wait);
    String twoDigitMinutes =
        twoDigits(wait.inMinutes.remainder(Duration.minutesPerHour).toInt());
    String twoDigitSeconds =
        twoDigits(wait.inSeconds.remainder(Duration.secondsPerMinute).toInt());

    if (mounted) {
      setState(() {
        _timerText = '$twoDigitMinutes:$twoDigitSeconds'.withPersianNumbers();
      });
    }

    _currentTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(end)) {
        timer.cancel();
        _isTimerActive = false;
      } else {
        final diff = end.difference(now);
        String twoDigitMinutes = twoDigits(
            diff.inMinutes.remainder(Duration.minutesPerHour).toInt());
        String twoDigitSeconds = twoDigits(
            diff.inSeconds.remainder(Duration.secondsPerMinute).toInt());

        _timerText = '$twoDigitMinutes:$twoDigitSeconds'.withPersianNumbers();
        _isTimerActive = true;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }
}
