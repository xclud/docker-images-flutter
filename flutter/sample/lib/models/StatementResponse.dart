import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class StatementResponse extends ResponseBase {
  StatementResponse({
    @required this.isValidToken,
    @required this.statements,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory StatementResponse.fromJson(Map<String, dynamic> json) {
    final statements = <Statement>[];
    if (json['statements'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['statements'])
          .map((v) => Statement.fromJson(v));

      statements.addAll(tmp);
    }

    return StatementResponse(
      statements: statements,
      isValidToken: json['isValidToken'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['isValidToken'] = isValidToken;
    data['statements'] = statements.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final bool isValidToken;
  final List<Statement> statements;
}

class Statement {
  Statement({
    @required this.serialNumber,
    @required this.date,
    @required this.datePersian,
    @required this.description,
    @required this.balance,
    @required this.statementSerial,
    @required this.branchCode,
    @required this.branchName,
    @required this.agentBranchCode,
    @required this.agentBranchName,
    @required this.transferAmount,
    @required this.referenceNumber,
    @required this.statementId,
  });

  Statement.fromJson(Map<String, dynamic> json)
      : this(
          serialNumber: json['serialNumber'],
          date: json['date'],
          datePersian: json['datePersian'],
          description: json['description'],
          balance: json['balance'],
          statementSerial: json['statementSerial'],
          branchCode: json['branchCode'],
          branchName: json['branchName'],
          agentBranchCode: json['agentBranchCode'],
          agentBranchName: json['agentBranchName'],
          transferAmount: json['transferAmount'],
          referenceNumber: json['referenceNumber'],
          statementId: json['statementId'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['serialNumber'] = serialNumber;
    data['date'] = date;
    data['datePersian'] = datePersian;
    data['description'] = description;
    data['balance'] = balance;
    data['statementSerial'] = statementSerial;
    data['branchCode'] = branchCode;
    data['branchName'] = branchName;
    data['agentBranchCode'] = agentBranchCode;
    data['agentBranchName'] = agentBranchName;
    data['transferAmount'] = transferAmount;
    data['referenceNumber'] = referenceNumber;
    data['statementId'] = statementId;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String serialNumber;
  final String date;
  final String datePersian;
  final String description;
  final num balance;
  final num statementSerial;
  final String branchCode;
  final String branchName;
  final String agentBranchCode;
  final String agentBranchName;
  final num transferAmount;
  final String referenceNumber;
  final String statementId;
}
