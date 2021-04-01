import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novinpay/bill_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/bill_payment.dart';
import 'package:novinpay/models/BillInquiryResponse.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class ServiceBill extends StatefulWidget {
  @override
  _ServiceBillState createState() => _ServiceBillState();
}

class _ServiceBillState extends State<ServiceBill> with BillPaymentMixin {
  final _billIdController = TextEditingController();
  final _paymentIdController = TextEditingController();
  Response<BillInquiryResponse> _data;
  final _formKey = GlobalKey<FormState>();
  final _billIdFocusNode = FocusNode();
  final _payIdFocusNode = FocusNode();
  final _btnFocusNode = FocusNode();

  @override
  void dispose() {
    _billIdController.dispose();
    _paymentIdController.dispose();
    super.dispose();
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'اطلاعات را به درستی تکمیل نمایید';
    }

    return null;
  }

  void _getBarcode() async {
    final barcode = await showBarcodeScanDialog(context);

    _billIdController.text = barcode?.code?.substring(0, 13);
    _paymentIdController.text = barcode?.code?.substring(13, 26);
  }

  @override
  Widget build(BuildContext context) {
    final message = Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            'لطفا شناسه قبض و شناسه پرداخت مورد نظر خود را جهت دریافت قبض وارد کنید.',
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ));

    final header = Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Space(),
              TextFormField(
                focusNode: _billIdFocusNode,
                controller: _billIdController,
                maxLength: 17,
                validator: _validator,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'شناسه قبض',
                    counterText: '',
                    hintText: '1234567890123'.withPersianNumbers()),
                textDirection: TextDirection.ltr,
                inputFormatters: digitsOnly(),
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  _billIdFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_payIdFocusNode);
                },
                onChanged: (value) {
                  setState(() {
                    _data = null;
                  });
                },
              ),
              Space(2),
              TextFormField(
                controller: _paymentIdController,
                focusNode: _payIdFocusNode,
                maxLength: 17,
                validator: _validator,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    labelText: 'شناسه پرداخت',
                    counterText: '',
                    hintText: '123456'.withPersianNumbers()),
                textDirection: TextDirection.ltr,
                inputFormatters: digitsOnly(),
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  _payIdFocusNode.unfocus();
                  FocusScope.of(context).requestFocus(_btnFocusNode);
                },
                onChanged: (value) {
                  setState(() {
                    _data = null;
                  });
                },
              ),
              Space(3),
            ],
          ),
        ),
      ],
    );

    Widget term() => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.greyColor.shade600,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 16.0, 24.0, 16.0),
                      child: Text(_data.content.billType ?? '',
                          style: colors.boldStyle(context)),
                    ),
                    Container(
                      color: colors.greyColor.shade800,
                      height: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          16.0, 8.0, 16.0, 8.0),
                      child: DualListTile(
                        start: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('مبلغ قابل پرداخت',
                                style: colors.bodyStyle(context)),
                            Text(
                              toRials(_data.content.billAmount ?? 0),
                              style: colors.boldStyle(context),
                            ),
                          ],
                        ),
                        end: FlatButton(
                          color: colors.accentColor,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, left: 8.0, top: 12.0, bottom: 12.0),
                            child: Text(
                              'پرداخت',
                              style: colors
                                  .bodyStyle(context)
                                  .copyWith(color: colors.greyColor.shade50),
                            ),
                          ),
                          onPressed: () async {
                            final billId = _billIdController.text;
                            final paymentId = _paymentIdController.text;
                            final amount = _data.content.billAmount ?? 0;
                            final acceptorName = _data.content.billType ?? '';
                            final acceptorId = _data.content.billTypeId ?? '';

                            final billInfo = BillInfo(
                              billId: billId,
                              paymentId: paymentId,
                              amount: amount,
                            );

                            await payBill(
                                type: BillType.service,
                                title: 'قبض',
                                billInfo: billInfo,
                                acceptorName: acceptorName,
                                acceptorId: acceptorId);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

    return HeadedPage(
      title: Text('قبض خدماتی'),
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
        header: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
          child: header,
        ),
        child: Expanded(
            child: (_data == null || _data.hasErrors()) ? message : term()),
        footer: (_data == null || _data.hasErrors())
            ? Padding(
                padding: const EdgeInsets.only(
                    right: 24.0, left: 24.0, bottom: 24.0),
                child: ConfirmButton(
                  child: CustomText(
                    strings.action_inquiry,
                    textAlign: TextAlign.center,
                  ),
                  onPressed: _submit,
                  focusNode: _btnFocusNode,
                  color: colors.ternaryColor,
                ),
              )
            : Container(),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final billId = _billIdController.text;
    final paymentId = _paymentIdController.text;

    final data = await Loading.run(
      context,
      nh.billPayment.billInquiry(
        billId: billId,
        paymentId: paymentId,
      ),
    );

    if (!showError(context, data)) {
      return;
    }

    setState(() {
      _data = data;
    });
  }
}
