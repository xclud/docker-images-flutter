import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/mobile_input.dart';
import 'package:novinpay/widgets/storage_management/action_type.dart';
import 'package:persian/persian.dart';

class AddMobileDialog extends StatefulWidget {
  AddMobileDialog({this.type, this.mruItem});

  final ActionType type;
  final MruItem mruItem;

  @override
  _AddMobileDialogState createState() => _AddMobileDialogState();
}

class _AddMobileDialogState extends State<AddMobileDialog> {
  _AddMobileDialogState();

  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _titleController = TextEditingController();
  final _firstFocus = FocusNode();
  final _secondFocus = FocusNode();
  final _buttonFocus = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.mruItem != null) {
        _mobileController.text = widget.mruItem.value ?? '';
        if (widget.mruItem.title != null) {
          _titleController.text = widget.mruItem.title;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 24.0, end: 24.0, top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.type == ActionType.Update)
                      Text(
                        '$lrm${widget.mruItem.value}'.withPersianNumbers(),
                        style: colors.boldStyle(context),
                      ),
                    if (widget.type == ActionType.Update) Space(2),
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
                    if (widget.type == ActionType.Add) Space(2),
                    if (widget.type == ActionType.Add)
                      MobileWidget(
                        focusNode: _secondFocus,
                        onEditingComplete: () {
                          _secondFocus.unfocus();
                          _buttonFocus.requestFocus();
                        },
                        controller: _mobileController,
                        showMruIcon: false,
                        showSimCard: false,
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
              onPressed: _onConfirm,
              child: CustomText(
                strings.action_ok,
                textAlign: TextAlign.center,
              )),
        )
      ],
    );
  }

  void _onConfirm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (widget.type == ActionType.Add) {
      final data = await Loading.run(
          context,
          nh.mru.addMru(
              type: MruType.mobile,
              title: _titleController.text,
              value: _mobileController.text));

      if (!showError(context, data)) {
        return;
      }
      Navigator.of(context).pop(true);
    } else if (widget.type == ActionType.Update) {
      final data = await Loading.run(
          context,
          nh.mru.updateMru(
              id: widget.mruItem.id,
              title: _titleController.text,
              mruValue: _mobileController.text));

      if (!showError(context, data)) {
        return;
      }
      Navigator.of(context).pop(true);
    }
  }
}
