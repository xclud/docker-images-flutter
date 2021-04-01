import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class LoginModel {
  LoginModel(
      {@required this.loginEnable,
      @required this.loginType,
      @required this.loginIsExpire});

  LoginModel.fromJson(Map<String, dynamic> json)
      : this(
          loginEnable: json['loginEnable'],
          loginType: json['loginType'],
          loginIsExpire: json['loginIsExpire'],
        );
  final bool loginEnable;
  final int loginType;
  final bool loginIsExpire;
}

class GetRecommenderStateResponse extends ResponseBase {
  final bool useRecommender;

  GetRecommenderStateResponse({
    @required this.useRecommender,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetRecommenderStateResponse.fromJson(Map<String, dynamic> json) {
    return GetRecommenderStateResponse(
      useRecommender: json['useRecommender'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }
}

class CheckVersionResponse extends ResponseBase {
  CheckVersionResponse({
    @required this.versionNumber,
    @required this.supportedBins,
    @required this.isForced,
    @required this.link,
    @required this.novinMalUrl,
    @required this.loginModel,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory CheckVersionResponse.fromJson(Map<String, dynamic> json) {
    final supportedBins = <String>[];
    final obj = json['supportedBins'];

    if (obj != null) {
      if (obj is String) {
        final tmp = obj.split(',').map((e) => e.trim()).toList();
        supportedBins.addAll(tmp);
      } else if (obj is Iterable) {
        final tmp = List<String>.from(obj).toList();
        supportedBins.addAll(tmp);
      }
    }
    return CheckVersionResponse(
      versionNumber: json['versionNumber'],
      supportedBins: supportedBins,
      isForced: json['isForced'],
      link: json['link'],
      novinMalUrl: json['novinMalUrl'],
      status: json['status'],
      loginModel: LoginModel.fromJson(json['loginModel']),
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final String versionNumber;
  final List<String> supportedBins;
  final bool isForced;
  final String link;
  final String novinMalUrl;
  final LoginModel loginModel;
}
