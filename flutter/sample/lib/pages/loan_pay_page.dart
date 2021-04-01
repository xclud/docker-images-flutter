import 'package:flutter/material.dart';
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/faraboom_authenticator.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loan_pay_card.dart';
import 'package:novinpay/widgets/loan_pay_deposit.dart';

class LoanPayPage extends StatefulWidget {
  @override
  _LoanPayPageState createState() => _LoanPayPageState();
}

class _LoanPayPageState extends State<LoanPayPage> with AnalyticsMixin {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('تسهیلات'),
      body: FaraboomAuthenticator(
        route: routes.loan_pay,
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
          child: Column(
            children: [
              CustomTabBar(
                onChange: (index) {
                  setState(() {
                    _selectedTab = index;
                    sendCurrentTabToAnalytics();
                  });
                },
                items: [
                  CustomTabBarItem(title: 'پرداخت با کارت'),
                  CustomTabBarItem(title: 'پرداخت با حساب'),
                ],
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    LoanPayCard(),
                    LoanPayDeposit(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  String getCurrentRoute() {
    return routes.loan_pay;
  }

  @override
  int getCurrentTab() {
    return _selectedTab;
  }
}
