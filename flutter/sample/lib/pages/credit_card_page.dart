import 'package:flutter/material.dart';
import 'package:novinpay/Item.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/credit_card/bills.dart';
import 'package:novinpay/widgets/credit_card/card_dark.dart';
import 'package:novinpay/widgets/credit_card/choose_payment_type.dart';
import 'package:novinpay/widgets/credit_card/choose_statement_type.dart';
import 'package:novinpay/widgets/credit_card/transaction_history_page.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';

class CreditCardMainMenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreditCardMainMenuPageState();
}

class _CreditCardMainMenuPageState extends State<CreditCardMainMenuPage> {
  @override
  Widget build(BuildContext context) {
    final customerInfo = appState.customerInfo;
    final cardCount =
        customerInfo?.customerCards?.cardInfoVOsField?.length ?? 0;

    String pan() => customerInfo.customerCards.cardInfoVOsField[0].pan ?? '';

    final String firstName = customerInfo.data.firstName ?? '';
    final String lastName = customerInfo.data.lastName ?? '';

    return HeadedPage(
      title: Text('کارت اعتباری'),
      body: Column(children: [
        if (cardCount > 0)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
            child: DarkCreditCard(
              holder: '$firstName $lastName',
              debit:
                  customerInfo.paymentInfo.data?.payAmtWithoutDiscount?.toInt(),
              currentDebit:
                  customerInfo.paymentInfo.data?.currentTotalDebitAmt?.toInt(),
              pan: pan(),
            ),
          ),
        Space(1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ScrollConfiguration(
              behavior: CustomBehavior(),
              child: GridView.count(
                padding: EdgeInsets.all(8),
                crossAxisCount: 3,
                childAspectRatio: 60.0 / 60.0,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: _getItems().toList(),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Iterable<Item> _getItems() sync* {
    final generalInfo = appState.generalInfo;
    final customerNumber = appState.customerInfo.data.customerNo;
    final customerInfo = appState.customerInfo;
    final bedehi =
        customerInfo.paymentInfo.data?.payAmtWithoutDiscount?.toInt() ?? 0;
    final hasNotBedehi = bedehi == 0;
    final hasNotGeneralInfo = generalInfo == null || generalInfo.status != true;
    yield Item(
        title: CustomText('اقساط'),
        image: Icon(Icons.event),
        onTap: () {
          if (hasNotGeneralInfo) {
            ToastUtils.showCustomToast(context, 'صورت حسابی وجود ندارد');
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CreditCardChooseStatementTypePage(),
              ),
            );
          }
        });

    yield Item(
        title: CustomText('صورت حساب ها'),
        image: Icon(Icons.receipt),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  CreditCardBills(customerNumber: customerNumber),
            ),
          );
        });

    yield Item(
        title: CustomText('لیست پرداخت ها'),
        image: Icon(Icons.credit_card),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreditCardTransactionHistoryPage(
                  customerNumber: customerNumber),
            ),
          );
        });

    yield Item(
      title: CustomText('پرداخت بدهی'),
      image: Icon(Icons.check_circle_outline),
      onTap: () {
        if (hasNotBedehi) {
          ToastUtils.showCustomToast(context, 'مبلغی برای پرداخت وجود ندارد');
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreditCardChoosePaymentTypePage(),
            ),
          );
        }
      },
    );
  }
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
