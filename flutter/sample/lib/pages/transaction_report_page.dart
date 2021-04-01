import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/transaction_filter_dialog.dart';
import 'package:novinpay/models/TransactionReportResponse.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class TransactionReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TransactionReportPageState();
}

class _TransactionReportPageState extends State<TransactionReportPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<TransactionReportResponse> _data;
  FilterApiModel _filterApiModel;
  FilterInfo _filterInfo = FilterInfo();

  @override
  void initState() {
    super.initState();
    _filterApiModel = FilterApiModel();
    List<int> transactionType = [];
    transactionType.add(0);
    _filterApiModel.transactionType = transactionType;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  Future<void> _refresh() async {
    final data = await nh.novinPay.application.transactionReport(
        fromDate: _filterApiModel.fromDate,
        toDate: _filterApiModel.toDate,
        transactionType: _filterApiModel.transactionType,
        billTypeId: _filterApiModel.billTypeId,
        status: _filterApiModel.status);

    if (mounted) {
      setState(() {
        showError(context, data);
        _data = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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

    Widget _buildTransactionList() {
      return ListView.separated(
        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        itemCount: _data.content.transactionsData.length,
        separatorBuilder: (context, intdex) => Space(2),
        itemBuilder: (context, index) {
          return _buildListItem(index);
        },
      );
    }

    Widget _buildChild() {
      if (_data == null) {
        return Container();
      }

      if (_data.isError) {
        return _buildMessage(strings.connectionError);
      }

      if (_data.content.status != true) {
        return _buildMessage(_data.content.description);
      }

      if (_data.content.transactionsData == null ||
          _data.content.transactionsData.isEmpty) {
        return _buildMessage('موردی برای نمایش یافت نشد');
      }

      return _buildTransactionList();
    }

    return HeadedPage(
      title: Text('گزارش تراکنش ها'),
      actions: [
        IconButton(
          color: colors.primaryColor,
          icon: Icon(Icons.filter_list),
          onPressed: _onShowFilterPage,
        ),
      ],
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _refresh,
        child: _buildChild(),
      ),
    );
  }

  Widget _buildListItem(int index) {
    final item = _data.content.transactionsData[index];
    return HistoryListItem(data: item);
  }

  void _onShowFilterPage() async {
    final filterInfo = await Navigator.push<FilterInfo>(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFilterDialog(filterInfo: _filterInfo),
        fullscreenDialog: true,
      ),
    );

    if (filterInfo != null) {
      _filterInfo = filterInfo;

      _addAllFilter();

      _refreshKey.currentState?.show();
    }
  }

  void _addTransactionFilter(FilterInfo filterInfo) {
    List<int> transactionType = [];
    List<int> billTypeId = [];
    if (_checkNotSetTransaction(filterInfo)) {
      transactionType.add(0);
    }
    if (filterInfo.cardToCard == true) {
      transactionType.add(2);
    }
    if (filterInfo.netPackage == true) {
      transactionType.add(4);
    }
    if (filterInfo.charge == true) {
      transactionType.add(3);
    }
    if (filterInfo.otherService == true) {
      if (!transactionType.contains(1)) {
        transactionType.add(1);
      }
      billTypeId.add(0);
      billTypeId.add(1);
      billTypeId.add(3);
      billTypeId.add(6);
      billTypeId.add(7);
    }
    if (filterInfo.carFine == true) {
      if (!transactionType.contains(1)) {
        transactionType.add(1);
      }
      billTypeId.add(9);
    }
    if (filterInfo.mobile == true) {
      if (!transactionType.contains(1)) {
        transactionType.add(1);
      }
      billTypeId.add(5);
    }
    if (filterInfo.landPhone == true) {
      if (!transactionType.contains(1)) {
        transactionType.add(1);
      }
      billTypeId.add(4);
    }
    if (filterInfo.elcBill == true) {
      if (!transactionType.contains(1)) {
        transactionType.add(1);
      }
      billTypeId.add(2);
    }

    _filterApiModel.transactionType = transactionType;
    _filterApiModel.billTypeId = billTypeId;
  }

  bool _checkNotSetTransaction(FilterInfo filterInfo) {
    if (filterInfo.cardToCard == false &&
        filterInfo.netPackage == false &&
        filterInfo.charge == false &&
        filterInfo.otherService == false &&
        filterInfo.carFine == false &&
        filterInfo.mobile == false &&
        filterInfo.landPhone == false &&
        filterInfo.elcBill == false) {
      return true;
    }
    return false;
  }

  void _addAllFilter() {
    _filterApiModel.status = null;
    _filterApiModel.fromDate = null;
    _filterApiModel.toDate = null;

    _addTransactionFilter(_filterInfo);
    _addStatusFilter(_filterInfo);
    _addDateFilter(_filterInfo);
  }

  void _addStatusFilter(FilterInfo filterInfo) {
    if (filterInfo.successful == true && filterInfo.unSuccessful == true) {
      _filterApiModel.status = null;
    } else if (filterInfo.successful == true) {
      _filterApiModel.status = 1;
    } else if (filterInfo.unSuccessful == true) {
      _filterApiModel.status = 0;
    }
  }

  void _addDateFilter(FilterInfo filterInfo) {
    if (filterInfo.today == true) {
      DateTime now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      _filterApiModel.fromDate =
          yesterday.toPersian().toString().withEnglishNumbers();
      _filterApiModel.toDate =
          today.toPersian().toString().withEnglishNumbers();
    } else if (filterInfo.recentWeek) {
      DateTime now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastWeek = DateTime(now.year, now.month, now.day - 7);
      _filterApiModel.fromDate =
          lastWeek.toPersian().toString().withEnglishNumbers();
      _filterApiModel.toDate =
          today.toPersian().toString().withEnglishNumbers();
    } else if (filterInfo.recentMonth) {
      DateTime now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastMonth = DateTime(now.year, now.month, now.day - 30);
      _filterApiModel.fromDate =
          lastMonth.toPersian().toString().withEnglishNumbers();
      _filterApiModel.toDate =
          today.toPersian().toString().withEnglishNumbers();
    } else if (filterInfo.periodSelected) {
      _filterApiModel.fromDate = filterInfo.startDay;
      _filterApiModel.toDate = filterInfo.endDay;
    } else {
      _filterApiModel.fromDate = null;
      _filterApiModel.toDate = null;
    }
  }
}

class HistoryListItem extends StatelessWidget {
  HistoryListItem({@required this.data});

  final TransactionData data;

  @override
  Widget build(BuildContext context) {
    final color = _getColor(data.status);

    String state = data.status == true ? 'موفق' : 'ناموفق';

    final line1 = _getHistoryItemTitle(data);
    final line2 = toRials(data.amount);
    final line3Title = _getHistoryItemLastLineTitle(data);
    final line3Value = _getHistoryItemLastLineValue(data);

    final Widget line3 = _isNotNull(line3Value)
        ? Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 24, top: 16, bottom: 16, end: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line3Title),
                Text(':'),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    line3Value,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          )
        : Space(2);

    return Container(
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpandablePanel(
        hasIcon: false,
        header: Container(
          decoration: BoxDecoration(
            color: colors.greyColor.shade600,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 24, top: 16, bottom: 0, end: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            line1,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Space(2),
                          Text(line2 ?? ''),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 24),
                    child: IgnorePointer(
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(color),
                          backgroundColor: MaterialStateProperty.all(
                              colors.greyColor.shade50),
                        ),
                        child: Text(state),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
              line3,
            ],
          ),
        ),
        expanded: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isNotNull(data.paymentId) && data.paymentId.length > 1)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
                child: Row(
                  children: [
                    Text('شناسه پرداخت'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text('${data.paymentId}'.withPersianNumbers())
                  ],
                ),
              ),
            if (_isNotNull(data.paymentId) && data.paymentId.length > 1)
              Space(2),
            if (_isNotNull(data.transferDescription))
              Padding(
                padding: EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
                child: Row(
                  children: [
                    Text('توضیحات'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text(data.transferDescription ?? '-'),
                  ],
                ),
              ),
            if (_isNotNull(data.transferDescription)) Space(2),
            if (_isNotNull(data.pan))
              Padding(
                padding: EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
                child: Row(
                  children: [
                    Text('کارت مبدا'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text('$lrm${protectCardNumber(data.pan)}'
                        .withPersianNumbers())
                  ],
                ),
              ),
            if (_isNotNull(data.pan)) Space(2),
            if (_isNotNull(data.destinationPan))
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 24, end: 24),
                child: Row(
                  children: [
                    Text('کارت مقصد'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text('$lrm${protectCardNumber(data.destinationPan)}'
                        .withPersianNumbers())
                  ],
                ),
              ),
            if (_isNotNull(data.destinationPan)) Space(2),
            if (_isNotNull(data.insertDateTime))
              Padding(
                padding: EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
                child: Row(
                  children: [
                    Text('زمان'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text('$lrm${data.insertDateTime}'.withPersianNumbers())
                  ],
                ),
              ),
            if (_isNotNull(data.insertDateTime)) Space(2),
            if (_isNotNull(data.rrn))
              Padding(
                padding: EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
                child: Row(
                  children: [
                    Text('شماره مرجع'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text(data.rrn.withPersianNumbers())
                  ],
                ),
              ),
            if (_isNotNull(data.rrn)) Space(2),
            if (_isNotNull(data.source))
              Padding(
                padding: EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
                child: Row(
                  children: [
                    Text('پرداخت از طریق'),
                    Text(':'),
                    SizedBox(width: 8),
                    Text(Utils.getPaymentSourceName(data.source))
                  ],
                ),
              ),
            Space(2)
          ],
        ),
      ),
    );
  }
}

