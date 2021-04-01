import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/bill_payment.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/mixins/phone_selection_mixin.dart';
import 'package:novinpay/models/PhoneInquiryResponse.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class PhoneBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneBillState();
}

class _PhoneBillState extends State<PhoneBill>
    with BillPaymentMixin, MruSelectionMixin, PhoneSelectionMixin {
  final _formKey = GlobalKey<FormState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _phoneController = TextEditingController();
  Response<PhoneInquiryResponse> _data;
  bool _isWorking = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _data = null;
      _isWorking = true;
    });

    final data =
        await nh.canPay.phoneInquiry(phoneNumber: _phoneController.text);

    setState(() {
      _data = data;
      _isWorking = false;
    });

    if (data.hasErrors()) {
      return;
    }

    nh.mru.addMru(
        type: MruType.landPhone, title: null, value: _phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    final header = Form(
      key: _formKey,
      child: Column(
        children: [
          Space(),
          PhoneTextFormField(
            enabled: _isWorking != true,
            onChanged: (value) {
              setState(() {
                _data = null;
              });
            },
            controller: _phoneController,
            hintText: '۰۲۱۲۲۳۴۵۶۷۸',
            showSelectionDialog: _showPhoneSelectionDialog,
          ),
          Space(3),
        ],
      ),
    );

    Widget midTerm() => Container(
          decoration: BoxDecoration(
            color: colors.greyColor.shade600,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 16.0, 24.0, 16.0),
                child: Text(
                  'قبض میان دوره',
                  style: colors.boldStyle(context),
                ),
              ),
              Container(
                color: colors.greyColor.shade800,
                height: 1.0,
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                child: DualListTile(
                  start: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مبلغ قابل پرداخت',
                        textAlign: TextAlign.start,
                        style: colors.bodyStyle(context),
                      ),
                      Text(toRials(_data?.content?.midTerm?.amount ?? 0),
                          textAlign: TextAlign.start,
                          style: colors.boldStyle(context)),
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
                      final data = _data;
                      if (data == null || data.hasErrors()) {
                        return;
                      }

                      final billInfo = data.content.midTerm;

                      await payBill(
                          type: BillType.phone,
                          title: 'قبض میان دوره',
                          billInfo: billInfo,
                          acceptorName: 'قبض تلفن ثابت',
                          acceptorId: '4');
                    },
                  ),
                ),
              ),
            ],
          ),
        );

    Widget endTerm() => Container(
          decoration: BoxDecoration(
            color: colors.greyColor.shade600,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 16.0, 24.0, 16.0),
                child: Text(
                  'قبض پایان دوره',
                  style: colors.boldStyle(context),
                ),
              ),
              Container(
                color: colors.greyColor.shade800,
                height: 1.0,
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                child: DualListTile(
                  start: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مبلغ قابل پرداخت',
                        textAlign: TextAlign.start,
                        style: colors.bodyStyle(context),
                      ),
                      Text(toRials(_data?.content?.endTerm?.amount ?? 0),
                          textAlign: TextAlign.start,
                          style: colors.boldStyle(context)),
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
                      final data = _data;
                      if (data == null || data.hasErrors()) {
                        return;
                      }

                      final billInfo = data.content.endTerm;

                      await payBill(
                          type: BillType.phone,
                          title: 'قبض پایان دوره',
                          billInfo: billInfo,
                          acceptorName: 'قبض تلفن ثابت',
                          acceptorId: '4');
                    },
                  ),
                ),
              ),
            ],
          ),
        );

    Widget buildMessage(String text) => Center(
          child: Text(
            text ?? '',
            textAlign: TextAlign.center,
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
            softWrap: true,
          ),
        );

    Widget buildWelcomeMessage() => buildMessage(
        'لطفا شماره تلفن ثابت مورد نظر خود را جهت دریافت قبض وارد کنید.');

    Widget buildBillList() {
      return ListView(
        children: [midTerm(), Space(2), endTerm()],
      );
    }

    Widget buildChild() {
      if (_data == null) {
        return buildWelcomeMessage();
      }
      if (_data.isError) {
        return buildMessage(strings.connectionError);
      }
      if (_data.content.status != true) {
        return buildMessage(
            _data.content.description ?? strings.connectionError);
      }

      return buildBillList();
    }

    final footer = (_data == null || _data.hasErrors())
        ? Padding(
            padding:
                const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
            child: ConfirmButton(
              onPressed: _isWorking ? null : _submit,
              child: CustomText(
                strings.action_inquiry,
                textAlign: TextAlign.center,
              ),
              color: colors.ternaryColor,
            ),
          )
        : Container();

    return HeadedPage(
      title: Text('قبض تلفن ثابت'),
      body: Split(
        header: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          child: header,
        ),
        child: Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: _refresh,
              child: buildChild(),
            ),
          ),
        ),
        footer: footer,
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _refreshKey.currentState.show();
  }

  void _showPhoneSelectionDialog() async {
    final data = await showPhoneSelectionDialog();
    if (data == null) {
      return;
    }

    final phone = data.value;
    _phoneController.text = phone;
    _submit();
  }
}
