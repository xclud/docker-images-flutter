import 'package:flutter/material.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/NetPackageResponse.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/mobile_input.dart';
import 'package:persian/persian.dart';

class NetPackagePage extends StatefulWidget {
  @override
  _NetPackagePageState createState() => _NetPackagePageState();
}

class _NetPackagePageState extends State<NetPackagePage> {
  final _mobileController = TextEditingController();
  Color _colorOperator;
  Color _colorOperatorSelected;
  Color _colorOperatorCard;
  Color _colorOperatorText;
  String _name = '';
  int _operatorId;
  ChargeType chargeType;
  String _acceptorId = '16';
  final List<ReturnList> _returnList = [];
  final List<String> _sortingCaptions = [];
  bool _visibleList = false;
  final List<ReturnList> _sortedList = [];
  final _formKey = GlobalKey<FormState>();

  int _position;
  int _positionOptions;
  bool _visibilityCard = false;
  int _amount;
  int _index = 0;
  bool _visible_tab_bar = false;
  String _chargeType;
  int _reserveNumber;

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  void _onChanged(String input) {
    if (input.length <= 10) {
      setState(() {
        _position = -1;
        _visible_tab_bar = false;
        _index = 0;
        _visibleList = false;
        _colorOperator = null;
        _colorOperatorSelected = null;
        _colorOperatorCard = null;
        _name = '';
      });
    }
  }

