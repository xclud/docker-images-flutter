import 'package:novinpay/repository/response.dart';

class NormalTransferResponse extends ResponseBase {
  NormalTransferResponse({
    @required this.isValidToken,
    @required this.trackingCode,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  NormalTransferResponse.fromJson(Map<String, dynamic> json)
      : this(
          isValidToken: json['isValidToken'],
          trackingCode: json['trackingCode'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['isValidToken'] = isValidToken;
    data['trackingCode'] = trackingCode;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final bool isValidToken;
  final String trackingCode;
}
