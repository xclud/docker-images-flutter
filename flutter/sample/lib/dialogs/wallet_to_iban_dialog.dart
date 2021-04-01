import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/iban_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class WalletToIbanDialog extends StatefulWidget {
  @override
  _WalletToIbanDialogState createState() => _WalletToIbanDialogState();
}

class _WalletToIbanDialogState extends State<WalletToIbanDialog>
    with MruSelectionMixin, IbanSelection {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _ibanController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _ibanFocusNode = FocusNode();
  final _confirmButtonFocusNode = FocusNode();

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomText(
                  'لطفا شماره شبا مورد نظر و مبلغ را جهت انتقال اعتبار از کیف پول وارد نمایید',
                  style: colors.bodyStyle(context),
                ),
                Space(2),
                IbanTextFormField(
                    focusNode: _ibanFocusNode,
                    controller: _ibanController,
                    showSelectionDialog: _showIbanSelectionDialog,
                    onEditingComplete: () {
                      _ibanFocusNode.unfocus();
                      _priceFocusNode.requestFocus();
                    }),
                Space(2),
                MoneyTextFormField(
                  minimum: 10,
                  maximum: 100000000,
                  focusNode: _priceFocusNode,
                  controller: _priceController,
                  onEditingComplete: () {
                    _priceFocusNode.unfocus();
                    _confirmButtonFocusNode.requestFocus();
                  },
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      footer: Padding(
        padding: EdgeInsets.only(bottom: 24.0, left: 24, right: 24.0),
        child: ConfirmButton(
            focusNode: _confirmButtonFocusNode,
            child: CustomText(
              strings.action_ok,
              style: colors
                  .tabStyle(context)
                  .copyWith(color: colors.greyColor.shade50),
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              if (!_formKey.currentState.validate()) {
                return;
              }
              int amount =
                  int.tryParse(_priceController.text.replaceAll(',', ''));

              final balanceData =
                  await Loading.run(context, nh.wallet.getBalance());

              if (!showError(context, balanceData)) {
                return;
              }

              final response = await Loading.run(
                  context,
                  nh.wallet.eWalletTransferToIban(
                    amount: amount,
                    iban: _ibanController.text,
                    balance: balanceData.content.balance.toInt(),
                  ));

              if (!showConnectionError(context, response)) {
                return;
              }

              if (response.content.status != true) {
                await showFailedTransaction(
                    context,
                    response.content.description,
                    '',
                    response.content.rrn,
                    'انتقال به شبا',
                    amount);
                return;
              }
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OverViewPage(
                    title: 'انتقال به شبا',
                    cardNumber: '',
                    stan: '',
                    rrn: response.content.rrn,
                    topupPin: null,
                    description:
                        'انتقال اعتبار به شماره شبا ${_ibanController.text}',
                    amount: amount,
                    isShaparak: true,
                  ),
                ),
              );
            }),
      ),
    );
  }

  void _showIbanSelectionDialog() async {
    final data = await showSourceIbanSelectionDialog();
    if (data == null) {
      return;
    }

    _ibanController.text = data.value;
  }
}
