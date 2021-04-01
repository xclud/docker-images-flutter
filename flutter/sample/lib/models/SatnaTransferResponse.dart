import 'package:novinpay/repository/response.dart';

class SatnaTransferResponse extends ResponseBase {
  SatnaTransferResponse({
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

  SatnaTransferResponse.fromJson(Map<String, dynamic> json)
      : this(
          isValidToken: json['isValidToken'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isValidToken'] = isValidToken;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final bool isValidToken;
}
