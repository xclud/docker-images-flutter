import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/storage_management/card_management.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class AddAccountDialog extends StatefulWidget {
  AddAccountDialog({
    @required this.scrollController,
    this.item,
  });

  final MruItem item;
  final ScrollController scrollController;

  @override
  _AddAccountDialogState createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<AddAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _titleController = TextEditingController();
  final _firstFocus = FocusNode();
  final _secondFocus = FocusNode();
  final _buttonFocus = FocusNode();

  @override
  void dispose() {
    _accountController.dispose();
    _titleController.dispose();
    _firstFocus.dispose();
    _secondFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.item != null) {
      _accountController.text = widget.item.value;
      if (widget.item.title != null) {
        _titleController.text = widget.item.title;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          controller: widget.scrollController,
          child: Form(
            key: _formKey,
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 24.0, end: 24.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.item != null)
                      Text(
                        '$lrm${widget.item.value}'.withPersianNumbers(),
                        style: colors.boldStyle(context),
                      ),
                    if (widget.item != null) Space(2),
                    TextFormField(
                      focusNode: _firstFocus,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () {
                        _firstFocus.unfocus();
                        _secondFocus.requestFocus();
                      },
                      maxLength: 40,
                      controller: _titleController,
                      decoration:
                          InputDecoration(counterText: '', labelText: 'عنوان'),
                    ),
                    if (widget.item == null) Space(2),
                    if (widget.item == null)
                      AccountTextFormField(
                        focusNode: _secondFocus,
                        onEditingComplete: () {
                          _secondFocus.unfocus();
                          _buttonFocus.requestFocus();
                        },
                        controller: _accountController,
                      ),
                    Space(2),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(
              start: 24.0, end: 24.0, bottom: 24.0),
          child: ConfirmButton(
              focusNode: _buttonFocus,
              onPressed: () {
                if (!_formKey.currentState.validate()) {
                  return;
                }
                final addedValue = ItemCardToCard();
                addedValue.pan = _accountController.text;
                addedValue.title = _titleController.text;
                Navigator.of(context).pop(addedValue);
              },
              child: CustomText(
                strings.action_ok,
                textAlign: TextAlign.center,
              )),
        )
      ],
    );
  }
}