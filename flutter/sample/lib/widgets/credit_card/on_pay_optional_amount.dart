import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/models/credit_card.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class OnPayOptionalAmount extends StatefulWidget {
  @override
  _OnPayOptionalAmountState createState() => _OnPayOptionalAmountState();
}

class _OnPayOptionalAmountState extends State<OnPayOptionalAmount>
    with DisableManagerMixin {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      footer: ConfirmButton(
        child: CustomText(
          'پرداخت',
          textAlign: TextAlign.center,
        ),
        onPressed: () => _onPayOptionalAmount(),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: MoneyTextFormField(
                    minimum: 10000,
                    maximum: 100000000,
                    controller: _priceController,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.greyColor),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: colors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('نکات پرداخت مبلغ دلخواه'),
                        ],
                      ),
                      Text(
                          'چنانچه از این منو طی چند مرحله پرداخت،اقدام به تسویه کل بدهی خود نمایید هیچ گونه تخفیفی شامل شما نمیگردد و امکان بازگشت مبلغ پرداختی نیز وجود ندارد لذا جهت برخورداری از تخفیف کامل از منوی تسویه کامل از منوی تسویه کل بدهی با تخفیف استفاده نمایید.',
                          style: TextStyle(
                              color: colors.greyColor.shade800,
                              fontSize: 14.0)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPayOptionalAmount() async {
    final customerInfo = appState.customerInfo;

    final String cardNumber =
        customerInfo.customerCards.cardInfoVOsField[0].pan;

    final String firstName = customerInfo.data.firstName ?? '';
    final String lastName = customerInfo.data.lastName ?? '';
    final customerNumber = customerInfo.data.customerNo;

    if (!_formKey.currentState.validate()) {
      return;
    }

    final int amount = int.tryParse(_priceController.text.replaceAll(',', ''));
    int totalAmount = customerInfo.paymentInfo?.data?.payableAmt?.toInt();
    if (amount > totalAmount) {
      ToastUtils.showCustomToast(context, 'مبلغ وارد شده از کل بدهی بیشتر است',
          Image.asset('assets/ic_error.png'), 'خطا');
      return;
    }

    final payInfo = await showPaymentBottomSheet(
        context: context,
        title: Text('پرداخت صورت حساب'),
        amount: amount,
        transactionType: TransactionType.buy,
        acceptorName: '',
        acceptorId: '17');

    if (payInfo == null) {
      return;
    }

    final response = await Loading.run(
        context,
        nh.creditCard.creditCardPayment(
          paymentType: PaymentMethod.two,
          cardInfo: payInfo.cardInfo,
          amount: amount,
          cardNumber: cardNumber,
          fullNamePayer: '$firstName $lastName',
          installmentCount: -1,
          customerNumber: customerNumber,
        ));

    if (!showConnectionError(context, response)) {
      return;
    }

    if (response.content.status != true) {
      await showFailedTransaction(
          context,
          response.content.description,
          response.content.stan,
          response.content.rrn,
          'پرداخت مبلغ دلخواه',
          amount);
      return;
    }
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'کارت اعتباری',
          cardNumber: payInfo.cardInfo.pan,
          stan: response.content.stan,
          rrn: response.content.rrn,
          topupPin: null,
          description:
              ' پرداخت مبلغ دلخواه از اقساط خانم/آقا$firstName $lastName',
          amount: amount,
          isShaparak: false,
        ),
      ),
    );
  }
}
