import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class BillInquiryResponse extends ResponseBase {
  BillInquiryResponse({
    @required this.billType,
    @required this.billAmount,
    @required this.billId,
    @required this.paymentId,
    @required this.billTypeId,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  BillInquiryResponse.fromJson(Map<String, dynamic> json)
      : this(
          billType: json['billType'],
          billAmount: int.tryParse(json['billAmount']?.toString() ?? '') ?? 0,
          billId: json['billId'],
          paymentId: json['paymentId'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          billTypeId: json['billTypeId'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['billType'] = billType;
    data['billAmount'] = billAmount;
    data['billId'] = billId;
    data['paymentId'] = paymentId;
    data['description'] = description;
    data['billTypeId'] = billTypeId;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String billType;
  final int billAmount;
  final String billId;
  final String paymentId;
  final String billTypeId;
}
