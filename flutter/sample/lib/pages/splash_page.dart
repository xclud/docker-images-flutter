import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/config.dart';
import 'package:novinpay/models/profile.dart';
import 'package:novinpay/pages/enter_password_page.dart';
import 'package:novinpay/pages/home_page.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/services/platform_helper.dart' as ph;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _hasPassword;
  //bool _loginIsExpire;
  int counter = 0;
  List<String> pin = [];
  bool _needPassWord = false;
  String _warning = '';

  @override
  void initState() {
    super.initState();
    if (appState.isSendAppOpen == false &&
        ph.getPlatform() != ph.PlatformType.web) {
      analytics.logAppOpen();
      appState.isSendAppOpen = true;
    }
    _checkCreditCardLogin();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final jwt = await appState.getJWT();
        if (jwt != null) {
          await _checkVersion();
        } else {
          await Navigator.of(context).pushReplacementNamed(routes.login);
        }
      },
    );

    nh.stream.listen((event) async {
      if (event.statusCode == 401) {
        await appState.setJWT(null);
        await Get.toNamed(routes.login);
      } else if (event.statusCode == 423) {
        analytics.logLock(phoneNumber: await appState.getPhoneNumber());
        await Get.toNamed(routes.password);
      }
    });
  }

  void _navigateToPassword() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => EnterPasswordPage()));
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(
          shouldAskForPassword: _needPassWord,
        ),
      ),
    );
  }

  Future<void> _checkVersion() async {
    setState(() {
      _warning = '';
    });

    final version = await nh.novinPay.application.checkVersion();

    if (version.hasErrors()) {
      _warning = strings.connectionError;
      setState(() {});
      return;
    } else {
      appState.supportedBins = version.content?.supportedBins;
      appState.novinMallLink = version.content?.novinMalUrl;

      if (version.content?.status == true) {
        _hasPassword = version.content.loginModel.loginEnable;
        //_loginIsExpire = version.content?.loginModel?.loginIsExpire ?? false;

        if (version.content.loginModel.loginType == null) {
          _needPassWord = true;
        }
        if (version.content.loginModel.loginType == LoginType.none.index) {
          _needPassWord = false;
        }

        final platform = ph.getPlatform();

        if (platform != ph.PlatformType.android) {
          if (_hasPassword != true) {
            _goToHome();
            return;
          }
          if (_hasPassword /*&& _loginIsExpire*/) {
            _navigateToPassword();
          } else {
            _goToHome();
          }
          return;
        } else {
          final link = version?.content?.link?.replaceAll('*', ':');
          final isForced = version?.content?.isForced ?? false;

          if (mounted && isForced) {
            await ph.showOtaUpdateDialog(
              context: context,
              link: link,
              forced: enforce_updates && (isForced),
            );
            return;
          }
          if (_hasPassword != true) {
            _goToHome();
            return;
          }
          if (_hasPassword /*&& _loginIsExpire*/) {
            _navigateToPassword();
          } else {
            _goToHome();
          }
        }
      } else {
        _warning = version.content.description;
        setState(() {});
      }
    }
  }

  Future<void> _checkCreditCardLogin() async {
    appState.creditCardLogin = await appState.getCreditCardLoginInfo() ?? false;
    appState.nationalCode = await appState.getNationalCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Column(
              children: [
                Image.asset('assets/logo/launch_image.png'),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_warning.isEmpty)
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(colors.primaryColor),
                    ),
                  if (_warning.isNotEmpty)
                    GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _warning ?? '',
                            style: colors
                                .boldStyle(context)
                                .copyWith(color: colors.red),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.refresh_outlined,
                            color: colors.red,
                          )
                        ],
                      ),
                      onTap: () async {
                        await _checkVersion();
                      },
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
