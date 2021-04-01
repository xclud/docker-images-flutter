import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/cheque.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class ChequeListPage extends StatefulWidget {
  ChequeListPage(this.nationalNumber)
      : assert(nationalNumber != null && nationalNumber.isNotEmpty);
  final String nationalNumber;

  @override
  State<StatefulWidget> createState() => _ChequeListPageState();
}

class _ChequeListPageState extends State<ChequeListPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<BackChequesResponse> _data;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  Future<void> _refresh() async {
    final data =
        await nh.cheque.getBackCheques(nationalNumber: widget.nationalNumber);

    if (mounted) {
      if (data.hasErrors()) {
        ToastUtils.showCustomToast(
            context, data.error ?? data.content.description);

        return;
      }

      setState(() {
        _data = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('استعلام چک برگشتی'),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: _data?.content?.result?.cheques?.length ?? 0,
          itemBuilder: (context, index) {
            final item = _data.content.result.cheques[index];
            return ChequeCardItem(item: item);
          },
        ),
      ),
    );
  }
}

class ChequeCardItem extends StatefulWidget {
  ChequeCardItem({@required this.item});

  final ChequeItem item;

  @override
  State<StatefulWidget> createState() => _ChequeCardItemState();
}

class _ChequeCardItemState extends State<ChequeCardItem> {
  Iterable<Widget> _buildList(bool expand) sync* {
    final item = widget.item;

    yield Padding(
      padding:
          const EdgeInsetsDirectional.only(top: 8.0, start: 16.0, end: 16.0),
      child: DualListTile(
        start: Text(
          '$lrm${item.accountNumber}'.withPersianNumbers() ?? '',
          style: colors.bodyStyle(context),
        ),
        end: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.backDate?.toString()?.withPersianLetters() ?? '',
              style: colors.boldStyle(context),
            ),
          ),
        ),
      ),
    );

    yield Padding(
      padding:
          const EdgeInsetsDirectional.only(top: 8.0, start: 24.0, end: 24.0),
      child: Text(
          item.branchCode?.trim()?.withPersianLetters()?.withPersianNumbers() ??
              '',
          style: colors.boldStyle(context)),
    );

    yield Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 16.0, start: 24.0, end: 24.0, bottom: 16.0),
      child: Text(
          '${item.amount}، ${item.date}'
              .withPersianLetters()
              .withPersianNumbers(),
          style: colors.bodyStyle(context)),
    );

    yield Container(
      color: colors.greyColor.shade800,
      height: 1,
    );

    yield Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 8.0, start: 16.0, end: 16.0, bottom: 8.0),
      child: DualListTile(
          start: Text(
            toRials(widget.item.amount),
            style: colors.boldStyle(context),
          ),
          end: Container()),
    );
  }

  Widget _build(bool expand) {
    final items = _buildList(expand).toList();

    return Padding(
      padding: EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.greyColor.shade600,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return AnimatedCrossFade(
    //   crossFadeState:
    //       _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    //   duration: const Duration(milliseconds: 500),
    //   firstChild: _build(false),
    //   secondChild: _build(true),
    // );

    return _build(true);
  }
}
