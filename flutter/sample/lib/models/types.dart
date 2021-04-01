import 'dart:convert';

import 'package:novinpay/repository/response.dart';

enum MobileOperator {
  mci,
  irancell,
  rightel,
}

class GenerateBankUrlResponse extends ResponseBase {
  GenerateBankUrlResponse({
    @required this.bankUrl,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
          status: status,
          description: description,
          mobileNumber: mobileNumber,
          errorMessage: errorMessage,
        );

  GenerateBankUrlResponse.fromJson(Map<String, dynamic> json)
      : this(
          bankUrl: json['bankUrl'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bankUrl'] = bankUrl;
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

  final String bankUrl;
}

class BoomTokenResponse extends ResponseBase {
  BoomTokenResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
    @required this.appState,
    @required this.expires,
  }) : super(
          status: status,
          description: description,
          mobileNumber: mobileNumber,
          errorMessage: errorMessage,
        );

  BoomTokenResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
          appState: json['appState'],
          expires: json['tokenExpireSecond'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['appState'] = appState;
    data['tokenExpireSecond'] = expires;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String appState;
  final int expires;
}

class CardToIbanResponse extends ResponseBase {
  CardToIbanResponse({
    @required this.iban,
    @required this.bankName,
    @required this.depositNumber,
    @required this.depositDescription,
    @required this.ownerName,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  CardToIbanResponse.fromJson(Map<String, dynamic> json)
      : this(
          iban: json['iban'],
          bankName: json['bankName'],
          depositNumber: json['depositNumber'],
          depositDescription: json['depositDescription'],
          ownerName: json['ownerName'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['iban'] = iban;
    data['bankName'] = bankName;
    data['depositNumber'] = depositNumber;
    data['depositDescription'] = depositDescription;
    data['ownerName'] = ownerName;
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

  final String iban;
  final String bankName;
  final String depositNumber;
  final String depositDescription;
  final String ownerName;
}

class BankLoginInfo {
  BankLoginInfo({
    @required this.state,
    @required this.code,
    @required this.expires,
  });

  final int state;
  final String code;
  final double expires;
}

class StateResponse extends ResponseBase {
  StateResponse({
    @required this.key,
    @required this.value,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  StateResponse.fromJson(Map<String, dynamic> json)
      : this(
          key: json['key'],
          value: json['value'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  String key;
  String value;
}
