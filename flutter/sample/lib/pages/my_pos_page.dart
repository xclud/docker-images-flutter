import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/pazirandegan/add_ticket.dart';
import 'package:novinpay/widgets/pazirandegan/ticket_filter.dart';
import 'package:novinpay/widgets/pazirandegan/transactions.dart';

class MyPosPage extends StatefulWidget {
  @override
  _MyPoseState createState() => _MyPoseState();
}

class _MyPoseState extends State<MyPosPage> with AnalyticsMixin {
  int _index = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      scaffoldKey: _scaffoldKey,
      title: CustomText('پذیرندگان'),
      actions: [
        if (_index == 1)
          IconButton(
            onPressed: _openTicketHistory,
            icon: Icon(
              Icons.restore_outlined,
              color: colors.ternaryColor,
            ),
          )
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
            child: CustomTabBar(
              onChange: (int index) {
                setState(() {
                  _index = index;
                  sendCurrentTabToAnalytics();
                });
              },
              items: [
                CustomTabBarItem(title: 'گزارش تراکنش'),
                //CustomTabBarItem(title: 'گزارش واریزی'),
                CustomTabBarItem(title: 'پشتیبانی'),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [PosTransaction(), /*PosTransaction(),*/ AddTicket()],
            ),
          )
        ],
      ),
    );
  }

  @override
  String getCurrentRoute() {
    return routes.my_pos;
  }

  @override
  int getCurrentTab() {
    return _index;
  }

  void _openTicketHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TicketFilter(),
      ),
    );
  }
}
