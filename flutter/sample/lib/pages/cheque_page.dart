import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/cheque/cheque_list_page.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class ChequePage extends StatefulWidget {
  @override
  _ChequePageState createState() => _ChequePageState();
}

class _ChequePageState extends State<ChequePage> {
  final _nationalNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nationalNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('استعلام چک برگشتی'),
      body: Split(
        header: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
            child: NationalNumberTextFormField(
              controller: _nationalNumberController,
            ),
          ),
        ),
        child: Expanded(
          child: Center(
            child: CustomText(
              'کد ملی خود را برای مشاهده \nچک های برگشتی وارد کنید',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: colors.greyColor.shade800, fontSize: 14.0),
            ),
          ),
        ),
        footer: Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 8),
          child: ConfirmButton(
            child: CustomText(
              strings.action_ok,
              textAlign: TextAlign.center,
            ),
            onPressed: _submit,
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final nationalNumber = _nationalNumberController.text;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChequeListPage(nationalNumber),
      ),
    );
  }
}
