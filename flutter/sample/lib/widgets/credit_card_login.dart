import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/pages/credit_card_page.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class CreditCardLogin extends StatefulWidget {
  @override
  CreditCardLoginState createState() => CreditCardLoginState();
}

class CreditCardLoginState extends State<CreditCardLogin> {
  final _nationalNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nationalNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      header: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 8),
          child: NationalNumberTextFormField(
            controller: _nationalNumberController,
          ),
        ),
      ),
      child: Expanded(
        child: Center(
          child: CustomText(
            'کد ملی خود را برای مشاهده \nکارت اعتباری وارد کنید',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.greyColor.shade800, fontSize: 14.0),
          ),
        ),
      ),
      footer: Container(
        margin: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 8),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            textAlign: TextAlign.center,
          ),
          onPressed: _submit,
        ),
      ),
    );
  }

  Future<bool> _getCreditCardInfo() async {
    final nationalNumber = _nationalNumberController.text;
    final customerInfo =
        await nh.creditCard.getCustomerInfo(customerNumber: nationalNumber);

    if (customerInfo.isError) {
      await _showNoDataDialog(strings.connectionError);
      return false;
    }

    if (customerInfo.content.status != true) {
      await _showNoDataDialog(customerInfo.content.description ?? '');
      return false;
    }

    final cards = customerInfo.content?.customerCards?.cardInfoVOsField;

    if (cards == null || cards.isEmpty) {
      await _showNoDataDialog('برای این کد ملی هیچ کارتی تعریف نشده است.');
      return false;
    }

    final creditCards =
        cards.where((element) => element.productTypeField == 1).toList();

    if (creditCards.isEmpty) {
      await _showNoDataDialog('برای این کد ملی هیچ کارتی تعریف نشده است.');
      return false;
    }

    appState.creditCards = creditCards;

    final generalInfo = await nh.creditCard
        .getGeneralInformation(customerNumber: nationalNumber);

    if (generalInfo.isError) {
      await _showNoDataDialog(strings.connectionError);
      return false;
    }

    final paymentInfo = await nh.creditCard.getPaymentInfo(
        cardNumber: customerInfo.content.customerCards.cardInfoVOsField[0].pan);

    if (paymentInfo.isError) {
      await _showNoDataDialog(strings.connectionError);
      return false;
    }

    appState.generalInfo = generalInfo.content;
    appState.paymentInfo = paymentInfo.content;
    appState.customerInfo = customerInfo.content;

    return true;
  }

  Future<T> _showNoDataDialog<T>(String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('کارت اعتباری'),
        content: CustomText(message ?? ''),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            child: Text('فهمیدم'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final didGetInfo = await Loading.run(context, _getCreditCardInfo());
    if (!didGetInfo) {
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreditCardMainMenuPage(),
      ),
    );
  }
}
