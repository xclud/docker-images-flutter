import 'package:novinpay/repository/response.dart';

class OpeningDepositResponse extends ResponseBase {
  OpeningDepositResponse({
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

  OpeningDepositResponse.fromJson(Map<String, dynamic> json)
      : this(
            depositNumber: json['depositNumber'],
            isValidToken: json['isValidToken'],
            status: json['status'],
            description: json['description'],
            mobileNumber: json['mobileNumber'],
            errorMessage: json['errorMessage']);

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

  final String depositNumber;
  final bool isValidToken;
}
