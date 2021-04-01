import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:latlng/latlng.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/bill_info.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/config.dart';
import 'package:novinpay/dialogs/account_type_dialog.dart';
import 'package:novinpay/encryption/rsa_helper.dart';
import 'package:novinpay/models/BillInquiryResponse.dart';
import 'package:novinpay/models/BillPaymentResponse.dart';
import 'package:novinpay/models/BillReportResponse.dart';
import 'package:novinpay/models/FollowSupportResponse.dart';
import 'package:novinpay/models/GetBannersResponse.dart';
import 'package:novinpay/models/GetBillInfoResponse.dart';
import 'package:novinpay/models/GetBillsResponse.dart';
import 'package:novinpay/models/GetInformationResponse.dart';
import 'package:novinpay/models/GetTicketTypeListResponse.dart';
import 'package:novinpay/models/GetTransactionListResponse.dart';
import 'package:novinpay/models/GetUserProfileResponse.dart';
import 'package:novinpay/models/InsertCustomerSuggestionResponse.dart';
import 'package:novinpay/models/InsertUserProfileResponse.dart';
import 'package:novinpay/models/ListOfTerminalNumbersResponse.dart';
import 'package:novinpay/models/LoanPaymentWithCardResponse.dart';
import 'package:novinpay/models/NetPackageConfirmResponse.dart';
import 'package:novinpay/models/NetPackageResponse.dart';
import 'package:novinpay/models/NormalTransferResponse.dart';
import 'package:novinpay/models/NotificationsInboxResponse.dart';
import 'package:novinpay/models/OpeningDepositResponse.dart';
import 'package:novinpay/models/PayaTransferResponse.dart';
import 'package:novinpay/models/PhoneInquiryResponse.dart';
import 'package:novinpay/models/RequestSupportResponse.dart';
import 'package:novinpay/models/SatnaTransferResponse.dart';
import 'package:novinpay/models/StatementResponse.dart';
import 'package:novinpay/models/TransactionReportResponse.dart';
import 'package:novinpay/models/application.dart';
import 'package:novinpay/models/authentication.dart';
import 'package:novinpay/models/bill_payment.dart';
import 'package:novinpay/models/bills.dart';
import 'package:novinpay/models/boom_market.dart';
import 'package:novinpay/models/can_pay.dart';
import 'package:novinpay/models/card_to_card.dart';
import 'package:novinpay/models/charge.dart';
import 'package:novinpay/models/charity.dart';
import 'package:novinpay/models/cheque.dart';
import 'package:novinpay/models/credit_card.dart';
import 'package:novinpay/models/diplomat.dart';
import 'package:novinpay/models/electric_bill.dart';
import 'package:novinpay/models/exchange.dart';
import 'package:novinpay/models/get_invitation_link_response.dart';
import 'package:novinpay/models/inquiry.dart';
import 'package:novinpay/models/insurance.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/novin_mall.dart';
import 'package:novinpay/models/novinpay.dart';
import 'package:novinpay/models/omid.dart';
import 'package:novinpay/models/profile.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/models/wallet.dart';
import 'package:novinpay/pages/insured_list_page.dart';
import 'package:novinpay/pages/insurer_information_page.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/services/platform_helper.dart';

final nh = NetworkHelper();

String get _mobileOs {
  final isNotWeb = getPlatform() != PlatformType.web;

  if (isNotWeb) {
    return 'Android';
  } else {
    return 'PWA';
  }
}

String get _clientPlatformType {
  //final isNotWeb = getPlatform() != PlatformType.web;
  return 'Android';
  // if (isNotWeb) {
  //   return 'Android';
  // } else {
  //   return 'PWA';
  // }
}

String get _mobileId => '123456';

int get _currencyId => 364;

String get _clientIP => '2.190.26.184';

String get _trackingNumber {
  final rnd = Random();
  final c = 8 + rnd.nextInt(4);

  final chars = <String>[];

  for (var i = 0; i < c; i++) {
    final n = rnd.nextInt(9);
    chars.add(n.toString());
  }

  return chars.join();
}

String get _mobileStan {
  final rnd = Random();
  return rnd.nextInt(999999).toString();
}

String get _bankId => 'BEGNIR';

String get _clientUserAgent =>
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.105 Safari/537.36';

String get _mobileDateTime =>
    DateFormat('yyyMMddHHmmss').format(DateTime.now());

String _getMobileOperatorName(MobileOperator op) {
  if (op == MobileOperator.mci) {
    return 'MCI';
  }
  if (op == MobileOperator.irancell) {
    return 'MTN';
  }
  if (op == MobileOperator.rightel) {
    return 'Rightel';
  }
  return '';
}

class _Response<T> {
  const _Response(this.statusCode, {this.content, this.error});

