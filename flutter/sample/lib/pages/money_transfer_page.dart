import 'package:flutter/material.dart';
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/faraboom_authenticator.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/money_transfer/intra.dart';
import 'package:novinpay/widgets/money_transfer/paya.dart';
import 'package:novinpay/widgets/money_transfer/satna.dart';

class MoneyTransferPage extends StatefulWidget {
  @override
  _MoneyTransferPageState createState() => _MoneyTransferPageState();
}

class _MoneyTransferPageState extends State<MoneyTransferPage>
    with AnalyticsMixin {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('انتقال وجه'),
      body: FaraboomAuthenticator(
        route: routes.money_transfer,
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
                  CustomTabBarItem(title: 'پایا'),
                  CustomTabBarItem(title: 'ساتنا'),
                  CustomTabBarItem(title: 'درون بانکی'),
                ],
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedTab,
                  children: [
                    PayaMoneyTransfer(),
                    SatnaMoneyTransfer(),
                    IntraBankMoneyTransfer(),
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
    return routes.money_transfer;
  }

  @override
  int getCurrentTab() {
    return _selectedTab;
  }
}
