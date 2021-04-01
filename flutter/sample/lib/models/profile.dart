import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class LoginResponse extends ResponseBase {
  LoginResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  LoginResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class ActiveLoginResponse extends ResponseBase {
  ActiveLoginResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  ActiveLoginResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class DeActiveLoginResponse extends ResponseBase {
  DeActiveLoginResponse({
    bool status,
    String description,
    String mobileNumber,
    String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  DeActiveLoginResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class ChangePasswordResponse extends ResponseBase {
  ChangePasswordResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  ChangePasswordResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class ForgetPassWordResponse extends ResponseBase {
  ForgetPassWordResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  ForgetPassWordResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

enum LoginType {
  none,
  password,
  fingerprint,
  face,
}
