import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/GetTicketTypeListResponse.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/loading.dart';

class TicketlListDialog extends StatefulWidget {
  @override
  _TicketlListDialogState createState() => _TicketlListDialogState();
}

class _TicketlListDialogState extends State<TicketlListDialog> {
  @override
  Widget build(BuildContext context) {
    return TicketlList();
  }
}

class TicketlList extends StatefulWidget {
  @override
  _TicketlListState createState() => _TicketlListState();
}

class _TicketlListState extends State<TicketlList> {
  final _completer = Completer<Response<GetTicketTypeListResponse>>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getTicketlList();
    });
  }

  Future<void> _getTicketlList() async {
    final data = await Loading.run(context, nh.mms.getTicketTypeList());
    if (data.isError) {
      _completer.completeError(data);
      if (!data.isExpired) {
        ToastUtils.showCustomToast(
            context, data.error, Image.asset('assets/ic_error.png'), 'خطا');
      }
      return;
    }

    if (data.content.status != true) {
      _completer.completeError(data);
      return;
    }

    _completer.complete(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<GetTicketTypeListResponse>>(
        future: _completer.future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _buildEmpty();
          }

          if (snapshot.hasData) {
            final data = snapshot.data.content;
            if (data.ticketTypes.isEmpty) {
              return _buildEmpty();
            } else {
              return ListView.builder(
                  itemCount: data.ticketTypes.length,
                  itemBuilder: (context, index) {
                    return TicketItem(ticket: data.ticketTypes[index]);
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

class TicketItem extends StatelessWidget {
  TicketItem({@required this.ticket});

  final TicketTypes ticket;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(ticket);
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 14.0, bottom: 14.0, left: 10.0, right: 10.0),
              child: Row(
                children: [
                  Text(
                    ticket.ticketDescription,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13),
                  ),
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
