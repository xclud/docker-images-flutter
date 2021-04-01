import 'package:latlng/latlng.dart';
import 'package:novinpay/repository/response.dart';

class GetUserProfileResponse extends ResponseBase {
  GetUserProfileResponse({
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    @required this.nationalNumber,
    @required this.birthDate,
    @required this.location,
    @required this.score,
    @required this.birthCityId,
    @required this.addressCityId,
    @required this.address,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetUserProfileResponse.fromJson(Map<String, dynamic> json) {
    LatLng location;
    if (json['latitude'] != null && json['longitude'] != null) {
      location = LatLng(
        double.tryParse(json['latitude'].toString()),
        double.tryParse(
          json['longitude'].toString(),
        ),
      );
    }

    return GetUserProfileResponse(
      firstName: json['name'],
      lastName: json['family'],
      email: json['email'],
      nationalNumber: json['nationalCode'],
      birthDate: json['birthDate'],
      location: location,
      birthCityId: json['birthCityId'],
      addressCityId: json['addressCityId'],
      address: json['address'],
      score: json['score'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['name'] = firstName;
    data['family'] = lastName;
    data['email'] = email;
    data['birthDate'] = birthDate;
    data['score'] = score;
    return data;
  }

  final String firstName;
  final String lastName;
  final String email;
  final String nationalNumber;
  final String birthDate;
  final LatLng location;
  final int birthCityId;
  final int addressCityId;
  final String address;
  final int score;
}
