import 'package:novinpay/bill_info.dart';
import 'package:novinpay/repository/response.dart';

class GetBillInfoResponse extends ResponseBase {
  GetBillInfoResponse({
    @required this.midTerm,
    @required this.endTerm,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory GetBillInfoResponse.fromJson(Map<String, dynamic> json) {
    final midTermAmount = int.tryParse(json['midTermAmount'] ?? '') ?? 0;
    final String midTermBillId = json['midTermBillId'];
    final String midTermPaymentCode = json['midTermPaymentCode'];

    final endTermAmount = int.tryParse(json['endTermAmount'] ?? '') ?? 0;
    final String endTermBillId = json['endTermBillId'];
    final String endTermPaymentId = json['endTermPaymentCode'];

    final midTerm = BillInfo(
      billId: midTermBillId,
      paymentId: midTermPaymentCode,
      amount: midTermAmount,
    );
    final endTerm = BillInfo(
      billId: endTermBillId,
      paymentId: endTermPaymentId,
      amount: endTermAmount,
    );

    return GetBillInfoResponse(
      midTerm: midTerm,
      endTerm: endTerm,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['midTermAmount'] = '${midTerm.amount}';
    data['midTermBillId'] = '${midTerm.billId}';
    data['midTermPaymentCode'] = '${midTerm.paymentId}';
    data['endTermAmount'] = '${endTerm.amount}';
    data['endTermBillId'] = '${endTerm.billId}';
    data['endTermPaymentCode'] = '${endTerm.paymentId}';
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final BillInfo midTerm;
  final BillInfo endTerm;
}
