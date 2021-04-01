import 'package:novinpay/bill_info.dart';
import 'package:novinpay/repository/response.dart';

class RahvarInquiryResponse extends ResponseBase {
  RahvarInquiryResponse({
    @required this.data,
    @required this.plaque,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory RahvarInquiryResponse.fromJson(Map<String, dynamic> json) {
    RahvarInquiryData data;
    PlaqueModel plaqueModel;
    if (json['data'] != null) {
      data = RahvarInquiryData.fromJson(json['data']);
    }
    if (json['plaqueModel'] != null) {
      plaqueModel = PlaqueModel.fromJson(json['plaqueModel']);
    }
    return RahvarInquiryResponse(
        data: data,
        plaque: plaqueModel,
        status: json['status'],
        description: json['description'],
        mobileNumber: json['mobileNumber'],
        errorMessage: json['errorMessage']);
  }

  final RahvarInquiryData data;
  final PlaqueModel plaque;
}

class RahvarInquiryData {
  RahvarInquiryData({
    @required this.number,
    @required this.amount,
    @required this.count,
    @required this.bills,
  });

  factory RahvarInquiryData.fromJson(Map<String, dynamic> json) {
    final bills = <RahvarBillData>[];

    if (json['bills'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['bills'])
          .map((e) => RahvarBillData.fromJson(e));

      bills.addAll(tmp);
    }

    return RahvarInquiryData(
      number: json['number'],
      amount: json['amount'],
      count: json['count'],
      bills: bills,
    );
  }

  final String number;
  final int amount;
  final int count;
  final List<RahvarBillData> bills;
}

class RahvarBillData {
  RahvarBillData({
    @required this.billInfo,
    @required this.description,
    @required this.date,
    @required this.datePersian,
    @required this.city,
    @required this.delivery,
    @required this.location,
    @required this.type,
    @required this.ussdCode,
    @required this.validForPayment,
  });

  factory RahvarBillData.fromJson(Map<String, dynamic> json) {
    final billInfo = BillInfo(
      billId: json['bill_identifier'],
      paymentId: json['payment_identifier'],
      amount: json['price'],
    );

    return RahvarBillData(
      billInfo: billInfo,
      description: json['description'],
      date: json['date'],
      datePersian: json['datePersian'],
      city: json['city'],
      delivery: json['delivery'],
      location: json['location'],
      type: json['type'],
      ussdCode: json['ussdCode'],
      validForPayment: json['validForPayment'],
    );
  }

  final BillInfo billInfo;
  final Map description;
  final String date;
  final String datePersian;
  final String city;
  final String delivery;
  final String location;
  final String type;
  final Map ussdCode;
  final Map validForPayment;
}

class PlaqueModel {
  PlaqueModel({
    @required this.ir,
    @required this.irNumber,
    @required this.part01,
    @required this.part02,
    @required this.part03,
  });

  factory PlaqueModel.fromJson(Map<String, dynamic> json) {
    return PlaqueModel(
      ir: json['ir'],
      irNumber: int.tryParse(json['irNumber'] ?? '') ?? 0,
      part01: int.tryParse(json['part01'] ?? '') ?? 0,
      part02: json['part02'],
      part03: int.tryParse(json['part03'] ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ir'] = ir;
    data['irNumber'] = irNumber;
    data['part01'] = part01;
    data['part02'] = part02;
    data['part03'] = part03;
    return data;
  }

  final String ir;
  final int irNumber;
  final int part01;
  final String part02;
  final int part03;
}
