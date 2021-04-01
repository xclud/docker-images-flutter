import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class AddBillResponse extends ResponseBase {
  AddBillResponse({
    @required this.message,
    @required this.timeStamp,
    @required this.sessionKey,
    @required this.traceNo,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  AddBillResponse.fromJson(Map<String, dynamic> json)
      : this(
          message: json['message'],
          timeStamp: json['timeStamp'],
          sessionKey: json['sessionKey'],
          traceNo: json['traceNo'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message;
    data['timeStamp'] = timeStamp;
    data['sessionKey'] = sessionKey;
    data['traceNo'] = traceNo;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String message;
  final String timeStamp;
  final String sessionKey;
  final int traceNo;
}

class RemoveBillResponse extends ResponseBase {
  RemoveBillResponse({
    @required this.message,
    @required this.timeStamp,
    @required this.sessionKey,
    @required this.traceNo,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  RemoveBillResponse.fromJson(Map<String, dynamic> json)
      : this(
          message: json['message'],
          timeStamp: json['timeStamp'],
          sessionKey: json['sessionKey'],
          traceNo: json['traceNo'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['message'] = message;
    data['timeStamp'] = timeStamp;
    data['sessionKey'] = sessionKey;
    data['traceNo'] = traceNo;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String message;
  final String timeStamp;
  final String sessionKey;
  final int traceNo;
}
