import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/bank_login.dart';
import 'package:novinpay/models/boom_market.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class SatnaReport extends StatefulWidget {
  @override
  _SatnaReportState createState() => _SatnaReportState();
}

class _SatnaReportState extends State<SatnaReport> with BankLogin {
  Response<SatnaReportResponse> _data;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
    super.initState();
  }

  Widget _buildMessage(String text) => Center(
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 24, end: 24),
          child: Text(
            text ?? '',
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      );

  Widget _buildList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(),
      itemCount: _data.content.satnaReport.transferReport.length,
      itemBuilder: (context, index) {
        var item = _data.content.satnaReport.transferReport[index];
        return SatnaItem(
          amount: item.amount,
          status: item.statusDescription,
          destinationBankName: item.destinationBank.name,
          sourseDeposit: item.sourceDepositNumber,
          destinationDeposit: item.destinationDepositNumber,
          time: item.registerDatePersian,
        );
      },
    );
  }

  Widget _buildChild() {
    if (_data == null) {
      return Center(
        child: Text('درحال دریافت اطلاعات'),
      );
    }

    if (_data.isError) {
      return _buildMessage(strings.connectionError);
    }

    if (_data.content.status != true) {
      return _buildMessage(_data.content.description);
    }

    if (_data.content.satnaReport == null) {
      return _buildMessage(_data.content.description);
    }
    if (_data.content.satnaReport.transferReport.isEmpty) {
      return _buildMessage('گزارشی یافت نشد');
    }
    return _buildList();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      child: _buildChild(),
    );
  }

  Future<void> _onRefresh() async {
    final data = await nh.boomMarket.satnaReport();
    setState(() {
      _data = data;
    });
  }
}

class SatnaItem extends StatelessWidget {
  SatnaItem({
    @required this.time,
    @required this.amount,
    @required this.sourseDeposit,
    @required this.destinationDeposit,
    @required this.destinationBankName,
    @required this.status,
  });

  final String time;
  final int amount;
  final String sourseDeposit;
  final String destinationDeposit;
  final String destinationBankName;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Column(
        children: [
          Space(),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 8,
              right: 24,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$lrm$time'?.withPersianNumbers(),
                        style: colors.bodyStyle(context),
                      ),
                      Space(),
                      Text(toRials(amount ?? 0),
                          style: colors.boldStyle(context)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                    child: Text(status ?? '',
                        style: colors.boldStyle(context).copyWith(
                              color: colors.accentColor,
                            )),
                  ),
                ),
              ],
            ),
          ),
          Space(),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Space(),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شبا مقصد',
                      style: colors.bodyStyle(context),
                    ),
                    Space(),
                    Text(
                      '$destinationDeposit'?.withPersianNumbers(),
                      style: colors.boldStyle(context),
                    ),
                    Space()
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
