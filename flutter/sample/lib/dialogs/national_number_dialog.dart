import 'package:flutter/material.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class NationalNumberDialog extends StatefulWidget {
  NationalNumberDialog({this.scrollController});

  final ScrollController scrollController;

  @override
  _NationalNumberDialogState createState() => _NationalNumberDialogState();
}

class _NationalNumberDialogState extends State<NationalNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nationalNumberController = TextEditingController();

  @override
  void dispose() {
    _nationalNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
            child: NationalNumberTextFormField(
              controller: _nationalNumberController,
            ),
          ),
        ),
      ),
      footer: Container(
        margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }

            Navigator.of(context).pop(_nationalNumberController.text);
          },
        ),
      ),
    );
  }
}
