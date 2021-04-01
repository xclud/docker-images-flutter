import 'package:novinpay/repository/response.dart';

class TransactionReportResponse extends ResponseBase {
  TransactionReportResponse({
    @required this.transactionsData,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory TransactionReportResponse.fromJson(Map<String, dynamic> json) {
    final data = <TransactionData>[];
    if (json['transactions'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['transactions'])
          .map((v) => TransactionData.fromJson(v));
      data.addAll(tmp);
    }

    return TransactionReportResponse(
      transactionsData: data,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['transactions'] = transactionsData.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final List<TransactionData> transactionsData;
}

class TransactionData {
  TransactionData({
    @required this.transactionType,
    @required this.insertDateTime,
    @required this.mobileNumber,
    @required this.amount,
    @required this.rrn,
    @required this.source,
    @required this.serviceName,
    @required this.status,
    @required this.description,
    @required this.pan,
    @required this.destinationPan,
    @required this.billId,
    @required this.paymentId,
    @required this.billTypeId,
    @required this.toChargeNumber,
    @required this.requestType,
    @required this.transferDescription,
    @required this.cardHolder,
  });

  TransactionData.fromJson(Map<String, dynamic> json)
      : this(
          transactionType: json['transactionType'],
          insertDateTime: json['insertDateTime'],
          mobileNumber: json['mobileNumber'],
          amount: json['amount'],
          rrn: json['rrn'],
          source: json['source'],
          serviceName: json['serviceName'],
          status: json['status'],
          description: json['description'],
          pan: json['pan'],
          destinationPan: json['destinationPan'],
          billId: json['billId'],
          paymentId: json['paymentId'],
          billTypeId: json['billTypeId'],
          toChargeNumber: json['toChargeNumber'],
          requestType: json['requestType'],
          transferDescription: json['transferDescription'],
          cardHolder: json['cardHolder'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionType'] = transactionType;
    data['insertDateTime'] = insertDateTime;
    data['mobileNumber'] = mobileNumber;
    data['amount'] = amount;
    data['rrn'] = rrn;
    data['source'] = source;
    data['serviceName'] = serviceName;
    data['status'] = status;
    data['description'] = description;
    data['pan'] = pan;
    data['destinationPan'] = destinationPan;
    data['billId'] = billId;
    data['paymentId'] = paymentId;
    data['billTypeId'] = billTypeId;
    data['toChargeNumber'] = toChargeNumber;
    data['requestType'] = requestType;
    return data;
  }

  final int transactionType;
  final String insertDateTime;
  final String mobileNumber;
  final int amount;
  final String rrn;
  final String source;
  final String serviceName;
  final bool status;
  final String description;
  final String pan;
  final String destinationPan;
  final String billId;
  final String paymentId;
  final int billTypeId;
  final String toChargeNumber;
  final String requestType;
  final String transferDescription;
  final String cardHolder;
}
