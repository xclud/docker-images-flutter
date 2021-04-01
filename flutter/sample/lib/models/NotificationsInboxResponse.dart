import 'package:novinpay/repository/response.dart';

class NotificationsInboxResponse extends ResponseBase {
  NotificationsInboxResponse({
    @required this.notifications,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory NotificationsInboxResponse.fromJson(Map<String, dynamic> json) {
    final notifications = <InboxInfo>[];

    if (json['notifications'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['notifications'])
          .map((v) => InboxInfo.fromJson(v));

      notifications.addAll(tmp);
    }

    return NotificationsInboxResponse(
      notifications: notifications,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final List<InboxInfo> notifications;
}

class InboxInfo {
  InboxInfo({
    @required this.title,
    @required this.noificationMessage,
  });

  factory InboxInfo.fromJson(Map<String, dynamic> json) {
    return InboxInfo(
      title: json['title'],
      noificationMessage: json['noificationMessage'],
    );
  }

  final String title;
  final String noificationMessage;
}
