import 'package:novinpay/repository/response.dart';

class GetTransactionListResponse extends ResponseBase {
  GetTransactionListResponse({
    @required this.totalCount,
    @required this.transactions,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetTransactionListResponse.fromJson(Map<String, dynamic> json) {
    var transactions = <Transactions>[];
    if (json.containsKey('transactions')) {
      final dc = List<Map<String, dynamic>>.from(json['transactions']);
      transactions = dc.map((e) => Transactions.fromJson(e)).toList();
    }
    return GetTransactionListResponse(
      transactions: transactions,
      totalCount: json['totalCount'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['totalCount'] = totalCount;
    data['transactions'] = transactions.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  int totalCount;
  List<Transactions> transactions;
}

class Transactions {
  Transactions({
    @required this.transactionDate,
    @required this.shamsiDate,
    @required this.terminalId,
    @required this.merchantId,
    @required this.panMasked,
    @required this.rrn,
    @required this.trace,
    @required this.amount,
    @required this.processCode,
    @required this.procesType,
    @required this.responseCode,
    @required this.status,
    @required this.statusDescription,
    @required this.additionalInfo,
    @required this.pan,
  });

  Transactions.fromJson(Map<String, dynamic> json)
      : this(
          transactionDate: json['transactionDate'],
          shamsiDate: json['shamsiDate'],
          terminalId: json['terminalId'],
          merchantId: json['merchantId'],
          panMasked: json['panMasked'],
          rrn: json['rrn'],
          trace: json['trace'],
          amount: int.parse(json['amount']),
          processCode: json['processCode'],
          procesType: json['procesType'],
          responseCode: json['responseCode'],
          status: json['status'],
          statusDescription: json['statusDescription'],
          additionalInfo: json['additionalInfo'],
          pan: json['pan'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['transactionDate'] = transactionDate;
    data['shamsiDate'] = shamsiDate;
    data['terminalId'] = terminalId;
    data['merchantId'] = merchantId;
    data['panMasked'] = panMasked;
    data['rrn'] = rrn;
    data['trace'] = trace;
    data['amount'] = '$amount';
    data['processCode'] = processCode;
    data['procesType'] = procesType;
    data['responseCode'] = responseCode;
    data['status'] = status;
    data['statusDescription'] = statusDescription;
    data['additionalInfo'] = additionalInfo;
    data['pan'] = pan;
    return data;
  }

  final String transactionDate;
  final String shamsiDate;
  final String terminalId;
  final String merchantId;
  final String panMasked;
  final String rrn;
  final String trace;
  final int amount;
  final String processCode;
  final String procesType;
  final String responseCode;
  final String status;
  final String statusDescription;
  final String additionalInfo;
  final String pan;
}
