import 'package:novinpay/repository/response.dart';

class AddDiplomatCardResponse extends ResponseBase {
  AddDiplomatCardResponse({
    @required this.cardHolder,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory AddDiplomatCardResponse.fromJson(Map<String, dynamic> json) {
    return AddDiplomatCardResponse(
      cardHolder: json['cardHolder'],
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final String cardHolder;
}

class RemoveDiplomatCardResponse extends ResponseBase {
  RemoveDiplomatCardResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory RemoveDiplomatCardResponse.fromJson(Map<String, dynamic> json) {
    return RemoveDiplomatCardResponse(
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }
}

class GetDiplomatCardsResponse extends ResponseBase {
  GetDiplomatCardsResponse({
    @required this.cards,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetDiplomatCardsResponse.fromJson(Map<String, dynamic> json) {
    final cards = <DiplomatCardInfo>[];

    if (json['diplomatCards'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['diplomatCards'])
          .map((v) => DiplomatCardInfo.fromJson(v));

      cards.addAll(tmp);
    }

    return GetDiplomatCardsResponse(
      cards: cards,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final List<DiplomatCardInfo> cards;
}

class DiplomatCardTransactionsResponse extends ResponseBase {
  DiplomatCardTransactionsResponse({
    @required this.transactions,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory DiplomatCardTransactionsResponse.fromJson(Map<String, dynamic> json) {
    final transactions = <TransactionInfo>[];

    if (json['transactions'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['transactions'])
          .map((v) => TransactionInfo.fromJson(v));

      transactions.addAll(tmp);
    }

    return DiplomatCardTransactionsResponse(
      transactions: transactions,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final List<TransactionInfo> transactions;
}

class DiplomatCardInfo {
  DiplomatCardInfo({
    @required this.id,
    @required this.panMasked,
    @required this.expDate,
    @required this.cardHolder,
    @required this.points,
  });

  factory DiplomatCardInfo.fromJson(Map<String, dynamic> json) {
    return DiplomatCardInfo(
      id: json['id'],
      panMasked: json['panMasked'],
      expDate: json['expDate'],
      cardHolder: json['cardHolder'],
      points: json['point'],
    );
  }

  final int id;
  final String panMasked;
  final String expDate;
  final String cardHolder;
  final int points;
}

class TransactionInfo {
  TransactionInfo({
    @required this.rrn,
    @required this.amount,
    @required this.terminalId,
    @required this.merchantId,
    @required this.panMasked,
    @required this.transactionShamsiDateTime,
    @required this.transactionMiladiDateTime,
    @required this.fullname,
    @required this.storeName,
    @required this.clubPoint,
  });

  factory TransactionInfo.fromJson(Map<String, dynamic> json) {
    return TransactionInfo(
      rrn: json['rrn'],
      amount: int.tryParse(json['amount'] ?? '') ?? 0,
      terminalId: json['terminalId'],
      merchantId: json['merchantId'],
      panMasked: json['panMasked'],
      transactionShamsiDateTime: json['transactionShamsiDateTime'],
      transactionMiladiDateTime: json['transactionMiladiDateTime'],
      fullname: json['fullname'],
      storeName: json['storeName'],
      clubPoint: json['clubPoint'],
    );
  }

  final String rrn;
  final int amount;
  final String terminalId;
  final String merchantId;
  final String panMasked;
  final String transactionShamsiDateTime;
  final String transactionMiladiDateTime;
  final String fullname;
  final String storeName;
  final String clubPoint;
}
