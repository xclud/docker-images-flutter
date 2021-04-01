import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/credit_card.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class CreditCardTransactionHistoryPage extends StatefulWidget {
  CreditCardTransactionHistoryPage({@required this.customerNumber});

  final String customerNumber;

  @override
  _CreditCardTransactionHistoryPageState createState() =>
      _CreditCardTransactionHistoryPageState();
}

class _CreditCardTransactionHistoryPageState
    extends State<CreditCardTransactionHistoryPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<PaymentListResponse> _data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('لیست پرداخت ها'),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: _buildChild(),
      ),
    );
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

  Widget _buildPaymentList() => ListView.separated(
        separatorBuilder: (context, index) => Space(),
        itemCount: _data.content.data.length,
        itemBuilder: (context, index) {
          final item = _data.content.data[index];
          return _buildItem(item);
        },
      );

  Widget _buildChild() {
    if (_data == null) {
      return Container();
    }

    if (_data.isError) {
      return _buildMessage(strings.connectionError);
    }

    if (_data.content.status != true) {
      return _buildMessage(
          _data.content.description ?? strings.connectionError);
    }

    if (_data.content.data == null || _data.content.data.isEmpty) {
      return _buildMessage('پرداختی برای نمایش وجود ندارد');
    }

    return _buildPaymentList();
  }

  Future<void> _onRefresh() async {
    final data = await nh.creditCard
        .getPaymentList(customerNumber: widget.customerNumber);

    setState(() {
      _data = data;
    });
  }

  Widget _buildItem(PaymentItem item) {
    final state = item.statusIdentifier == true ? 'تایید شده' : 'تایید نشده';
    final color =
        item.statusIdentifier == true ? colors.accentColor : colors.red;

    return Container(
      margin: EdgeInsetsDirectional.only(start: 24, end: 24),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('کد مرجع'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text(item.referenceNumber
                            ?.toString()
                            ?.withPersianNumbers() ??
                        '-')
                  ],
                ),
                Space(),
                Row(
                  children: [
                    Text('تاریخ'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text('$lrm${item.date ?? '-'}'.withPersianNumbers())
                  ],
                ),
                Space(),
                Row(
                  children: [
                    Text('مبلغ'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text(toRials(item.amount ?? 0))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0),
            child: IgnorePointer(
              child: TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(color),
                  backgroundColor:
                      MaterialStateProperty.all(colors.greyColor.shade50),
                ),
                child: Text(state),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
