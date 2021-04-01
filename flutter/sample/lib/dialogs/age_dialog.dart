import 'package:flutter/material.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';

class AgeDialog extends StatefulWidget {
  AgeDialog({@required this.scrollController, @required this.age});

  final ScrollController scrollController;
  final int age;

  @override
  _AgeDialogState createState() => _AgeDialogState();
}

class _AgeDialogState extends State<AgeDialog> {
  final _formKey = GlobalKey<FormState>();

  final _ageController = TextEditingController();

  String _ageValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'سن خود را وارد نمایید';
    }
    if (int.tryParse(value) > 99 || int.tryParse(value) < 1) {
      return 'سن معتبر نمیباشد';
    }
    return null;
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _ageController.text = widget.age.toString();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      header: Form(
        key: _formKey,
        child: TextFormField(
          controller: _ageController,
          validator: _ageValidator,
          textDirection: TextDirection.ltr,
          maxLength: 2,
          inputFormatters: digitsOnly(),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'سن',
            hintText: '۲۰',
            hintTextDirection: TextDirection.ltr,
            counterText: '',
          ),
        ),
      ),
      footer: ConfirmButton(
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }
          Navigator.of(context).pop(int.tryParse(_ageController.text));
        },
        child: CustomText(
          strings.action_ok,
          textAlign: TextAlign.center,
        ),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          controller: widget.scrollController,
        ),
      ),
    );
  }
}
