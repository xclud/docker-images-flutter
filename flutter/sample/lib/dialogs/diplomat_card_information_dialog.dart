import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/card_selection_mixin.dart';
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class DiplomatCardInformation extends StatefulWidget {
  @override
  _DiplomatCardInformationState createState() =>
      _DiplomatCardInformationState();
}

class _DiplomatCardInformationState extends State<DiplomatCardInformation>
    with MruSelectionMixin, CardSelectionMixin, DisableManagerMixin {
  final _formKey = GlobalKey<FormState>();
  static final _translator = {
    '#': RegExp(r'[\d]'),
    '*': RegExp(r'[\d\*]'),
  };
  final _panController = MaskedTextController(
      mask: '####-##**-****-####', translator: _translator);

  int _prevPanLength = 0;

  final _expMController = MaskedTextController(mask: '00');
  final _expYController = MaskedTextController(mask: '00');
  int _sourceCardId;

  final _panFocusNode = FocusNode();
  final _expYFocusNode = FocusNode();
  final _expMFocusNode = FocusNode();
  final _btnFocusNode = FocusNode();

  String _expYValidator(String value) {
    if (_expYController.text == null || _expYController.text.isEmpty) {
      return strings.validation_should_not_be_empty;
    }

    if (_expYController.text.length != 2) {
      return strings.validation_is_not_correct;
    }

    return null;
  }

  String _expMValidator(String value) {
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
    _panController.dispose();
    _expMController.dispose();
    _expYController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pan = CardTextFormField(
      focusNode: _panFocusNode,
      controller: _panController,
      labelText: 'شماره کارت',
      showSelectionDialog: _showCardSelectionDialog,
      onEditingComplete: () {
        _panFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_expMFocusNode);
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

        if (_prevPanLength != value.length && value.length == 19) {
          _panFocusNode.unfocus();
          _expMFocusNode.requestFocus();
        }

        _prevPanLength = value.length;
        setState(() {});
      },
    );

    final expM = PasswordTextFormField(
      focusNode: _expMFocusNode,
      validator: _expMValidator,
      controller: _expMController,
      maxLength: 2,
      obscureText: _sourceCardId != null,
      onEditingComplete: () {
        _expMFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_expYFocusNode);
      },
      labelText: 'ماه',
      hintText: '۱۲',
    );

    final expY = PasswordTextFormField(
      focusNode: _expYFocusNode,
      validator: _expYValidator,
      controller: _expYController,
      maxLength: 2,
      obscureText: _sourceCardId != null,
      onEditingComplete: () {
        _expYFocusNode.unfocus();
        FocusScope.of(context).requestFocus(_btnFocusNode);
      },
      labelText: 'سال',
      hintText: '۰۴',
    );

    final form = Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pan,
          Space(2),
          Row(
            children: [
              Expanded(child: expM),
              SizedBox(
                width: 16,
              ),
              Expanded(child: expY),
            ],
          ),
        ],
      ),
    );

    return Split(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 8.0),
        child: Column(
          children: [
            form,
            Space(),
          ],
        ),
      ),
      footer: _buildFooter(),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
      child: ConfirmButton(
        focusNode: _btnFocusNode,
        onPressed: _submit,
        child: CustomText(
          strings.action_ok,
          style: colors
              .tabStyle(context)
              .copyWith(color: colors.greyColor.shade50),
          textAlign: TextAlign.center,
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
      expire: expire,
      sourceCardId: _sourceCardId,
    );

    final payInfo = PayInfo.normal(cardInfo);
    Navigator.of(context).pop(payInfo);
  }

  void _showCardSelectionDialog() async {
    final data = await showSourceCardSelectionDialog();

    if (data == null) {
      return;
    }
    setState(() {
      _panController.text = data.value;
      _sourceCardId = data.id;
      if (data.expDate != null && data.expDate.length >= 4) {
        _expYController.text = data.expDate.substring(0, 2);
        _expMController.text = data.expDate.substring(2, 4);
      } else {
        _expYController.text = '';
        _expMController.text = '';
      }
    });
  }
}
