import 'package:novinpay/repository/response.dart';

class PayaTransferResponse extends ResponseBase {
  PayaTransferResponse({
    @required this.isValidToken,
    @required this.referenceId,
    @required this.sourceIbanNumber,
    @required this.currency,
    @required this.transferStatus,
    @required this.ibanNumber,
    @required this.ownerName,
    @required this.amount,
    @required this.transactionStatus,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  PayaTransferResponse.fromJson(Map<String, dynamic> json)
      : this(
          isValidToken: json['isValidToken'],
          referenceId: json['referenceId'],
          sourceIbanNumber: json['sourceIbanNumber'],
          currency: json['currency'],
          transferStatus: json['transferStatus'],
          ibanNumber: json['ibanNumber'],
          ownerName: json['ownerName'],
          amount: json['amount'],
          transactionStatus: json['transactionStatus'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isValidToken'] = isValidToken;
    data['referenceId'] = referenceId;
    data['sourceIbanNumber'] = sourceIbanNumber;
    data['currency'] = currency;
    data['transferStatus'] = transferStatus;
    data['ibanNumber'] = ibanNumber;
    data['ownerName'] = ownerName;
    data['amount'] = amount;
    data['transactionStatus'] = transactionStatus;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final bool isValidToken;
  final String referenceId;
  final String sourceIbanNumber;
  final String currency;
  final String transferStatus;
  final String ibanNumber;
  final String ownerName;
  final double amount;
  final String transactionStatus;
}
