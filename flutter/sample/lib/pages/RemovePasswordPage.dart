import 'package:flutter/material.dart';
import 'package:novinpay/widgets/RemovePasswordWidget.dart';
import 'package:novinpay/widgets/general/general.dart';

class RemovePasswordPage extends StatefulWidget {
  RemovePasswordPage({
    @required this.hasPassword,
  });

  final bool hasPassword;

  @override
  _RemovePasswordPageState createState() => _RemovePasswordPageState();
}

class _RemovePasswordPageState extends State<RemovePasswordPage> {
  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('حذف رمز ورود'),
      body: Padding(
        child: RemovePasswordWidget(),
        padding: EdgeInsets.symmetric(
          horizontal: 24,
        ),
      ),
    );
  }
}
