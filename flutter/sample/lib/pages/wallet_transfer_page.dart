import 'package:flutter/material.dart';
import 'package:novinpay/dialogs/wallet_to_wallet_dialog.dart';
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/pages/wallet_group_transfer_page.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/general.dart';

class WalletTransferPage extends StatefulWidget {
  @override
  _WalletTransferPageState createState() => _WalletTransferPageState();
}

class _WalletTransferPageState extends State<WalletTransferPage>
    with AnalyticsMixin {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('انتقال اعتبار'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0, left: 24, bottom: 16.0),
            child: CustomTabBar(
              onChange: (index) {
                setState(() {
                  _selectedTab = index;

                  //Always put [sendCurrentTabToAnalytics] after setting the [_selectedTab] value;
                  sendCurrentTabToAnalytics();
                });
              },
              items: [
                CustomTabBarItem(title: 'کیف پول'),
                CustomTabBarItem(title: 'گروهی'),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                WalletToWalletDialog(),
                WalletGroupTransfer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  String getCurrentRoute() {
    return routes.bill_pay;
  }

  @override
  int getCurrentTab() {
    return _selectedTab;
  }
}