  void _onItemClicked(String value) {
    _inquiry();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('بسته اینترنتی'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Form(
              key: _formKey,
              child: MobileWidget(
                controller: _mobileController,
                onChanged: _onChanged,
                onItemClicked: _onItemClicked,
                showSimCard: false,
              ),
            ),
          ),
          if (_visible_tab_bar)
            Container(
              margin: EdgeInsets.only(right: 24, left: 24),
              child: CustomTabBar(
                onChange: (index) async {
                  setState(() {
                    chargeType = _getChargeType(index);
                    _position = -1;
                    _positionOptions = -1;
                    _visibilityCard = false;
                  });
                  _callService();
                },
                items: [
                  CustomTabBarItem(title: 'اعتباری'),
                  CustomTabBarItem(title: 'دائمی'),
                  CustomTabBarItem(title: 'دیتا'),
                ],
              ),
            ),
          if (_index == 0)
            Expanded(
              child: Center(
                child: Text(
                  'برای مشاهده بسته های اینترنت شماره مورد نظر \n خود را وارد نمایید',
                  style: colors
                      .regularStyle(context)
                      .copyWith(color: colors.greyColor.shade900),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (_index != 0)
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  if (_visibleList)
                    SizedBox(
                      height: 48,
                      child: ListView.builder(
                          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                          scrollDirection: Axis.horizontal,
                          itemCount: _sortingCaptions.length,
                          itemBuilder: (context, index) {
                            var item = _sortingCaptions[index];
                            return InkWell(
                              onTap: () {
                                _sortedList.clear();
                                for (int i = 0; i < _returnList.length; i++) {
                                  if (_returnList[i].caption == item) {
                                    _sortedList.add(_returnList[i]);
                                  }
                                }
                                setState(() {
                                  _visibilityCard = false;
                                  _position = null;
                                  _positionOptions = index;
                                });
                              },
                              child: Container(
                                  margin: EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 4, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: _positionOptions == index
                                        ? colors.primaryColor
                                        : colors.primaryColor.shade100,
                                  ),
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 4, 16, 4),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      item,
                                      style: TextStyle(
                                        color: _positionOptions == index
                                            ? Colors.white
                                            : colors.primaryColor,
                                      ),
                                    ),
                                  )),
                            );
                          }),
                    ),
                  if (_visibleList)
                    SizedBox(
                      height: 20,
                    ),
                  Expanded(
                    flex: 6,
                    child: ListView.builder(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _sortedList.length,
                      itemBuilder: (context, index) {
                        var item = _sortedList[index];
                        return Container(
                          margin: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 4),
                          padding:
                              EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                          decoration: BoxDecoration(
                            color: _position == index
                                ? _colorOperatorSelected
                                : _colorOperator,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _chargeType = item.chType;
                                _position = index;
                                _amount = int.tryParse(item.affAmount);
                                _visibilityCard = true;
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        item.trafic
                                            .trim()
                                            ?.withPersianNumbers(),
                                        maxLines: 1,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                            color: _colorOperatorText),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                          toTomans(
                                              int.tryParse(item.orgAmount) ~/
                                                  10),
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              color: _colorOperatorText)),
                                    )
                                  ],
                                ),
                                Space(),
                                Text(item.title?.withPersianNumbers(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textDirection: TextDirection.rtl,
                                    style:
                                        TextStyle(color: _colorOperatorText)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (_visibilityCard)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
                        child: DismissibleRoundButton(
                          buttonText: 'خرید',
                          color: _colorOperatorCard,
                          text: ' مبلغ + مالیات : ${toTomans(_amount ~/ 10)}',
                          onPressed: _pay,
                          onDismiss: () {
                            setState(() {
                              _visibilityCard = false;
                            });
                          },
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (!_visible_tab_bar)
            Container(
              margin: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
              child: ConfirmButton(
                color: colors.ternaryColor,
                onPressed: () {
                  _inquiry();
                },
                child: CustomText(
                  strings.action_inquiry,
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ],
      ),
    );
  }

  ChargeType _getChargeType(int index) {
    switch (index) {
      case 0:
        return ChargeType.credit;
      case 1:
        return ChargeType.permanent;
      case 2:
        return ChargeType.data;
    }
    return ChargeType.credit;
  }

  void _inquiry() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    String input = _mobileController.text;
    final MobileOperator _operatorType = Utils.getOperatorType(input);
    if (_operatorType == null) {
      ToastUtils.showCustomToast(
          context,
          'متاسفانه اپراتور درخواستی پشتیبانی نمیشود.',
          Image.asset('assets/ic_error.png'),
          'خطا');
    } else if (input.length == 11) {
      setState(() {
        _colorOperator = Utils.getOperatorInactiveColor(_operatorType);
        _colorOperatorCard = Utils.getOperatorCardColor(_operatorType);
        _colorOperatorSelected = Utils.getOperatorActiveColor(_operatorType);
        _name = Utils.getOperatorName(_operatorType);
        _colorOperatorText = Utils.getOperatorTextColor(_operatorType);
        if (_operatorType == MobileOperator.irancell) {
          _operatorId = 2;
          _acceptorId = '14';
        } else if (_operatorType == MobileOperator.rightel) {
          _operatorId = 3;
          _acceptorId = '15';
        } else if (_operatorType == MobileOperator.mci) {
          _operatorId = 1;
          _acceptorId = '13';
        }
      });

      if (_name == '') {
        ToastUtils.showCustomToast(context, 'شماره وارد شده صحیح نمیباشد.',
            Image.asset('assets/ic_error.png'));
      } else {
        setState(() {
          _visible_tab_bar = true;
          _callService();
        });
      }
    }
  }

  void _pay() async {
    final mobile = _mobileController.text;
    final payInfo = await showPaymentBottomSheet(
      transactionType: TransactionType.buy,
      acceptorName: 'بسته اینترنتی',
      context: context,
      title: Text('بسته اینترنتی'),
      amount: _amount,
      acceptorId: _acceptorId,
      enableWallet: true,
      children: [
        DualListTile(
          start: Text(strings.label_mobile_number),
          end: Text(mobile?.withPersianNumbers() ?? ''),
        ),
      ],
    );

    if (payInfo == null) {
      return;
    }
    if (payInfo.type == PaymentType.normal) {
      _normalPay(payInfo.cardInfo);
    } else if (payInfo.type == PaymentType.wallet) {
      _walletPay();
    }
  }

  void _normalPay(CardInfo cardInfo) async {
    final mobile = _mobileController.text;
    final data = await Loading.run(
        context,
        nh.netPackage.getConfirm(
          cardInfo: cardInfo,
          reserveNumber: _reserveNumber,
          amount: _amount,
          chargeType: int.parse(_chargeType),
          deviceType: 59,
          toChargeNumber: mobile,
          additionalData: '',
        ));

    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(context, data.content.description,
          data.content.stan, data.content.rrn, 'بسته اینترنتی', _amount);
      return;
    }
    nh.mru.addMru(type: MruType.mobile, title: null, value: mobile);

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
            title: 'بسته اینترنتی',
            cardNumber: cardInfo.pan,
            stan: data.content.stan,
            rrn: data.content.rrn,
            topupPin: null,
            description: 'خرید بسته اینترنتی $mobile'.withPersianNumbers(),
            amount: _amount,
            isShaparak: true),
      ),
    );
  }

  void _walletPay() async {
    final mobile = _mobileController.text;
    final balanceData = await Loading.run(context, nh.wallet.getBalance());

    if (!showError(context, balanceData)) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.wallet.internetPackage(
        deviceType: 59,
        additionalData: '',
        toChargeNumber: mobile,
        reserveNumber: _reserveNumber,
        chargeType: int.parse(_chargeType),
        amount: _amount,
        balance: balanceData.content.balance,
      ),
    );

    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(
          context,
          data.content.description,
          data.content.reserveNumber.toString(),
          data.content.referenceNumber.toString(),
          'بسته اینترنتی',
          _amount);
      return;
    }
    nh.mru.addMru(type: MruType.mobile, title: null, value: mobile);

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
            title: 'بسته اینترنتی',
            cardNumber: null,
            stan: data.content.reserveNumber.toString(),
            rrn: data.content.referenceNumber.toString(),
            topupPin: null,
            description: 'خرید بسته اینترنتی $mobile'.withPersianNumbers(),
            amount: _amount,
            isShaparak: false),
      ),
    );
  }

  void _callService() async {
    chargeType ??= ChargeType.credit;
    if (_operatorId == 1 || _operatorId == 2 || _operatorId == 3) {
      _returnList.clear();
      _sortedList.clear();
      _sortingCaptions.clear();
      final data = await Loading.run(
        context,
        nh.netPackage.netPackage(
          operatorId: _operatorId,
          chargeType: chargeType.index,
          toChargeNumber: _mobileController.text,
        ),
      );

      if (data.isError) {
        if (!data.isExpired) {
          ToastUtils.showCustomToast(context, data.error,
              Image(image: AssetImage('assets/ic_error.png')));
        }
        setState(() {
          _visibleList = false;
          _visible_tab_bar = false;
        });
        return;
      }
      if (data.content.status) {
        _reserveNumber = data.content.reserveNumber;
        setState(() {
          _index = 1;
          _visibleList = true;
          _visibilityCard = false;
          _returnList.addAll(data.content.returnList);
//          _sortedList.addAll(_returnList);
          for (int i = 0; i < _returnList.length; i++) {
            if (!_sortingCaptions.contains(_returnList[i].caption)) {
              _sortingCaptions.add(_returnList[i].caption);
            }
          }
          _sortedList.clear();
          for (int i = 0; i < _returnList.length; i++) {
            if (_returnList[i].caption == _sortingCaptions[0]) {
              _sortedList.add(_returnList[i]);
            }
          }
          _positionOptions = 0;
        });
      } else {
        ToastUtils.showCustomToast(context, strings.connectionError,
            Image.asset('assets/ic_error.png'), 'خطا');
        setState(() {
          _visibleList = false;
          _visible_tab_bar = false;
        });
        return;
      }
    } else {
      if (_mobileController.text.isEmpty) {
        ToastUtils.showCustomToast(
            context,
            'لطفا شماره موبایل مورد نظر را وارد نمایید',
            Image.asset('assets/ic_error.png'));
      }
      ToastUtils.showCustomToast(context, 'شماره وارد شده صحیح نیست',
          Image.asset('assets/ic_error.png'), 'خطا');
    }
  }
}

enum ChargeType { permanent, credit, data }
