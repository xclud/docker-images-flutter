import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/config.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';
import 'package:sms_retriever_api/sms_retriever_api.dart';

final _smsRetrieverApi = SmsRetrieverApi();

enum LoginPageStatus {
  login,
  verification,
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage>
    with DisableManagerMixin, AskYesNoMixin {
  LoginPageStatus _loginStatus = LoginPageStatus.login;

  final _loginFormKey = GlobalKey<FormState>();
  final _verifyFormKey = GlobalKey<FormState>();
  final _mobileNumberController = TextEditingController();
  final _codeController = TextEditingController();
  final _recommenderCodeController = TextEditingController();
  bool _canUseRecommender = false;
  DateTime _insertedTime = DateTime.now();
  bool _isTimerActive = false;
  String _timerText;
  Timer _currentTimer;
  String _enteredPhoneNumber;
  String _askForRecommenderMessage = 'کد معرف دارید؟';

  void _onSmsReceived(String value) {
    final regexp = RegExp(r'(\d+)');
    final matches = regexp.allMatches(value).toList();

    if (matches.isNotEmpty) {
      if (matches[0].groupCount > 0) {
        _codeController.text = matches[0].group(1);

        _submitVerifyOTP(_codeController.text);
      }
    }
  }

  void _startSmsRetriever() async {
    if (getPlatform() == PlatformType.android) {
      _smsRetrieverApi.startListening(onReceived: _onSmsReceived);
    }
  }

  @override
  void initState() {
    super.initState();
    _startSmsRetriever();
  }

  @override
  void dispose() {
    //SmsRetriever.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: HeadedPage(
        hasAppBar: false,
        body: SafeArea(
          child: _loginStatus == LoginPageStatus.login
              ? _buildLoginForm()
              : _buildVerifyForm(),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Split(
        child: Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Space(4),
                FractionallySizedBox(
                  widthFactor: 0.25,
                  child: Image.asset('assets/logo/sun.png'),
                ),
                Space(4),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 240,
                    ),
                    child: CustomText(
                      'لطفا شماره موبایل خود را جهت ثبت نام وارد کنید.',
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
                    child: Column(
                      children: [
                        MobileTextFormField(
                          enabled: enabled,
                          controller: _mobileNumberController,
                        ),
                        Space(2),
                        if (!_canUseRecommender)
                          TextButton(
                            child: Text(
                              _askForRecommenderMessage,
                              style: colors.boldStyle(context).copyWith(
                                  decoration: TextDecoration.underline,
                                  color: colors.ternaryColor),
                            ),
                            onPressed: () async {
                              if (!_loginFormKey.currentState.validate()) {
                                return;
                              }
                              final response = await Loading.run(
                                  context,
                                  nh.novinPay.application.getRecommenderState(
                                      mobileNumber:
                                          _mobileNumberController.text));
                              if (!showError(context, response)) {
                                return;
                              }
                              if (response.content.status != true) {
                                ToastUtils.showCustomToast(
                                    context, response.content.description);
                                return;
                              }
                              if (response.content.status &&
                                  response.content.useRecommender == false) {
                                setState(() {
                                  _canUseRecommender = true;
                                });
                              }
                              if (response.content.status &&
                                  response.content.useRecommender) {
                                setState(() {
                                  _askForRecommenderMessage =
                                      'شما قبلا از کد معرف استفاده کرده اید.';
                                });
                              }
                            },
                          )
                        else
                          TextFormField(
                            enabled: enabled,
                            controller: _recommenderCodeController,
                            textDirection: TextDirection.ltr,
                            inputFormatters: digitsOnly(),
                            keyboardType: TextInputType.number,
                            maxLength: 11,
                            decoration: InputDecoration(
                              hintTextDirection: TextDirection.rtl,
                              labelText: 'کد معرف',
                              hintText: 'اختیاری',
                              counterText: '',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'نسخه $app_version',
                style: colors.bodyStyle(context),
              ),
              Space(2),
              FutureConfirmButton(
                child: Text('ارسال کد تایید'),
                onPressed: _submitRequestOTP,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyForm() {
    final mobileNumber = _mobileNumberController.text;

    return Form(
      key: _verifyFormKey,
      child: Split(
        child: Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Space(4),
                FractionallySizedBox(
                  widthFactor: 0.25,
                  child: Image.asset('assets/logo/sun.png'),
                ),
                Space(4),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 240,
                    ),
                    child: CustomText(
                      'لطفا کد تایید ارسال شده به شماره $mobileNumber را وارد نمایید.'
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
                    child: TextFormField(
                      enabled: enabled,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      textDirection: TextDirection.ltr,
                      inputFormatters: digitsOnly(),
                      controller: _codeController,
                      onChanged: (value) {
                        if (value.length == 6) {
                          _submitVerifyOTP(value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'کد تایید',
                        hintText: '۱۲۳۴۵۶',
                        hintTextDirection: TextDirection.ltr,
                        counterText: '',
                      ),
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
                                final phoneNumber =
                                    _mobileNumberController.text;

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
          child: _buildChangeNumberButton(),
        ),
      ),
    );
  }

  void _submitVerifyOTP(String pin) async {
    final mobileNumber = _mobileNumberController.text;
    final recommender = _recommenderCodeController.text;
    disable();

    final data = await nh.novinPay.application.verifyToken(
        mobileNumber: mobileNumber, token: pin, recommender: recommender);

    enable();

    if (!showError(context, data)) {
      _codeController.clear();
      return;
    }
    await appState.setJWT(data.content.token);
    analytics.logLogin(phoneNumber: await appState.getPhoneNumber());

    await Navigator.of(context).pushReplacementNamed(routes.splash);
  }

  Future<void> _submitRequestOTP() async {
    if (!_loginFormKey.currentState.validate()) {
      return;
    }

    final phoneNumber = _mobileNumberController.text;

    if (_enteredPhoneNumber != null &&
        _enteredPhoneNumber == phoneNumber &&
        DateTime.now().difference(_insertedTime).inMinutes < 2) {
      setState(() {
        _loginStatus = LoginPageStatus.verification;
      });
      return;
    }
    disable();

    final data = await nh.novinPay.application.requestToken(
      mobileNumber: phoneNumber,
    );

    enable();

    if (!showError(context, data)) {
      return;
    }
    _enteredPhoneNumber = _mobileNumberController.text;
    _insertedTime = DateTime.now();
    _startTimer();

    _loginStatus = LoginPageStatus.verification;
    setState(() {
      _isTimerActive = true;
      _insertedTime = DateTime.now();
    });
  }

  Widget _buildChangeNumberButton() {
    return ConfirmButton(
      color: colors.ternaryColor,
      onPressed: enabled
          ? () {
              _mobileNumberController.text = '';
              _recommenderCodeController.text = '';
              _codeController.text = '';
              _currentTimer?.cancel();
              setState(() {
                _isTimerActive = false;
                _loginStatus = LoginPageStatus.login;
              });
            }
          : null,
      child: CustomText(
        'تغییر شماره',
        textAlign: TextAlign.center,
      ),
    );
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
