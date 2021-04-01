import 'package:novinpay/repository/response.dart';

class RequestOtpResponse extends ResponseBase {
  RequestOtpResponse({
    @required this.trackingNumber,
    @required this.requestId,
    @required this.registrationDate,
    @required List<DeliveryChannel> deliveryChannels,
    @required List<Error> errors,
    @required bool status,
    @required String description,
    @required String mobileNumber,
    @required String errorMessage,
  }) : super(
            status: status,
            description: description,
            mobileNumber: mobileNumber,
            errorMessage: errorMessage) {
    this.deliveryChannels.addAll(deliveryChannels);
    this.errors.addAll(errors);
  }

  factory RequestOtpResponse.fromJson(Map<String, dynamic> json) {
    var deliveryChannels = <DeliveryChannel>[];
    var errors = <Error>[];

    if (json.containsKey('deliveryChannels')) {
      final dc = List<Map<String, dynamic>>.from(json['deliveryChannels']);
      deliveryChannels = dc.map((e) => DeliveryChannel.fromJson(e)).toList();
    }
    if (json.containsKey('errors')) {
      final dc = List<Map<String, dynamic>>.from(json['errors']);
      errors = dc.map((e) => Error.fromJson(e)).toList();
    }

    return RequestOtpResponse(
      trackingNumber: json['trackingNumber'],
      requestId: json['requestId'],
      registrationDate: json['registrationDate'],
      deliveryChannels: deliveryChannels,
      errors: errors,
      status: json['status'],
      description: json['description'],
      mobileNumber: json['mobileNumber'],
      errorMessage: json['errorMessage'],
    );
  }

  final String trackingNumber;
  final String requestId;
  final String registrationDate;
  final List<DeliveryChannel> deliveryChannels = [];
  final List<Error> errors = [];
}

class DeliveryChannel {
  DeliveryChannel({
    @required this.channelType,
    @required this.channelAdditionalData,
  });

  factory DeliveryChannel.fromJson(Map<String, dynamic> json) {
    return DeliveryChannel(
      channelType: json['channelType'],
      channelAdditionalData: json['channelAdditionalData'],
    );
  }

  int channelType;
  String channelAdditionalData;
}

class Error {
  Error({
    @required this.errorCode,
    @required this.errorDescription,
    @required this.referenceName,
    @required this.originalValue,
    @required this.extraData,
  });

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      errorCode: json['errorCode'],
      errorDescription: json['errorDescription'],
      referenceName: json['referenceName'],
      originalValue: json['originalValue'],
      extraData: json['extraData'],
    );
  }

  // @override
  // String toString() {
  //   return jsonEncode(toJson());
  // }
  final int errorCode;
  final String errorDescription;
  final String referenceName;
  final String originalValue;
  final String extraData;
}

enum TransactionType {
  buy,
  balance,
  statement,
  bill,
  charge,
  otpConfirm,
}
