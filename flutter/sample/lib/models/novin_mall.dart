import 'package:novinpay/repository/response.dart';

class GetUrlResponse extends ResponseBase {
  GetUrlResponse({
    @required this.novinMallUrl,
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

  GetUrlResponse.fromJson(Map<String, dynamic> json)
      : this(
            novinMallUrl: json['novinMallUrl'],
            status: json['status'],
            description: json['description'],
            mobileNumber: json['mobileNumber'],
            errorMessage: json['errorMessage']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['novinMallUrl'] = novinMallUrl;
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final String novinMallUrl;
}
