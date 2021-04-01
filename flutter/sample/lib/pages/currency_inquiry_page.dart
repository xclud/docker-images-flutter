import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/exchange.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class CurrencyInquiryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CurrencyInquiryPageState();
}

class _CurrencyInquiryPageState extends State<CurrencyInquiryPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<ExchangeRateResponse> _data;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  Future<void> _refresh() async {
    final data = await nh.exchangeRate.exchangeRate();

    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildMessage(String message) => Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
            child: Text(
              message ?? '',
              textAlign: TextAlign.center,
            ),
          ),
        );

    Widget _buildLoadingMessage() => _buildMessage(strings.please_wait);

    Widget _buildCurrencyList() {
      List<MoneyRates> items = [];
      if (_selectedTab == 0) {
        items = _data.content.moneyRates;
      } else {
        items = _data.content.chequeRate;
      }
      return ScrollConfiguration(
        behavior: CustomBehavior(),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return CurrencyItem(moneyRates: items[index]);
          },
        ),
      );
    }

    Widget _buildHeader() {
      String date = _getDateFromDateTime(_data?.content?.updateDateTime);
      String gregorianDate = _getGregorianDate(date);
      String time = _getTimeFromDateTime(_data?.content?.updateDateTime);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsetsDirectional.only(top: 8.0),
            child: Column(
              children: [
                CustomText((date ?? '').withPersianNumbers(),
                    textAlign: TextAlign.center,
                    style: colors.boldStyle(context).copyWith(
                          color: colors.ternaryColor,
                        )),
                SizedBox(
                  height: 4,
                ),
                CustomText(gregorianDate ?? '',
                    textAlign: TextAlign.center,
                    style: colors.tabStyle(context).copyWith(
                          color: colors.ternaryColor,
                        )),
                SizedBox(
                  height: 4,
                ),
                Center(
                  child: CustomText(
                    'آخرین بروزرسانی: ساعت ${time ?? ''}'.withPersianNumbers(),
                    textAlign: TextAlign.center,
                    style: colors.regularStyle(context).copyWith(
                          color: colors.accentColor,
                        ),
                  ),
                )
              ],
            ),
          ),
          Space(3),
        ],
      );
    }

    Widget _buildBody() {
      return Split(
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
                  child: CustomTabBar(
                    onChange: (index) {
                      setState(() {
                        _selectedTab = index;
                      });
                    },
                    items: [
                      CustomTabBarItem(title: strings.banknote_rates),
                      CustomTabBarItem(title: strings.cheque_rates),
                    ],
                  ),
                ),
                Space(3),
                _buildCurrencyList(),
                Space(1),
              ],
            ),
          ),
        ),
        footer: InkWell(
          onTap: () {
            Utils.customLaunch(context, 'http://mex.co.ir/');
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24),
            child: Text('منبع: صرافی ملی ایران ${lrm}mex.co.ir',
                style: colors.boldStyle(context).copyWith(
                      color: Colors.blue.shade900,
                      decoration: TextDecoration.underline,
                    )),
          ),
        ),
      );
    }

    Widget _buildChild() {
      if (_data == null) {
        return _buildLoadingMessage();
      }

      if (_data.isError) {
        return _buildMessage(strings.connectionError);
      }

      if (_data.content.status != true) {
        return _buildMessage(_data.content.description);
      }

      if (_data.content.moneyRates == null ||
          _data.content.moneyRates.isEmpty) {
        return _buildMessage(strings.noItemsFound);
      }

      if (_data.content.chequeRate == null ||
          _data.content.chequeRate.isEmpty) {
        return _buildMessage(strings.noItemsFound);
      }

      return _buildBody();
    }

    return HeadedPage(
      title: Text(strings.currency_inquiry),
        actions: [
          IconButton(
            onPressed: () {
              _refreshKey.currentState?.show();
            },
            icon: Icon(
              Icons.refresh_outlined,
              color: colors.ternaryColor,
            ),
          )
        ],
        body: Split(
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _refresh,
            child: _buildChild(),
          ),
        ));
  }

  String _getTimeFromDateTime(String datetime) {
    if (datetime == null) {
      return '';
    }
    List<String> dts = datetime.split(' ');
    if (dts.length < 2) {
      return '';
    }
    return dts[1];
  }

  String _getDateFromDateTime(String datetime) {
    if (datetime == null) {
      return '';
    }
    List<String> dts = datetime.split(' ');
    if (dts.length < 2) {
      return '';
    }
    return dts[0];
  }

  String _getGregorianDate(String date) {
    if (date == null) {
      return '';
    }
    List<String> ds = date.split('/');
    if (ds.length != 3) {
      return '';
    }
    return Utils.jalaliToGregorian(
        int.tryParse(ds[0]), int.tryParse(ds[1]), int.tryParse(ds[2]), '/');
  }
}

class CurrencyItem extends StatelessWidget {
  CurrencyItem({@required this.moneyRates});

  final MoneyRates moneyRates;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Container(
        padding:
            EdgeInsetsDirectional.only(start: 24, end: 24, top: 16, bottom: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: colors.greyColor.shade600),
        child: Center(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Image.network(
                      moneyRates.imageUrl,
                      height: 36,
                      width: 36,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      Utils.getCurrencyName(moneyRates.title),
                      style: colors.boldStyle(context),
                    )
                  ],
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(strings.buy,
                        style: colors.bodyStyle(context).copyWith(
                              color: colors.accentColor,
                            )),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      toRials(moneyRates.buy),
                      style: colors.boldStyle(context),
                    )
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(strings.sale,
                        style: colors.bodyStyle(context).copyWith(
                              color: colors.red,
                            )),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      toRials(moneyRates.sale),
                      style: colors.boldStyle(context),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