class FilterApiModel {
  String fromDate;
  String toDate;
  List<int> transactionType;
  List<int> billTypeId;
  int status;
}

enum FilterType {
  cardToCard,
  mobile,
  netPackage,
  landPhone,
  charge,
  elcBill,
  carFine,
  otherService,
  successful,
  unSuccessful,
  today,
  recentWeek,
  recentMonth,
  periodSelected
}

class TagModel {
  TagModel({this.name, this.type});

  String name;
  FilterType type;
}

Color _getColor(bool status) {
  return status == true ? colors.accentColor : colors.red;
}

String _getHistoryItemTitle(TransactionData item) {
  if (item.transactionType == 1) {
    final typeName = Utils.getBillName(item.billTypeId);
    return 'قبض $typeName';
  } else if (item.transactionType == 2) {
    return 'کارت به کارت';
  } else if (item.transactionType == 3) {
    return 'شارژ تلفن همراه';
  } else if (item.transactionType == 4) {
    return 'بسته اینترنتی';
  } else {
    return '';
  }
}

String _getHistoryItemLastLineTitle(TransactionData item) {
  if (item.transactionType == 1) {
    return 'شناسه قبض';
  } else if (item.transactionType == 2) {
    return 'نام گیرنده';
  } else if (item.transactionType == 3) {
    return 'شماره موبایل';
  } else if (item.transactionType == 4) {
    return 'شماره موبایل';
  } else {
    return '';
  }
}

String _getHistoryItemLastLineValue(TransactionData item) {
  if (item.transactionType == 1) {
    final billId = item.billId;
    return billId.withPersianNumbers();
  } else if (item.transactionType == 2) {
    if (_isNotNull(item.cardHolder)) {
      return item.cardHolder.withPersianLetters().withPersianNumbers();
    }
    return null;
  } else if (item.transactionType == 3) {
    return item.toChargeNumber.withPersianNumbers();
  } else if (item.transactionType == 4) {
    return item.toChargeNumber.withPersianNumbers();
  } else {
    return '';
  }
}

bool _isNotNull(String str) {
  return str != null && str.isNotEmpty && str != '-';
}
