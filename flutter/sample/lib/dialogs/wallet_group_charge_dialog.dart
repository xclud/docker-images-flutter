import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/iban_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class WalletGroupChargeDialog extends StatefulWidget {
  @override
  _WalletGroupChargeState createState() => _WalletGroupChargeState();
}

class _WalletGroupChargeState extends State<WalletGroupChargeDialog>
    with MruSelectionMixin, IbanSelection {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _ibanController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _ibanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomText(
                  'لطفا مبلغ مورد نظر جهت شارژ گروه کیف پول را وارد نمایید',
                  style: colors.bodyStyle(context),
                ),
                Space(2),
                MoneyTextFormField(
                  minimum: 10,
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
      ),
      footer: Padding(
        padding: EdgeInsets.only(bottom: 24.0, left: 24, right: 24.0),
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
