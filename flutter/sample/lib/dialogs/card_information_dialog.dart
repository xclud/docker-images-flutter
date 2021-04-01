import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/payment_method_dialog.dart';
import 'package:novinpay/mixins/card_selection_mixin.dart';
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun_icons.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/otp_button.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class CardInformation extends StatefulWidget {
  CardInformation({
    @required this.amount,
    @required this.transactionType,
    @required this.acceptorName,
    @required this.acceptorId,
    this.scrollController,
    this.onPay,
  });

  final int amount;
  final ScrollController scrollController;
  final TransactionType transactionType;
  final String acceptorName;
  final String acceptorId;
  final PayCallback onPay;

  @override
  _CardInformationState createState() => _CardInformationState();
}

class _CardInformationState extends State<CardInformation>
    with MruSelectionMixin, CardSelectionMixin, DisableManagerMixin {
  final _formKey = GlobalKey<FormState>();
  static final _translator = {
    '#': RegExp(r'[\d]'),
    '*': RegExp(r'[\d\*]'),
  };
  final _panController = MaskedTextController(
      mask: '####-##**-****-####', translator: _translator);

  @override
  void initState() {
    super.initState();
    _expMController.addListener(() {
      if (_expMController.text.length == 2) {
        _expMFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_expYFocusNode);
      }
    });
  }

  final _pinController = TextEditingController();
  final _cvvController = TextEditingController();
  final TextEditingController _expMController = TextEditingController();
  final TextEditingController _expYController = TextEditingController();
  int _prevPanLength = 0;
  bool _ignoreValidation = false;
  int _sourceCardId;
  final bool _saveCardInfo = true; //Remove final and use.

  final _panFocusNode = FocusNode();
  final _pinFocusNode = FocusNode();
  final _cvvFocusNode = FocusNode();
  final _expYFocusNode = FocusNode();
  final _expMFocusNode = FocusNode();
  final _otpBtnFocusNode = FocusNode();
  final _btnFocusNode = FocusNode();

  String _pinValidator(String value) {
    if (_ignoreValidation) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return strings.validation_should_not_be_empty;
    }
    if (value.length < 5) {
      return strings.validation_is_not_correct;
    }
    return null;
  }

  String _expYValidator(String value) {
    if (_ignoreValidation == true) {
      return null;
    }

    if (_expYController.text == null || _expYController.text.isEmpty) {
      return strings.validation_should_not_be_empty;
    }

    if (_expYController.text.length != 2) {
      return strings.validation_is_not_correct;
    }

    return null;
  }

  String _expMValidator(String value) {
    if (_ignoreValidation == true) {
      return null;
    }

    if (value == null ||
        value.isEmpty ||
        _expMController.text == null ||
        _expMController.text.isEmpty) {
      return strings.validation_should_not_be_empty;
    }

    if (value.length != 2 || _expMController.text.length != 2) {
      return strings.validation_is_not_correct;
    }

    if (!value.contains('•') && RegExp(r'^[0-9]*$').hasMatch(value)) {
      final int _intValue = int.parse(value);
      if (_intValue > 12 || _intValue < 1) {
        return strings.validation_is_not_correct;
      }
    }

    return null;
  }

  String _cvvValidator(String value) {
    if (_ignoreValidation) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return strings.validation_should_not_be_empty;
    }
    if (value.length < 3) {
      return strings.validation_is_not_correct;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('پرداخت با کارت شتابی'),
      body: Split(
        child: Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 16.0, 16.0, 16.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: colors.primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              SunIcons.bill,
                              size: 30,
                              color: colors.primaryColor,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    toRials(widget.amount).withPersianNumbers(),
                                    textAlign: TextAlign.right,
                                    style: colors.boldStyle(context).copyWith(
                                          color: colors.primaryColor,
                                        ),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(_getPersianAmount(),
                                      textAlign: TextAlign.right,
                                      style: colors
                                          .bodyStyle(context)
                                          .copyWith(color: colors.primaryColor))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Space(3),
                      CardTextFormField(
                        focusNode: _panFocusNode,
                        controller: _panController,
                        labelText: 'شماره کارت',
                        showSelectionDialog: _showCardSelectionDialog,
                        onEditingComplete: () {
                          _panFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_pinFocusNode);
                        },
                        onChanged: (value) {
                          if (value.length < 19) {
                            if (_sourceCardId != null) {
                              _panController.text = '';
                            }
                            _sourceCardId = null;
                            _expYController.text = '';
                            _expMController.text = '';
                          }

                          if (_prevPanLength != value.length &&
                              value.length == 19) {
                            _panFocusNode.unfocus();
                            _pinFocusNode.requestFocus();
                          }

                          _prevPanLength = value.length;
                          setState(() {});
                        },
                      ),
                      Space(2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PasswordTextFormField(
                              focusNode: _pinFocusNode,
                              controller: _pinController,
                              validator: _pinValidator,
                              maxLength: 12,
                              onEditingComplete: () {
                                _pinFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_cvvFocusNode);
                              },
                              labelText: 'رمز دوم',
                              hintText: '۱۲۳۴۵۶',
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 48.0,
                              child: OtpButton(
                                focusNode: _otpBtnFocusNode,
                                onRequested: _requestOTP,
                              ),
                            ),
                          )
                        ],
                      ),
                      Space(2),
                      PasswordTextFormField(
                        focusNode: _cvvFocusNode,
                        controller: _cvvController,
                        maxLength: 4,
                        validator: _cvvValidator,
                        onEditingComplete: () {
                          _cvvFocusNode.unfocus();
                          FocusScope.of(context).requestFocus(_expMFocusNode);
                        },
                        hintText: '۱۲۳',
                        labelText: 'CVV2',
                      ),
                      Space(2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PasswordTextFormField(
                              focusNode: _expMFocusNode,
                              validator: _expMValidator,
                              controller: _expMController,
                              maxLength: 2,
                              obscureText: _sourceCardId != null,
                              onEditingComplete: () {
                                _expMFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_expYFocusNode);
                              },
                              onChanged: (value) {
                                if (value.length == 2) {
                                  _expMFocusNode.unfocus();
                                  _expYFocusNode.requestFocus();
                                }
                              },
                              labelText: 'ماه',
                              hintText: '۱۲',
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: PasswordTextFormField(
                              focusNode: _expYFocusNode,
                              validator: _expYValidator,
                              controller: _expYController,
                              maxLength: 2,
                              obscureText: _sourceCardId != null,
                              onEditingComplete: () {
                                _expYFocusNode.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_btnFocusNode);
                              },
                              onChanged: (value) {
                                if (value.length == 2) {
                                  _expYFocusNode.unfocus();
                                  _btnFocusNode.requestFocus();
                                }
                              },
                              labelText: 'سال',
                              hintText: '۰۴',
                            ),
                          ),
                        ],
                      ),
                      Space(2),
                    ],
                  ),
                ),
                Space(),
              ],
            ),
            controller: widget.scrollController,
          ),
        ),
        footer: _buildPayButton(),
      ),
    );
  }

  Widget _buildPayButton() {
    if (widget.onPay == null) {
      return Padding(
        padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
        child: ConfirmButton(
          focusNode: _btnFocusNode,
          onPressed: _submit,
          child: CustomText(
            'پرداخت',
            style: colors
                .tabStyle(context)
                .copyWith(color: colors.greyColor.shade50),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24),
      child: FutureConfirmButton(
        focusNode: _btnFocusNode,
        onPressed: _submitWithPay,
        child: Text(
          'پرداخت',
          style: colors
              .tabStyle(context)
              .copyWith(color: colors.greyColor.shade50),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final year = _expYController.text;
    final month = _expMController.text;

    final expire = '$year$month';

    final cardInfo = CardInfo(
      pan: _panController.text,
      pin: _pinController.text,
      cvv: _cvvController.text,
      expire: expire,
      sourceCardId: _sourceCardId,
      saveCard: _saveCardInfo,
    );

    final payInfo = PayInfo.normal(cardInfo);
    Navigator.of(context).pop(payInfo);
  }

  Future<void> _submitWithPay() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final year = _expYController.text;
    final month = _expMController.text;

    final expire = '$year$month';

    final cardInfo = CardInfo(
      pan: _panController.text,
      pin: _pinController.text,
      cvv: _cvvController.text,
      expire: expire,
      sourceCardId: _sourceCardId,
      saveCard: _saveCardInfo,
    );

    final payInfo = PayInfo.normal(cardInfo);
    await widget.onPay?.call(payInfo);
  }

  Future<bool> _requestOTP() async {
    hideKeyboard(context);

    _ignoreValidation = true;
    if (!_formKey.currentState.validate()) {
      _ignoreValidation = false;
      return false;
    }

    _ignoreValidation = false;

    final year = _expYController.text;
    final month = _expMController.text;

    final expire = '$year$month';

    final cardInfo = CardInfo(
      pan: _panController.text.replaceAll('-', ''),
      pin: _pinController.text,
      cvv: _cvvController.text,
      expire: expire,
      sourceCardId: _sourceCardId,
    );

    final data = await nh.shaparakHarim.requestOtp(
        cardInfo: cardInfo,
        amount: widget.amount,
        transactionType: widget.transactionType,
        acceptorName: widget.acceptorName,
        acceptorId: widget.acceptorId);

    if (!showError(context, data)) {
      return false;
    }

    ToastUtils.showCustomToast(
      context,
      data.content.description,
      Image.asset('assets/ok.png'),
    );
    return true;
  }

  void _showCardSelectionDialog() async {
    final data = await showSourceCardSelectionDialog();

    if (data == null) {
      return;
    }
    _panController.text = data.value;
    _sourceCardId = data.id;
    if (data.expDate != null && data.expDate.length >= 4) {
      _expYController.text = data.expDate.substring(0, 2);
      _expMController.text = data.expDate.substring(2, 4);
    } else {
      _expYController.text = '';
      _expMController.text = '';
    }
    _panFocusNode.unfocus();
    FocusScope.of(context).requestFocus(_pinFocusNode);
    setState(() {});
  }

  String _getPersianAmount() {
    final amount = widget.amount;
    if (amount == null) {
      return '';
    }
    final toman = (amount ~/ 10).toPersianString();
    return '$toman تومان';
  }

  @override
  void dispose() {
    _panController.dispose();
    _pinController.dispose();
    _cvvController.dispose();
    _expMController.dispose();
    _expYController.dispose();
    super.dispose();
  }
}
