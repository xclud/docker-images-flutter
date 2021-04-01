import 'package:flutter/material.dart';
import 'package:novinpay/widgets/change_password_widget.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/set_password_widget.dart';

class SetOrChangePasswordPage extends StatefulWidget {
  SetOrChangePasswordPage({
    @required this.hasPassword,
  });

  final bool hasPassword;

  @override
  _SetOrChangePasswordPageState createState() =>
      _SetOrChangePasswordPageState();
}

class _SetOrChangePasswordPageState extends State<SetOrChangePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text(widget.hasPassword ? 'تغییر رمز ورود' : 'تنظیم رمز ورود'),
      body: Padding(
        child:
            widget.hasPassword ? ChangePasswordWidget() : SetPasswordWidget(),
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
      ),
    );
  }
}
