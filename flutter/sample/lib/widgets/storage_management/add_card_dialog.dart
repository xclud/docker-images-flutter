import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/storage_management/card_management.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class AddCardDialog extends StatefulWidget {
  AddCardDialog({
    @required this.mruType,
    @required this.scrollController,
    this.value,
  });

  final ItemCardToCard value;
  final MruType mruType;
  final ScrollController scrollController;

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCardDialog> {
  final _panFocusNode = FocusNode();
  final _panController = TextEditingController();
  final _expireMonthController = TextEditingController();
  final _expireYearController = TextEditingController();
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _monthFocusNode = FocusNode();
  final _yearFocusNode = FocusNode();
  final _titleFocus = FocusNode();

  String _expireYearValidator(String value) {
    if (value == null || value.isEmpty) {
      return strings.validation_should_not_be_empty;
    }

    if (value.length != 2) {
      return strings.validation_is_not_correct;
    }
    return null;
  }

  String _expireMonthValidator(String value) {
    if (value == null || value.isEmpty) {
      return strings.validation_should_not_be_empty;
    }

    if (value.length != 2) {
      return strings.validation_is_not_correct;
    }

    final month = int.tryParse(value ?? '');
    if (month == null || month < 1 || month > 12) {
      return strings.validation_is_not_correct;
    }
    return null;
  }

  @override
  void dispose() {
    _panController.dispose();
    _expireMonthController.dispose();
    _expireYearController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.value != null) {
        _panController.text = widget.value.pan.replaceAll('-', '');
        _titleController.text = widget.value.title;
        if (widget.value.ExpDate != null && widget.value.ExpDate.length == 4) {
          _expireYearController.text = widget.value.ExpDate.substring(0, 2);
          _expireMonthController.text = widget.value.ExpDate.substring(2, 4);
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _showExpDate = widget.mruType == MruType.sourceCard;
    return Column(
      children: [
        SingleChildScrollView(
          controller: widget.scrollController,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 24.0, end: 24.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.value != null)
                    Text(
                      '$lrm${protectCardNumber(widget.value.pan)}'
                          .withPersianNumbers(),
                      style: colors.boldStyle(context),
                    ),
                  if (widget.value != null) Space(2),
                  TextFormField(
                    focusNode: _titleFocus,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      _titleFocus.unfocus();
                      _panFocusNode.requestFocus();
                    },
                    maxLines: 1,
                    maxLength: 26,
                    controller: _titleController,
                    decoration: InputDecoration(
                        counterText: '', labelText: 'عنوان کارت'),
                  ),
                  if (widget.value == null) Space(2),
                  if (widget.value == null)
                    CardTextFormField(
                      labelText: 'شماره کارت',
                      focusNode: _panFocusNode,
                      controller: _panController,
                    ),
                  if (_showExpDate) Space(2),
                  if (_showExpDate)
                    Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          focusNode: _monthFocusNode,
                          validator: _expireMonthValidator,
                          controller: _expireMonthController,
                          maxLength: 2,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 2) {
                              _monthFocusNode.unfocus();
                              _yearFocusNode.requestFocus();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'ماه انقضا',
                            hintText: '۱۲',
                            counterText: '',
                            hintTextDirection: TextDirection.ltr,
                          ),
                        )),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: TextFormField(
                          focusNode: _yearFocusNode,
                          validator: _expireYearValidator,
                          controller: _expireYearController,
                          maxLength: 2,
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 2) {
                              _yearFocusNode.unfocus();
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'سال انقضا',
                            hintText: '۰۴',
                            counterText: '',
                            hintTextDirection: TextDirection.ltr,
                          ),
                        )),
                      ],
                    ),
                  Space(2),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 24.0, end: 24.0, bottom: 24.0),
          child: ConfirmButton(
              onPressed: _onConfirm,
              child: CustomText(
                strings.action_ok,
                textAlign: TextAlign.center,
              )),
        )
      ],
    );
  }

  void _onConfirm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final addedValue = ItemCardToCard();
    addedValue.pan =
        _panController.text.replaceAll('-', '').withEnglishNumbers();
    addedValue.ExpDate =
        _expireYearController.text + _expireMonthController.text;
    addedValue.title = _titleController.text;
    addedValue.ExpDate =
        '${_expireYearController.text}${_expireMonthController.text}';
    Navigator.of(context).pop(addedValue);
  }
}
