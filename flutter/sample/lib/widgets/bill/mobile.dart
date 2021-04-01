import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/bill_payment.dart';
import 'package:novinpay/models/GetBillInfoResponse.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/mobile_input.dart';

class MobileBill extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MobileBillState();
}

class _MobileBillState extends State<MobileBill> with BillPaymentMixin {
  final _mobileNumberController = TextEditingController();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();
  Response<GetBillInfoResponse> _data;
  bool _isWorking = false;

  @override
  void dispose() {
    _mobileNumberController.dispose();
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

    final mobileNumber = _mobileNumberController.text;

    final data = await nh.irmci.getBillInfo(mobileNumber: mobileNumber);

    if (!mounted) {
      return;
    }

    setState(() {
      _data = data;
      _isWorking = false;
    });

    if (!data.hasErrors()) {
      nh.mru.addMru(
        type: MruType.mobile,
        title: null,
        value: mobileNumber,
      );
    }
  }

  void _showToast() {
    ToastUtils.showCustomToast(
        context,
        'در حال حاضر فقط امکان استعلام خطوط همراه اول وجود دارد',
        Image.asset('assets/ic_error.png'),'خطا');
    return;
  }

  @override
  Widget build(BuildContext context) {
    final header = Form(
      key: _formKey,
      child: Column(
        children: [
          Space(),
          MobileWidget(
            enabled: _isWorking != true,
            controller: _mobileNumberController,
            showSimCard: false,
            onChanged: (value) {
              setState(() {
                _data = null;
              });
            },
            onItemClicked: (value) {
              _submit();
            },
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
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      Text(toRials(_data?.content?.midTerm?.amount ?? 0),
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
                      final billInfo = _data?.content?.midTerm;

                      await payBill(
                          type: BillType.mobile,
                          title: 'قبض میان دوره',
                          billInfo: billInfo,
                          acceptorName: 'قبض همراه اول',
                          acceptorId: '5');
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
                      final billInfo = _data?.content?.endTerm;

                      await payBill(
                          type: BillType.mobile,
                          title: 'قبض پایان دوره',
                          billInfo: billInfo,
                          acceptorName: 'قبض همراه اول',
                          acceptorId: '5');
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
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        );

    Widget buildWelcomeMessage() => buildMessage(
          'لطفا شماره موبایل مورد نظر خود (خطوط همراه اول) را جهت دریافت قبض وارد کنید.',
        );

    Widget buildChild() {
      if (_data == null) {
        return buildWelcomeMessage();
      }

      if (_data.isError || _data.content == null) {
        return buildMessage(strings.connectionError);
      }

      if (_data.content.status != true) {
        return buildMessage(
            _data.content.description ?? strings.connectionError);
      }

      return ListView(
        children: [midTerm(), Space(2), endTerm()],
      );
    }

    final footer = (_data == null || _data.hasErrors())
        ? Padding(
            padding:
                const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
            child: ConfirmButton(
              onPressed: _isWorking == true ? null : _submit,
              child: CustomText(
                strings.action_inquiry,
                textAlign: TextAlign.center,
              ),
              color: colors.ternaryColor,
            ),
          )
        : Container();

    return HeadedPage(
      title: Text('قبض موبایل'),
      body: Split(
        header: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
          child: header,
        ),
        child: Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0, 24.0, 0),
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
    hideKeyboard(context);

    if (!_formKey.currentState.validate()) {
      return;
    }

    final mobile = _mobileNumberController.text;

    final op = Utils.getOperatorType(mobile);
    if (op == null) {
      return;
    }

    if (op == MobileOperator.mci) {
      _refreshKey.currentState.show();
    } else {
      _showToast();
    }
  }
}
