import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class MobileTopUpResponse extends ResponseBase {
  MobileTopUpResponse({
    @required this.stan,
    @required this.rrn,
    @required this.amount,
    @required this.chargeSerial,
    @required this.chargePin,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  MobileTopUpResponse.fromJson(Map<String, dynamic> json)
      : this(
          stan: json['stan'],
          rrn: json['rrn'],
          amount: int.tryParse(json['amount'] ?? '') ?? 0,
          chargeSerial: json['chargeSerial'],
          chargePin: json['chargePin'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['stan'] = stan;
    data['rrn'] = rrn;
    data['amount'] = '$amount';
    data['description'] = description;
    data['chargeSerial'] = chargeSerial;
    data['chargePin'] = chargePin;
    return data;
  }

  final String stan;
  final String rrn;
  final int amount;
  final String chargeSerial;
  final String chargePin;
}

class MobilePinResponse extends ResponseBase {
  MobilePinResponse({
    @required this.stan,
    @required this.rrn,
    @required this.amount,
    @required this.chargeSerial,
    @required this.chargePin,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  MobilePinResponse.fromJson(Map<String, dynamic> json)
      : this(
          stan: json['stan'],
          rrn: json['rrn'],
          amount: json['amount'],
          chargeSerial: json['chargeSerial'],
          chargePin: json['chargePin'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['stan'] = stan;
    data['rrn'] = rrn;
    data['amount'] = amount;
    data['chargeSerial'] = chargeSerial;
    data['chargePin'] = chargePin;
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

  final String stan;
  final String rrn;
  final String amount;
  final String chargeSerial;
  final String chargePin;
}
