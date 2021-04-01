import 'package:flutter/material.dart';
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/topup/direct.dart';
import 'package:novinpay/widgets/topup/pin.dart';

class ChargePage extends StatefulWidget {
  @override
  _ChargePageState createState() => _ChargePageState();
}

class _ChargePageState extends State<ChargePage> with AnalyticsMixin {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('خرید شارژ'),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
                top: 8.0, right: 24.0, left: 24.0, bottom: 24.0),
            child: CustomTabBar(
              onChange: (index) {
                setState(() {
                  _selectedTab = index;
                  sendCurrentTabToAnalytics();
                });
              },
              items: [
                CustomTabBarItem(title: 'شارژ مستقیم'),
                CustomTabBarItem(title: 'پین شارژ'),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                ChargeDirect(),
                ChargePin(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  String getCurrentRoute() {
    return routes.charge;
  }

  @override
  int getCurrentTab() {
    return _selectedTab;
  }
}
