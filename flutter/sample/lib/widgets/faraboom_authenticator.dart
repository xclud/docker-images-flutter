import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/bank_login.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';

class FaraboomAuthenticator extends StatefulWidget {
  //final FaraboomLoginController controller;
  FaraboomAuthenticator({
    @required this.child,
    @required this.route,
  });

  final Widget child;
  final String route;

  @override
  State<StatefulWidget> createState() => _FaraboomAuthenticatorState();
}

class _FaraboomAuthenticatorState extends State<FaraboomAuthenticator>
    with BankLogin {
  String state;
  String code;
  int _page;
  bool _loading = false;
  bool _isError = false;
  String _errorText;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _processArgs();
      _checkLogin();
    });
  }

  void _checkLogin() async {
    final login = await appState.getBankLoginInfo();

    if (login.code == null || login.state == null || login.expires == null) {
      _showDialog();
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    if (now >= login.expires) {
      _showDialog();
    }
  }

  void _showDialog() {
    bool _allowPop = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () => Future.value(_allowPop),
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'کاربر گرامی، انجام عملیات بانکی نیازمند احراز هویت در سامانه بانکی است',
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          elevation: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              'ورود به بانک',
                              style: colors
                                  .boldStyle(context)
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          onPressed: () async {
                            final result = await ensureBankLogin(widget.route);

                            if (result != null) {
                              _allowPop = true;
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  color: colors.ternaryColor, width: 2)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Text(
                              'انصراف',
                              style: colors
                                  .regularStyle(context)
                                  .copyWith(color: colors.ternaryColor),
                            ),
                          ),
                          onPressed: () {
                            _allowPop = true;

                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed(
                                routes.home,
                                arguments: {'selectedPage': _page ?? 2});
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          );
        });
  }

  Future<void> _processArgs() async {
    final args = ModalRoute.of(context).settings.arguments;
    if (args == null) {
      return;
    }

    if (args is Map<String, Object>) {
      final state = int.tryParse(args['state']?.toString() ?? '');
      final code = args['code'] as String;
      final page = args['selectedPage'];

      if (page != null && page is int) {
        _page = page;
      }

      if (state == null || code == null || code.isEmpty) {
        return;
      }

      setState(() {
        _loading = true;
      });

      final data = await nh.boomMarket.boomToken(
        state: state,
        code: code,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
      });

      if (data.isError) {
        setState(() {
          _isError = true;
          _errorText = data.error;
        });

        return;
      }

      if (data.content?.status != true) {
        setState(() {
          _isError = true;
          _errorText = data.content.description;
        });

        return;
      }

      setState(() {
        _isError = false;
        _errorText = null;
      });

      final now = DateTime.now().millisecondsSinceEpoch - 100;
      await appState.setBankLoginInfo(
        state,
        code,
        now + data.content.expires * 1000.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (_isError) {
      children.add(Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 48,
      ));
      children.add(SizedBox(height: 8));
      children.add(Text(_errorText ?? ''));
    } else {
      children.add(CircularProgressIndicator());
      children.add(SizedBox(height: 8));
      children.add(Text(strings.please_wait));
    }
    final x = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );

    if (_loading) {
      return x;
    }

    if (_isError) {
      return x;
    }

    return widget.child;
  }
}
