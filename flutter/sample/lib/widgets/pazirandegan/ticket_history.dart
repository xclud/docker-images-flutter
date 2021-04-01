import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/FollowSupportResponse.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/dual_list_tile.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class TicketHistory extends StatefulWidget {
  TicketHistory({this.filterData});

  final List<String> filterData;

  @override
  _TicketHistoryState createState() => _TicketHistoryState();
}

class _TicketHistoryState extends State<TicketHistory> {
  final _completer = Completer<Response<FollowSupportResponse>>();
  List<String> _filterData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _filterData = widget.filterData;
      _getHistoryOfTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
        title: Text('تاریخچه تیکت ها'),
        body: Center(
          child: FutureBuilder<Response<FollowSupportResponse>>(
              future: _completer.future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(strings.connectionError);
                } else if (snapshot.hasData) {
                  if (snapshot.data.content.status == false) {
                    return Text(snapshot.data?.content?.description ?? '');
                  } else if (snapshot.data.content.ticketCount == 0) {
                    return Text('شما هیچ تیکت ثبت شده ای ندارید');
                  } else {
                    final resp = snapshot.data;
                    final data = resp.content.ticketsList;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          TicketStatus state;
                          if (data[index].ticketStatusId == 1 ||
                              data[index].ticketStatusId == 7) {
                            state = TicketStatus.inProgress;
                          } else if (data[index].ticketStatusId == 6) {
                            state = TicketStatus.done;
                          } else {
                            state = TicketStatus.doing;
                          }
                          return TicketHistoryItem(
                            typeOfTicket: data[index].ticketType,
                            date: data[index].createDate,
                            code: data[index].emergencyMaintenanceId.toString(),
                            status: state,
                          );
                        });
                  }
                }
                return Text('شما هیچ تیکت ثبت شده ای ندارید');
              }),
        ));
  }

  void _getHistoryOfTickets() async {
    if (_filterData != null && _filterData.isNotEmpty) {
      final response = await Loading.run(
          context,
          nh.mms.getFollowSupport(
              _filterData[0], _filterData[1], _filterData[2]));
      if (response.isError) {
        _completer.completeError(response);
        if (!response.isExpired) {
          ToastUtils.showCustomToast(
              context, response.error, Image.asset('assets/ic_error.png'), 'خطا');
        }
        return;
      }
      if (!response.content.status) {
        _completer.complete(response);

        ToastUtils.showCustomToast(context, response.content.description,
            Image.asset('assets/ic_error.png'), 'خطا');
        return;
      }
      _completer.complete(response);
    } else {
      final response = await nh.mms.getFollowSupport('', '', '');
      if (response.isError) {
        _completer.completeError(response);
        if (!response.isExpired) {
          ToastUtils.showCustomToast(
              context, response.error, Image.asset('assets/ic_error.png'), 'خطا');
        }
        return;
      }
      if (!response.content.status) {
        _completer.complete(response);

        ToastUtils.showCustomToast(context, response.content.description,
            Image.asset('assets/ic_error.png'), 'خطا');
        return;
      }
      _completer.complete(response);
    }

    if (mounted) {
      setState(() {});
    }
  }
}

class TicketHistoryItem extends StatefulWidget {
  TicketHistoryItem(
      {@required this.status,
      @required this.code,
      @required this.date,
      @required this.typeOfTicket});

  final String typeOfTicket;
  final String date;
  final String code;
  final TicketStatus status;

  @override
  _TicketHistoryItemState createState() => _TicketHistoryItemState();
}

class _TicketHistoryItemState extends State<TicketHistoryItem> {
  String description = '';

  Icon icon;

  Color color;

  @override
  Widget build(BuildContext context) {
    if (widget.status == TicketStatus.doing) {
      description = 'درحال انجام';
      color = colors.ternaryColor;
      icon = Icon(
        Icons.build,
        size: 16,
        color: colors.primaryColor,
      );
    } else if (widget.status == TicketStatus.done) {
      description = 'انجام شده';
      color = colors.accentColor;

      icon = Icon(
        Icons.done,
        size: 18,
        color: colors.primaryColor,
      );
    } else if (widget.status == TicketStatus.inProgress) {
      description = 'درحال بررسی';
      color = colors.red;

      icon = Icon(
        Icons.access_time,
        size: 16,
      );
    }
    return Container(
      padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      margin: EdgeInsets.only(left: 24.0, right: 24.0, top: 8),
      decoration: BoxDecoration(
        color: colors.greyColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DualListTile(
            start: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.date?.withPersianNumbers() ?? ''),
                Text(widget.code?.withPersianLetters()?.withPersianNumbers() ??
                    ''),
              ],
            ),
            end: Container(
              padding: EdgeInsets.only(
                  left: 16.0, top: 8.0, bottom: 8.0, right: 16.0),
              decoration: BoxDecoration(
                color: colors.greyColor.shade50,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                description?.withPersianLetters()?.withPersianNumbers() ?? '',
                style: TextStyle(color: color),
              ),
            ),
          ),
          Space(),
          DualListTile(
            start: Expanded(
              child: Text(
                widget.typeOfTicket
                        ?.withPersianLetters()
                        ?.withPersianNumbers() ??
                    '',
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            end: Container(),
          )
        ],
      ),
    );
  }
}

enum TicketStatus { doing, done, inProgress }
