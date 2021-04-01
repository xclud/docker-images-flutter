import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/NotificationsInboxResponse.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/widgets/general/general.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<NotificationsInboxResponse> _data;

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
      title: Text('صندوق پیام'),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: _buildChild(),
      ),
    );
  }

  Future<void> _onRefresh() async {
    final data = await nh.novinPay.application
        .notificationsInbox(offset: '1', length: '100');

    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  Widget _buildMessage(String message) {
    return Text(
      message,
      style: colors
          .regularStyle(context)
          .copyWith(color: colors.greyColor.shade900),
    );
  }

  Widget _buildChild() {
    if (_data == null) {
      return Center(
        child: _buildMessage(strings.please_wait),
      );
    }

    if (_data.isError) {
      return Center(
        child: _buildMessage(strings.connectionError),
      );
    }

    if (_data.content.status != true) {
      return Center(
        child: _buildMessage(_data.content.description ?? ''),
      );
    }

    final notifications = _data.content.notifications;

    return ListView(
        children: notifications
            .map((e) => _buildItem(
                title: e.title, notificationMessage: e.noificationMessage))
            .toList());
  }

  Widget _buildItem({
    @required String title,
    @required String notificationMessage,
  }) {
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: Text(title)),
        Space(),
        Divider(
          height: 2,
          color: colors.primaryColor,
        ),
        Space(),
        Center(child: Text(notificationMessage)),
      ],
    ));
  }
}