  const _Response.error() : this(-1, error: 'CONNECTION_ERROR');

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['content'] = content?.toString();
    data['error'] = error;
    return data;
  }

  /// The HTTP status code for this response.
  final int statusCode;

  /// Content returned from server.
  final T content;

  final String error;

  bool get isError => statusCode != 200;

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class NetworkHelper {
  factory NetworkHelper() => _singleton;

  NetworkHelper._internal();

  String _endpoint = '$end_point/api/v2/sun/';

  set endpoint(String value) {
    _endpoint = value;
  }

  final _streamController = StreamController<http.Response>();
  Stream<http.Response> _stream;

  static final NetworkHelper _singleton = NetworkHelper._internal();

  Stream<http.Response> get stream {
    _stream ??= _streamController.stream.asBroadcastStream();

    return _stream;
  }

  String avatarUrl() {
    return '${_endpoint}profile/profilepicture';
  }

  final novinPay = const _NovinPay();
  final billPayment = const _BillPayment();
  final irmci = const _IrMCI();
  final electricBill = const _ElectricBill();
  final topup = const _Topup();
  final canPay = const _CanPay();
  final shaparakHarim = const _ShaparakHarim();
  final boomMarket = const _BoomMarket();
  final finnoTech = const _FinnoTech();
  final netPackage = _NetPackage();
  final cardTransfer = const _CardTransfer();
  final mms = const _Mms();
  final creditCard = const _CreditCard();
  final mru = const _MostRecentlyUsed();
  final diplomat = const _Diplomat();
  final novinMall = const _NovinMall();
  final insuranceAgency = const _InsuranceAgency();
  final profile = const _Profile();
  final exchangeRate = const _ExchangeRate();
  final wallet = const _Wallet();
  final inquiry = const _Inquiry();
  final charity = const _Charity();
  final cheque = const _Cheque();

  // void setAuthToken(String jwt) {
  //   if (jwt == null) {
  //     return;
  //   }

  //   final decodedToken = JwtDecoder.decode(jwt);

  //   final expire = decodedToken['exp'];

  //   // final data = Jwt.parseJwt(jwt);
  //   // if (data != null && data.containsKey('exp') && data['exp'] is DateTime) {
  //   //   _authTokenExpire = data['exp'];
  //   // }
  //   _authToken = jwt;
  // }

  Future<void> _updateTokenIfNeeded() async {
    // final now = DateTime.now();
    // if (_authTokenExpire == null ||
    //     now.difference(_authTokenExpire).inMinutes >= 30) {
    //   final tokenResponse = await novinPay.getTokenByUsernamePassword(
    //       username: 'admin', password: '123456');
    //   if (tokenResponse?.content != null) {
    //     setAuthToken(tokenResponse.content.token);
    //     _authTokenExpire = now;
    //   }
    // }
  }

  String _getFullPath(String path) {
    return (_endpoint + path); //.replaceAll('//', '/');
  }

  Future<String> uploadMultipart({
    @required String path,
    @required String field,
    @required dynamic content,
    Map<String, String> headers,
  }) async {
    await _updateTokenIfNeeded();
    final fullpath = _getFullPath(path);

    final globalheaders = <String, String>{};
    globalheaders['APP_VERSION'] = app_version;
    final _authToken = (await appState.getJWT())?.value;

    if (_authToken != null && _authToken.isNotEmpty) {
      globalheaders[HttpHeaders.authorizationHeader] = 'Bearer $_authToken';
    }

    var request = http.MultipartRequest('POST', Uri.parse(fullpath));
    if (content is List<int>) {
      request.files.add(
          http.MultipartFile.fromBytes(field, content, filename: 'avatar.png'));
    } else if (content is Uint8List) {
      request.files.add(
          http.MultipartFile.fromBytes(field, content, filename: 'avatar.png'));
    } else if (content is String) {
      request.files.add(
        await http.MultipartFile.fromPath(field, content,
            filename: 'avatar.png'),
      );
    }

    request.headers.addAll(globalheaders);
    final res = await request.send();
    final json = await res.stream.bytesToString();
    return json;
  }

  Future<_Response<String>> getUtf8String(
      {@required String path, Map<String, String> headers}) async {
    await _updateTokenIfNeeded();
    final fullpath = _getFullPath(path);

    final globalheaders = <String, String>{};
    globalheaders['APP_VERSION'] = app_version;
    final _authToken = (await appState.getJWT())?.value;

    if (_authToken != null && _authToken.isNotEmpty) {
      globalheaders[HttpHeaders.authorizationHeader] = 'Bearer $_authToken';
    }

    if (headers != null) {
      headers.forEach((key, value) {
        globalheaders[key] = value;
      });
    }

    try {
      final data = await http.get(Uri.parse(fullpath), headers: globalheaders);
      _streamController.add(data);

      if (data.statusCode == 200) {
        return _Response(data.statusCode, content: utf8.decode(data.bodyBytes));
      } else {
        return _Response(data.statusCode, error: data.reasonPhrase);
      }
    } on Exception {
      return _Response.error();
    }
  }

  Future<_Response<String>> postUtf8String(
      {@required String path,
      @required String body,
      Map<String, String> headers}) async {
    await _updateTokenIfNeeded();
    final fullpath = _getFullPath(path);

    final globalheaders = <String, String>{};
    globalheaders['APP_VERSION'] = app_version;

    final _authToken = (await appState.getJWT())?.value;

    if (_authToken != null && _authToken.isNotEmpty) {
      globalheaders[HttpHeaders.authorizationHeader] = 'Bearer $_authToken';
    }

    if (headers != null) {
      headers.forEach((key, value) {
        globalheaders[key] = value;
      });
    }

    globalheaders['content-type'] = 'application/json';

    try {
      final data = await http.post(Uri.parse(fullpath),
          headers: globalheaders, body: body, encoding: utf8);
      _streamController.add(data);
      analytics.sendNetworkLogEvent(
          name: path.replaceAll('/', '_'), statusCode: data.statusCode);
      if (data.statusCode == 200) {
        return _Response(data.statusCode, content: utf8.decode(data.bodyBytes));
      } else {
        return _Response(data.statusCode, error: data.reasonPhrase);
      }
    } on Exception {
      return _Response.error();
    }
  }

  Future<_Response<Map<String, dynamic>>> getJSON<T>(
      {@required String path, Map<String, String> headers}) async {
    final data = await getUtf8String(path: path, headers: headers);
    if (data.statusCode == 200) {
      return _Response(data.statusCode, content: jsonDecode(data.content));
    }
    return _Response(data.statusCode, error: data.error);
  }

  Future<_Response<Map<String, dynamic>>> postJSON<T>(
      {@required String path,
      @required String body,
      bool encrypt = true,
      Map<String, String> headers}) async {
    var json = body;

    if (encrypt == true) {
      var databody = {
        'data': RSAHelper.encrypt(json),
      };

      json = jsonEncode(databody);
    }

    final data = await postUtf8String(path: path, body: json, headers: headers);
    if (data.statusCode == 200) {
      return _Response(data.statusCode, content: jsonDecode(data.content));
    }
    return _Response(data.statusCode, error: data.error);
  }
}

