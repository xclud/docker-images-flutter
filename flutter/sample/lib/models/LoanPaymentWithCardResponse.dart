import 'package:novinpay/repository/response.dart';

class LoanPaymentWithCardResponse extends ResponseBase {
  LoanPaymentWithCardResponse({
    @required this.paymentDate,
    @required this.switchResponseRrn,
    @required this.trackingNumber,
    @required this.loanStates,
    @required this.ledgerBalance,
    @required this.currency,
    @required this.sourcePan,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  LoanPaymentWithCardResponse.fromJson(Map<String, dynamic> json)
      : this(
          paymentDate: json['paymentDate'],
          switchResponseRrn: json['switchResponseRrn'],
          trackingNumber: json['trackingNumber'],
          loanStates: json['loanStates'],
          ledgerBalance: json['ledgerBalance'],
          currency: json['currency'],
          sourcePan: json['sourcePan'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['paymentDate'] = paymentDate;
    data['switchResponseRrn'] = switchResponseRrn;
    data['trackingNumber'] = trackingNumber;
    data['loanStates'] = loanStates;
    data['ledgerBalance'] = ledgerBalance;
    data['currency'] = currency;
    data['sourcePan'] = sourcePan;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final String paymentDate;
  final String switchResponseRrn;
  final String trackingNumber;
  final double loanStates;
  final double ledgerBalance;
  final String currency;
  final String sourcePan;
}
