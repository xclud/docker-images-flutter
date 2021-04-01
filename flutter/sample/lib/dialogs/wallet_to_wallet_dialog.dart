import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/mobile_input.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class WalletToWalletDialog extends StatefulWidget {
  @override
  _WalletToWalletDialogState createState() => _WalletToWalletDialogState();
}

class _WalletToWalletDialogState extends State<WalletToWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _mobileController = TextEditingController();
  final _priceFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _confirmButtonFocusNode = FocusNode();

  @override
  void dispose() {
    _priceController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: Expanded(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Space(1),
                  CustomText(
                    'لطفا شماره موبایل مورد نظر و مبلغ را جهت انتقال اعتبار از کیف پول وارد نمایید',
                    style: colors.bodyStyle(context),
                  ),
                  Space(2),
                  MobileWidget(
                    showMruIcon: true,
                    showSimCard: false,
                    controller: _mobileController,
                    focusNode: _mobileFocusNode,
                    onEditingComplete: () {
                      _mobileFocusNode.unfocus();
                      _priceFocusNode.requestFocus();
                    },
                  ),
                  Space(2),
                  MoneyTextFormField(
                    minimum: 10,
                    maximum: 100000000,
                    controller: _priceController,
                    focusNode: _priceFocusNode,
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
            final phoneNumber = await appState.getPhoneNumber();
            if (_mobileController.text == phoneNumber) {
              ToastUtils.showCustomToast(
                  context,
                  'امکان انتقال اعتبار به کیف پول شماره خودتان امکان پذیر نیست',
                  Image.asset('assets/ic_error.png'),'خطا');
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
                nh.wallet.eWalletTransferToEWallet(
                  amount: amount,
                  toMobileNumber: _mobileController.text,
                  balance: balanceData.content.balance.toInt(),
                ));

            if (!showConnectionError(context, response)) {
              return;
            }

            if (response.content.status != true) {
              await showFailedTransaction(context, response.content.description,
                  '', response.content.rrn, 'انتقال اعتبار به کیف پول', amount);
              return;
            }
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OverViewPage(
                  title: 'انتقال اعتبار به کیف پول',
                  cardNumber: '',
                  stan: '',
                  rrn: response.content.rrn,
                  topupPin: null,
                  description:
                      'انتقال اعتبار کیف پول به شماره ${_mobileController.text}',
                  amount: amount,
                  isShaparak: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WalletTransfer {
  WalletTransfer({
    this.destination,
    this.amount,
  });

  String destination;
  int amount;
}