class _NetPackage {
  Future<Response<NetPackageResponse>> netPackage({
    @required int operatorId,
    @required int chargeType,
    @required String toChargeNumber,
  }) async {
    var data = {
      'operatorId': operatorId,
      'chargeType': chargeType,
      'toChargeNumber': toChargeNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'internetpackage/inquery', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = NetPackageResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<NetPackageConfirmResponse>> getConfirm({
    @required CardInfo cardInfo,
    @required int reserveNumber,
    @required int amount,
    @required int chargeType,
    @required int deviceType,
    @required String toChargeNumber,
    @required String additionalData,
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
      'mobileId': _mobileId,
      'reserveNumber': reserveNumber,
      'amount': '$amount',
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
      'chargeType': chargeType,
      'deviceType': deviceType,
      'toChargeNumber': toChargeNumber,
      'additionalData': additionalData,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'internetpackage/getconfirm', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = NetPackageConfirmResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Mms {
  const _Mms();

  Future<Response<ListOfTerminalNumbersResponse>> getTerminals() async {
    var data = {};

    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'mms/listofterminals', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = ListOfTerminalNumbersResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<RequestSupportResponse>> getRequestSupport(
      String requestDescription, int ticketTypeId, String terminalId) async {
    var data = {
      'requestDescription': requestDescription,
      'ticketTypeId': ticketTypeId,
      'terminalId': terminalId
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'mms/requestsupport', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RequestSupportResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetTicketTypeListResponse>> getTicketTypeList() async {
    var data = {};
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'mms/gettickettypelist', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetTicketTypeListResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<FollowSupportResponse>> getFollowSupport(
      String terminalId, String terminalFromDate, String terminalToDate) async {
    var data = {
      'terminalId': terminalId,
      'terminalFromDate': terminalFromDate,
      'terminalToDate': terminalToDate
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'mms/followsupport', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = FollowSupportResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetTransactionListResponse>> getTransactionList(
      String terminalId, String fromDate, String toDate) async {
    var data = {
      'terminalId': terminalId,
      'fromDate': fromDate,
      'toDate': toDate
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'mms/gettransactionlist', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetTransactionListResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _NovinPay {
  const _NovinPay();

  final application = const _Application();
}

class _Application {
  const _Application();

  Future<Response<GetRecommenderStateResponse>> getRecommenderState(
      {@required String mobileNumber}) async {
    var data = {'mobileNumber': mobileNumber, 'mobileOs': _mobileOs};
    var json = jsonEncode(data);
    final result = await nh.postJSON(
      path: 'application/getrecommenderstate',
      body: json,
      encrypt: false,
    );
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetRecommenderStateResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetInvitationLinkResponse>> getInvitationLink() async {
    var data = {};
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'application/getinvitationlink', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetInvitationLinkResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetListOfGuildsResponse>> getListOfGuilds() async {
    final result = await nh.getJSON(path: 'application/listofguilds');
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetListOfGuildsResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<CheckVersionResponse>> checkVersion({
    String appType = 'ANDROID',
    String fcmToken,
  }) async {
    var data = {
      'appType': appType,
      'mobileVersion': app_version,
    };

    if (fcmToken != null && fcmToken.isNotEmpty) {
      data['fcmToken'] = fcmToken;
    }

    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'application/checkversion', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CheckVersionResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<RequestTokenResponse>> requestToken({
    @required String mobileNumber,
  }) async {
    var data = {
      'mobileNumber': mobileNumber,
      'mobileId': _mobileId,
      'mobileDateTime': _mobileDateTime,
      'mobileOs': _mobileOs,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(
      path: 'application/requesttoken',
      body: json,
      encrypt: false,
    );

    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RequestTokenResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<VerifyTokenResponse>> verifyToken({
    @required String mobileNumber,
    @required String token,
    String recommender,
  }) async {
    var data = {
      'mobileNumber': mobileNumber,
      'mobileId': _mobileId,
      'token': token,
      'recommender': recommender,
      'mobileDateTime': _mobileDateTime,
      'mobileOs': _mobileOs,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(
      path: 'application/verifytoken',
      body: json,
      encrypt: false,
    );

    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = VerifyTokenResponse.fromJson(result.content);
    appState.setJWT(model.token);

    return Response(result.statusCode, content: model);
  }

  Future<Response<ForgetPassWordResponse>> forgetPassword(
      {@required String otp,
      @required String newPassword,
      @required String confirmNewPassword}) async {
    var data = {
      'otp': otp,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
      'mobileId': _mobileId,
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'profile/ForgotPassword', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = ForgetPassWordResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<StateResponse>> getState({@required String key}) async {
    var headers = {};

    final result = await nh.getJSON(
        path: 'application/appstate?key=$key', headers: headers);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = StateResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<StateResponse>> setState({
    @required String key,
    @required String value,
  }) async {
    var data = {
      'key': key,
      'value': value,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'application/appstate', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = StateResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<InsertCustomerSuggestionResponse>> insertCustomerSuggestion({
    @required String suggestion,
  }) async {
    var data = {
      'suggestion': suggestion,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(
        path: 'application/insertcustomersuggestion', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = InsertCustomerSuggestionResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetBannersResponse>> getBanners() async {
    final result = await nh.getJSON(path: 'application/getbanner');
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetBannersResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<NotificationsInboxResponse>> notificationsInbox(
      {@required String offset, @required String length}) async {
    var data = {
      'offset': offset,
      'length': length,
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'application/notificationsinbox', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = NotificationsInboxResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<TransactionReportResponse>> transactionReport({
    @required List<int> transactionType,
    String fromDate,
    String toDate,
    List<int> billTypeId,
    int status,
  }) async {
    transactionType ??= [];
    var data = {
      'fromDate': fromDate,
      'toDate': toDate,
      'transactionType': transactionType.map((e) => e).toList(),
      'billTypeId':
          (billTypeId != null) ? billTypeId.map((e) => e).toList() : null,
      'status': status,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(path: 'application/trxreport', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = TransactionReportResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Profile {
  const _Profile();

  Future<Response<LoginResponse>> login({@required String password}) async {
    var data = {
      'password': password,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(path: 'profile/Login', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = LoginResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<ActiveLoginResponse>> activeLogin(
      {@required String password, @required LoginType loginType}) async {
    var data = {'password': password, 'loginType': loginType.index};
    var json = jsonEncode(data);

    final result = await nh.postJSON(path: 'profile/ActiveLogin', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = ActiveLoginResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<ChangePasswordResponse>> changePassword(
      {@required String oldPassword,
      @required String newPassword,
      @required String confirmNewPassword}) async {
    var data = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'profile/ChangePassword', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = ChangePasswordResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<ActiveLoginResponse>> deActiveLogin(
      {@required String password}) async {
    var data = {'password': password};
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'profile/DeActiveLogin', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = ActiveLoginResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<InsertUserProfileResponse>> insertUserProfile({
    String firstName,
    String lastName,
    String email,
    String birthDate,
    String nationalNumber,
    LatLng location,
    int birthCityId,
    int addressCityId,
    String address,
  }) async {
    var data = <String, Object>{};

    if (firstName != null) {
      data['name'] = firstName;
    }
    if (lastName != null) {
      data['familyName'] = lastName;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (birthDate != null) {
      data['birthDate'] = birthDate;
    }

    if (location != null) {
      data['latitude'] = location.latitude;
      data['longitude'] = location.longitude;
    }

    if (nationalNumber != null) {
      data['nationalCode'] = nationalNumber;
    }

    if (birthCityId != null) {
      data['birthCityId'] = birthCityId;
    }

    if (addressCityId != null) {
      data['addressCityId'] = addressCityId;
    }

    if (address != null) {
      data['address'] = address;
    }

    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'profile/insertuserprofile', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = InsertUserProfileResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetUserProfileResponse>> getUserProfile() async {
    var data = {};
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'profile/getuserprofile', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetUserProfileResponse.fromJson(result.content);

    appState.profileData.addressCityId = model.addressCityId;
    appState.profileData.birthCityId = model.birthCityId;
    appState.profileData.birthDate = model.birthDate;
    appState.profileData.email = model.email;
    appState.profileData.firstName = model.firstName;
    appState.profileData.lastName = model.lastName;
    appState.profileData.location = model.location;
    appState.profileData.nationalNumber = model.nationalNumber;
    appState.profileData.address = model.address;
    appState.profileData.score = model.score;

    return Response(result.statusCode, content: model);
  }

  Future<Uint8List> getUserImage() async {
    try {
      final _authToken = (await appState.getJWT())?.value;

      final result = await http.get(
        Uri.parse(nh.avatarUrl()),
        headers: {'Authorization': 'Bearer $_authToken'},
      );
      if (result.statusCode == 200) {
        return result.bodyBytes;
      } else {
        return null;
      }
    } catch (exp) {
      //
    }

    return null;
  }
}

class _MostRecentlyUsed {
  const _MostRecentlyUsed();

  Future<Response<MruListResponse>> mruList({@required MruType mruType}) async {
    var data = {
      'mruType': mruType.index,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'mostrecentlyused/mrulist', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = MruListResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<AddMruResponse>> addMru(
      {@required MruType type,
      @required String title,
      @required String value,
      String expDate}) async {
    var data = {
      'mruType': type.index,
      'title': title,
      'mruValue': value,
      'expDate': expDate
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'mostrecentlyused/addmru', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = AddMruResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<UpdateMru>> updateMru(
      {@required int id,
      @required String title,
      @required String mruValue,
      String expDate}) async {
    var data = {
      'expDate': expDate,
      'id': id,
      'title': title,
      'mruValue': mruValue,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'mostrecentlyused/updatemru', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = UpdateMru.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<DeleteMru>> deleteMru({
    @required int id,
  }) async {
    var data = {
      'id': id,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'mostrecentlyused/deletemru', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = DeleteMru.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _ShaparakHarim {
  const _ShaparakHarim();

  Future<Response<RequestOtpResponse>> requestOtp({
    @required CardInfo cardInfo,
    @required int amount,
    TransactionType transactionType,
    String acceptorName,
    String acceptorId,
  }) async {
    var data = {
      'trackingNumber': _trackingNumber,
      'secureData': cardInfo.generateSecure(),
      'amount': amount,
    };

    if (transactionType != null) {
      data['transactionType'] = transactionType.index;
    }
    if (acceptorName != null) {
      data['acceptorName'] = acceptorName;
    }
    if (acceptorId != null) {
      data['acceptorId'] = acceptorId;
    }

    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'shaparakharim/requestotp', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RequestOtpResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<RequestOtpResponse>> requestOtpPardakhtSaz({
    @required CardInfo cardInfo,
    @required int amount,
  }) async {
    var data = {
      'trackingNumber': _trackingNumber,
      'secureData': cardInfo.generateSecure(),
      'amount': amount,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(
        path: 'shaparakharim/requestotppardakhtsaz', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RequestOtpResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _BillPayment {
  const _BillPayment();

  Future<Response<BillInquiryResponse>> billInquiry({
    @required String billId,
    @required String paymentId,
  }) async {
    var data = {
      'billId': '$billId',
      'paymentId': '$paymentId',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'billpayment/billinquiry', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = BillInquiryResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<BillPaymentResponse>> billPayment({
    @required CardInfo cardInfo,
    @required BillInfo billInfo,
    String stanMobile = '12',
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
      'mobileId': _mobileId,
      'billId': billInfo.billId,
      'paymentId': billInfo.paymentId,
      'amount': '${billInfo.amount}',
      'stanMobile': stanMobile,
      'mobileDateTime': _mobileDateTime,
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'billpayment/billpayment', body: json);

    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = BillPaymentResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  // Future<Response<CheckForPaidBillResponse>> checkForPaidBill({
  //   @required String billId,
  //   @required String paymentId,
  //
  //   ,
  // }) async {
  //   var data = {
  //     'billId': billId,
  //     'paymentId': paymentId,
  //     'mobileNumber': mobileNumber,
  //     'mobileOs': mobileOs,
  //   };
  //   var json = jsonEncode(data);

  //   final result = await _nh
  //       .postJSON(path: 'billpayment/checkforpaidbill', body: json);
  //   final model = CheckForPaidBillResponse.fromJson(result.content);
  //   return Response(result.statusCode, content: model);
  // }

  Future<Response<BillReportResponse>> billReport({
    @required List<PaymentReport> reportType,
  }) async {
    reportType ??= [];
    var data = {
      'reportType': reportType.map((e) => e.index).toList(),
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'application/transactionreport', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = BillReportResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _IrMCI {
  const _IrMCI();

  Future<Response<GetBillInfoResponse>> getBillInfo({
    @required String mobileNumber,
  }) async {
    var data = {
      'cellPhoneNumber': mobileNumber,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(path: 'irmci/getbillinfo', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetBillInfoResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _ElectricBill {
  const _ElectricBill();

  Future<Response<RegisterPaymentResponse>> registerPayment({
    @required int billId,
    @required int paymentId,
    @required int bankCode,
    @required int refCode,
    @required int amount,
  }) async {
    var data = {
      'BILL_IDENTIFIER': billId,
      'payment_identifier': paymentId,
      'payDate': _mobileDateTime,
      'bankCode': bankCode,
      'refCode': refCode,
      'amount': amount,
      'chanelType': 59,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'electricbillapi/registerpayment', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RegisterPaymentResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetBillsResponse>> getBills() async {
    var data = <String, String>{};
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'electricbillapi/getbills', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetBillsResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<AddBillResponse>> addBill({
    @required String nationalCode,
    @required String email,
    @required int billIdentifier,
    @required String billTitle,
    @required bool viaSms,
    @required bool viaPrint,
    @required bool viaEmail,
    @required bool viaApp,
  }) async {
    var data = {
      'nationalCode': nationalCode,
      'email': email,
      'billModel': {
        'BILL_IDENTIFIER': billIdentifier,
        'billTitle': billTitle,
        'viaSms': viaSms,
        'viaPrint': viaPrint,
        'viaEmail': viaEmail,
        'viaApp': viaApp,
      }
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'electricbillapi/addbill', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = AddBillResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<RemoveBillResponse>> removeBill({
    @required int billId,
    @required String nationalCode,
  }) async {
    var data = {
      'BILL_IDENTIFIER': billId.toString(),
      'nationalCode': nationalCode
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'electricbillapi/removebill', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RemoveBillResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetBranchDebitResponse>> getBranchDebit({
    @required int billId,
  }) async {
    var data = {'BILL_IDENTIFIER': billId};
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'electricbillapi/getbranchdebit', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetBranchDebitResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<BranchDataResponse>> getBranchData({
    @required int billId,
  }) async {
    var data = {'BILL_IDENTIFIER': billId};
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'electricbillapi/getbranchdata', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = BranchDataResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Topup {
  const _Topup();

  Future<Response<MobileTopUpResponse>> mobileTopUp({
    @required CardInfo cardInfo,
    @required int amount,
    @required MobileOperator operatorName,
    @required String destinationMobileNumber,
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
      'mobileId': _mobileId,
      'amount': '$amount',
      'mobileStan': _mobileStan,
      'operatorName': _getMobileOperatorName(operatorName),
      'destinationMobileNumber': destinationMobileNumber,
      'mobileDateTime': _mobileDateTime,
    };
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'mobiletopup/mobiletopup', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = MobileTopUpResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<MobilePinResponse>> mobilePin({
    @required CardInfo cardInfo,
    @required int amount,
    @required MobileOperator operatorName,
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
      'mobileId': _mobileId,
      'amount': '$amount',
      'mobileStan': _mobileStan,
      'operatorName': _getMobileOperatorName(operatorName),
      'mobileDateTime': _mobileDateTime,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'mobiletopup/mobilepin', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = MobilePinResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _CanPay {
  const _CanPay();

  Future<Response<PhoneInquiryResponse>> phoneInquiry({
    @required String phoneNumber,
  }) async {
    var data = {
      'phoneNumber': phoneNumber,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'canpay/phoneinquiry', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PhoneInquiryResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<RahvarInquiryResponse>> rahvarInquiry({
    @required String code,
  }) async {
    var data = {
      'code': code,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'canpay/rahvarinquiry', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RahvarInquiryResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _BoomMarket {
  const _BoomMarket();

  Future<Response<OpeningDepositResponse>> openingDeposit({
    @required int depositBranchCode,
    @required int withdrawableAmount,
    @required String withdrawableDeposit,
    @required AccountType accountType,
    @required int interestSettlementDay,
  }) async {
    final bankLogin = await appState.getBankLoginInfo();

    var data = {
      'stateId': bankLogin.state,
      'bank': _bankId,
      'depositBranchCode': depositBranchCode,
      'withdrawableAmount': withdrawableAmount,
      'withdrawableDeposit': withdrawableDeposit,
      'sameSignatureDepositNumber': '',
      'customerNumber': '',
      'depositType': accountType.code,
      'depositGroup': accountType.group,
      'mobile': '',
      'email': '',
      'fax': '',
      'addressId': '',
      'reportDate': '',
      'depositDurationUnit': '',
      'investmentDeposit': {
        'interestSettlementDay': interestSettlementDay,
        'interestToDepositNumber': interestSettlementDay.toString()
      },
      'savingDeposit': {
        'lifeCycleMonth': 0,
        'paymentDepositNumber': '',
        'duration': 0,
        'paymentAmount': 0
      },
    };

    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'boommarket/openingdeposit', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = OpeningDepositResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetInformationBodyResponse>> getInformation() async {
    var data = {};
    var json = jsonEncode(data);

    final result =
        await nh.postJSON(path: 'boommarket/getinformation', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetInformationBodyResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GenerateBankUrlResponse>> generateBankUrl({
    @required String returnUrl,
    @required String nationalCode,
  }) async {
    var data = {
      'returnUrl': returnUrl,
      'bankSwift': _bankId,
      'nationalCode': nationalCode,
      'clientIpAddress': _clientIP,
      'clientPlatformType': _clientPlatformType,
      'clientDeviceId': _clientIP,
      'clientUserAgent': _clientUserAgent,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'boommarket/generatebankurl', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GenerateBankUrlResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<BoomTokenResponse>> boomToken({
    @required int state,
    @required String code,
  }) async {
    var data = {
      'state': state,
      'code': code,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'boommarket/boomtoken', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = BoomTokenResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<PayaTransferResponse>> payaTransfer({
    @required String sourceDepositNumber,
    @required String ibanNumber,
    @required String ownerName,
    @required String description,
    @required int amount,
  }) async {
    final bankLogin = await appState.getBankLoginInfo();

    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
      'sourceDepositNumber': sourceDepositNumber,
      'ibanNumber': ibanNumber?.replaceAll('-', ''),
      'ownerName': ownerName,
      'description': description != null && description.isNotEmpty
          ? description
          : 'سوپر اپ نوین (سان)',
      'amount': amount,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'boommarket/payatransfer', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PayaTransferResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<SatnaTransferResponse>> satnaTransfer({
    @required String sourceDepositNumber,
    @required String receiverName,
    @required String receiverFamily,
    @required String destinationIbanNumber,
    @required String description,
    @required int amount,
  }) async {
    final bankLogin = await appState.getBankLoginInfo();

    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
      'amount': amount,
      'sourceDepositNumber': sourceDepositNumber,
      'receiverName': receiverName,
      'receiverFamily': receiverFamily,
      'destinationIbanNumber': destinationIbanNumber?.replaceAll('-', ''),
      'description': description != null && description.isNotEmpty
          ? description
          : 'سوپر اپ نوین (سان)',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'boommarket/satnatransfer', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = SatnaTransferResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<NormalTransferResponse>> normalTransfer({
    @required String sourceDeposit,
    @required String destinationDeposit,
    @required String sourceComment,
    @required String destinationComment,
    @required int amount,
  }) async {
    final bankLogin = await appState.getBankLoginInfo();
    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
      'sourceDeposit': sourceDeposit,
      'destinationDeposit': destinationDeposit,
      'sourceComment': sourceComment,
      'destinationComment': destinationComment,
      'amount': amount,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'boommarket/normaltransfer', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = NormalTransferResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetIbanResponse>> getIban({
    @required String deposit,
  }) async {
    var data = {
      'clientIpAddress': _clientIP,
      'clientPlatformType': _clientPlatformType,
      'clientDeviceId': _clientIP,
      'clientUserAgent': _clientUserAgent,
      'bankId': _bankId,
      'deposit': deposit,
    };
    var json = jsonEncode(data);

    final result = await nh.postJSON(path: 'boommarket/getiban', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetIbanResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetDepositResponse>> getDeposit({
    @required String iban,
  }) async {
    var data = {
      'iban': iban?.replaceAll('-', ''),
      'clientIpAddress': _clientIP,
      'ClientPlatformType': _clientPlatformType,
      'clientDeviceId': _clientIP,
      'clientUserAgent': _clientUserAgent,
      'bankId': _bankId,
    };

    var json = jsonEncode(data);

    final result = await nh.postJSON(path: 'boommarket/getdeposit', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetDepositResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<StatementResponse>> statement({
    @required String depositNumber,
  }) async {
    final bankLogin = await appState.getBankLoginInfo();
    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
      'depositNumber': depositNumber,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'boommarket/statement', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = StatementResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<LoanPaymentWithDepositResponse>> loanPaymentWithDeposit({
    @required String loanNumber,
    @required String paymentMethod,
    @required String customDepositNumber,
    @required int amount,
  }) async {
    final bankLogin = await appState.getBankLoginInfo();
    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
      'loanNumber': loanNumber,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'customDepositNumber': customDepositNumber,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(
        path: 'boommarket/loanpaymentwithdeposit', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = LoanPaymentWithDepositResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<LoanPaymentWithCardResponse>> loanPaymentWithCard({
    @required CardInfo cardInfo,
    @required String loanNumber,
    @required int amount,
  }) async {
    var data = {
      'bankId': _bankId,
      'secureData': cardInfo.generateSecure(),
      'loanNumber': loanNumber,
      'applyAmount': amount,
      'clientIpAddress': _clientIP,
      'clientPlatformType': _clientPlatformType,
      'clientDeviceId': _mobileId,
      'clientUserAgent': _mobileId,
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'boommarket/loanpaymentwithcard', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = LoanPaymentWithCardResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<PayaReportResponse>> payaReport(
      {@required String sourceDepositIban}) async {
    final bankLogin = await appState.getBankLoginInfo();

    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
      'sourceDepositIban': sourceDepositIban
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'boommarket/payareport', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PayaReportResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<SatnaReportResponse>> satnaReport() async {
    final bankLogin = await appState.getBankLoginInfo();

    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'boommarket/satnareport', body: json);

    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = SatnaReportResponse.fromJson(result.content);

    return Response(result.statusCode, content: model);
  }

  Future<Response<StatementReportResponse>> statementReport(
      {@required String depositNumber}) async {
    final bankLogin = await appState.getBankLoginInfo();

    var data = {
      'stateId': bankLogin.state,
      'bankId': _bankId,
      'depositNumber': depositNumber,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'boommarket/statement', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = StatementReportResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _FinnoTech {
  const _FinnoTech();

  Future<Response<CardToIbanResponse>> cardToIban({
    @required CardInfo cardInfo,
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'finnotech/cardtoiban', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CardToIbanResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _CardTransfer {
  const _CardTransfer();

  Future<Response<CardInquiryResponse>> cardInquiry({
    @required CardInfo cardInfo,
    @required int amount,
    @required String dateTime,
    @required String mobileStan,
  }) async {
    var data = {
      'SecureData': cardInfo.generateSecure(),
      'MobileId': _mobileId,
      'Amount': '$amount',
      'MobileStan': mobileStan,
      'MobileDateTime': dateTime,
      'MobileIp': _clientIP,
      'MobileBrand': '',
      'MobileBrandModel': '',
      'MobileOsVersion': '',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'cardtransfer/cardholderinquiry', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CardInquiryResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<CardTransferResponse>> cardTransfer({
    @required CardInfo cardInfo,
    @required int amount,
    @required String switchStan,
    @required String holderInquiryDateTime,
    @required String additionalData,
    @required String sourceCardTitle,
    @required String destinationCardITitle,
    @required bool saveCard,
    @required String description,
    @required String mobileStan,
  }) async {
    var data = {
      'SecureData': cardInfo.generateSecure(),
      'MobileId': _mobileId,
      'Amount': '$amount',
      'MobileStan': mobileStan,
      'SwitchStan': switchStan,
      'HolderInquiryDateTime': holderInquiryDateTime,
      'AdditionalData': additionalData,
      'MobileDateTime': _mobileDateTime,
      'MobileIp': _clientIP,
      'isUseful': saveCard,
      'MobileBrand': '',
      'MobileBrandModel': '',
      'MobileOsVersion': '',
      'SourceCardTitle': sourceCardTitle,
      'DestinationCardITitle': destinationCardITitle,
      'description': description,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'cardtransfer/cardtransfer', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CardTransferResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _CreditCard {
  const _CreditCard();

  Future<Response<CrediCardPaymentResponse>> creditCardPayment({
    @required PaymentMethod paymentType,
    @required CardInfo cardInfo,
    @required int amount,
    @required String cardNumber,
    @required String fullNamePayer,
    @required int installmentCount,
    @required String customerNumber,
    String statementNumber,
  }) async {
    var data = {
      'paymentType': paymentType.index,
      'secureData': cardInfo.generateSecure(),
      'amount': amount.toString(),
      'mobileStan': _mobileStan,
      'mobileId': _mobileId,
      'mobileDateTime': _mobileDateTime,
      'cardNumber': cardNumber,
      'fullNamePayer': fullNamePayer,
      'statementNumber': statementNumber,
      'installmentCount': installmentCount.toString(),
      'customerNumber': customerNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/creditcardpayment', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CrediCardPaymentResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GeneralInformationResponse>> getGeneralInformation(
      {@required String customerNumber}) async {
    var data = {
      'customerNumber': customerNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/generalinformation', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GeneralInformationResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetPaymentTypeResponse>> getPaymentType({
    @required String customerNumber,
  }) async {
    var data = {
      'customerNumber': customerNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/getpaymenttype', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetPaymentTypeResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<PaymentInfoResponse>> getPaymentInfo({
    @required String cardNumber,
  }) async {
    var data = {
      'cardNumber': cardNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/getpaymentinfo', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PaymentInfoResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<CardLastStatementResponse>> getCardLastStatement({
    @required String cardNumber,
    @required bool loadTransactions,
  }) async {
    var data = {
      'cardNumber': cardNumber,
      'loadTransactions': loadTransactions,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/getcardlaststatement', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CardLastStatementResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<StatementPaymentResponse>> statementPayment({
    @required String cardNumber,
    @required String refNumber,
    @required int payAmount,
    @required String fullNamePayer,
    @required String statementNumber,
    @required int installmentCount,
  }) async {
    var data = {
      'cardNumber': cardNumber,
      'refNumber': refNumber,
      'payAmount': '$payAmount',
      'fullNamePayer': fullNamePayer,
      'statementNumber': statementNumber,
      'installmentCount': '$installmentCount',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/statementpayment', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = StatementPaymentResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<ListOfBillsResponse>> getListOfBills({
    @required String customerNumber,
  }) async {
    var data = {
      'customerNumber': customerNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/getlistofbills', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = ListOfBillsResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<PaymentOrTransactionResponse>> getPaymentOrTransaction({
    @required String customerNumber,
  }) async {
    var data = {
      'customerNumber': customerNumber,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(
        path: 'creditcard/getpaymentortransaction', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PaymentOrTransactionResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetCustomerInfoResponse>> getCustomerInfo({
    @required String customerNumber,
  }) async {
    var data = {
      'customerNumber': customerNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/getcustomerinfo', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetCustomerInfoResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<PaymentListResponse>> getPaymentList({
    @required String customerNumber,
  }) async {
    var data = {
      'customerNumber': customerNumber,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/paymentlist', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PaymentListResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Diplomat {
  const _Diplomat();

  Future<Response<AddDiplomatCardResponse>> addDiplomatCard({
    @required CardInfo cardInfo,
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/adddiplomatcard', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = AddDiplomatCardResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<RemoveDiplomatCardResponse>> deleteDiplomatCard({
    @required int id,
  }) async {
    var data = {
      'id': id,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/removediplomatcard', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = RemoveDiplomatCardResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetDiplomatCardsResponse>> getDiplomatCards() async {
    var data = {};
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/getdiplomatcards', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetDiplomatCardsResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<DiplomatCardTransactionsResponse>> getDiplomatTransactions({
    @required CardInfo cardInfo,
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(
        path: 'creditcard/diplomatcardtransactions', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = DiplomatCardTransactionsResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<GetOmidMerchantsResponse>> getOmidMerchants({
    @required int stateId,
    @required int cityId,
    @required int guildId,
  }) async {
    var data = <String, Object>{};

    if (stateId != null) {
      data['stateId'] = stateId;
    }

    if (cityId != null) {
      data['cityId'] = cityId;
    }

    if (guildId != null) {
      data['guildId'] = guildId;
    }

    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'creditcard/omidmerchant', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetOmidMerchantsResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _NovinMall {
  const _NovinMall();

  Future<Response<GetUrlResponse>> getUrl() async {
    var data = {};
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'novinmall/geturl', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = GetUrlResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _InsuranceAgency {
  const _InsuranceAgency();

  Future<Response<CreateOrderResponse>> CreateOrder(
      OrderCreator orderCreator, List<InsuredModel> insuredModels) async {
    List<Map> jsonInsuredModel = insuredModels != null
        ? insuredModels.map((i) => i.toJson()).toList()
        : null;
    var data = {
      'orderModel': {
        'name': orderCreator?.name,
        'lastName': orderCreator?.lastName,
        'mobile': orderCreator?.mobile,
        'nationalCode': orderCreator?.nationalCode,
        'birthDate': orderCreator?.birthDate,
        'items': jsonInsuredModel
      },
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'insuranceagency/createorder', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CreateOrderResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<InsurancePaymentResponse>> InsuranceAgencyPayment(
      CardInfo cardInfo, int amount, String orderToken) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
      'mobileId': _mobileId,
      'amount': amount,
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
      'orderToken': orderToken,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(
        path: 'insuranceagency/insuranceagencypayment', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = InsurancePaymentResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<PlanAgeResponse>> planAge({@required int age}) async {
    var data = {
      'age': age,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'insuranceagency/planage', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PlanAgeResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<PlanDetailResponse>> planDetail({@required int id}) async {
    var data = {
      'id': id,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'insuranceagency/plandetail', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = PlanDetailResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _ExchangeRate {
  const _ExchangeRate();

  Future<Response<ExchangeRateResponse>> exchangeRate() async {
    var data = {};
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'exchangerate/exchangerate', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = ExchangeRateResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Wallet {
  const _Wallet();

  Future<Response<WalletBillPaymentResponse>> billPayment(
      {@required String billId,
      @required String paymentId,
      @required int billAmount,
      @required int balance}) async {
    var data = {
      'billId': billId,
      'paymentId': paymentId,
      'billAmount': billAmount.toString(),
      'balance': balance.toString(),
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
      'mobileId': _mobileId,
      'serviceId': '000032',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletbillpayment', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletBillPaymentResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletTopupChargeResponse>> topup(
      {@required int chargeAmount,
      @required MobileOperator operatorName,
      @required int balance,
      @required String destinationMobileNumber}) async {
    var data = {
      'chargeAmount': chargeAmount.toString(),
      'operatorName': _getMobileOperatorName(operatorName),
      'balance': balance.toString(),
      'destinationMobileNumber': destinationMobileNumber,
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
      'mobileId': _mobileId,
      'serviceId': '000030',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewallettopupcharge', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletTopupChargeResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletPinChargeResponse>> pinCharge(
      {@required int chargeAmount,
      @required MobileOperator operatorName,
      @required int balance}) async {
    var data = {
      'chargeAmount': chargeAmount.toString(),
      'operatorName': _getMobileOperatorName(operatorName),
      'balance': balance.toString(),
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
      'mobileId': _mobileId,
      'serviceId': '000038',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletpincharge', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletPinChargeResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletInternetPackageResponse>> internetPackage(
      {@required int deviceType,
      @required String additionalData,
      @required String toChargeNumber,
      @required int reserveNumber,
      @required int chargeType,
      @required int amount,
      @required int balance}) async {
    var data = {
      'mobileId': _mobileId,
      'serviceId': '000039',
      'balance': balance.toString(),
      'deviceType': deviceType,
      'additionalData': additionalData,
      'toChargeNumber': toChargeNumber,
      'reserveNumber': reserveNumber,
      'chargeType': chargeType,
      'amount': amount.toString(),
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletinternetpackage', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletInternetPackageResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletActivateResponse>> activate() async {
    var data = {
      'currencyId': _currencyId,
      'mobileId': _mobileId,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'ewallet/activate', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletActivateResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGetBalanceResponse>> getBalance() async {
    var data = {};
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'ewallet/getbalance', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGetBalanceResponse.fromJson(result.content);
    if (model.balance != null) {
      appState.wallet.balance = model.balance.toInt();
    }
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletChargeResponse>> eWalletCharge(
      {@required CardInfo cardInfo, @required int amount}) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
      'mobileId': _mobileId,
      'mobileStan': _mobileStan,
      'serviceId': '000010',
      'mobileDateTime': _mobileDateTime,
      'amount': '$amount',
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'ewallet/ewalletcharge', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletChargeResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletTransferToWalletResponse>> eWalletTransferToEWallet(
      {@required String toMobileNumber,
      @required int amount,
      @required int balance}) async {
    var data = {
      'toMobileNumber': toMobileNumber,
      'balance': balance.toString(),
      'amount': '$amount',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewallettransfertoewallet', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletTransferToWalletResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletTransferToWalletResponse>> eWalletTransferToIban(
      {@required String iban,
      @required int amount,
      @required int balance}) async {
    var data = {
      'iban': iban,
      'balance': balance.toString(),
      'amount': '$amount',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewallettransfertoiban', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletTransferToWalletResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupAddNewResponse>> walletGroupAddNew(
      {@required String groupName, @required String description}) async {
    var data = {
      'groupName': groupName,
      'description': description,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupaddnew', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupAddNewResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupUpdateResponse>> walletGroupUpdate(
      {@required int id,
      @required String groupName,
      @required String description}) async {
    var data = {
      'id': id,
      'groupName': groupName,
      'description': description,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupupdate', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupUpdateResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupRemoveResponse>> walletGroupRemove(
      {@required int id}) async {
    var data = {
      'id': id,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupremove', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupRemoveResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupListResponse>> walletGroupList() async {
    var data = {};
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgrouplist', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupListResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupUserAddNew>> walletGroupUserAddNew(
      {@required String name,
      @required String family,
      @required String customerId,
      @required int groupId}) async {
    var data = {
      'name': name,
      'family': family,
      'customerId': customerId,
      'groupId': groupId,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupuseraddnew', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupUserAddNew.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupUserUpdate>> walletGroupUserUpdate(
      {@required String name,
      @required String family,
      @required String customerId,
      @required int groupId}) async {
    var data = {
      'name': name,
      'family': family,
      'customerId': customerId,
      'groupId': groupId,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupuserupdate', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupUserUpdate.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupChargeResponse>> eWalletGroupUserCharge(
      WalletGroupUserChargeRequestModel walletGroupUserChargeRequestModel,
      List<WalletGroupUserChargeRequestModel> models) async {
    List<Map> jsonModel =
        models != null ? models.map((i) => i.toJson()).toList() : null;
    var data = {
      'ewalletGroupUserChargeRequest': jsonModel,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupusercharge', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupChargeResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupChargeResponse>> eWalletGroupCharge(
      {@required int amount, @required int groupId}) async {
    var data = {
      'groupId': groupId,
      'amount': '$amount',
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupcharge', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupChargeResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupUserListResponse>> eWalletGroupUserList(
      {@required int groupId}) async {
    var data = {
      'groupId': groupId,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(
        path: 'ewallet/ewallet/ewalletgroupuserlist', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupUserListResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<WalletGroupUserRemove>> eWalletGroupUserRemove(
      {@required int groupId, @required String customerId}) async {
    var data = {
      'groupId': groupId,
      'customerId': customerId,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'ewallet/ewalletgroupuserremove', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = WalletGroupUserRemove.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Inquiry {
  const _Inquiry();

  Future<Response<IbanValidationResponse>> ibanValidation(
      {@required String iban}) async {
    var data = {
      'iban': iban,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'inquiry/ibanvalidation', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = IbanValidationResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Charity {
  const _Charity();

  Future<Response<CharityInfoResponse>> getCharityInfo() async {
    var data = <String, String>{};
    var json = jsonEncode(data);

    final result = await nh.postJSON(path: 'charity/charityInfo', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CharityInfoResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }

  Future<Response<CharityPaymentResponse>> charityPayment({
    @required CardInfo cardInfo,
    @required int amount,
    @required String charityServiceId,
  }) async {
    var data = {
      'secureData': cardInfo.generateSecure(),
      'mobileId': _mobileId,
      'charityServiceId': charityServiceId,
      'amount': '$amount',
      'mobileStan': _mobileStan,
      'mobileDateTime': _mobileDateTime,
    };
    var json = jsonEncode(data);
    final result =
        await nh.postJSON(path: 'internetpackage/getconfirm', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = CharityPaymentResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}

class _Cheque {
  const _Cheque();

  Future<Response<BackChequesResponse>> getBackCheques(
      {@required String nationalNumber}) async {
    var data = {
      'nationalCode': nationalNumber,
    };
    var json = jsonEncode(data);
    final result = await nh.postJSON(path: 'finnotech/backcheques', body: json);
    if (result.isError) {
      return Response(result.statusCode, error: result.error);
    }
    final model = BackChequesResponse.fromJson(result.content);
    return Response(result.statusCode, content: model);
  }
}
