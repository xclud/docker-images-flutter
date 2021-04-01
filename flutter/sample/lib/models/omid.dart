import 'package:novinpay/repository/response.dart';

class GetOmidMerchantsResponse extends ResponseBase {
  GetOmidMerchantsResponse({
    @required this.merchants,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetOmidMerchantsResponse.fromJson(Map<String, dynamic> json) {
    final merchants = <Merchant>[];
    if (json['merchantList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['merchantList'])
          .map((v) => Merchant.fromJson(v));

      merchants.addAll(tmp);
    }

    return GetOmidMerchantsResponse(
      merchants: merchants,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final List<Merchant> merchants;
}

class Merchant {
  Merchant({
    @required this.discountPercent,
    @required this.workTitle,
    @required this.city,
    @required this.stateName,
    @required this.guild,
    @required this.address,
    @required this.phoneNumber,
  });

  Merchant.fromJson(Map<String, dynamic> json)
      : this(
          discountPercent: json['discountPercent'],
          workTitle: json['workTitle'],
          city: json['city'],
          stateName: json['stateName'],
          guild: json['guild'],
          address: json['shaparakAddressText'],
          phoneNumber: json['phoneNumber'],
        );
  final num discountPercent;
  final String workTitle;
  final String city;
  final String stateName;
  final String guild;
  final String address;
  final String phoneNumber;
}
