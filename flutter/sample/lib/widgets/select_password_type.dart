import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/pages/RemovePasswordPage.dart';
import 'package:novinpay/pages/set_or_change_password_page.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/general/general.dart';

class SelectPasswordType extends StatefulWidget {
  @override
  _SelectPasswordTypeState createState() => _SelectPasswordTypeState();
}

class _SelectPasswordTypeState extends State<SelectPasswordType> {
  bool _hasFinger = false;
  bool _hasPassword = false;
  bool _canCheckBioMetric = false;

  final LocalAuthentication auth = LocalAuthentication();
  final bool _isNotWeb = getPlatform() != PlatformType.web;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getPrefPasswords();
    });
  }

  void getPrefPasswords() async {
    if (_isNotWeb) {
      _canCheckBioMetric = await auth.canCheckBiometrics;
    }
    _hasFinger = await appState.getFinger() ?? false;
    _hasPassword = await appState.checkUserHasPassword() ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('تنظیمات ورود'),
      body: Center(
        child: Container(
          child: Column(
            children: [
              GestureDetector(
                  onTap: () async {
                    final set = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (context) {
                          return SetOrChangePasswordPage(
                              hasPassword: _hasPassword);
                        },
                      ),
                    );
                    if (set ?? false) {
                      _hasPassword = true;
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: 60,
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
                    margin: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                    decoration: BoxDecoration(
                      color: colors.greyColor.shade600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DualListTile(
                      start: Row(
                        children: [
                          Icon(
                            SunIcons.lock,
                            color: colors.primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text(
                            _hasPassword ? 'تغییر رمز ورود' : 'تنظیم رمز ورود',
                          ),
                        ],
                      ),
                      end: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                  )),
              if (_hasPassword)
                GestureDetector(
                    onTap: () async {
                      final set = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                          builder: (context) {
                            return RemovePasswordPage(
                                hasPassword: _hasPassword);
                          },
                        ),
                      );
                      if (set ?? false) {
                        _hasPassword = false;
                        _hasFinger = false;
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: 60,
                      padding: EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
                      margin: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                      decoration: BoxDecoration(
                        color: colors.greyColor.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DualListTile(
                        start: Row(
                          children: [
                            Icon(
                              SunIcons.delete_lock,
                              color: colors.primaryColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'حذف رمز ورود',
                            ),
                          ],
                        ),
                        end: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                        ),
                      ),
                    )),
              if (_isNotWeb && _canCheckBioMetric && _hasPassword)
                Container(
                  height: 60,
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
                  margin: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                  decoration: BoxDecoration(
                    color: colors.greyColor.shade600,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DualListTile(
                    start: Row(
                      children: [
                        Icon(
                          Icons.fingerprint,
                          color: colors.primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'ورود با اثر انگشت',
                        ),
                      ],
                    ),
                    end: Switch(
                      value: _hasFinger,
                      onChanged: (bool state) {
                        if (state && !_hasPassword) {
                          ToastUtils.showCustomToast(
                              context,
                              'لطفا قبل از فعالسازی ورود با اثر انگشت، رمز ورود تنظیم کنید.',
                              Image.asset('assets/ic_error.png'),
                              'اخطار');
                        } else {
                          appState.setFinger(state);
                          setState(() {
                            _hasFinger = state;
                          });
                        }
                      },
                    ),
                  ),
                ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          padding: EdgeInsets.all(24),
        ),
      ),
    );
  }
}
