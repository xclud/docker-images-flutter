import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class GetBillsResponse extends ResponseBase {
  GetBillsResponse({
    @required this.data,
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

  GetBillsResponse.fromJson(Map<String, dynamic> json)
      : this(
          data: json['data'] != null ? Data.fromJson(json['data']) : null,
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
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = status;
    data['message'] = message;
    data['timeStamp'] = timeStamp;
    data['sessionKey'] = sessionKey;
    data['traceNo'] = traceNo;
    data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final Data data;
  final String message;
  final String timeStamp;
  final String sessionKey;
  final int traceNo;
}

class Data {
  Data({
    @required this.billData,
    @required this.email,
    @required this.nationalCode,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    final billData = <BillData>[];

    if (json['billData'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['billData'])
          .map((v) => BillData.fromJson(v));

      billData.addAll(tmp);
    }

    return Data(
      billData: billData,
      email: json['email'],
      nationalCode: json['nationalCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['billData'] = billData.map((v) => v.toJson()).toList();
    data['email'] = email;
    data['nationalCode'] = nationalCode;
    return data;
  }

  final List<BillData> billData;
  final String email;
  final String nationalCode;
}

class BillData {
  BillData({
    @required this.exData,
    @required this.billName,
    @required this.viaSms,
    @required this.viaPrint,
    @required this.viaEmail,
    @required this.viaApp,
    @required this.billId,
  });

  BillData.fromJson(Map<String, dynamic> json)
      : this(
          exData:
              json['exData'] != null ? ExData.fromJson(json['exData']) : null,
          billName: json['billTitle'],
          viaSms: json['viaSms'],
          viaPrint: json['viaPrint'],
          viaEmail: json['viaEmail'],
          viaApp: json['viaApp'],
          billId: json['BILL_IDENTIFIER'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (exData != null) {
      data['exData'] = exData.toJson();
    }
    data['billTitle'] = billName;
    data['viaSms'] = viaSms;
    data['viaPrint'] = viaPrint;
    data['viaEmail'] = viaEmail;
    data['viaApp'] = viaApp;
    data['BILL_IDENTIFIER'] = billId;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final ExData exData;
  final String billName;
  final bool viaSms;
  final bool viaPrint;
  final bool viaEmail;
  final bool viaApp;
  final int billId;
}

class ExData {
  ExData({
    @required this.firstName,
    @required this.lastName,
    @required this.fabricNumber,
  });

  ExData.fromJson(Map<String, dynamic> json)
      : this(
          firstName: json['firstName'],
          lastName: json['lastName'],
          fabricNumber: json['fabricNumber'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['fabricNumber'] = fabricNumber;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  String firstName;
  String lastName;
  String fabricNumber;
}
