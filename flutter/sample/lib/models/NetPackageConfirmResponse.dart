import 'package:novinpay/repository/response.dart';

class NetPackageConfirmResponse extends ResponseBase {
  NetPackageConfirmResponse({
    @required this.stan,
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

  NetPackageConfirmResponse.fromJson(Map<String, dynamic> json)
      : this(
          stan: json['stan'],
          rrn: json['rrn'],
          amount: json['amount'],
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
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final String stan;
  final String rrn;
  final String amount;
}
