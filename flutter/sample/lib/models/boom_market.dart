import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class GetDepositResponse extends ResponseBase {
  GetDepositResponse({
    @required this.depositNumber,
    @required this.isValidToken,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  GetDepositResponse.fromJson(Map<String, dynamic> json)
      : this(
          depositNumber: json['depositNumber'],
          isValidToken: json['isValidToken'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['depositNumber'] = depositNumber;
    data['isValidToken'] = isValidToken;
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

  final String depositNumber;
  final bool isValidToken;
}

class GetIbanResponse extends ResponseBase {
  GetIbanResponse({
    @required this.ibanNumber,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  GetIbanResponse.fromJson(Map<String, dynamic> json)
      : this(
          ibanNumber: json['ibanNumber'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ibanNumber'] = ibanNumber;
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

  final String ibanNumber;
}

class LoanPaymentWithDepositResponse extends ResponseBase {
  LoanPaymentWithDepositResponse({
    @required this.isValidToken,
    @required this.documentNumber,
    @required this.documentTitle,
    @required this.appliedAmount,
    @required this.currency,
    @required this.loanStates,
    @required this.loanStatesFarsiDescription,
    @required this.trackingCode,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  LoanPaymentWithDepositResponse.fromJson(Map<String, dynamic> json)
      : this(
          isValidToken: json['isValidToken'],
          documentNumber: json['documentNumber'],
          documentTitle: json['documentTitle'],
          appliedAmount: json['appliedAmount'],
          currency: json['currency'],
          loanStates: json['loanStates'],
          loanStatesFarsiDescription: json['loanStatesFarsiDescription'],
          trackingCode: json['trackingCode'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isValidToken'] = isValidToken;
    data['documentNumber'] = documentNumber;
    data['documentTitle'] = documentTitle;
    data['appliedAmount'] = appliedAmount;
    data['currency'] = currency;
    data['loanStates'] = loanStates;
    data['loanStatesFarsiDescription'] = loanStatesFarsiDescription;
    data['trackingCode'] = trackingCode;
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

  final bool isValidToken;
  final String documentNumber;
  final String documentTitle;
  final String appliedAmount;
  final String currency;
  final String loanStates;
  final String loanStatesFarsiDescription;
  final String trackingCode;
}

class PayaReportResponse extends ResponseBase {
  PayaReportResponse({
    @required this.isValidToken,
    @required this.totalRecord,
    @required this.transactions,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory PayaReportResponse.fromJson(Map<String, dynamic> json) {
    final transactions = <Transactions>[];
    if (json['transactions'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['transactions'])
          .map((v) => Transactions.fromJson(v));
      transactions.addAll(tmp);
    }
    return PayaReportResponse(
      transactions: transactions,
      isValidToken: json['isValidToken'],
      totalRecord: json['totalRecord'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final bool isValidToken;
  final int totalRecord;
  final List<Transactions> transactions;
}

class Transactions {
  Transactions({
    @required this.sourceIbanNumber,
    @required this.resumable,
    @required this.referenceId,
    @required this.id,
    @required this.amount,
    @required this.currency,
    @required this.ibanNumber,
    @required this.ibanOwnerName,
    @required this.issueDate,
    @required this.issueDateDescription,
    @required this.status,
    @required this.statusDescription,
    @required this.cancelable,
    @required this.suspendable,
    @required this.changeable,
    @required this.description,
  });

  Transactions.fromJson(Map<String, dynamic> json)
      : this(
          sourceIbanNumber: json['sourceIbanNumber'],
          resumable: json['resumable'],
          referenceId: json['referenceId'],
          id: json['id'],
          amount: json['amount'],
          currency: json['currency'],
          ibanNumber: json['ibanNumber'],
          ibanOwnerName: json['ibanOwnerName'],
          issueDate: json['issueDate'],
          issueDateDescription: json['issueDateDescription'],
          status: json['status'],
          statusDescription: json['statusDescription'],
          cancelable: json['cancelable'],
          suspendable: json['suspendable'],
          changeable: json['changeable'],
          description: json['description'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sourceIbanNumber'] = sourceIbanNumber;
    data['resumable'] = resumable;
    data['referenceId'] = referenceId;
    data['id'] = id;
    data['amount'] = amount;
    data['currency'] = currency;
    data['ibanNumber'] = ibanNumber;
    data['ibanOwnerName'] = ibanOwnerName;
    data['issueDate'] = issueDate;
    data['issueDateDescription'] = issueDateDescription;
    data['status'] = status;
    data['statusDescription'] = statusDescription;
    data['cancelable'] = cancelable;
    data['suspendable'] = suspendable;
    data['changeable'] = changeable;
    data['description'] = description;
    return data;
  }

  final String sourceIbanNumber;
  final bool resumable;
  final String referenceId;
  final String id;
  final int amount;
  final String currency;
  final String ibanNumber;
  final String ibanOwnerName;
  final String issueDate;
  final String issueDateDescription;
  final String status;
  final String statusDescription;
  final bool cancelable;
  final bool suspendable;
  final bool changeable;
  final String description;
}

class SatnaReportResponse extends ResponseBase {
  SatnaReportResponse({
    @required this.isValidToken,
    @required this.satnaReport,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  SatnaReportResponse.fromJson(Map<String, dynamic> json)
      : this(
          isValidToken: json['isValidToken'],
          satnaReport: SatnaReport.fromJson(json['satnaReport']),
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final bool isValidToken;
  final SatnaReport satnaReport;
}

class SatnaReport {
  SatnaReport({@required this.transferReport});

  factory SatnaReport.fromJson(Map<String, dynamic> json) {
    final transferReport = <TransferReport>[];
    if (json['transfer_report'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['transfer_report'])
          .map((v) => TransferReport.fromJson(v));
      transferReport.addAll(tmp);
    }
    return SatnaReport(
      transferReport: transferReport,
    );
  }

  final List<TransferReport> transferReport;
}

class TransferReport {
  TransferReport({
    @required this.serial,
    @required this.destinationDepositNumber,
    @required this.destinationBank,
    @required this.amount,
    @required this.sourceDepositNumber,
    @required this.status,
    @required this.statusDescription,
    @required this.systemCode,
    @required this.registerDate,
    @required this.registerDatePersian,
  });

  TransferReport.fromJson(Map<String, dynamic> json)
      : this(
          serial: json['serial'],
          destinationDepositNumber: json['destination_deposit_number'],
          destinationBank: json['destination_bank'] != null
              ? DestinationBank.fromJson(json['destination_bank'])
              : null,
          amount: json['amount'],
          sourceDepositNumber: json['source_deposit_number'],
          status: json['status'],
          statusDescription: json['statusDescription'],
          systemCode: json['system_code'],
          registerDate: json['register_date'],
          registerDatePersian: json['registerDatePersian'],
        );

  final String serial;
  final String destinationDepositNumber;
  final DestinationBank destinationBank;
  final int amount;
  final String sourceDepositNumber;
  final String status;
  final String statusDescription;
  final String systemCode;
  final String registerDate;
  final String registerDatePersian;
}

class DestinationBank {
  DestinationBank({@required this.code, @required this.name});

  DestinationBank.fromJson(Map<String, dynamic> json)
      : this(
          code: json['code'],
          name: json['name'],
        );

  final int code;
  final String name;
}

class StatementReportResponse extends ResponseBase {
  StatementReportResponse({
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

  factory StatementReportResponse.fromJson(Map<String, dynamic> json) {
    final statements = <Statements>[];
    if (json['statements'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['statements'])
          .map((v) => Statements.fromJson(v));
      statements.addAll(tmp);
    }
    return StatementReportResponse(
      statements: statements,
      isValidToken: json['isValidToken'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['isValidToken'] = isValidToken;
    data['statements'] = statements.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final bool isValidToken;
  final List<Statements> statements;
}

class Statements {
  Statements({
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

  Statements.fromJson(Map<String, dynamic> json)
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
    final Map<String, dynamic> data = {};
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

  final String serialNumber;
  final String date;
  final String datePersian;
  final String description;
  final int balance;
  final int statementSerial;
  final String branchCode;
  final String branchName;
  final String agentBranchCode;
  final String agentBranchName;
  final int transferAmount;
  final String referenceNumber;
  final String statementId;
}
