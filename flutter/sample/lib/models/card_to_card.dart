import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class CardInquiryResponse extends ResponseBase {
  CardInquiryResponse({
    @required this.cardHolder,
    @required this.stan,
    @required this.traceNumber,
    @required this.amount,
    @required this.additionalData,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  CardInquiryResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          mobileNumber: json['mobileNumber'],
          cardHolder: json['cardHolder'],
          stan: json['stan'],
          traceNumber: json['traceNumber'],
          amount: json['amount'],
          additionalData: json['additionalData'],
          description: json['description'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['cardHolder'] = cardHolder;
    data['stan'] = stan;
    data['traceNumber'] = traceNumber;
    data['amount'] = amount;
    data['additionalData'] = additionalData;
    data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String cardHolder;
  final String stan;
  final String traceNumber;
  final String amount;
  final String additionalData;
}

class CardTransferResponse extends ResponseBase {
  CardTransferResponse({
    @required this.stan,
    @required this.rrn,
    @required this.amount,
    @required this.cardBalance,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  CardTransferResponse.fromJson(Map<String, dynamic> json)
      : this(
          stan: json['stan'],
          rrn: json['rrn'],
          amount: int.tryParse(json['amount'] ?? '') ?? 0,
          cardBalance: json['cardBalance'],
          status: json['status'],
          mobileNumber: json['mobileNumber'],
          description: json['description'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['stan'] = stan;
    data['rrn'] = rrn;
    data['amount'] = '$amount';
    data['cardBalance'] = cardBalance;
    data['description'] = description;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String stan;
  final String rrn;
  final int amount;
  final String cardBalance;
}
