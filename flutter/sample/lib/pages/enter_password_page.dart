import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/config.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/pages/home_page.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/space.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';
import 'package:url_launcher/url_launcher.dart';

class EnterPasswordPage extends StatefulWidget {
  EnterPasswordPage();

  @override
  _EnterPasswordPageState createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage>
    with AskYesNoMixin {
  int counter = 0;
  String _warning;
  List<String> pin = [];
  bool _isTouched = false;
  bool _isNotWeb = false;
  bool _touchEnabled = false;
  bool _hasPass = false;
  String _phoneNumber = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _isNotWeb = getPlatform() != PlatformType.web;
        checkFingerEnable();
      });
    });
    super.initState();
  }

  Future<void> checkFingerEnable() async {
    _phoneNumber = await appState.getPhoneNumber();
    _touchEnabled = await appState.getFinger() ?? false;
    _hasPass = await appState.checkUserHasPassword();

    if (_isNotWeb && _touchEnabled && _hasPass) {
      _authenticate();
    }
  }

  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Split(
          child: Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(children: [
                  Space(4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        SunIcons.lock,
                        size: 20,
                        color: colors.primaryColor.shade300,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'رمز عبور را وارد نمایید',
                        style: colors
                            .regularStyle(context)
                            .copyWith(color: colors.primaryColor.shade300),
                      ),
                    ],
                  ),
                  Space(),
                  GestureDetector(
                      onTap: _changeNumber,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تغییر شماره',
                            style: colors
                                .regularStyle(context)
                                .copyWith(color: colors.primaryColor),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            _phoneNumber?.withPersianNumbers() ?? '',
                            style: colors.tabStyle(context).copyWith(
                                decoration: TextDecoration.underline,
                                color: colors.primaryColor),
                          )
                        ],
                      )),
                  Space(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors.greyColor.shade600,
                        ),
                        child: Center(
                          child: Text(counter < 4 ? '-' : '*',
                              style: colors.keypadStyle(context)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 56,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors.greyColor.shade600,
                        ),
                        child: Center(
                          child: Text(counter < 3 ? '-' : '*',
                              style: colors.keypadStyle(context)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 56,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors.greyColor.shade600,
                        ),
                        child: Center(
                          child: Text(counter < 2 ? '-' : '*',
                              style: colors.keypadStyle(context)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Container(
                        width: 56,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colors.greyColor.shade600,
                        ),
                        child: Center(
                          child: Text(counter < 1 ? '-' : '*',
                              style: colors.keypadStyle(context)),
                        ),
                      ),
                    ],
                  ),
                  Space(2),
                  if (_warning != null && _warning.isNotEmpty)
                    Text(
                      _warning,
                      style:
                          colors.bodyStyle(context).copyWith(color: colors.red),
                    ),
                  Space(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _addToPin('3'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('3'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () => _addToPin('2'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('2'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () => _addToPin('1'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('1'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Space(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _addToPin('6'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('6'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () => _addToPin('5'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('5'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () => _addToPin('4'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('4'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Space(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _addToPin('9'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('9'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () => _addToPin('8'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('8'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () => _addToPin('7'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('7'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Space(2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _remove,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Icon(
                            Icons.backspace_outlined,
                            textDirection: TextDirection.ltr,
                          ),
                          //   onTap: _remove,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () => _addToPin('0'),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.greyColor.shade600,
                          ),
                          child: Center(
                            child: Text('0'.withPersianNumbers(),
                                style: colors.keypadStyle(context)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      GestureDetector(
                        onTap: () async {
                          final enable = await canScanFingerPrint();
                          if (enable) {
                            _authenticate();
                          } else {
                            _cancelAuthentication();
                          }
                        },
                        child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colors.greyColor.shade600,
                            ),
                            child: _isNotWeb
                                ? Icon(
                                    Icons.fingerprint,
                                  )
                                : Container()),
                      ),
                    ],
                  ),
                  Space(2),
                  TextButton(
                    child: Text(
                      'رمز عبور را فراموش کرده اید؟',
                      style: colors
                          .regularStyle(context)
                          .copyWith(color: colors.primaryColor),
                    ),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(routes.forgetPassword),
                  ),
                  Space(),
                ]),
              ),
            ),
          ),
          footer: Column(
            children: [
              GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.help_outline_rounded,
                        color: colors.accentColor,
                        textDirection: TextDirection.ltr),
                    SizedBox(
                      width: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'پشتیبانی:',
                          style: colors.tabStyle(context).copyWith(
                                color: colors.accentColor,
                              ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(support_phone.withPersianNumbers(),
                            style: colors.tabStyle(context).copyWith(
                                  color: colors.accentColor,
                                  decoration: TextDecoration.underline,
                                ))
                      ],
                    )
                  ],
                ),
                onTap: () => launch('tel:$support_phone'),
              ),
              Space(2)
            ],
          ),
        ),
        onWillPop: () => Future.value(false),
      ),
    );
  }

  Future<void> login(String password) async {
    final response =
        await Loading.run(context, nh.profile.login(password: password));
    if (response.statusCode == 307) {
      /// user enter wrong password too much
      _showForgetPassDialog();
    } else if (!showConnectionError(context, response)) {
      return;
    } else {
      if (response.content.status != true) {
        ToastUtils.showCustomToast(context, 'رمز وارد شده صحیح نمی باشد!',
            Image.asset('assets/ic_error.png'), 'خطا');
        setState(() {
          pin.clear();
          counter = pin.length;
        });
      }
      if (response.content.status == true) {
        appState.setFinger(true);
        appState.setUserPassword(password);
        analytics.logUnlock(phoneNumber: await appState.getPhoneNumber());
        _goToHome();
      }
    }
  }

  void _addToPin(String value) async {
    if (pin.length < 4) {
      pin.add(value);
    }
    setState(() {
      counter = pin.length;
    });
    if (pin.length == 4) {
      login(pin[0] + pin[1] + pin[2] + pin[3]);
    }
  }

  void _remove() {
    if (pin.isNotEmpty) {
      pin.removeLast();
    }
    setState(() {
      counter = pin.length;
    });
  }

  void _authenticate() async {
    AndroidAuthMessages androidAuthMessages = AndroidAuthMessages(
      biometricHint: strings.fingerprintHint,
      biometricNotRecognized: strings.fingerprintNotRecognized,
      cancelButton: strings.enterPasswordButton,
      biometricRequiredTitle: strings.fingerprintRequiredTitle,
      biometricSuccess: strings.fingerprintSuccess,
      goToSettingsButton: strings.goToSettingsButton,
      goToSettingsDescription: strings.goToSettingsDescription,
      signInTitle: strings.signInTitle,
    );
    IOSAuthMessages iosAuthMessages = IOSAuthMessages(
      lockOut: strings.lockOut,
      goToSettingsDescription: strings.goToSettingsDescription,
      goToSettingsButton: strings.goToSettingsButton,
      cancelButton: strings.enterPasswordButton,
    );
    final canCheckBiometrics = await auth.canCheckBiometrics;
    if (canCheckBiometrics) {
      bool authenticated = false;
      try {
        setState(() {
          _isTouched = true;
        });
        authenticated = await auth.authenticate(
            localizedReason: 'اثر انگشت خود را اسکن کنید',
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
            androidAuthStrings: androidAuthMessages,
            iOSAuthStrings: iosAuthMessages);
        setState(() {
          _isTouched = false;
        });
      } on PlatformException {
        //
      }
      if (!mounted) return;

      if (authenticated) {
        final password = await appState.getPassword();
        if (password != null && password.length == 4) {
          login(password);
        }
      }
    } else {
      ToastUtils.showCustomToast(
          context, 'دستگاه شما امکان اسکن اثر انگشت را ندارد');
    }
  }

  void _cancelAuthentication() {
    debugPrint('stopAuthentication: stopAuthentication');
    ToastUtils.showCustomToast(
      context,
      'تعداد تلاش بیش از حد مجاز است',
      Image(
        image: AssetImage('assets/ic_error.png'),
      ),
    );
    auth.stopAuthentication();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => HomePage(
                shouldAskForPassword: false,
              )),
    );
  }

  Future<bool> canScanFingerPrint() async {
    if (!_isNotWeb) {
      ToastUtils.showCustomToast(
          context,
          'برای استفاده از اثرانگشت نسخه اندروید را استفاده نمایید',
          Image(image: AssetImage('assets/ic_error.png')),
          'اخطار');
      return false;
    }
    if (!_touchEnabled) {
      ToastUtils.showCustomToast(
          context,
          'لطفا پس از ورود از طریق تنظیمات امکان ورود با اثر انگشت را فعال کنید ',
          Image(image: AssetImage('assets/ic_error.png')),
          'اخطار');
      return false;
    }
    if (!_isTouched && _hasPass) {
      return true;
    }
    return false;
  }

  Future<dynamic> _showForgetPassDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'بدلیل بیش از حد مجاز وارد کردن رمز لطفا از طریق فراموشی رمز آنرا بازیابی کنید.',
              textAlign: TextAlign.center,
            ),
            Space(3),
            ConfirmButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(routes.forgetPassword);
              },
              child: Text('فراموشی رمز'),
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }

  void _changeNumber() async {
    final result = await askYesNo(
      title: null,
      content: Column(
        children: [
          Text(
            'آیا از تغییر شماره اطمینان دارید؟',
            textAlign: TextAlign.center,
          ),
          Space(2)
        ],
      ),
    );

    if (result != true) {
      return;
    }

    await appState.setUserPassword(null);
    await appState.setFinger(null);
    await appState.setJWT(null);
    await Navigator.of(context).popUntil((r) => true);
    await Navigator.of(context).pushNamed(routes.login);
  }
}
