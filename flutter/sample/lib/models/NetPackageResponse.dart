import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class NetPackageResponse extends ResponseBase {
  NetPackageResponse({
    @required this.returnList,
    @required this.chargeType,
    @required this.reserveNumber,
    @required this.returnCode,
    @required this.inquiryDescription,
    @required this.additionalData,
    @required this.localDateTime,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory NetPackageResponse.fromJson(Map<String, dynamic> json) {
    final returnList = <ReturnList>[];

    if (json['returnList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['returnList'])
          .map((v) => ReturnList.fromJson(v));
      returnList.addAll(tmp);
    }

    return NetPackageResponse(
      returnList: returnList,
      chargeType: json['chargeType'],
      reserveNumber: json['reserveNumber'],
      returnCode: json['returnCode'],
      inquiryDescription: json['inquiryDescription'],
      additionalData: json['additionalData'],
      localDateTime: json['localDateTime'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['returnList'] = returnList.map((v) => v.toJson()).toList();
    data['chargeType'] = chargeType;
    data['reserveNumber'] = reserveNumber;
    data['returnCode'] = returnCode;
    data['inquiryDescription'] = inquiryDescription;
    data['additionalData'] = additionalData;
    data['localDateTime'] = localDateTime;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final List<ReturnList> returnList;
  final int chargeType;
  final int reserveNumber;
  final int returnCode;
  final String inquiryDescription;
  final String additionalData;
  final String localDateTime;
}

class ReturnList {
  ReturnList({
    @required this.caption,
    @required this.title,
    @required this.chType,
    @required this.expiry,
    @required this.orgAmount,
    @required this.affAmount,
    @required this.trafic,
  });

  ReturnList.fromJson(Map<String, dynamic> json)
      : this(
          caption: json['caption'],
          title: json['title'],
          chType: json['ch_type'],
          expiry: json['expiry'],
          orgAmount: json['org_amount'],
          affAmount: json['aff_amount'],
          trafic: json['trafic'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['caption'] = caption;
    data['title'] = title;
    data['ch_type'] = chType;
    data['expiry'] = expiry;
    data['org_amount'] = orgAmount;
    data['aff_amount'] = affAmount;
    data['trafic'] = trafic;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String caption;
  final String title;
  final String chType;
  final String expiry;
  final String orgAmount;
  final String affAmount;
  final String trafic;
}
