import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/ListOfTerminalNumbersResponse.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class TerminalListDialog extends StatefulWidget {
  @override
  _TerminalListDialogState createState() => _TerminalListDialogState();
}

class _TerminalListDialogState extends State<TerminalListDialog> {
  @override
  Widget build(BuildContext context) {
    return TerminalList();
  }
}

class TerminalList extends StatefulWidget {
  @override
  _TerminalListState createState() => _TerminalListState();
}

class _TerminalListState extends State<TerminalList> {
  final _completer = Completer<Response<ListOfTerminalNumbersResponse>>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getTerminalList();
    });
  }

  Future<void> _getTerminalList() async {
    final data = await Loading.run(context, nh.mms.getTerminals());
    if (data.isError) {
      _completer.completeError(data);
      if (!data.isExpired) {
        ToastUtils.showCustomToast(
            context, data.error, Image.asset('assets/ic_error.png'), 'خطا');
      }
      return;
    }

    if (data.content.status != true) {
      ToastUtils.showCustomToast(context, 'اطلاعات پذیرندگی شما یافت نشد',
          Image.asset('assets/ic_error.png'), 'خطا');
      _completer.completeError(data);
      Navigator.of(context)
          .pushReplacementNamed(routes.home, arguments: {'selectedPage': 4});
      return;
    }

    _completer.complete(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<ListOfTerminalNumbersResponse>>(
        future: _completer.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildEmpty();
          }

          if (snapshot.hasData) {
            final data = snapshot.data.content;
            if (data.listOfTerminals.isEmpty) {
              return _buildEmpty();
            } else {
              return ListView.builder(
                  itemCount: data.listOfTerminals.length,
                  itemBuilder: (context, index) {
                    return TerminalItem(terminal: data.listOfTerminals[index]);
                  });
            }
          }

          return _buildEmpty();
        });
  }
}

Widget _buildEmpty() {
  return Center(
    child: Text('ترمینالی برای نمایش یافت نشد'),
  );
}

class TerminalItem extends StatelessWidget {
  TerminalItem({@required this.terminal});

  final ListOfTerminals terminal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(terminal);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 14.0, bottom: 14.0, left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('شماره ترمینال'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(terminal.terminalId
                          ?.withPersianLetters()
                          ?.withPersianNumbers()),
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Image.asset('assets/ic_en_bank.png'))
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              color: colors.greyColor.shade800,
            )
          ],
        ),
      ),
    );
  }
}
