import 'dart:convert';

import 'package:novinpay/bill_info.dart';
import 'package:novinpay/repository/response.dart';

class RegisterPaymentResponse extends ResponseBase {
  RegisterPaymentResponse({
    @required this.message,
    @required this.timeStamp,
    @required this.sessionKey,
    @required this.traceNo,
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

  RegisterPaymentResponse.fromJson(Map<String, dynamic> json)
      : this(
          message: json['message'],
          timeStamp: json['timeStamp'],
          sessionKey: json['sessionKey'],
          traceNo: json['traceNo'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final String message;
  final String timeStamp;
  final String sessionKey;
  final int traceNo;
}

class GetBranchDebitResponse extends ResponseBase {
  GetBranchDebitResponse({
    @required this.data,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  GetBranchDebitResponse.fromJson(Map<String, dynamic> json)
      : this(
          data: json['data'] != null
              ? BranchDebitData.fromJson(json['data'])
              : null,
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final BranchDebitData data;
}

class BranchDebitData {
  BranchDebitData({
    @required this.billInfo,
    @required this.oTHERACCOUNTDEBT,
    @required this.tOTALREGISTERDEBT,
    @required this.pAYMENTDEADLINE,
    @required this.lICENSEREADDATE,
  });

  factory BranchDebitData.fromJson(Map<String, dynamic> json) {
    final billId = json['BILL_IDENTIFIER'];
    final paymentId = json['PAYMENT_IDENTIFIER'];
    final int amount = json['TOTAL_BILL_DEBT'];

    final billInfo = BillInfo(
      billId: billId.toString(),
      paymentId: paymentId.toString(),
      amount: amount,
    );

    return BranchDebitData(
      billInfo: billInfo,
      oTHERACCOUNTDEBT: json['OTHER_ACCOUNT_DEBT'],
      tOTALREGISTERDEBT: json['TOTAL_REGISTER_DEBT'],
      pAYMENTDEADLINE: json['PAYMENT_DEAD_LINE'],
      lICENSEREADDATE: json['LICENSE_READ_DATE'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['BILL_IDENTIFIER'] = billInfo.billId;
    data['PAYMENT_IDENTIFIER'] = billInfo.paymentId;
    data['TOTAL_BILL_DEBT'] = billInfo.amount;
    data['OTHER_ACCOUNT_DEBT'] = oTHERACCOUNTDEBT;
    data['TOTAL_REGISTER_DEBT'] = tOTALREGISTERDEBT;
    data['PAYMENT_DEAD_LINE'] = pAYMENTDEADLINE;
    data['LICENSE_READ_DATE'] = lICENSEREADDATE;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  final BillInfo billInfo;
  final int oTHERACCOUNTDEBT;
  final int tOTALREGISTERDEBT;
  final String pAYMENTDEADLINE;
  final String lICENSEREADDATE;
}

class BranchDataResponse extends ResponseBase {
  BranchDataResponse({
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
    @required this.message,
    @required this.timeStamp,
    @required this.sessionKey,
    @required this.traceNo,
    @required this.data,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  BranchDataResponse.fromJson(Map<String, dynamic> json)
      : this(
          data: json['data'] != null ? BranchData.fromJson(json['data']) : null,
          message: json['message'],
          timeStamp: json['timeStamp'],
          sessionKey: json['sessionKey'],
          traceNo: json['traceNo'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final String message;
  final String timeStamp;
  final String sessionKey;
  final int traceNo;
  final BranchData data;
}

class BranchData {
  BranchData({
    @required this.billInfo,
    @required this.companyCode,
    @required this.phase,
    @required this.voltageType,
    @required this.amper,
    @required this.contractDemand,
    @required this.tariffType,
    @required this.customerType,
    @required this.customerName,
    @required this.telNumber,
    @required this.mobileNumber,
    @required this.serviceAdd,
    @required this.servicePostCode,
    @required this.totalBillDebt,
    @required this.otherAccountDebt,
    @required this.totalRegisterDebt,
    @required this.locationStatus,
    @required this.serialNumber,
    @required this.paymentDeadline,
    @required this.lastReadDate,
    @required this.licenseExpireDate,
  });

  BranchData.fromJson(Map<String, dynamic> json)
      : this(
          billInfo: BillInfo(
            billId: json['BILL_IDENTIFIER']?.toString() ?? '',
            paymentId: json['PAYMENT_IDENTIFIER']?.toString() ?? '',
            amount: json['TOTAL_BILL_DEBT'],
          ),
          companyCode: json['Company_Code'],
          phase: json['phase'],
          voltageType: json['Voltage_Type'],
          amper: json['amper'],
          contractDemand: json['CONTRACT_DEMAND'],
          tariffType: json['TARIFF_TYPE'],
          customerType: json['CUSTOMER_TYPE'],
          customerName: json['CUSTOMER_NAME'],
          telNumber: json['TEL_NUMBER'],
          mobileNumber: json['MOBILE_NUMBER'],
          serviceAdd: json['SERVICE_ADD'],
          servicePostCode: json['SERVICE_POST_CODE'],
          totalBillDebt: json['TOTAL_BILL_DEBT'],
          otherAccountDebt: json['OTHER_ACCOUNT_DEBT'],
          totalRegisterDebt: json['TOTAL_REGISTER_DEBT'],
          locationStatus: json['LOCATION_STATUS'],
          serialNumber: json['SERIAL_NUMBER'],
          paymentDeadline: json['PAYMENT_DEAD_LINE'],
          lastReadDate: json['LAST_READ_DATE'],
          licenseExpireDate: json['LICENSE_EXPIRE_DATE'],
        );
  BillInfo billInfo;
  int companyCode;
  int phase;
  int voltageType;
  int amper;
  num contractDemand;
  int tariffType;
  int customerType;
  String customerName;
  String telNumber;
  String mobileNumber;
  String serviceAdd;
  String servicePostCode;
  int totalBillDebt;
  int otherAccountDebt;
  int totalRegisterDebt;
  String locationStatus;
  String serialNumber;
  String paymentDeadline;
  String lastReadDate;
  String licenseExpireDate;
}
