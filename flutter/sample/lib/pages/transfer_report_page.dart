import 'package:flutter/material.dart';
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/faraboom_authenticator.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/transfer_report/paya_report.dart';
import 'package:novinpay/widgets/transfer_report/satna_report.dart';

class TransferReportPage extends StatefulWidget {
  @override
  _TransferReportState createState() => _TransferReportState();
}

class _TransferReportState extends State<TransferReportPage>
    with AnalyticsMixin {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('گزارشات'),
      body: FaraboomAuthenticator(
        route: routes.transfer_report,
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
          child: Column(
            children: [
              CustomTabBar(
                onChange: (int index) {
                  setState(() {
                    _selectedPage = index;
                    sendCurrentTabToAnalytics();
                  });
                },
                items: [
                  CustomTabBarItem(title: 'ساتنا'),
                  CustomTabBarItem(title: 'پایا'),
                ],
              ),
              Expanded(
                child: IndexedStack(
                  index: _selectedPage,
                  children: [SatnaReport(), PayaReport()],
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
    return routes.transfer_report;
  }

  @override
  int getCurrentTab() {
    return _selectedPage;
  }
}
