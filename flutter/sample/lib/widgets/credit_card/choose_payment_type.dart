import 'package:flutter/material.dart';
import 'package:novinpay/widgets/credit_card/on_pay_all_amount.dart';
import 'package:novinpay/widgets/credit_card/on_pay_optional_amount.dart';
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/general.dart';

class CreditCardChoosePaymentTypePage extends StatefulWidget {
  @override
  _CreditCardChoosePaymentTypePageState createState() =>
      _CreditCardChoosePaymentTypePageState();
}

class _CreditCardChoosePaymentTypePageState
    extends State<CreditCardChoosePaymentTypePage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('تعیین نوع پرداخت'),
      body: Container(
        margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
        child: Column(
          children: [
            CustomTabBar(
              onChange: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              items: [
                CustomTabBarItem(title: 'پرداخت کل بدهی'),
                CustomTabBarItem(title: 'پرداخت مبلغ دلخواه'),
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  OnPayAllAmount(),
                  OnPayOptionalAmount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
