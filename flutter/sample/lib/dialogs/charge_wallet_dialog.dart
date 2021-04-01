import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class ChargeWalletDialog extends StatefulWidget {
  @override
  _ChargeWalletDialogState createState() => _ChargeWalletDialogState();
}

class _ChargeWalletDialogState extends State<ChargeWalletDialog> {
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
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'لطفا مبلغ مورد نظر خود را جهت شارژ کیف پول وارد کنید',
                style: colors.bodyStyle(context),
              ),
              Space(2),
              MoneyTextFormField(
                minimum: 100,
                maximum: 100000000,
                controller: _priceController,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              Space(2),
            ],
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            style: colors
                .tabStyle(context)
                .copyWith(color: colors.greyColor.shade50),
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            int amount =
                int.tryParse(_priceController.text.replaceAll(',', ''));
            Navigator.of(context).pop(amount ?? 0);
          },
        ),
      ),
    );
  }
}
