import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/ListOfTerminalNumbersResponse.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/pazirandegan/terminal_list_dialog.dart';
import 'package:novinpay/widgets/pazirandegan/ticket_history.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class TicketFilter extends StatefulWidget {
  @override
  _TicketFilterState createState() => _TicketFilterState();
}

class _TicketFilterState extends State<TicketFilter> {
  final _formKey = GlobalKey<FormState>();
  final _dateStartController = TextEditingController();
  final _dateEndController = TextEditingController();
  final _terminalController = TextEditingController();
  List<String> data = [];
  String from;
  String to;

  String _validateTerminalId(String value) {
    if (value == null || value.isEmpty) {
      return 'شناسه ترمینال را انتخاب نمایید';
    }
    return null;
  }

  @override
  void dispose() {
    _dateStartController.dispose();
    _dateEndController.dispose();
    _terminalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('فیلتر تیکت'),
      body: Split(
        child: Expanded(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    onTap: () async {
                      hideKeyboard(context);
                      final data = await showCustomDraggableBottomSheet<ListOfTerminals>(
                        context: context,
                        title: Text('شناسه ترمینال'),
                        initialChildSize: 0.7,
                        builder: (context, scrollController) =>
                            TerminalListDialog(),
                      );
                      if (data == null) {
                        return;
                      }
                      setState(() {
                        _terminalController.text = data.terminalId;
                      });
                    },
                    controller: _terminalController,
                    validator: _validateTerminalId,
                    decoration: InputDecoration(
                      labelText: 'شماره ترمینال',
                    ),
                    textAlign: TextAlign.end,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: PersianDateTextFormField(
                            controller: _dateStartController,
                            labelText: 'از تاریخ',
                          ),
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Expanded(
                          child: PersianDateTextFormField(
                            controller: _dateEndController,
                            labelText: 'تا تاریخ',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        footer: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
          child: ConfirmButton(
            child: CustomText(
              strings.action_ok,
              textAlign: TextAlign.center,
            ),
            onPressed: _submit,
            color: colors.ternaryColor,
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    data.add(_terminalController.text);
    var startDateItems = _dateStartController.text.split('/');

    data.add(validDate(Utils.jalaliToGregorian(
        int.tryParse(startDateItems[0]),
        int.tryParse(startDateItems[1]),
        int.tryParse(startDateItems[2]),
        '/')));
    var endDateItems = _dateEndController.text.split('/');
    data.add(validDate(Utils.jalaliToGregorian(int.tryParse(endDateItems[0]),
        int.tryParse(endDateItems[1]), int.tryParse(endDateItems[2]), '/')));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TicketHistory(
          filterData: data,
        ),
      ),
    );
  }
}

String validDate(String date) {
  String year = date.split('/')[0];
  String month = date.split('/')[1];
  if (int.tryParse(month) < 10) {
    month = '0$month';
  }
  String day = date.split('/')[2];
  if (int.tryParse(day) < 10) {
    day = '0$day';
  }
  return '$year/$month/$day';
}
