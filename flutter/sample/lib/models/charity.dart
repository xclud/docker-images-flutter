import 'package:novinpay/repository/response.dart';

class CharityInfoResponse extends ResponseBase {
  CharityInfoResponse({
    @required this.charityInfoList,
    @required this.charityTransactions,
    @required this.lastTransaction,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory CharityInfoResponse.fromJson(Map<String, dynamic> json) {
    final charityInfoListData = <CharityInfoList>[];
    final charityTransactionsListData = <CharityTransactionsList>[];

    if (json['charityInfoList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['charityInfoList'])
          .map((v) => CharityInfoList.fromJson(v));
      charityInfoListData.addAll(tmp);
    }
    if (json['charityTransactions'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['charityTransactions'])
          .map((v) => CharityTransactionsList.fromJson(v));
      charityTransactionsListData.addAll(tmp);
    }

    return CharityInfoResponse(
      charityInfoList: charityInfoListData,
      charityTransactions: charityTransactionsListData,
      lastTransaction: LastTransaction.fromJson(json['lastTransaction']),
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final List<CharityInfoList> charityInfoList;
  final List<CharityTransactionsList> charityTransactions;
  final LastTransaction lastTransaction;
}

class CharityInfoList {
  CharityInfoList({
    @required this.id,
    @required this.charityServiceId,
    @required this.charityName,
    @required this.description,
    @required this.website,
    @required this.phoneNumber,
  });

  CharityInfoList.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          charityServiceId: json['charityServiceId'],
          charityName: json['charityName'],
          description: json['description'],
          website: json['website'],
          phoneNumber: json['phoneNumber'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['charityServiceId'] = charityServiceId;
    data['charityName'] = charityName;
    data['description'] = description;
    data['website'] = website;
    data['phoneNumber'] = phoneNumber;
    return data;
  }

  final int id;
  final String charityServiceId;
  final String charityName;
  final String description;
  final String website;
  final String phoneNumber;
}

class CharityTransactionsList {
  CharityTransactionsList({
    @required this.charityName,
    @required this.description,
    @required this.totalAmount,
    @required this.countOfTrx,
  });

  CharityTransactionsList.fromJson(Map<String, dynamic> json)
      : this(
          charityName: json['charityName'],
          description: json['description'],
          totalAmount: json['totalAmount'],
          countOfTrx: json['countOfTrx'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['charityName'] = charityName;
    data['description'] = description;
    data['totalAmount'] = totalAmount;
    data['countOfTrx'] = countOfTrx;
    return data;
  }

  final String charityName;
  final String description;
  final String totalAmount;
  final String countOfTrx;
}

class LastTransaction {
  LastTransaction({
    @required this.charityName,
    @required this.description,
    @required this.insertDateTime,
    @required this.amount,
  });

  LastTransaction.fromJson(Map<String, dynamic> json)
      : this(
          charityName: json['charityName'],
          description: json['description'],
          insertDateTime: json['insertDateTime'],
          amount: json['amount'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['charityName'] = charityName;
    data['description'] = description;
    data['insertDateTime'] = insertDateTime;
    data['amount'] = amount;
    return data;
  }

  final String charityName;
  final String description;
  final String insertDateTime;
  final int amount;
}

class CharityPaymentResponse extends ResponseBase {
  CharityPaymentResponse({
    @required this.stan,
    @required this.rrn,
    @required this.amount,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
          status: status,
          description: description,
          mobileNumber: mobileNumber,
          errorMessage: errorMessage,
        );

  CharityPaymentResponse.fromJson(Map<String, dynamic> json)
      : this(
          stan: json['stan'],
          rrn: json['rrn'],
          amount: json['amount'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final String stan;
  final String rrn;
  final String amount;
}
