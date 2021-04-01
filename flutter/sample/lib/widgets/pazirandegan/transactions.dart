import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/GetTransactionListResponse.dart';
import 'package:novinpay/models/ListOfTerminalNumbersResponse.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/pazirandegan/terminal_list_dialog.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class PosTransaction extends StatefulWidget {
  @override
  _PosTransactionState createState() => _PosTransactionState();
}

class _PosTransactionState extends State<PosTransaction> {
  final _formKey = GlobalKey<FormState>();
  List<Transactions> _transactionList = [];
  final _terminalIdInput = TextEditingController();
  final _fromDate = TextEditingController();
  final _toDateInput = TextEditingController();

  String _validateTerminalId(String value) {
    if (value == null || value.isEmpty) {
      return 'شناسه ترمینال را انتخاب نمایید';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
            child: TextFormField(
              onTap: () async {
                final data = await showCustomDraggableBottomSheet<ListOfTerminals>(
                  context: context,
                  title: Text('شناسه ترمینال'),
                  builder: (context, scrollController) => TerminalListDialog(),
                );
                if (data == null) {
                  return;
                }
                setState(() {
                  _terminalIdInput.text = data.terminalId;
                });
              },
              controller: _terminalIdInput,
              validator: _validateTerminalId,
              textAlign: TextAlign.end,
              decoration: InputDecoration(labelText: 'شناسه ترمینال'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 24.0, right: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: PersianDateTextFormField(
                    controller: _fromDate,
                    labelText: 'از تاریخ',
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: PersianDateTextFormField(
                    controller: _toDateInput,
                    labelText: 'تا تاریخ',
                  ),
                ),
              ],
            ),
          ),
          Space(2),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _transactionList.length,
                itemBuilder: (context, index) {
                  return TransactionItem(
                    item: _transactionList[index],
                  );
                }),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
            child: ConfirmButton(
              onPressed: _getTransactionList,
              child: CustomText(
                'استعلام',
                textAlign: TextAlign.center,
              ),
              color: colors.ternaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _getTransactionList() async {
    if (int.tryParse(_fromDate.text.replaceAll('/', '')) >
        int.tryParse(_toDateInput.text.replaceAll('/', ''))) {
      ToastUtils.showCustomToast(context, 'تاریخ را به درستی وارد نمایید',
          Image.asset('assets/ic_error.png'),'اخطار');
      return;
    }
    if (!_formKey.currentState.validate()) {
      return;
    }
    final data = await Loading.run(
        context,
        nh.mms.getTransactionList(
            _terminalIdInput.text,
            _fromDate.text.replaceAll('/', ''),
            _toDateInput.text.replaceAll('/', '')));

    if (!showError(context, data)) {
      return;
    } else {
      setState(() {
        _transactionList = data.content.transactions;
      });
    }
  }
}

class TransactionItem extends StatelessWidget {
  TransactionItem({@required this.item});

  final Transactions item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
      decoration: BoxDecoration(
        color: colors.greyColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DualListTile(
              start: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    toRials(item.amount),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(item?.statusDescription?.withPersianNumbers() ?? ''),
                ],
              ),
              end: Container(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                  color: colors.greyColor.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                      color: (item.status == 'موفق')
                          ? colors.accentColor
                          : colors.red),
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: colors.greyColor.shade800,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DualListTile(
              start: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.shamsiDate?.withPersianNumbers() ?? '',
                  ),
                  Text(
                    item?.panMasked?.withPersianNumbers() ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              end: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item?.rrn?.withPersianNumbers() ?? '',
                  ),
                  Text(
                    item?.merchantId?.withPersianNumbers() ?? '',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
