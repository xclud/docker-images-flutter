import 'package:novinpay/repository/response.dart';

class BillReportResponse extends ResponseBase {
  BillReportResponse({
    @required this.data,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory BillReportResponse.fromJson(Map<String, dynamic> json) {
    final data = <Data>[];
    if (json['data'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['data'])
          .map((v) => Data.fromJson(v));
      data.addAll(tmp);
    }

    return BillReportResponse(
      data: data,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final List<Data> data;
}

class Data {
  Data({
    @required this.pan,
    @required this.billDate,
    @required this.billId,
    @required this.paymentId,
    @required this.amount,
    @required this.mobileNumber,
    @required this.rrn,
    @required this.source,
    @required this.serviceName,
    @required this.status,
  });

  Data.fromJson(Map<String, dynamic> json)
      : this(
          pan: json['pan'],
          billDate: json['billDate'],
          billId: json['billId'],
          paymentId: json['paymentId'],
          amount: int.tryParse(json['amount'] ?? '') ?? 0,
          mobileNumber: json['mobileNumber'],
          rrn: json['rrn'],
          source: json['source'],
          serviceName: json['serviceName'],
          status: json['status'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pan'] = pan;
    data['billDate'] = billDate;
    data['billId'] = billId;
    data['paymentId'] = paymentId;
    data['amount'] = '$amount';
    data['mobileNumber'] = mobileNumber;
    data['rrn'] = rrn;
    data['source'] = source;
    data['serviceName'] = serviceName;
    data['status'] = status;
    return data;
  }

  final String pan;
  final String billDate;
  final String billId;
  final String paymentId;
  final int amount;
  final String mobileNumber;
  final String rrn;
  final String source;
  final String serviceName;
  final String status;
}
