import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';

class SuggestionDialog extends StatefulWidget {
  @override
  _SuggestionDialogState createState() => _SuggestionDialogState();
}

class _SuggestionDialogState extends State<SuggestionDialog> {
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
    return Split(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: Container(
                height: 150,
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.greyColor.shade600,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      decoration: InputDecoration.collapsed(
                          hintText: 'لطفا پیام خود را با ما درمیان بگذارید'),
                      controller: _suggestionController,
                      maxLines: null,
                      validator: _validateSuggestion,
                    ),
                  ),
                ),
              ),
            ),
            Space(2),
          ],
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
        child: ConfirmButton(
          onPressed: _submit,
          child: CustomText(
            'ارسال',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    Navigator.of(context).pop(_suggestionController.text);
  }
}
