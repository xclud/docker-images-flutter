import 'package:novinpay/repository/response.dart';

class IbanValidationResponse extends ResponseBase {
  IbanValidationResponse({
    @required this.ibanOwnerName,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  IbanValidationResponse.fromJson(Map<String, dynamic> json)
      : this(
          ibanOwnerName: json['ibanOwnerName'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ibanOwnerName'] = ibanOwnerName;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final String ibanOwnerName;
}
