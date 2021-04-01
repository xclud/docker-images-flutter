import 'package:novinpay/repository/response.dart';

class ExchangeRateResponse extends ResponseBase {
  ExchangeRateResponse({
    @required this.moneyRates,
    @required this.chequeRate,
    @required this.updateDateTime,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    final moneyRates = <MoneyRates>[];
    if (json['moneyRates'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['moneyRates'])
          .map((e) => MoneyRates.fromJson(e))
          .toList();
      moneyRates.addAll(tmp);
    }
    final chequeRate = <MoneyRates>[];
    if (json['chequeRates'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['chequeRates'])
          .map((e) => MoneyRates.fromJson(e))
          .toList();
      chequeRate.addAll(tmp);
    }

    return ExchangeRateResponse(
      moneyRates: moneyRates,
      chequeRate: chequeRate,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      updateDateTime: json['updateDateTime'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['updateDateTime'] = updateDateTime;
    data['moneyRates'] = moneyRates.map((e) => e.toJson()).toList();
    data['chequeRates'] = chequeRate.map((e) => e.toJson()).toList();
    return data;
  }

  final List<MoneyRates> moneyRates;
  final List<MoneyRates> chequeRate;
  final String updateDateTime;
}

class MoneyRates {
  MoneyRates({
    @required this.title,
    @required this.buy,
    @required this.sale,
    @required this.imageUrl,
  });

  factory MoneyRates.fromJson(Map<String, dynamic> json) {
    return MoneyRates(
        title: json['title'],
        buy: json['buy'],
        sale: json['sale'],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['buy'] = buy;
    data['sale'] = sale;
    data['imageUrl'] = imageUrl;
    return data;
  }

  final String title;
  final int buy;
  final int sale;
  final String imageUrl;
}

class ChequeRate {
  ChequeRate({
    @required this.title,
    @required this.buy,
    @required this.sale,
    @required this.imageUrl,
  });

  factory ChequeRate.fromJson(Map<String, dynamic> json) {
    return ChequeRate(
        title: json['title'],
        buy: json['buy'],
        sale: json['sale'],
        imageUrl: json['imageUrl']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    data['buy'] = buy;
    data['sale'] = sale;
    data['imageUrl'] = imageUrl;
    return data;
  }

  final String title;
  final int buy;
  final int sale;
  final String imageUrl;
}
