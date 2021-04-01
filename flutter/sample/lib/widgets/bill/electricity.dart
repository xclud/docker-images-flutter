import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/electricity_bill_dialog.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/mixins/bill_payment.dart';
import 'package:novinpay/models/GetBillsResponse.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class ElectricityBill extends StatefulWidget {
  @override
  _ElectricityBillState createState() {
    return _ElectricityBillState();
  }
}

class _ElectricityBillState extends State<ElectricityBill>
    with AskYesNoMixin, BillPaymentMixin {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Widget _buildBills() {
    final data = _response.content.data;

    final items = data.billData.map(
      (e) => _buildBillItem(
        billName: e.billName,
        billId: e.billId,
        nationalCode: data.nationalCode,
      ),
    );

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0),
      child: Column(
        children: items.toList(),
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'سامانه استعلام و مدیریت قبوض برق',
          style: colors
              .regularStyle(context)
              .copyWith(color: colors.greyColor.shade900),
          textAlign: TextAlign.center,
          softWrap: true,
        )
      ],
    ));
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      actions: [],
      title: CustomText('قبض برق'),
      body: Split(
        child: Expanded(
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _refresh,
            child: Builder(
              builder: (context) {
                if (_response == null) {
                  return Container();
                }
                if (_response.isError) {
                  return Center(
                    child: Text(strings.connectionError),
                  );
                }

                if (_response.content.status != true) {
                  return Center(
                    child: Text(
                      _response.content.description ?? strings.connectionError,
                      style: colors
                          .regularStyle(context)
                          .copyWith(color: colors.greyColor.shade900),
                    ),
                  );
                }

                final billList = _response.content.data.billData;

                if (billList.isEmpty) {
                  return _buildEmpty();
                }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildBills(),
                );
              },
            ),
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.only(right: 24.0, left: 24.0, bottom: 24.0),
          child: ConfirmButton(
            child: CustomText(
              'افزودن قبض جدید',
              textAlign: TextAlign.center,
            ),
            onPressed: () => _addBill(''),
          ),
        ),
      ),
    );
  }

  Response<GetBillsResponse> _response;

  Future<void> _refresh() async {
    final data = await nh.electricBill.getBills();
    _response = data;

    if (mounted) {
      setState(() {});
    }
  }

  void _addBill(String billId) async {
    final result = await Navigator.of(context).push<ElectricityBillData>(
      MaterialPageRoute(
        builder: (context) => ElectricityBillDialog(
          billId: billId,
        ),
      ),
    );

    if (result == null) {
      return;
    }

    final data = await nh.electricBill.addBill(
      nationalCode: null,
      email: null,
      billIdentifier: int.tryParse(result.id),
      billTitle: result.name,
      viaSms: false,
      viaPrint: false,
      viaEmail: false,
      viaApp: true,
    );

    if (!showError(context, data)) {
      return;
    }

    _refreshKey.currentState.show();
  }

  Widget _buildBillItem({
    @required int billId,
    @required String billName,
    @required String nationalCode,
  }) {
    final deleteIcon = InkWell(
      onTap: () => _doDelete(context, billId, billName, nationalCode),
      child: Icon(
        Icons.delete_outlined,
        color: colors.red,
      ),
    );

    return Container(
        margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: colors.greyColor.shade600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 8.0),
              child: DualListTile(
                  start: Text(
                    billName?.withPersianLetters() ?? '',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  end: deleteIcon),
            ),
            Space(),
            Container(
              height: 1,
              color: colors.greyColor.shade800,
            ),
            Space(),
            Padding(
              padding:
                  const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 8.0),
              child: DualListTile(
                start: Text(
                  (billId.toString()?.withPersianNumbers() ??
                      '0'.withPersianNumbers()),
                  style: colors.boldStyle(context),
                ),
                end: FlatButton(
                  padding: EdgeInsets.only(
                      right: 8.0, left: 8.0, top: 16.0, bottom: 16.0),
                  onPressed: () => _onBillItemTap(context, billId),
                  child: Text(
                    strings.action_inquiry,
                    style: colors.regularStyle(context).copyWith(
                        color: colors.greyColor.shade50, fontSize: 12.0),
                  ),
                  color: colors.ternaryColor,
                ),
              ),
            ),
          ],
        ));
  }

  void _onBillItemTap(BuildContext context, int billId) async {
    final data = await Loading.run(
      context,
      nh.electricBill.getBranchData(billId: billId),
    );

    if (!showError(context, data)) {
      return;
    }

    final billInfo = data.content.data.billInfo;

    await payBill(
        type: BillType.elec,
        title: 'قبض برق',
        billInfo: billInfo,
        acceptorName: 'قبض برق',
        acceptorId: '2');
  }

  void _doDelete(
    BuildContext context,
    int billId,
    String billName,
    String nationalCode,
  ) async {
    final result = await askYesNo(
      title: Text("حذف '$billName' ؟"),
    );

    if (result != true) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.electricBill.removeBill(billId: billId, nationalCode: nationalCode),
    );

    if (!showError(context, data)) {
      return;
    }

    ToastUtils.showCustomToast(
      context,
      data.content?.description ?? 'قبض با موفقیت حذف شد',
      Image.asset('assets/ok.png'),
    );

    _refreshKey.currentState.show();
  }
}
