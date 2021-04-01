import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/credit_card.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/credit_card/installment_payment.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class CreditCardChooseStatementTypePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _CreditCardChooseStatementTypePageState();
}

class _CreditCardChooseStatementTypePageState
    extends State<CreditCardChooseStatementTypePage> {
  int _groupValue;
  bool _visibleList = true;
  final List<PaymentType> _returnList = [];
  final List<String> _sortingCaptions = [];
  final List<PaymentType> _sortedList = [];
  int _positionOptions;
  int paymentType;

  void _onChanged(int value) {
    setState(() {
      _groupValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    final paymentTypes = appState.generalInfo.paymentTypes;
    if (paymentTypes != null && paymentTypes.length == 1) {
      _groupValue = 0;
      _positionOptions = 0;
    }
    if (paymentTypes != null) {
      _visibleList = true;
      _returnList.addAll(paymentTypes);
      for (int i = 0; i < _returnList.length; i++) {
        if (!_sortingCaptions.contains(
            setInstallmentCountTitle(_returnList[i].installmentCount))) {
          _sortingCaptions
              .add(setInstallmentCountTitle(_returnList[i].installmentCount));
        }
      }
      _sortedList.clear();
      for (int i = 0; i < _returnList.length; i++) {
        if (setInstallmentCountTitle(_returnList[i].installmentCount) ==
            _sortingCaptions[0]) {
          _sortedList.add(_returnList[i]);
        }
      }
      _positionOptions = 0;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('تعیین اقساط صورتحساب'),
      body: Column(
        children: [
          if (_sortingCaptions.isNotEmpty)
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Space(2),
                      if (_visibleList)
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: _sortingCaptions.length,
                              itemBuilder: (context, index) {
                                var item = _sortingCaptions[index];
                                return InkWell(
                                  onTap: () {
                                    _sortedList.clear();
                                    for (int i = 0;
                                        i < _returnList.length;
                                        i++) {
                                      if (setInstallmentCountTitle(
                                              _returnList[i]
                                                  .installmentCount) ==
                                          item) {
                                        _sortedList.add(_returnList[i]);
                                      }
                                    }
                                    setState(() {
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
                                            : colors.primaryColor.shade50,
                                      ),
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          8, 8, 8, 8),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            color: _positionOptions == index
                                                ? colors.greyColor
                                                : colors.primaryColor,
                                          ),
                                        ),
                                      )),
                                );
                              }),
                        ),
                      Space(2),
                      if (_visibleList)
                        Expanded(
                          flex: 9,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _sortedList.length,
                            itemBuilder: (context, index) {
                              var item = _sortedList[index];
                              return Container(
                                margin:
                                    EdgeInsetsDirectional.fromSTEB(4, 8, 4, 8),
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24, 16, 24, 16),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {});
                                  },
                                  child: InstallmentPayment(
                                    onChanged: _onChanged,
                                    label: setInstallmentCountTitle(
                                        item.installmentCount),
                                    due: item.dueDate?.withPersianNumbers(),
                                    value: index,
                                    groupValue: _groupValue,
                                    total: item.mainDebitAmount,
                                    soodTashilat: item.installmentFee,
                                    paid: item.payAmount,
                                    pay: item.curInstallmentAmount,
                                    previous: item.prevDebit,
                                    serviceFee: item.feeTotalAmount,
                                    sood: item.crInterestTotalAmount,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          Container(
            margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
            child: ConfirmButton(
              onPressed: _onSubmit,
              child: CustomText(
                'پرداخت',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    final generalInfo = appState.generalInfo;
    final customerInfo = appState.customerInfo;
    if (generalInfo.statementDetails.isPayed) {
      ToastUtils.showCustomToast(context, 'بدهی قبلا پرداخت شده است',
          Image.asset('assets/ic_error.png'));
      return;
    }
    final List<PaymentType> paymentTypes = generalInfo.paymentTypes;
    final installmentCount = paymentTypes[_positionOptions].installmentCount;
    final amount = paymentTypes[_positionOptions].payAmount;

    final String cardNumber =
        customerInfo.customerCards.cardInfoVOsField[0].pan;
    //  final String cardNumber = generalInfo.statementDetails.cardPan;

    final String firstName =
        generalInfo.statementDetails.customerFirstName ?? '';
    final String lastName = generalInfo.statementDetails.customerLastName ?? '';
    final String statementNumber =
        generalInfo.statementDetails.statementNumber ?? '';

    final customerNumber = customerInfo.data.customerNo;
    if (amount != null && amount > 0) {
      final payInfo = await showPaymentBottomSheet(
          context: context,
          title: Text('پرداخت صورت حساب'),
          amount: amount,
          transactionType: TransactionType.buy,
          acceptorName: '',
          acceptorId: '17');
      if (payInfo == null) {
        return;
      }
      final data = await Loading.run(
          context,
          nh.creditCard.creditCardPayment(
            paymentType: PaymentMethod.one,
            cardInfo: payInfo.cardInfo,
            amount: amount,
            cardNumber: cardNumber,
            fullNamePayer: '$firstName $lastName',
            statementNumber: statementNumber,
            installmentCount: installmentCount,
            customerNumber: customerNumber,
          ));

      if (!showConnectionError(context, data)) {
        return;
      }

      if (data.content.status != true) {
        await showFailedTransaction(context, data.content.description,
            data.content.stan, data.content.rrn, 'پرداخت صورت حساب', amount);
        return;
      }

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OverViewPage(
            title: 'کارت اعتباری',
            cardNumber: payInfo.cardInfo.pan,
            stan: data.content.stan,
            rrn: data.content.rrn,
            topupPin: null,
            description: ' پرداخت صورت حساب $firstName $lastName',
            amount: amount,
            isShaparak: false,
          ),
        ),
      );
    }
  }

  String setInstallmentCountTitle(int installment) {
    switch (installment) {
      case 0:
        return 'پرداخت یکجا';
      case -1:
        return 'پرداخت بدون تقسیط';
    }
    return 'در $installment قسط';
  }
}
