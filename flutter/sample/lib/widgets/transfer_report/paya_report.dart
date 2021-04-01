import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/bank_login.dart';
import 'package:novinpay/mixins/iban_selection.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/boom_market.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class PayaReport extends StatefulWidget {
  @override
  _PayaReportState createState() => _PayaReportState();
}

class _PayaReportState extends State<PayaReport>
    with BankLogin, MruSelectionMixin, IbanSelection {
  final _ibanController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Response<PayaReportResponse> _data;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  bool _disable = false;
  bool _showInquiryButton = true;

  Widget _buildWelcomeMessage() {
    return _buildMessage('لطفا شماره شبا خود را جهت دریافت گزارش وارد نمایید');
  }

  Widget _buildMessage(String text) => Center(
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 24, end: 24),
          child: Text(
            text ?? '',
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      );

  Widget _buildList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(),
      itemCount: _data.content.transactions.length,
      itemBuilder: (context, index) {
        var item = _data.content.transactions[index];
        return PayaItem(
          amount: item.amount,
          status: item.statusDescription,
          sourceDeposit: item.sourceIbanNumber,
          destinationDeposit: item.ibanNumber,
          time: item.issueDateDescription,
        );
      },
    );
  }

  Widget _buildChild() {
    _showInquiryButton = true;
    if (_data == null) {
      return _buildWelcomeMessage();
    }

    if (_data.isError) {
      return _buildMessage(strings.connectionError);
    }

    if (_data.content.status != true) {
      return _buildMessage(_data.content.description);
    }

    if (_data.content.transactions == null) {
      return _buildMessage(_data.content.description);
    }
    _showInquiryButton = false;

    if (_data.content.transactions.isEmpty) {
      return _buildMessage('گزارشی یافت نشد');
    }
    return _buildList();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _disable = true;
    });
    final data = await nh.boomMarket.payaReport(
        sourceDepositIban: _ibanController.text.replaceAll('-', ''));
    if (!data.hasErrors()) {
      nh.mru.addMru(
          type: MruType.sourceIban, title: null, value: _ibanController.text);
    }
    setState(() {
      _disable = false;
      _data = data;
    });
  }

  void _showIbanSelectionDialog() async {
    final data = await showSourceIbanSelectionDialog();
    if (data == null) {
      return;
    }
    _ibanController.text = data.value;
  }

  @override
  Widget build(BuildContext context) {
    final footer = Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Container(
        margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
        child: ConfirmButton(
          child: CustomText(
            strings.action_inquiry,
            textAlign: TextAlign.center,
          ),
          onPressed: _disable ? null : _submit,
          color: colors.ternaryColor,
        ),
      ),
    );
    return Split(
      header: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: IbanTextFormField(
                  controller: _ibanController,
                  showSelectionDialog: _showIbanSelectionDialog,
                  onChanged: (value) {
                    setState(() {
                      _data = null;
                      _showInquiryButton = true;
                      _disable = false;
                    });
                  },
                ),
              ),
            ),
            Space(),
          ],
        ),
      ),
      child: Expanded(
        child: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _onRefresh,
          child: Container(
              margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
              child: Center(child: _buildChild())),
        ),
      ),
      footer: _showInquiryButton ? footer : Container(),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final r2 = await ensureBankLogin(routes.transfer_report);
    if (r2 == null) {
      return;
    }
    await _refreshKey.currentState.show();
  }
}

class PayaItem extends StatelessWidget {
  PayaItem({
    @required this.time,
    @required this.amount,
    @required this.sourceDeposit,
    @required this.destinationDeposit,
    @required this.status,
  });

  final String time;
  final int amount;
  final String sourceDeposit;
  final String destinationDeposit;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Space(2),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              top: 8,
              right: 24,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 6, 0, 6),
                          child: Text(
                            '$lrm$time'?.withPersianNumbers(),
                            style: colors.bodyStyle(context),
                          )),
                      Text(
                        toRials(amount ?? 0),
                        style: colors.boldStyle(context),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(status ?? '',
                        style: colors
                            .boldStyle(context)
                            .copyWith(color: colors.accentColor)),
                  ),
                ),
              ],
            ),
          ),
          Space(),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          Space(),
          Row(children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'شبا مقصد',
                      style: colors.bodyStyle(context),
                    ),
                    Space(),
                    Text(
                      '$destinationDeposit'?.withPersianNumbers(),
                      style: colors.boldStyle(context),
                    ),
                    Space(),
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
