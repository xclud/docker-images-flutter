import 'package:novinpay/repository/response.dart';

class MruListResponse extends ResponseBase {
  MruListResponse({
    @required this.mruList,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  MruListResponse.fromJson(Map<String, dynamic> json)
      : this(
          mruList: List.from(json['mruList'])
              .map((v) => MruItem.fromJson(v))
              .toList(),
          status: json['status'],
          mobileNumber: json['mobileNumber'],
          description: json['description'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['status'] = status;
    data['description'] = description;
    data['mruList'] = mruList.map((v) => v.toJson()).toList();

    return data;
  }

  List<MruItem> mruList;
}

class MruItem {
  MruItem({
    @required this.id,
    @required this.title,
    @required this.value,
    this.mruSource,
    this.mruType,
    this.customerId,
    this.insertDateTime,
    this.expDate,
  });

  MruItem.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          customerId: json['customerId'],
          insertDateTime: json['insertDateTime'],
          title: json['title'],
          value: json['mruValue'],
          mruType: _convertIntToMru(json['mruType']),
          mruSource: json['mruSource'],
          expDate: json['expDate'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['customerId'] = customerId;
    data['insertDateTime'] = insertDateTime;
    data['title'] = title;
    data['mruValue'] = value;
    data['mruType'] = mruType?.index;
    data['mruSource'] = mruSource;
    data['expDate'] = expDate;
    return data;
  }

  final int id;
  final String title;
  final String value;
  final MruType mruType;
  final String mruSource;
  final String customerId;
  final String insertDateTime;
  final String expDate;
}

class AddMruResponse extends ResponseBase {
  AddMruResponse({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  AddMruResponse.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}

class UpdateMru extends ResponseBase {
  UpdateMru({
    @required String expDate,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  UpdateMru.fromJson(Map<String, dynamic> json)
      : this(
          expDate: json['expDate'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}

class DeleteMru extends ResponseBase {
  DeleteMru({
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  DeleteMru.fromJson(Map<String, dynamic> json)
      : this(
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}

enum MruType {
  all,
  mobile,
  destinationAccount,
  sourceAccount,
  destinationIban,
  sourceIban,
  loan,
  landPhone,
  vehicleId,
  sourceCard,
  destinationCard,
}

MruType _convertIntToMru(int type) {
  switch (type) {
    case 0:
      return MruType.all;
    case 1:
      return MruType.mobile;
    case 2:
      return MruType.sourceAccount;
    case 3:
      return MruType.sourceIban;
    case 4:
      return MruType.destinationAccount;
    case 5:
      return MruType.destinationIban;
    case 6:
      return MruType.loan;
    case 7:
      return MruType.landPhone;
    case 8:
      return MruType.vehicleId;
    case 9:
      return MruType.sourceCard;
    case 10:
      return MruType.destinationCard;
  }

  throw Exception();
}
