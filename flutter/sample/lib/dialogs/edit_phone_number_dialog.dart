import 'package:flutter/material.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/mobile_input.dart';

class EditPhoneNumberDialog extends StatefulWidget {
  EditPhoneNumberDialog({@required this.scrollController});

  final ScrollController scrollController;

  @override
  _EditPhoneNumberDialogState createState() => _EditPhoneNumberDialogState();
}

class _EditPhoneNumberDialogState extends State<EditPhoneNumberDialog> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      header: Form(
        key: _formKey,
        child: MobileWidget(
          controller: _phoneController,
          showMruIcon: false,
          showSimCard: false,
        ),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          controller: widget.scrollController,
        ),
      ),
      footer: ConfirmButton(
        child: CustomText(
          strings.action_ok,
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }
          Navigator.of(context).pop(_phoneController.text);
        },
      ),
    );
  }
}
