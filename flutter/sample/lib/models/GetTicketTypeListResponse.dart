import 'package:novinpay/repository/response.dart';

class GetTicketTypeListResponse extends ResponseBase {
  GetTicketTypeListResponse({
    @required this.ticketTypes,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetTicketTypeListResponse.fromJson(Map<String, dynamic> json) {
    final ticketTypes = <TicketTypes>[];
    if (json['ticketTypes'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['ticketTypes'])
          .map((v) => TicketTypes.fromJson(v));

      ticketTypes.addAll(tmp);
    }

    return GetTicketTypeListResponse(
      ticketTypes: ticketTypes,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['ticketTypes'] = ticketTypes.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  List<TicketTypes> ticketTypes;
}

class TicketTypes {
  TicketTypes({
    @required this.ticketTypeCode,
    @required this.ticketTypeId,
    @required this.ticketDescription,
    @required this.priority,
  });

  TicketTypes.fromJson(Map<String, dynamic> json)
      : this(
          ticketTypeCode: json['ticketTypeCode'],
          ticketTypeId: json['ticketTypeId'],
          ticketDescription: json['ticketDescription'],
          priority: json['priority'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ticketTypeCode'] = ticketTypeCode;
    data['ticketTypeId'] = ticketTypeId;
    data['ticketDescription'] = ticketDescription;
    data['priority'] = priority;
    return data;
  }

  final int ticketTypeCode;
  final int ticketTypeId;
  final String ticketDescription;
  final int priority;
}
