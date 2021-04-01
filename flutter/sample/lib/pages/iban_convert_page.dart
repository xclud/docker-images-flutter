import 'package:flutter/material.dart';
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/iban_from_account.dart';
import 'package:novinpay/widgets/iban_to_account.dart';

class IbanConvertPage extends StatefulWidget {
  @override
  _IbanConvertPageState createState() => _IbanConvertPageState();
}

class _IbanConvertPageState extends State<IbanConvertPage> with AnalyticsMixin {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text(strings.action_inquiry),
      body: Container(
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
                CustomTabBarItem(title: strings.label_iban_number),
                CustomTabBarItem(title: strings.label_account_number),
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  IbanFromAccount(),
                  IbanToAccount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String getCurrentRoute() {
    return routes.iban_convert;
  }

  @override
  int getCurrentTab() {
    return _selectedTab;
  }
}
