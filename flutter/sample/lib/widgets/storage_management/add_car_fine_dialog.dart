import 'package:flutter/material.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/storage_management/action_type.dart';
import 'package:persian/persian.dart';

class AddCarFineDialog extends StatefulWidget {
  AddCarFineDialog({
    @required this.scrollController,
    @required this.controller,
    this.type,
    this.mruItem,
  });

  final ActionType type;
  final MruItem mruItem;
  final ScrollController scrollController;
  final TextEditingController controller;

  @override
  _AddCarFineDialogState createState() => _AddCarFineDialogState();
}

class _AddCarFineDialogState extends State<AddCarFineDialog> {
  _AddCarFineDialogState();

  final _formKey = GlobalKey<FormState>();
  final _firstFocus = FocusNode();
  final _buttonFocus = FocusNode();

  String _vehicleIdValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'بارکد را وارد نمایید';
    }

    if (value.length < 8 || value.length > 10) {
      return 'بارکد معتبر نیست';
    }
    return null;
  }

  @override
  void initState() {
    if (widget.mruItem != null) {
      widget.controller.text = widget.mruItem.value ?? '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _firstFocus.dispose();
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                children: [
                  TextFormField(
                    focusNode: _firstFocus,
                    onEditingComplete: () {
                      _firstFocus.unfocus();
                      _buttonFocus.requestFocus();
                    },
                    controller: widget.controller,
                    validator: _vehicleIdValidator,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: 'شماره بارکد کارت ماشین',
                    ),
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
    final vehicleId = widget.controller.text;
    final result =
        await Loading.run(context, nh.canPay.rahvarInquiry(code: vehicleId));
    if (result.isError) {
      if (!result.isExpired) {
        ToastUtils.showCustomToast(
            context, result.error, Image.asset('assets/ic_error.png'), 'خطا');
      }
      return;
    }
    if (result.content.status != true) {
      ToastUtils.showCustomToast(context, result.content.description,
          Image.asset('assets/ic_error.png'), 'خطا');
      return;
    }
    if (widget.type == ActionType.Add) {
      final data = await Loading.run(
          context,
          nh.mru.addMru(
              type: MruType.vehicleId,
              title: result.content.data.number
                  ?.withPersianLetters()
                  ?.withPersianNumbers(),
              value: widget.controller.text));

      if (!showError(context, data)) {
        return;
      }
      Navigator.of(context).pop(true);
    } else if (widget.type == ActionType.Update) {
      final data = await Loading.run(
          context,
          nh.mru.updateMru(
              id: widget.mruItem.id,
              title: result.content.data.number
                  ?.withPersianLetters()
                  ?.withPersianNumbers(),
              mruValue: widget.controller.text));

      if (!showError(context, data)) {
        return;
      }
      Navigator.of(context).pop(true);
    }
  }
}
