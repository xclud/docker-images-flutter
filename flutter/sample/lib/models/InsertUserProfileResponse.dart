import 'package:novinpay/repository/response.dart';

class InsertUserProfileResponse extends ResponseBase {
  InsertUserProfileResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
          status: status,
          description: description,
          mobileNumber: mobileNumber,
          errorMessage: errorMessage,
        );

  InsertUserProfileResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
