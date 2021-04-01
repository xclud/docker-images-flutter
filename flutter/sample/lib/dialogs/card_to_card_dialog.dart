import 'package:flutter/material.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/otp_button.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class CardToCardDialog extends StatefulWidget {
  CardToCardDialog({
    @required this.sourceCardNumber,
    @required this.sourceCardId,
    @required this.destinationCardNumber,
    @required this.destinationCardId,
    @required this.amount,
    @required this.expDateMonth,
    @required this.expDateYear,
    @required this.saveCardInfo,
    this.scrollController,
  });

  final String sourceCardNumber;
  final int sourceCardId;
  final String destinationCardNumber;
  final int destinationCardId;
  final int amount;
  final ScrollController scrollController;
  final String expDateMonth;
  final String expDateYear;
  final bool saveCardInfo;

  @override
  _CardToCardDialogState createState() => _CardToCardDialogState();
}

class _CardToCardDialogState extends State<CardToCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _cvvController = TextEditingController();
  final _expYController = TextEditingController();
  final _expMController = TextEditingController();
  bool _ignoreValidation = false;

  final _pinFocusNode = FocusNode();
  final _cvvFocusNode = FocusNode();
  final _btnFocusNode = FocusNode();
  final _expMFocusNode = FocusNode();
  final _expYFocusNode = FocusNode();

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

  @override
  void dispose() {
    _pinController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.expDateYear != null) {
        _expYController.text = widget.expDateYear;
      }
      if (widget.expDateMonth != null) {
        _expMController.text = widget.expDateMonth;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cvv = PasswordTextFormField(
      onEditingComplete: () {
        _cvvFocusNode.unfocus();
        _expMFocusNode.requestFocus();
      },
      focusNode: _cvvFocusNode,
      controller: _cvvController,
      maxLength: 4,
      validator: _cvvValidator,
      labelText: 'CVV2',
      hintText: '۱۲۳',
    );

    final pin = PasswordTextFormField(
      onEditingComplete: () {
        _pinFocusNode.unfocus();
        _cvvFocusNode.requestFocus();
      },
      focusNode: _pinFocusNode,
      controller: _pinController,
      validator: _pinValidator,
      maxLength: 12,
      labelText: 'رمز دوم',
      hintText: '۱۲۳۴۵۶',
    );

    final expM = PasswordTextFormField(
      onEditingComplete: () {
        _expMFocusNode.unfocus();
        _expYFocusNode.requestFocus();
      },
      obscureText: widget.sourceCardId != null,
      focusNode: _expMFocusNode,
      validator: _expMValidator,
      controller: _expMController,
      maxLength: 2,
      labelText: 'ماه',
      hintText: '۱۲',
    );

    final expY = PasswordTextFormField(
      onEditingComplete: () {
        _expYFocusNode.unfocus();
        _pinFocusNode.requestFocus();
      },
      focusNode: _expYFocusNode,
      validator: _expYValidator,
      controller: _expYController,
      obscureText: widget.sourceCardId != null,
      maxLength: 2,
      labelText: 'سال',
      hintText: '۰۴',
    );

    return Split(
      child: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: widget.scrollController,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: pin,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 48.0,
                            child: OtpButton(
                              onRequested: _requestOTP,
                            ),
                          ),
                        )
                      ],
                    ),
                    Space(2),
                    cvv,
                    Space(2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: expM,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: expY,
                        )
                      ],
                    ),
                    Space(2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
        child: ConfirmButton(
          child: CustomText(
            'تایید پرداخت',
            style: colors.tabStyle(context).copyWith(
                  color: colors.greyColor.shade50,
                ),
            textAlign: TextAlign.center,
          ),
          focusNode: _btnFocusNode,
          onPressed: _submit,
        ),
      ),
    );
  }

  Future<bool> _requestOTP() async {
    hideKeyboard(context);
    _ignoreValidation = true;

    if (!_formKey.currentState.validate()) {
      _ignoreValidation = false;
      return false;
    }
    _ignoreValidation = false;
    final year = widget.expDateYear;
    final month = widget.expDateMonth;

    final expire = '$year$month';

    final cardInfo = CardInfo(
      pan: widget.sourceCardNumber,
      pin: _pinController.text,
      cvv: _cvvController.text,
      expire: expire,
      destinationPan: widget.destinationCardNumber,
      sourceCardId: widget.sourceCardId,
      destinationCardId: widget.destinationCardId,
      saveCard: widget.saveCardInfo,
    );

    final data = await nh.shaparakHarim.requestOtpPardakhtSaz(
      cardInfo: cardInfo,
      amount: widget.amount,
    );

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

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final year = _expYController.text;
    final month = _expMController.text;

    final expire = '$year$month';

    final cardInfo = CardInfo(
      pan: widget.sourceCardNumber,
      sourceCardId: widget.sourceCardId,
      pin: _pinController.text,
      cvv: _cvvController.text,
      expire: expire,
      destinationPan: widget.destinationCardNumber,
      destinationCardId: widget.destinationCardId,
      saveCard: widget.saveCardInfo,
    );

    Navigator.of(context).pop(cardInfo);
  }
}
