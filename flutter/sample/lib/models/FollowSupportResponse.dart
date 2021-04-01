import 'package:novinpay/repository/response.dart';

class FollowSupportResponse extends ResponseBase {
  FollowSupportResponse({
    @required this.ticketCount,
    @required this.ticketsList,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory FollowSupportResponse.fromJson(Map<String, dynamic> json) {
    final data = <TicketsList>[];

    if (json['ticketsList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['ticketsList'])
          .map((v) => TicketsList.fromJson(v));
      data.addAll(tmp);
    }

    return FollowSupportResponse(
      ticketsList: data,
      ticketCount: json['ticketCount'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['ticketCount'] = ticketCount;
    data['ticketsList'] = ticketsList.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final int ticketCount;
  final List<TicketsList> ticketsList;
}

class TicketsList {
  TicketsList({
    @required this.createDate,
    @required this.emergencyMaintenanceId,
    @required this.merchantId,
    @required this.phoneNumber,
    @required this.terminalId,
    @required this.ticketStatus,
    @required this.ticketStatusId,
    @required this.ticketType,
    @required this.ticketTypeId,
  });

  TicketsList.fromJson(Map<String, dynamic> json)
      : this(
          createDate: json['createDate'],
          emergencyMaintenanceId: json['emergencyMaintenanceId'],
          merchantId: json['merchantId'],
          phoneNumber: json['phoneNumber'],
          terminalId: json['terminalId'],
          ticketStatus: json['ticketStatus'],
          ticketStatusId: json['ticketStatusId'],
          ticketType: json['ticketType'],
          ticketTypeId: json['ticketTypeId'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['createDate'] = createDate;
    data['emergencyMaintenanceId'] = emergencyMaintenanceId;
    data['merchantId'] = merchantId;
    data['phoneNumber'] = phoneNumber;
    data['terminalId'] = terminalId;
    data['ticketStatus'] = ticketStatus;
    data['ticketStatusId'] = ticketStatusId;
    data['ticketType'] = ticketType;
    data['ticketTypeId'] = ticketTypeId;
    return data;
  }

  String createDate;
  int emergencyMaintenanceId;
  String merchantId;
  String phoneNumber;
  String terminalId;
  String ticketStatus;
  int ticketStatusId;
  String ticketType;
  int ticketTypeId;
}
