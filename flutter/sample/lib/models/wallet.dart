import 'dart:convert';

import 'package:novinpay/repository/response.dart';

class WalletBillPaymentResponse extends ResponseBase {
  WalletBillPaymentResponse({
    @required this.balance,
    @required this.rrn,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletBillPaymentResponse.fromJson(Map<String, dynamic> json)
      : this(
          balance: json['ewalletBalance'],
          rrn: json['rrn'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ewalletBalance'] = balance;
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

  final int balance;
  final String rrn;
}

class WalletTopupChargeResponse extends ResponseBase {
  WalletTopupChargeResponse({
    @required this.balance,
    @required this.amount,
    @required this.referenceNumber,
    @required this.reserveNumber,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletTopupChargeResponse.fromJson(Map<String, dynamic> json)
      : this(
          balance: json['ewalletBalance'],
          amount: num.tryParse(json['chargeAmount'] ?? '') ?? 0,
          referenceNumber: json['referenceNumber'],
          reserveNumber: json['reserveNumber'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ewalletBalance'] = balance;
    data['chargeAmount'] = amount;
    data['referenceNumber'] = referenceNumber;
    data['reserveNumber'] = reserveNumber;
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

  final num balance;
  final num amount;
  final int referenceNumber;
  final int reserveNumber;
}

class WalletPinChargeResponse extends ResponseBase {
  WalletPinChargeResponse({
    @required this.balance,
    @required this.amount,
    @required this.referenceNumber,
    @required this.reserveNumber,
    @required this.chargeSerial,
    @required this.chargePin,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletPinChargeResponse.fromJson(Map<String, dynamic> json)
      : this(
          balance: json['ewalletBalance'],
          amount: json['chargeAmount'],
          referenceNumber: json['referenceNumber'],
          reserveNumber: json['reserveNumber'],
          chargeSerial: json['chargeSerial'],
          chargePin: json['chargePin'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ewalletBalance'] = balance;
    data['chargeAmount'] = amount;
    data['referenceNumber'] = referenceNumber;
    data['reserveNumber'] = reserveNumber;
    data['chargeSerial'] = chargeSerial;
    data['chargePin'] = chargePin;
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

  final int balance;
  final String amount;
  final int referenceNumber;
  final int reserveNumber;
  final String chargeSerial;
  final String chargePin;
}

class WalletInternetPackageResponse extends ResponseBase {
  WalletInternetPackageResponse({
    @required this.balance,
    @required this.referenceNumber,
    @required this.reserveNumber,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletInternetPackageResponse.fromJson(Map<String, dynamic> json)
      : this(
          balance: json['ewalletBalance'],
          referenceNumber: json['referenceNumber'],
          reserveNumber: json['reserveNumber'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ewalletBalance'] = balance;
    data['referenceNumber'] = referenceNumber;
    data['reserveNumber'] = reserveNumber;
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

  final int balance;
  final int referenceNumber;
  final int reserveNumber;
}

class WalletActivateResponse extends ResponseBase {
  WalletActivateResponse({
    @required this.mobileId,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletActivateResponse.fromJson(Map<String, dynamic> json)
      : this(
          mobileId: json['mobileId'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['mobileId'] = mobileId;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }

  final String mobileId;
}

class WalletGetBalanceResponse extends ResponseBase {
  WalletGetBalanceResponse({
    @required this.balance,
    @required this.currency,
    @required this.isFloating,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletGetBalanceResponse.fromJson(Map<String, dynamic> json)
      : this(
          balance: json['balance'],
          currency: json['currency'],
          isFloating: json['isFloating'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['balance'] = balance;
    data['currency'] = currency;
    data['isFloating'] = isFloating;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }

  final num balance;
  final int currency;
  final bool isFloating;
}

class WalletChargeResponse extends ResponseBase {
  WalletChargeResponse({
    @required this.stan,
    @required this.traceNumber,
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
            errorMessage: errorMessage);

  WalletChargeResponse.fromJson(Map<String, dynamic> json)
      : this(
          stan: json['stan'],
          traceNumber: json['traceNumber'],
          rrn: json['rrn'],
          amount: json['amount'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['stan'] = stan;
    data['traceNumber'] = traceNumber;
    data['rrn'] = rrn;
    data['amount'] = amount;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }

  final String stan;
  final String traceNumber;
  final String rrn;
  final String amount;
}

class WalletTransferToWalletResponse extends ResponseBase {
  WalletTransferToWalletResponse({
    @required this.balance,
    @required this.rrn,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletTransferToWalletResponse.fromJson(Map<String, dynamic> json)
      : this(
          balance: json['balance'],
          rrn: json['rrn'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['balance'] = balance;
    data['rrn'] = rrn;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }

  final String balance;
  final String rrn;
}

class WalletTransferToIbanResponse extends ResponseBase {
  WalletTransferToIbanResponse({
    @required this.balance,
    @required this.rrn,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletTransferToIbanResponse.fromJson(Map<String, dynamic> json)
      : this(
          balance: json['balance'],
          rrn: json['rrn'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['balance'] = balance;
    data['rrn'] = rrn;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }

  final String balance;
  final String rrn;
}

class WalletGroupAddNewResponse extends ResponseBase {
  WalletGroupAddNewResponse({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletGroupAddNewResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }
}

class WalletGroupUpdateResponse extends ResponseBase {
  WalletGroupUpdateResponse({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletGroupUpdateResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }
}

class WalletGroupRemoveResponse extends ResponseBase {
  WalletGroupRemoveResponse({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletGroupRemoveResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }
}

class WalletGroupListResponse extends ResponseBase {
  WalletGroupListResponse({
    @required this.ewalletGroupList,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory WalletGroupListResponse.fromJson(Map<String, dynamic> json) {
    final groups = <WalletGroup>[];
    if (json['ewalletGroupList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['ewalletGroupList'])
          .map((e) => WalletGroup.fromJson(e))
          .toList();
      groups.addAll(tmp);
    }

    return WalletGroupListResponse(
      ewalletGroupList: groups,
      status: json['status'],
      mobileNumber: json['mobileNumber'],
      description: json['description'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    data['ewalletGroupList'] = ewalletGroupList.map((v) => v.toJson()).toList();

    return data;
  }

  final List<WalletGroup> ewalletGroupList;
}

class WalletGroup {
  WalletGroup({
    @required this.groupName,
    @required this.ewalletDescription,
    @required this.groupId,
    @required this.ewalletGroupUser,
  });

  factory WalletGroup.fromJson(Map<String, dynamic> json) {
    final users = <WalletUser>[];
    if (json['ewalletGroupUser'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['ewalletGroupUser'])
          .map((e) => WalletUser.fromJson(e))
          .toList();
      users.addAll(tmp);
    }

    return WalletGroup(
        groupName: json['groupName'],
        ewalletDescription: json['ewalletDescription'],
        groupId: json['groupId'],
        ewalletGroupUser: users);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['groupName'] = groupName;
    data['ewalletDescription'] = ewalletDescription;
    data['groupId'] = groupId;
    data['ewalletGroupUser'] = ewalletGroupUser.map((v) => v.toJson()).toList();

    return data;
  }

  final String groupName;
  final String ewalletDescription;
  final int groupId;
  final List<WalletUser> ewalletGroupUser;
}

class WalletUser {
  WalletUser({
    @required this.name,
    @required this.family,
    @required this.customerId,
  });

  WalletUser.fromJson(Map<String, dynamic> json)
      : this(
            name: json['name'],
            family: json['family'],
            customerId: json['customerId']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['family'] = family;
    data['customerId'] = customerId;
    return data;
  }

  final String name;
  final String family;
  final String customerId;
}

class WalletGroupUserAddNew extends ResponseBase {
  WalletGroupUserAddNew({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletGroupUserAddNew.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }
}

class WalletGroupUserUpdate extends ResponseBase {
  WalletGroupUserUpdate({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletGroupUserUpdate.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }
}

class WalletGroupUserRemove extends ResponseBase {
  WalletGroupUserRemove({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  WalletGroupUserRemove.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    data['description'] = description;
    return data;
  }
}

class WalletGroupUserChargeResponse extends ResponseBase {
  WalletGroupUserChargeResponse({
    @required this.walletGroupUserChargeData,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory WalletGroupUserChargeResponse.fromJson(Map<String, dynamic> json) {
    final data = <WalletGroupUserChargeData>[];
    if (json['ewalletGroupUserChargeResponse'] != null) {
      final tmp = List<Map<String, dynamic>>.from(
              json['ewalletGroupUserChargeResponse'])
          .map((v) => WalletGroupUserChargeData.fromJson(v));
      data.addAll(tmp);
    }

    return WalletGroupUserChargeResponse(
      walletGroupUserChargeData: data,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['ewalletGroupUserChargeResponse'] =
        walletGroupUserChargeData.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final List<WalletGroupUserChargeData> walletGroupUserChargeData;
}

class WalletGroupChargeResponse extends ResponseBase {
  WalletGroupChargeResponse({
    @required this.walletGroupUserChargeData,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory WalletGroupChargeResponse.fromJson(Map<String, dynamic> json) {
    final data = <WalletGroupUserChargeData>[];
    if (json['ewalletGroupUserChargeResponse'] != null) {
      final tmp = List<Map<String, dynamic>>.from(
              json['ewalletGroupUserChargeResponse'])
          .map((v) => WalletGroupUserChargeData.fromJson(v));
      data.addAll(tmp);
    }

    return WalletGroupChargeResponse(
      walletGroupUserChargeData: data,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ewalletGroupUserChargeResponse'] =
        walletGroupUserChargeData.map((v) => v.toJson()).toList();

    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final List<WalletGroupUserChargeData> walletGroupUserChargeData;
}

class WalletGroupUserChargeData {
  WalletGroupUserChargeData({
    @required this.status,
    @required this.description,
    @required this.customerId,
    @required this.customerName,
    @required this.balance,
    @required this.groupId,
  });

  WalletGroupUserChargeData.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          customerId: json['customerId'],
          customerName: json['customerName'],
          balance: json['balance'],
          groupId: json['groupId'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['description'] = description;
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['balance'] = balance;
    data['groupId'] = groupId;

    return data;
  }

  final bool status;
  final String description;
  final String customerId;
  final String customerName;
  final String balance;
  final int groupId;
}

class WalletGroupUserListResponse extends ResponseBase {
  WalletGroupUserListResponse({
    @required this.walletGroupUserList,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory WalletGroupUserListResponse.fromJson(Map<String, dynamic> json) {
    final data = <WalletGroupUserListData>[];
    if (json['ewalletGroupUserList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['ewalletGroupUserList'])
          .map((v) => WalletGroupUserListData.fromJson(v));
      data.addAll(tmp);
    }

    return WalletGroupUserListResponse(
      walletGroupUserList: data,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['ewalletGroupUserList'] =
        walletGroupUserList.map((v) => v.toJson()).toList();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final List<WalletGroupUserListData> walletGroupUserList;
}

class WalletGroupUserListData {
  WalletGroupUserListData({
    @required this.customerId,
    @required this.name,
    @required this.family,
  });

  WalletGroupUserListData.fromJson(Map<String, dynamic> json)
      : this(
          customerId: json['customerId'],
          name: json['name'],
          family: json['family'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['name'] = name;
    data['family'] = family;

    return data;
  }

  final String customerId;
  final String name;
  final String family;
}

class WalletGroupUserChargeRequestModel {
  WalletGroupUserChargeRequestModel({
    @required this.customerId,
    @required this.groupId,
    @required this.amount,
  });

  WalletGroupUserChargeRequestModel.fromJson(Map<String, dynamic> json)
      : this(
          customerId: json['customerId'],
          groupId: json['groupId'],
          amount: json['amount'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['groupId'] = groupId;
    data['amount'] = amount;

    return data;
  }

  final String customerId;
  final String groupId;
  final String amount;
}
