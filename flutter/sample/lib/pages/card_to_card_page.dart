import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/card_selection_mixin.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/pages/card_to_card_confirm_page.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class CardToCardPage extends StatefulWidget {
  @override
  _CardToCardPageState createState() => _CardToCardPageState();
}

class _CardToCardPageState extends State<CardToCardPage>
    with MruSelectionMixin, CardSelectionMixin {
  final _formKey = GlobalKey<FormState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _sourceCardController = TextEditingController();
  final _destinationController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _panFocusNode = FocusNode();
  final _destinationFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();
  final _btnFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  String _expMonth;
  String _expYear;
  int _sourceCardId;
  int _destinationCardId;

  bool _listenSourceId = true;
  bool _listenDestinationId = true;

  final ScrollController _scrollController = ScrollController();

  Future<void> _onRefresh() async {
    if (appState.supportedBins == null || appState.supportedBins.isEmpty) {
      final data = await nh.novinPay.application.checkVersion();

      if (data.hasErrors()) {
        return;
      }

      setState(() {
        appState.supportedBins = data.content.supportedBins;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    final banks = appState?.supportedBins
        ?.map((e) => Utils.getBankLogo(e))
        ?.toSet()
        ?.toList();

    Widget child = Split(
      child: Expanded(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 24.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CardTextFormField(
                    focusNode: _panFocusNode,
                    labelText: 'کارت مبدا',
                    onChanged: (value) {
                      if (_listenSourceId) {
                        _sourceCardId = null;
                        _expYear = null;
                        _expMonth = null;
                      }
                    },
                    controller: _sourceCardController,
                    onEditingComplete: () {
                      _panFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_destinationFocusNode);
                    },
                    showSelectionDialog: _showSourceCardDialog,
                  ),
                  Space(2),
                  CardTextFormField(
                    focusNode: _destinationFocusNode,
                    labelText: 'کارت مقصد',
                    onChanged: (value) {
                      if (_listenDestinationId) {
                        _destinationCardId = null;
                      }
                    },
                    controller: _destinationController,
                    onEditingComplete: () {
                      _destinationFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(_amountFocusNode);
                    },
                    showSelectionDialog: _showDestinationCardDialog,
                  ),
                  Space(2),
                  MoneyTextFormField(
                    focusNode: _amountFocusNode,
                    minimum: 10000,
                    maximum: 100000000,
                    controller: _amountController,
                    onEditingComplete: () {
                      _amountFocusNode.unfocus();
                      FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode);
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  Space(2),
                  Text(
                    _getPersianAmount(),
                    style: TextStyle(color: colors.accentColor.shade500),
                  ),
                  Space(2),
                  Container(
                    height: 80,
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                    child: TextFormField(
                      focusNode: _descriptionFocusNode,
                      controller: _descriptionController,
                      minLines: 2,
                      maxLines: null,
                      onEditingComplete: () {
                        _descriptionFocusNode.unfocus();
                        _btnFocusNode.requestFocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'توضیحات',
                        border: InputBorder.none,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: colors.greyColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Space(4),
                  if (appState.supportedBins != null &&
                      appState.supportedBins.isNotEmpty)
                    Marquee(
                      direction: Axis.horizontal,
                      pauseDuration: Duration(seconds: 1),
                      animationDuration: Duration(seconds: 10),
                      backDuration: Duration(seconds: 10),
                      child: Container(
                        height: 56.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: banks.length,
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          itemBuilder: (context, index) {
                            final item = banks[index];
                            if (item != null) {
                              return Container(
                                margin: EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  banks[index],
                                  width: 56,
                                  height: 56,
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
        child: ConfirmButton(
          focusNode: _btnFocusNode,
          child: CustomText(
            'تایید',
            style: colors.tabStyle(context).copyWith(
                  color: colors.greyColor.shade50,
                ),
            textAlign: TextAlign.center,
          ),
          onPressed: _submit,
        ),
      ),
    );

    if (appState.supportedBins == null || appState.supportedBins.isEmpty) {
      child = RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: child,
      );
    }

    return HeadedPage(
      title: Text('کارت به کارت'),
      body: child,
    );
  }

  String _getPersianAmount() {
    final text = _amountController.text?.replaceAll(',', '');
    final amount = int.tryParse(text ?? '');
    if (amount == null) {
      return 'مبلغ به حروف';
    }
    final toman = (amount ~/ 10).toPersianString();
    return '$toman تومان';
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final sourceCardNumber = _sourceCardController.text;
    final destinationCardNumber = _destinationController.text;

    final inqcardInfo = CardInfo(
      pan: sourceCardNumber,
      pin: '1111',
      cvv: '123',
      expire: '1010',
      sourceCardId: _sourceCardId,
      destinationCardId: _destinationCardId,
      destinationPan: destinationCardNumber,
    );

    final dateTime = DateFormat('yyyMMddHHmmss').format(DateTime.now());

    final mobileStan = _mobileStan();

    final amount =
        int.tryParse(_amountController.text?.replaceAll(',', '') ?? '');

    final data = await Loading.run(
      context,
      nh.cardTransfer.cardInquiry(
        cardInfo: inqcardInfo,
        amount: amount,
        dateTime: dateTime,
        mobileStan: mobileStan,
      ),
    );

    if (!showError(context, data)) {
      return;
    }

    final switchStan = data.content.traceNumber;
    final sourceCardTitle = Utils.getBankName(sourceCardNumber);
    final destinationHolderName = data.content.cardHolder;
    final additionalData = data.content.additionalData;
    final description = _descriptionController.text;

    final cardInfo = await Navigator.of(context).push<CardInfo>(
      MaterialPageRoute(
          builder: (context) => CartToCardConfirm(
                sourceCardNumber: sourceCardNumber,
                sourceCardId: _sourceCardId,
                destinationCardNumber: destinationCardNumber,
                destinationCardId: _destinationCardId,
                amount: amount,
                holderName: destinationHolderName,
                expDateMonth: _expMonth,
                expDateYear: _expYear,
              )),
    );

    if (cardInfo == null) {
      return;
    }

    Future<void> _doCardTransfer() async {
      final data = await Loading.run(
        context,
        nh.cardTransfer.cardTransfer(
          cardInfo: cardInfo,
          amount: amount,
          switchStan: switchStan,
          holderInquiryDateTime: dateTime,
          sourceCardTitle: sourceCardTitle,
          destinationCardITitle: destinationHolderName,
          additionalData: additionalData,
          saveCard: cardInfo.saveCard,
          description: description,
          mobileStan: mobileStan,
        ),
      );
      if (!showConnectionError(context, data)) {
        return;
      }
      if (!data.content.status) {
        await showFailedTransaction(context, data.content.description,
            data.content.stan, null, 'کارت به کارت', amount);
        return;
      }
      nh.mru.addMru(
        type: MruType.sourceCard,
        title: Utils.getBankName(sourceCardNumber),
        value: sourceCardNumber.replaceAll('-', ''),
        expDate: cardInfo.expire,
      );

      if (cardInfo.saveCard) {
        nh.mru.addMru(
          type: MruType.destinationCard,
          title: destinationHolderName,
          value: destinationCardNumber.replaceAll('-', ''),
        );
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OverViewPage(
              title: 'کارت به کارت',
              cardNumber: sourceCardNumber,
              destinationCardNumber: destinationCardNumber,
              stan: data.content.stan,
              rrn: data.content.rrn,
              description:
                  'انتقال وجه به شماره  کارت $lrm${protectCardNumber(destinationCardNumber)}$rlm به نام $destinationHolderName',
              amount: amount,
              isShaparak: false),
        ),
      );
    }

    await _doCardTransfer();
  }

  void _showSourceCardDialog() async {
    final data = await showSourceCardSelectionDialog();
    if (data == null) {
      return;
    }

    setState(() {
      _listenSourceId = false;
      _sourceCardController.text = protectCardNumber(data.value);
      _listenSourceId = true;
      _sourceCardId = data.id;
      if (data.expDate != null && data.expDate.length == 4) {
        _expYear = data.expDate.substring(0, 2);
        _expMonth = data.expDate.substring(2, 4);
      }
    });
  }

  void _showDestinationCardDialog() async {
    final data = await showDestinationCardSelectionDialog();

    if (data == null) {
      return;
    }
    setState(() {
      _listenDestinationId = false;
      _destinationController.text = protectCardNumber(data.value);
      _listenDestinationId = true;
      _destinationCardId = data.id;
    });
  }

  String _mobileStan() {
    final rnd = Random();
    return rnd.nextInt(999999).toString();
  }
}
