import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';

class SuggestionPage extends StatefulWidget {
  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final _suggestionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _validateSuggestion(String value) {
    if (value == null || value.isEmpty) {
      return 'پیشنهاد را وارد کنید';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('انتقادات و پیشنهادات'),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Split(
          header: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'لطفا با ارسال انتقادات و پیشنهادات خود ما را در جهت بهبود نرم افزار یاری کنید',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              Space(2),
            ],
          ),
          child: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 200,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration.collapsed(
                            hintText: 'لطفا متن خود را اینجا وارد نمایید.'),
                        controller: _suggestionController,
                        maxLines: null,
                        validator: _validateSuggestion,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          footer: ConfirmButton(
            onPressed: _submit,
            child: CustomText(
              'ارسال',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final data = await Loading.run(
      context,
      nh.novinPay.application
          .insertCustomerSuggestion(suggestion: _suggestionController.text),
    );
    if (data.isError) {
      if (!data.isExpired) {
        ToastUtils.showCustomToast(
            context, data.error, Image.asset('assets/ic_error.png'), 'خطا');
      }
      return;
    }
    if (data.content.status != true) {
      ToastUtils.showCustomToast(context, data.content.description,
          Image.asset('assets/ic_error.png'), 'خطا');
      return;
    }
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'پیام شما ارسال شد',
              textAlign: TextAlign.center,
            ),
            content: Text('با تشکر از مشارکت شما، دیدگاه شما بررسی خواهد شد.'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            actions: [
              RaisedButton(
                elevation: 0,
                color: colors.accentColor.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  strings.action_ok,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
    Navigator.of(context).pop();
  }
}
