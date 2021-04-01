import 'package:novinpay/bill_info.dart';
import 'package:novinpay/repository/response.dart';

class PhoneInquiryResponse extends ResponseBase {
  PhoneInquiryResponse({
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

  factory PhoneInquiryResponse.fromJson(Map<String, dynamic> json) {
    final String midTermBillId = json['midTermBillId'];
    final int midTermPaymentId = json['midTermPaymentId'];
    final int midTermAmount = json['midTermAmount'];
    final String endTermBillId = json['endTermBillId'];
    final int endTermPaymentId = json['endTermPaymentId'];
    final int endTermAmount = json['endTermAmount'];

    final midTerm = BillInfo(
      billId: midTermBillId,
      paymentId: midTermPaymentId.toString(),
      amount: midTermAmount,
    );
    final endTerm = BillInfo(
      billId: endTermBillId,
      paymentId: endTermPaymentId.toString(),
      amount: endTermAmount,
    );

    return PhoneInquiryResponse(
        midTerm: midTerm,
        endTerm: endTerm,
        status: json['status'],
        description: json['description'],
        mobileNumber: json['mobileNumber'],
        errorMessage: json['errorMessage']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['midTermBillId'] = '${midTerm.billId}';
    data['midTermPaymentId'] = '${midTerm.paymentId}';
    data['midTermAmount'] = '${midTerm.amount}';
    data['endTermBillId'] = '${endTerm.billId}';
    data['endTermPaymentId'] = '${endTerm.paymentId}';
    data['endTermAmount'] = '${endTerm.amount}';
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    data['errorMessage'] = errorMessage;
    return data;
  }

  final BillInfo midTerm;
  final BillInfo endTerm;
}
