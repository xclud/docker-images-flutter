import 'package:novinpay/repository/response.dart';

enum PaymentMethod {
  none,
  one,
  two,
}

class CrediCardPaymentResponse extends ResponseBase {
  CrediCardPaymentResponse({
    @required this.rrn,
    @required this.stan,
    @required this.traceNumber,
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

  CrediCardPaymentResponse.fromJson(Map<String, dynamic> json)
      : this(
          rrn: json['rrn'],
          stan: json['stan'],
          traceNumber: json['traceNumber'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final String rrn;
  final String stan;
  final String traceNumber;
}

class GeneralInformationResponse extends ResponseBase {
  GeneralInformationResponse({
    @required this.statementDetails,
    @required this.paymentOrTransactions,
    @required this.paymentTypes,
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

  factory GeneralInformationResponse.fromJson(Map<String, dynamic> json) {
    final List<PaymentOrTransaction> paymentOrTransactions = [];
    final List<PaymentType> paymentTypes = [];
    if (json.containsKey('paymentOrTransaction')) {
      final dc = List<Map<String, dynamic>>.from(json['paymentOrTransaction']);
      final temp = dc.map((e) => PaymentOrTransaction.fromJson(e)).toList();
      paymentOrTransactions.addAll(temp);
    }
    if (json.containsKey('paymentType')) {
      final dc = List<Map<String, dynamic>>.from(json['paymentType']);
      final temp = dc.map((e) => PaymentType.fromJson(e)).toList();
      paymentTypes.addAll(temp);
    }
    return GeneralInformationResponse(
      paymentOrTransactions: paymentOrTransactions,
      paymentTypes: paymentTypes,
      statementDetails: StatementDetails.fromJson(json['statementDetail']),
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['statementDetail'] = statementDetails.toJson();
    data['status'] = status;
    data['description'] = description;
    data['mobileNumber'] = mobileNumber;
    return data;
  }

  final StatementDetails statementDetails;
  final List<PaymentOrTransaction> paymentOrTransactions;
  final List<PaymentType> paymentTypes;
}

class GetPaymentTypeResponse extends ResponseBase {
  GetPaymentTypeResponse({
    @required this.data,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  GetPaymentTypeResponse.fromJson(Map<String, dynamic> json)
      : this(
          data: List.from(json['data'])
              .map((v) => GetPaymentTypeData.fromJson(v))
              .toList(),
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final List<GetPaymentTypeData> data;
}

class CardLastStatementResponse extends ResponseBase {
  CardLastStatementResponse({
    @required this.lastStatementModel,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  CardLastStatementResponse.fromJson(Map<String, dynamic> json)
      : this(
          lastStatementModel:
              LastStatementModel.fromJson(json['lastStatementModel']),
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final LastStatementModel lastStatementModel;
}

class PaymentInfoResponse extends ResponseBase {
  PaymentInfoResponse({
    @required this.paymentInfo,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory PaymentInfoResponse.fromJson(Map<String, dynamic> json) {
    PaymentInfo paymentInfo;
    if (json['paymentInfo'] != null) {
      paymentInfo = PaymentInfo.fromJson(json['paymentInfo']);
    }
    return PaymentInfoResponse(
      paymentInfo: paymentInfo,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final PaymentInfo paymentInfo;
}

class PaymentOrTransactionResponse extends ResponseBase {
  PaymentOrTransactionResponse({
    @required this.paymentOrTransactions,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory PaymentOrTransactionResponse.fromJson(Map<String, dynamic> json) {
    final data = <PaymentOrTransaction>[];
    if (json['paymentOrTransactionModel'] != null) {
      final tmp =
          List<Map<String, dynamic>>.from(json['paymentOrTransactionModel'])
              .map(
        (v) => PaymentOrTransaction.fromJson(v),
      );

      data.addAll(tmp);
    }
    return PaymentOrTransactionResponse(
        status: json['status'],
        description: json['description'],
        mobileNumber: json['mobileNumber'],
        errorMessage: json['errorMessage'],
        paymentOrTransactions: data);
  }

  final List<PaymentOrTransaction> paymentOrTransactions;
}

class ListOfBillsResponse extends ResponseBase {
  ListOfBillsResponse({
    @required this.bills,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory ListOfBillsResponse.fromJson(Map<String, dynamic> json) {
    final data = <CreditCardBillItem>[];
    if (json.containsKey('bills') && json['bills'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['bills']).map(
        (v) => CreditCardBillItem.fromJson(v),
      );

      data.addAll(tmp);
    }
    return ListOfBillsResponse(
      bills: data,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  List<CreditCardBillItem> bills;
}

class GetCustomerInfoResponse extends ResponseBase {
  GetCustomerInfoResponse({
    @required this.data,
    @required this.paymentInfo,
    @required this.customerCards,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  GetCustomerInfoResponse.fromJson(Map<String, dynamic> json)
      : this(
          data: CustomerInfo.fromJson(json['data']),
          paymentInfo: PaymentInfo.fromJson(json['paymentInfo']),
          customerCards: CustomerCards.fromJson(json['customerCards']),
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final CustomerInfo data;
  final PaymentInfo paymentInfo;
  final CustomerCards customerCards;
}

class PaymentListResponse extends ResponseBase {
  PaymentListResponse({
    @required this.data,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  factory PaymentListResponse.fromJson(Map<String, dynamic> json) {
    final data = <PaymentItem>[];
    if (json.containsKey('paymentList') && json['paymentList'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['paymentList']).map(
        (v) => PaymentItem.fromJson(v),
      );

      data.addAll(tmp);
    }

    return PaymentListResponse(
      data: data,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final List<PaymentItem> data;
}

class PaymentItem {
  PaymentItem({
    @required this.paymentId,
    @required this.customerNumber,
    @required this.statusIdentifier,
    @required this.date,
    @required this.referenceNumber,
    @required this.amount,
  });

  PaymentItem.fromJson(Map<String, dynamic> json)
      : this(
          paymentId: json['paymentId'],
          customerNumber: json['customerNumber'],
          statusIdentifier:
              json['statusIdentifier'].toString().toLowerCase() == 'true',
          date: json['createDate'],
          referenceNumber: json['refNumber'],
          amount: json['amount'],
        );
  final int paymentId;
  final String customerNumber;
  final bool statusIdentifier;
  final String date;
  final int referenceNumber;
  final int amount;
}

class GetPaymentTypeData {
  GetPaymentTypeData({
    @required this.customerNumber,
    @required this.isSelected,
    @required this.installmentCount,
    @required this.mainDebitAmount,
    @required this.feeTotalAmount,
    @required this.crInterestTotalAmount,
    @required this.curInstallmentAmount,
    @required this.installmentFee,
    @required this.prevDebit,
    @required this.payAmount,
    @required this.issueDate,
    @required this.dueDate,
    @required this.statementNumber,
    @required this.paymentCode,
    @required this.tableId,
  });

  GetPaymentTypeData.fromJson(Map<String, dynamic> json)
      : this(
          customerNumber: json['customerNumber'],
          isSelected: json['isSelected'],
          installmentCount: json['installmentCount'],
          mainDebitAmount: int.tryParse(json['mainDebitAmount'] ?? '') ?? 0,
          feeTotalAmount: int.tryParse(json['feeTotalAmount'] ?? '') ?? 0,
          crInterestTotalAmount:
              int.tryParse(json['crInterestTotalAmount'] ?? '') ?? 0,
          curInstallmentAmount:
              int.tryParse(json['curInstallmentAmount'] ?? '') ?? 0,
          installmentFee: int.tryParse(json['installmentFee'] ?? '') ?? 0,
          prevDebit: int.tryParse(json['prevDebit'] ?? '') ?? 0,
          payAmount: int.tryParse(json['payAmount'] ?? '') ?? 0,
          issueDate: json['issueDate'],
          dueDate: json['dueDate'],
          statementNumber: json['statementNumber'],
          paymentCode: json['paymentCode'],
          tableId: json['tableId'],
        );
  final String customerNumber;
  final bool isSelected;
  final int installmentCount;
  final int mainDebitAmount;
  final int feeTotalAmount;
  final int crInterestTotalAmount;
  final int curInstallmentAmount;
  final int installmentFee;
  final int prevDebit;
  final int payAmount;
  final String issueDate;
  final String dueDate;
  final String statementNumber;
  final String paymentCode;
  final int tableId;
}

class LastStatementModel {
  const LastStatementModel({
    @required this.anualInterestRate,
    @required this.canInstAmount,
    @required this.canNotInstAmount,
    @required this.cardHolderAddress,
    @required this.cardHolderEmail,
    @required this.cardHolderPostalCode,
    @required this.cardPAN,
    @required this.crInterestTotalAmount,
    @required this.creditLimit,
    @required this.currentTotalAmount,
    @required this.customerFirstName,
    @required this.customerLastName,
    @required this.customerNumber,
    @required this.cycleEndDate,
    @required this.cycleStartDate,
    @required this.dueDate,
    @required this.feeTotalAmount,
    @required this.fileNumber,
    @required this.installmentPreviewVOsField,
    @required this.isPayable,
    @required this.issueDate,
    @required this.mainDebitAmount,
    @required this.paymentCode,
    @required this.paymentOrTransactionVOs,
    @required this.paymentTypeVOs,
    @required this.prevInstLtInterest,
    @required this.prevInstSurcharge,
    @required this.prevInstallmentDebit,
    @required this.prevNotInstallmentDebit,
    @required this.prevTotalInstallmentAmt,
    @required this.remainedCredit,
    @required this.statementNumber,
    @required this.totalDebitAmount,
    @required this.totalInstallmentAmount,
  });

  LastStatementModel.fromJson(Map<String, dynamic> json)
      : this(
          anualInterestRate: json['anualInterestRate'],
          canInstAmount: json['canInstAmount'],
          canNotInstAmount: json['canNotInstAmount'],
          cardHolderAddress: json['cardHolderAddress'],
          cardHolderEmail: json['cardHolderEmail'],
          cardHolderPostalCode: json['cardHolderPostalCode'],
          cardPAN: json['cardPAN'],
          crInterestTotalAmount: json['crInterestTotalAmount'],
          creditLimit: json['creditLimit'],
          currentTotalAmount: json['currentTotalAmount'],
          customerFirstName: json['customerFirstName'],
          customerLastName: json['customerLastName'],
          customerNumber: json['customerNumber'],
          cycleEndDate: json['cycleEndDate'],
          cycleStartDate: json['cycleStartDate'],
          dueDate: json['dueDate'],
          feeTotalAmount: json['feeTotalAmount'],
          fileNumber: json['fileNumber'],
          installmentPreviewVOsField: List.from(json['installmentPreviewVOs'])
              .map((e) => InstallmentPreviewVO.fromJson(e))
              .toList(),
          isPayable: json['isPayable'],
          issueDate: json['issueDate'],
          mainDebitAmount: json['mainDebitAmount'],
          paymentCode: json['paymentCode'],
          paymentOrTransactionVOs: List.from(json['paymentOrTransactionVOs'])
              .map((e) => PaymentOrTransactionVO.fromJson(e))
              .toList(),
          paymentTypeVOs: List.from(json['paymentTypeVOs'])
              .map((e) => PaymentType.fromJson(e))
              .toList(),
          prevInstLtInterest: json['prevInstLtInterest'],
          prevInstSurcharge: json['prevInstSurcharge'],
          prevInstallmentDebit: json['prevInstallmentDebit'],
          prevNotInstallmentDebit: json['prevNotInstallmentDebit'],
          prevTotalInstallmentAmt: json['prevTotalInstallmentAmt'],
          remainedCredit: json['remainedCredit'],
          statementNumber: json['statementNumber'],
          totalDebitAmount: json['totalDebitAmount'],
          totalInstallmentAmount: json['totalInstallmentAmount'],
        );
  final double anualInterestRate;
  final double canInstAmount;
  final double canNotInstAmount;
  final String cardHolderAddress;
  final String cardHolderEmail;
  final String cardHolderPostalCode;
  final String cardPAN;
  final double crInterestTotalAmount;
  final double creditLimit;
  final double currentTotalAmount;
  final String customerFirstName;
  final String customerLastName;
  final String customerNumber;
  final String cycleEndDate;
  final String cycleStartDate;
  final String dueDate;
  final double feeTotalAmount;
  final String fileNumber;
  final List<InstallmentPreviewVO> installmentPreviewVOsField;
  final bool isPayable;
  final String issueDate;
  final double mainDebitAmount;
  final String paymentCode;
  final List<PaymentOrTransactionVO> paymentOrTransactionVOs;
  final List<PaymentType> paymentTypeVOs;
  final double prevInstLtInterest;
  final double prevInstSurcharge;
  final double prevInstallmentDebit;
  final double prevNotInstallmentDebit;
  final double prevTotalInstallmentAmt;
  final double remainedCredit;
  final String statementNumber;
  final double totalDebitAmount;
  final double totalInstallmentAmount;
}

class InstallmentPreviewVO {
  InstallmentPreviewVO({
    @required this.dueDate,
    @required this.feeAmount,
    @required this.installmentAmount,
    @required this.interestAmount,
    @required this.order,
    @required this.payAmount,
  });

  InstallmentPreviewVO.fromJson(Map<String, dynamic> json)
      : this(
          dueDate: json['dueDate'],
          feeAmount: json['feeAmount'],
          installmentAmount: json['installmentAmount'],
          interestAmount: json['interestAmount'],
          order: json['order'],
          payAmount: json['payAmount'],
        );
  final String dueDate;
  final double feeAmount;
  final double installmentAmount;
  final double interestAmount;
  final int order;
  final double payAmount;
}

class PaymentOrTransactionVO {
  PaymentOrTransactionVO({
    @required this.amount,
    @required this.date,
    @required this.desc,
    @required this.isPayment,
    @required this.refrenceNumber,
    @required this.time,
  });

  PaymentOrTransactionVO.fromJson(Map<String, dynamic> json)
      : this(
          amount: json['amount'],
          date: json['date'],
          desc: json['desc'],
          isPayment: json['isPayment'],
          refrenceNumber: json['refrenceNumber'],
          time: json['time'],
        );
  final double amount;
  final String date;
  final String desc;
  final bool isPayment;
  final String refrenceNumber;
  final String time;
}

class PaymentType {
  PaymentType({
    @required this.customerNumber,
    @required this.isSelected,
    @required this.installmentCount,
    @required this.mainDebitAmount,
    @required this.feeTotalAmount,
    @required this.crInterestTotalAmount,
    @required this.curInstallmentAmount,
    @required this.installmentFee,
    @required this.prevDebit,
    @required this.payAmount,
    @required this.issueDate,
    @required this.dueDate,
    @required this.statementNumber,
    @required this.paymentCode,
    @required this.tableId,
  });

  PaymentType.fromJson(Map<String, dynamic> json)
      : this(
          customerNumber: json['customerNumber'],
          isSelected: json['isSelected'],
          installmentCount: json['installmentCount'],
          mainDebitAmount:
              double.tryParse(json['mainDebitAmount'] ?? '')?.toInt() ?? 0,
          feeTotalAmount:
              double.tryParse(json['feeTotalAmount'] ?? '')?.toInt() ?? 0,
          crInterestTotalAmount:
              double.tryParse(json['crInterestTotalAmount'] ?? '')?.toInt() ??
                  0,
          curInstallmentAmount:
              double.tryParse(json['curInstallmentAmount'] ?? '')?.toInt() ?? 0,
          installmentFee:
              double.tryParse(json['installmentFee'] ?? '')?.toInt() ?? 0,
          prevDebit: double.tryParse(json['prevDebit'] ?? '')?.toInt() ?? 0,
          payAmount: double.tryParse(json['payAmount'] ?? '')?.toInt() ?? 0,
          issueDate: json['issueDate'],
          dueDate: json['dueDate'],
          statementNumber: json['statementNumber'],
          paymentCode: json['paymentCode'],
          tableId: json['tableId'],
        );
  final String customerNumber;
  final bool isSelected;
  final int installmentCount;
  final int mainDebitAmount;
  final int feeTotalAmount;
  final int crInterestTotalAmount;
  final int curInstallmentAmount;
  final int installmentFee;
  final int prevDebit;
  final int payAmount;
  final String issueDate;
  final String dueDate;
  final String statementNumber;
  final String paymentCode;
  final int tableId;
}

class StatementPaymentResponse extends ResponseBase {
  StatementPaymentResponse({
    @required this.rsCode,
    @required this.message,
    @required bool status,
    @required String mobileNumber,
    @required String description,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage);

  StatementPaymentResponse.fromJson(Map<String, dynamic> json)
      : this(
          rsCode: json['rsCodeField'],
          message: json['messageField'],
          status: json['status'],
          description: json['description'],
          mobileNumber: json['mobileNumber'],
          errorMessage: json['errorMessage'],
        );
  final int rsCode;
  final String message;
}

class CreditCardBillItem {
  CreditCardBillItem({
    @required this.customerNumber,
    @required this.issueDate,
    @required this.cycleStartDate,
    @required this.cycleEndDate,
    @required this.statementNumber,
    @required this.dueDate,
  });

  CreditCardBillItem.fromJson(Map<String, dynamic> json)
      : this(
          customerNumber: json['customerNumber'],
          issueDate: json['issueDate'],
          cycleStartDate: json['cycleStartDate'],
          cycleEndDate: json['cycleEndDate'],
          statementNumber: json['statementNumber'],
          dueDate: json['dueDate'],
        );
  final String customerNumber;
  final String issueDate;
  final String cycleStartDate;
  final String cycleEndDate;
  final String statementNumber;
  final String dueDate;
}

class PaymentOrTransaction {
  PaymentOrTransaction({
    @required this.customerNumber,
    @required this.isPayment,
    @required this.time,
    @required this.date,
    @required this.desc,
    @required this.refrenceNumber,
    @required this.amount,
  });

  PaymentOrTransaction.fromJson(Map<String, dynamic> json)
      : this(
          customerNumber: json['customerNumber'],
          isPayment: json['isPayment'],
          time: json['time'],
          date: json['date'],
          desc: json['desc'],
          refrenceNumber: json['refrenceNumber'],
          amount: int.tryParse(json['amount'] ?? '') ?? 0,
        );
  final String customerNumber;
  final bool isPayment;
  final String time;
  final String date;
  final String desc;
  final String refrenceNumber;
  final int amount;
}

class PaymentInfo {
  PaymentInfo({@required this.data});

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      data: PaymentInfoData.fromJson(json['data']),
    );
  }

  final PaymentInfoData data;
}

class PaymentInfoData {
  PaymentInfoData({
    @required this.currentCreditAmt,
    @required this.currentFeeAmt,
    @required this.currentPrevInstAmount,
    @required this.currentPrevInstLtInterest,
    @required this.currentPrevInstSurcharge,
    @required this.currentPrevNotInstAmount,
    @required this.currentPrevTotalInstAmount,
    @required this.currentTotalAmt,
    @required this.currentTotalDebitAmt,
    @required this.currentTotalInstAmt,
    @required this.discountAmount,
    @required this.discountInterestAmount,
    @required this.minPayAmtForDiscountInt,
    @required this.payAmtWithoutDiscount,
    @required this.payableAmt,
    @required this.totalCrInterestAmt,
    this.paymentTypes,
  });

  PaymentInfoData.fromJson(Map<String, dynamic> json)
      : this(
          currentCreditAmt: json['currentCreditAmtField'],
          currentFeeAmt: json['currentFeeAmtField'],
          currentPrevInstAmount: json['currentPrevInstAmountField'],
          currentPrevInstLtInterest: json['currentPrevInstLtInterestField'],
          currentPrevInstSurcharge: json['currentPrevInstSurchargeField'],
          currentPrevNotInstAmount: json['currentPrevNotInstAmountField'],
          currentPrevTotalInstAmount: json['currentPrevTotalInstAmountField'],
          currentTotalAmt: json['currentTotalAmtField'],
          currentTotalDebitAmt: json['currentTotalDebitAmtField'],
          currentTotalInstAmt: json['currentTotalInstAmtField'],
          discountAmount: json['discountAmountField'],
          discountInterestAmount: json['discountInterestAmountField'],
          minPayAmtForDiscountInt: json['minPayAmtForDiscountIntField'],
          payAmtWithoutDiscount: json['payAmtWithoutDiscountField'],
          payableAmt: json['payableAmtField'],
//          paymentTypes: List.from(json['paymentTypesField'])
//              .map((e) => PaymentType.fromJson(e))
//              .toList(),
          totalCrInterestAmt: json['totalCrInterestAmtField'],
        );
  final double currentCreditAmt;
  final double currentFeeAmt;
  final double currentPrevInstAmount;
  final double currentPrevInstLtInterest;
  final double currentPrevInstSurcharge;
  final double currentPrevNotInstAmount;
  final double currentPrevTotalInstAmount;
  final double currentTotalAmt;
  final double currentTotalDebitAmt;
  final double currentTotalInstAmt;
  final double discountAmount;
  final double discountInterestAmount;
  final double minPayAmtForDiscountInt;
  final double payAmtWithoutDiscount;
  final double payableAmt;
  final List<PaymentType> paymentTypes;
  final double totalCrInterestAmt;
}

class CustomerInfo {
  CustomerInfo({
    @required this.address,
    @required this.birthCityName,
    @required this.birthDate,
    @required this.customerNo,
    @required this.docNumber,
    @required this.docSerial,
    @required this.email,
    @required this.englishFirstName,
    @required this.englishLastName,
    @required this.fatherName,
    @required this.firstName,
    @required this.gender,
    @required this.lastName,
    @required this.mobileNumber,
    @required this.nin,
    @required this.postalCode,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      address: json['addressField'],
      birthCityName: json['birthCityNameField'],
      birthDate: json['birthDateField'],
      customerNo: json['customerNoField'],
      docNumber: json['docNumberField'],
      docSerial: json['docSerialField'],
      email: json['emailField'],
      englishFirstName: json['englishFirstNameField'],
      englishLastName: json['englishLastNameField'],
      fatherName: json['fatherNameField'],
      firstName: json['firstNameField'],
      gender: json['genderField'],
      lastName: json['lastNameField'],
      mobileNumber: json['mobileNumberField'],
      nin: json['ninField'],
      postalCode: json['postalCodeField'],
    );
  }

  final String address;
  final String birthCityName;
  final String birthDate;
  final String customerNo;
  final String docNumber;
  final String docSerial;
  final String email;
  final String englishFirstName;
  final String englishLastName;
  final String fatherName;
  final String firstName;
  final String gender;
  final String lastName;
  final String mobileNumber;
  final String nin;
  final String postalCode;
}

class StatementDetails {
  StatementDetails({
    @required this.tableId,
    @required this.fileId,
    @required this.issueDate,
    @required this.customerNumber,
    @required this.customerFirstName,
    @required this.customerLastName,
    @required this.cardPan,
    @required this.cycleStartDate,
    @required this.cycleEndDate,
    @required this.statementNumber,
    @required this.dueDate,
    @required this.cardHolderAddress,
    @required this.paymentCode,
    @required this.fileNumber,
    @required this.mainDebitAmount,
    @required this.feeTotalAmount,
    @required this.crInterestTotalAmount,
    @required this.currentTotalAmount,
    @required this.canInstAmount,
    @required this.canNotInstAmount,
    @required this.totalDebitAmount,
    @required this.totalInstallmentAmount,
    @required this.prevTotalInstallmentAmt,
    @required this.prevInstLtInterest,
    @required this.prevInstSurcharge,
    @required this.prevInstallmentDebit,
    @required this.prevNotInstallmentDebit,
    @required this.cardHolderPostalCode,
    @required this.cardHolderEmail,
    @required this.annualInterestRate,
    @required this.remainedCredit,
    @required this.creditLimit,
    @required this.utmostDuePeriodDebtAmount,
    @required this.isPayed,
  });

  StatementDetails.fromJson(Map<String, dynamic> json)
      : this(
          tableId: json['tableId'],
          fileId: json['fileId'],
          issueDate: json['issueDate'],
          customerNumber: json['customerNumber'],
          customerFirstName: json['customerFirstName'],
          customerLastName: json['customerLastName'],
          cardPan: json['cardPan'],
          cycleStartDate: json['cycleStartDate'],
          cycleEndDate: json['cycleEndDate'],
          statementNumber: json['statementNumber'],
          dueDate: json['dueDate'],
          cardHolderAddress: json['cardHolderAddress'],
          paymentCode: json['paymentCode'],
          fileNumber: json['fileNumber'],
          mainDebitAmount: int.tryParse(json['mainDebitAmount'] ?? '') ?? 0,
          feeTotalAmount: int.tryParse(json['feeTotalAmount'] ?? '') ?? 0,
          crInterestTotalAmount:
              int.tryParse(json['crInterestTotalAmount'] ?? '??') ?? 0,
          currentTotalAmount:
              int.tryParse(json['currentTotalAmount'] ?? '') ?? 0,
          canInstAmount: int.tryParse(json['canInstAmount'] ?? '') ?? 0,
          canNotInstAmount: int.tryParse(json['canNotInstAmount'] ?? '') ?? 0,
          totalDebitAmount: int.tryParse(json['totalDebitAmount'] ?? '') ?? 0,
          totalInstallmentAmount:
              int.tryParse(json['totalInstallmentAmount'] ?? '') ?? 0,
          prevTotalInstallmentAmt:
              int.tryParse(json['prevTotalInstallmentAmt'] ?? '') ?? 0,
          prevInstLtInterest:
              int.tryParse(json['prevInstLtInterest'] ?? '') ?? 0,
          prevInstSurcharge: int.tryParse(json['prevInstSurcharge'] ?? '') ?? 0,
          prevInstallmentDebit:
              int.tryParse(json['prevInstallmentDebit'] ?? '') ?? 0,
          prevNotInstallmentDebit:
              int.tryParse(json['prevNotInstallmentDebit'] ?? '') ?? 0,
          cardHolderPostalCode:
              int.tryParse(json['cardHolderPostalCode'] ?? '') ?? 0,
          cardHolderEmail: json['cardHolderEmail'],
          annualInterestRate: json['anualInterestRate'],
          remainedCredit: json['remainedCredit'],
          creditLimit: json['creditLimit'],
          utmostDuePeriodDebtAmount:
              int.tryParse(json['utmostDuePeriodDebtAmount'] ?? '') ?? 0,
          isPayed: json['isPayed'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['tableId'] = tableId;
    data['fileId'] = fileId;
    data['issueDate'] = issueDate;
    data['customerNumber'] = customerNumber;
    data['customerFirstName'] = customerFirstName;
    data['customerLastName'] = customerLastName;
    data['cardPan'] = cardPan;
    data['cycleStartDate'] = cycleStartDate;
    data['cycleEndDate'] = cycleEndDate;
    data['statementNumber'] = statementNumber;
    data['dueDate'] = dueDate;
    data['cardHolderAddress'] = cardHolderAddress;
    data['paymentCode'] = paymentCode;
    data['fileNumber'] = fileNumber;
    data['mainDebitAmount'] = mainDebitAmount;
    data['feeTotalAmount'] = feeTotalAmount;
    data['crInterestTotalAmount'] = crInterestTotalAmount;
    data['currentTotalAmount'] = currentTotalAmount;
    data['canInstAmount'] = canInstAmount;
    data['canNotInstAmount'] = canNotInstAmount;
    data['totalDebitAmount'] = totalDebitAmount;
    data['totalInstallmentAmount'] = totalInstallmentAmount;
    data['prevTotalInstallmentAmt'] = prevTotalInstallmentAmt;
    data['prevInstLtInterest'] = prevInstLtInterest;
    data['prevInstSurcharge'] = prevInstSurcharge;
    data['prevInstallmentDebit'] = prevInstallmentDebit;
    data['prevNotInstallmentDebit'] = prevNotInstallmentDebit;
    data['cardHolderPostalCode'] = cardHolderPostalCode;
    data['cardHolderEmail'] = cardHolderEmail;
    data['anualInterestRate'] = annualInterestRate;
    data['remainedCredit'] = remainedCredit;
    data['creditLimit'] = creditLimit;
    data['utmostDuePeriodDebtAmount'] = utmostDuePeriodDebtAmount;
    data['isPayed'] = isPayed;
    return data;
  }

  final int tableId;
  final int fileId;
  final String issueDate;
  final String customerNumber;
  final String customerFirstName;
  final String customerLastName;
  final String cardPan;
  final String cycleStartDate;
  final String cycleEndDate;
  final String statementNumber;
  final String dueDate;
  final String cardHolderAddress;
  final String paymentCode;
  final String fileNumber;
  final int mainDebitAmount;
  final int feeTotalAmount;
  final int crInterestTotalAmount;
  final int currentTotalAmount;
  final int canInstAmount;
  final int canNotInstAmount;
  final int totalDebitAmount;
  final int totalInstallmentAmount;
  final int prevTotalInstallmentAmt;
  final int prevInstLtInterest;
  final int prevInstSurcharge;
  final int prevInstallmentDebit;
  final int prevNotInstallmentDebit;
  final int cardHolderPostalCode;
  final String cardHolderEmail;
  final String annualInterestRate;
  final String remainedCredit;
  final String creditLimit;
  final int utmostDuePeriodDebtAmount;
  final bool isPayed;
}

class CustomerCards {
  CustomerCards({
    @required this.cardInfoVOsField,
  });

  factory CustomerCards.fromJson(Map<String, dynamic> json) {
    final cardInfoVOsFields = <CardInfoVOsField>[];

    if (json['cardInfoVOsField'] != null) {
      final tmp = List<Map<String, dynamic>>.from(json['cardInfoVOsField'])
          .map((v) => CardInfoVOsField.fromJson(v));
      cardInfoVOsFields.addAll(tmp.toList());
    }

    return CustomerCards(
      cardInfoVOsField: cardInfoVOsFields,
    );
  }

  final List<CardInfoVOsField> cardInfoVOsField;
}

class CardInfoVOsField {
  CardInfoVOsField({
    @required this.pan,
    @required this.openToBuyField,
    @required this.productTypeField,
    @required this.stateField,
  });

  CardInfoVOsField.fromJson(Map<String, dynamic> json)
      : this(
          pan: json['cardPanField'],
          openToBuyField: json['openToBuyField'],
          productTypeField: json['productTypeField'],
          stateField: json['stateField'],
        );
  final String pan;
  final double openToBuyField;
  final int productTypeField;
  final int stateField;
}
