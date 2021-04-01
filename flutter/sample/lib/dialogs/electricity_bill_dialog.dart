import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:persian/persian.dart';

class ElectricityBillDialog extends StatefulWidget {
  ElectricityBillDialog({this.billId});

  final String billId;

  @override
  _ElectricityBillDialogState createState() {
    return _ElectricityBillDialogState();
  }
}

class _ElectricityBillDialogState extends State<ElectricityBillDialog> {
  final TextEditingController _billIdController = TextEditingController();
  final TextEditingController _billNameController = TextEditingController();
  final _billIdFocus = FocusNode();
  final _nationalIdFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _buttonFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.billId.isNotEmpty) {
      _billIdController.text = widget.billId;
    }
  }

  @override
  void dispose() {
    _billIdController.dispose();
    _billNameController.dispose();
    _billIdFocus.dispose();
    _nationalIdFocus.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('افزودن قبض جدید'),
      actions: [
        FlatButton(
          onPressed: isSecureEnvironment ? _getBarcode : null,
          child: Row(
            children: [
              Text(
                'اسکن بارکد',
                style: colors
                    .boldStyle(context)
                    .copyWith(color: colors.ternaryColor),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.qr_code_outlined,
                color: colors.ternaryColor,
              ),
            ],
          ),
        )
      ],
      body: Split(
        child: Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
                child: Column(
                  children: [
                    TextFormField(
                      onEditingComplete: () {
                        _billIdFocus.unfocus();
                        _nationalIdFocus.requestFocus();
                      },
                      focusNode: _billIdFocus,
                      controller: _billIdController,
                      maxLength: 17,
                      textDirection: TextDirection.ltr,
                      inputFormatters: digitsOnly(),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'شناسه قبض',
                          counterText: '',
                          hintText: '1234567890123'.withPersianNumbers()),
                    ),
                    Space(2),
                    TextFormField(
                      onEditingComplete: () {
                        _nameFocus.unfocus();
                        _buttonFocus.requestFocus();
                      },
                      focusNode: _nameFocus,
                      textInputAction: TextInputAction.next,
                      controller: _billNameController,
                      decoration: InputDecoration(
                        labelText: 'نام قبض',
                        hintText: 'مثلا: کنتور مغازه',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
          child: ConfirmButton(
            focusNode: _buttonFocus,
            child: CustomText(
              'افزودن',
              textAlign: TextAlign.center,
            ),
            onPressed: () async {
              if (!_formKey.currentState.validate()) {
                return;
              }

              final bill = ElectricityBillData(
                id: _billIdController.text,
                name: _billNameController.text,
              );

              Navigator.of(context).pop(bill);
            },
          ),
        ),
      ),
    );
  }

  void _getBarcode() async {
    final barcode = await showBarcodeScanDialog(context);

    _billIdController.text = barcode?.code;
  }
}

class ElectricityBillData {
  ElectricityBillData({@required this.id, @required this.name});

  final String id;
  final String name;
}
