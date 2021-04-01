import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/credit_card.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class CreditCardBills extends StatefulWidget {
  CreditCardBills({@required this.customerNumber});

  final String customerNumber;

  @override
  State<StatefulWidget> createState() => _CreditCardBillsState();
}

class _CreditCardBillsState extends State<CreditCardBills> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<ListOfBillsResponse> _data;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _data = null;
    });

    final data = await nh.creditCard
        .getListOfBills(customerNumber: widget.customerNumber);

    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildMessage(String text) => Center(
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

    Widget buildWelcomeMessage() => buildMessage('لیست صورت حساب ها.');

    Widget buildBillList() {
      final items = _data.content.bills
          .map(
            (e) => Container(
              decoration: BoxDecoration(
                color: colors.greyColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              margin: EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('شماره صورت حساب'),
                        Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 6, 0, 16),
                            child: Text(
                                e.statementNumber?.withPersianNumbers() ?? '')),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: colors.greyColor.shade800,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 16, 16, 0),
                    child: Text(
                        'شروع دوره: ${e.cycleStartDate}'.withPersianNumbers()),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 8, 16, 0),
                    child: Text(
                        'پایان دوره: ${e.cycleEndDate}'.withPersianNumbers()),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 8, 16, 0),
                    child:
                        Text('تاریخ صدور: ${e.issueDate}'.withPersianNumbers()),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 8, 16, 16),
                    child:
                        Text('مهلت پرداخت: ${e.dueDate}'.withPersianNumbers()),
                  ),
                ],
              ),
            ),
          )
          .toList();

      return ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: items.length,
        itemBuilder: (context, index) => items[index],
      );
    }

    Widget buildChild() {
      if (_data == null) {
        return buildWelcomeMessage();
      }
      if (_data.isError) {
        return buildMessage(strings.connectionError);
      }
      if (_data.content.status != true) {
        return buildMessage(_data.content.description);
      }

      if (_data.content.bills == null || _data.content.bills.isEmpty) {
        return buildMessage('صورت حسابی برای نمایش وجود ندارد');
      }

      return buildBillList();
    }

    return HeadedPage(
      title: Text('لیست صورت حساب ها'),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refresh,
        child: buildChild(),
      ),
    );
  }
}
