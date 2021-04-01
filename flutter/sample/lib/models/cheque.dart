import 'package:novinpay/sun.dart';

class BackChequesResponse extends ResponseBase {
  BackChequesResponse({
    @required this.result,
    @required this.serviceStatus,
    @required this.trackId,
    @required this.error,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory BackChequesResponse.fromJson(Map<String, dynamic> json) {
    return BackChequesResponse(
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
      serviceStatus: json['serviceStatus'],
      trackId: json['trackId'],
      error: json['error'] != null ? Error.fromJson(json['error']) : null,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (result != null) {
      data['result'] = result.toJson();
    }

    data['serviceStatus'] = serviceStatus;
    data['trackId'] = trackId;
    if (error != null) {
      data['error'] = error.toJson();
    }

    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final Result result;
  final String serviceStatus;
  final String trackId;
  final Error error;
}

class Result {
  Result({
    @required this.cheques,
    @required this.nid,
    @required this.name,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    final List<ChequeItem> cheques = [];

    if (json['chequeList'] != null) {
      final tmp =
          List.from(json['chequeList']).map((v) => ChequeItem.fromJson(v));

      cheques.addAll(tmp);
    }

    final String nid = json['nid'];
    final String name = json['name'];

    return Result(cheques: cheques, nid: nid, name: name);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['chequeList'] = cheques.map((v) => v.toJson()).toList();
    data['nid'] = nid;
    data['name'] = name;
    return data;
  }

  final List<ChequeItem> cheques;
  final String nid;
  final String name;
}

class ChequeItem {
  ChequeItem({
    @required this.accountNumber,
    @required this.amount,
    @required this.backDate,
    @required this.bankCode,
    @required this.branchCode,
    @required this.branchDescription,
    @required this.date,
    @required this.id,
    @required this.number,
  });

  ChequeItem.fromJson(Map<String, dynamic> json)
      : this(
          accountNumber: json['accountNumber'],
          amount: json['amount'],
          backDate: json['backDate'],
          bankCode: json['bankCode'],
          branchCode: json['branchCode'],
          branchDescription: json['branchDescription'],
          date: json['date'],
          id: json['id'],
          number: json['number'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['accountNumber'] = accountNumber;
    data['amount'] = amount;
    data['backDate'] = backDate;
    data['bankCode'] = bankCode;
    data['branchCode'] = branchCode;
    data['branchDescription'] = branchDescription;
    data['date'] = date;
    data['id'] = id;
    data['number'] = number;
    return data;
  }

  final String accountNumber;
  final int amount;
  final int backDate;
  final int bankCode;
  final String branchCode;
  final String branchDescription;
  final int date;
  final String id;
  final String number;
}

class Error {
  Error({@required this.code, @required this.message});

  Error.fromJson(Map<String, dynamic> json)
      : this(code: json['code'], message: json['message']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    data['message'] = message;
    return data;
  }

  final String code;
  final String message;
}
