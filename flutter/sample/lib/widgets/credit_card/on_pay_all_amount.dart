import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/models/credit_card.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';

class OnPayAllAmount extends StatefulWidget {
  @override
  _OnPayAllAmountState createState() => _OnPayAllAmountState();
}

class _OnPayAllAmountState extends State<OnPayAllAmount>
    with DisableManagerMixin {
  final _priceController = TextEditingController();
  int amount = appState.customerInfo.paymentInfo?.data?.payableAmt?.toInt();

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
        onPressed: () => _onPayAll(),
      ),
      child: Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DualListTile(
                  start: Text('مبلغ کل بدهی'),
                  end: Text(
                    toRials(amount),
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
                          Text('نکات پرداخت کل بدهی'),
                        ],
                      ),
                      Text(
                        'مشتری گرامی،در صورتی پرداخت شما شامل تخفیف خواهد شد که مبلغ پرداختی دقیقا مطابق با کل بدهی قابل پرداخت باشد',
                        style: TextStyle(
                            color: colors.greyColor.shade800, fontSize: 14.0),
                      ),
                      Text(
                        'بدهی شامل مبالغ خریدهای انجام شده پس از صدور آخرین صورتحساب و سود دوره خرید مربوط به آنها نمی باشد',
                        style: TextStyle(
                            color: colors.greyColor.shade800, fontSize: 14.0),
                      ),
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

  void _onPayAll() async {
    final customerInfo = appState.customerInfo;

    final String cardNumber =
        customerInfo.customerCards.cardInfoVOsField[0].pan;

    final String firstName = customerInfo.data.firstName ?? '';
    final String lastName = customerInfo.data.lastName ?? '';
    final customerNumber = customerInfo.data.customerNo;

    int amount = customerInfo.paymentInfo?.data?.payableAmt?.toInt();
    if (amount == null || amount <= 0) {
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
    final data = await Loading.run(
      context,
      nh.creditCard.creditCardPayment(
          paymentType: PaymentMethod.two,
          cardInfo: payInfo.cardInfo,
          amount: amount,
          cardNumber: cardNumber,
          fullNamePayer: '$firstName $lastName',
          installmentCount: -1,
          customerNumber: customerNumber),
    );

    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(context, data.content.description,
          data.content.stan, data.content.rrn, 'پرداخت کل بدهی', amount);
      return;
    }
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'کارت اعتباری',
          cardNumber: payInfo.cardInfo.pan,
          stan: data.content.stan,
          rrn: data.content.rrn,
          topupPin: null,
          description: ' پرداخت کل بدهی $firstName $lastName',
          amount: amount,
          isShaparak: false,
        ),
      ),
    );
  }
}
