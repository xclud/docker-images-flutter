import 'package:novinpay/repository/response.dart';

class BillPaymentResponse extends ResponseBase {
  BillPaymentResponse({
    @required this.stan,
    @required this.traceNumber,
    @required this.rrn,
    @required this.amount,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  BillPaymentResponse.fromJson(Map<String, dynamic> json)
      : this(
          stan: json['stan'],
          traceNumber: json['traceNumber'],
          rrn: json['rrn'],
          amount: json['amount'],
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
    data['traceNumber'] = traceNumber;
    data['rrn'] = rrn;
    data['amount'] = amount;
    data['description'] = description;
    return data;
  }

  final String stan;
  final String traceNumber;
  final String rrn;
  final String amount;
}
