import 'package:flutter/material.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class PriceDialog extends StatefulWidget {
  @override
  _PriceDialogState createState() => _PriceDialogState();
}

class _PriceDialogState extends State<PriceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: Form(
        key: _formKey,
        child: Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  'لطفا مبلغ مورد نظر خود را جهت تسویه اقساط خود وارد کنید'),
              Space(2),
              MoneyTextFormField(
                minimum: 10000,
                maximum: 100000000,
                controller: _priceController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ],
          ),
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
          int amount = int.tryParse(_priceController.text.replaceAll(',', ''));
          Navigator.of(context).pop(amount ?? 0);
        },
      ),
    );
  }
}
