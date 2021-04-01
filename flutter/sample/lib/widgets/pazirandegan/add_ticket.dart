import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/ticket_list_dialog.dart';
import 'package:novinpay/models/GetTicketTypeListResponse.dart';
import 'package:novinpay/models/ListOfTerminalNumbersResponse.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/pazirandegan/terminal_list_dialog.dart';
import 'package:persian/persian.dart';

class AddTicket extends StatefulWidget {
  @override
  _AddTicketState createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  final _formKey = GlobalKey<FormState>();
  final _terminalIdInput = TextEditingController();
  final _ticketInput = TextEditingController();
  final _descriptionInput = TextEditingController();
  int _ticketTypeId;

  String _validateTerminalId(String value) {
    if (value == null || value.isEmpty) {
      return 'شناسه ترمینال را انتخاب نمایید';
    }
    return null;
  }

  String _validateTicket(String value) {
    if (value == null || value.isEmpty) {
      return 'نوع تیکت را انتخاب نمایید';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 24.0),
                      child: TextFormField(
                        onTap: () async {
                          final data = await showCustomDraggableBottomSheet<
                              ListOfTerminals>(
                            context: context,
                            initialChildSize: 0.7,
                            title: Text('شناسه ترمینال'),
                            builder: (context, scrollController) =>
                                TerminalListDialog(),
                          );
                          if (data == null) {
                            return;
                          }
                          setState(() {
                            _terminalIdInput.text = data.terminalId;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'شناسه ترمینال',
                        ),
                        controller: _terminalIdInput,
                        validator: _validateTerminalId,
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, right: 24.0, top: 16.0),
                      child: TextFormField(
                        onTap: () async {
                          final data =
                              await showCustomDraggableBottomSheet<TicketTypes>(
                            context: context,
                            title: Text('نوع تیکت'),
                            initialChildSize: 0.7,
                            builder: (context, scrollController) =>
                                TicketlListDialog(),
                          );
                          if (data == null) {
                            return;
                          }
                          setState(() {
                            _ticketInput.text = data.ticketDescription;
                            _ticketTypeId = data.ticketTypeId;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'نوع تیکت',
                        ),
                        controller: _ticketInput,
                        textAlign: TextAlign.center,
                        validator: _validateTicket,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 160,
                margin: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                child: TextFormField(
                  controller: _descriptionInput,
                  minLines: 6,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'توضیحات',
                    border: InputBorder.none,
                  ),
                ),
                decoration: BoxDecoration(
                  color: colors.greyColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
      footer: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
        child: ConfirmButton(
          onPressed: _submit,
          child: CustomText(
            'ارسال تیکت',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final data = await Loading.run(
        context,
        nh.mms.getRequestSupport(
            _descriptionInput.text, _ticketTypeId, _terminalIdInput.text));
    if (data.isError) {
      if (!data.isExpired) {
        ToastUtils.showCustomToast(
            context, data.error, Image.asset('assets/ic_error.png'), 'خطا');
      }
      return;
    }
    if (data.content.status != true) {
      ToastUtils.showCustomToast(context, data.content.description,
          Image.asset('assets/ic_error.png'), 'خطا');
      return;
    }

    ToastUtils.showCustomToast(
        context,
        '$rlm${data.content.description}'
            .withPersianLetters()
            ?.withPersianNumbers(),
        Image.asset('assets/ok.png'));
    return;
  }
}
