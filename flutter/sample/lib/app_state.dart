import 'package:flutter/foundation.dart';
import 'package:novinpay/encryption/rsa_helper.dart';
import 'package:novinpay/jwt.dart';
import 'package:novinpay/models/credit_card.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/profile_info.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:shared_preferences/shared_preferences.dart';

class _AppState {
  GeneralInformationResponse generalInfo;
  GetCustomerInfoResponse creditCardCustomerInformation;
  PaymentInfoResponse paymentInfo;
  GetCustomerInfoResponse customerInfo;
  List<String> supportedBins;
  List<String> loginType;
  String passWord;
  final profileData = ProfileData();
  final wallet = _WalletState();
  Jwt _cachedJwt;
  bool isActiveWallet = false;
  List<CardInfoVOsField> creditCards;

  String novinMallLink;
  String nationalCode;
  bool creditCardLogin;
  bool creditCardHasData;

  bool isSendAppOpen = false;

  Future<String> getPhoneNumber() async {
    final jwt = await getJWT();

    return jwt?.mobile;
  }

  Jwt getJWTSync() {
    return _cachedJwt;
  }

  Future<Jwt> getJWT() async {
    final pref = await SharedPreferences.getInstance();

    final value = pref.getString('APPSTATE_JWT');

    if (value == null) {
      _cachedJwt = null;
      return null;
    }

    final jwt = Jwt.fromString(value);

    if (jwt.expires.isBefore(DateTime.now())) {
      _cachedJwt = null;
      await setJWT(null);
      return null;
    }

    _cachedJwt = jwt;
    publicKey = jwt.publicKey;

    return jwt;
  }

  /// android
  Future<String> getPassword() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(strings.PREF_PASSWORD);
  }

  /// android
  Future<void> setFinger(bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(strings.PREF_FINGERPRINT, value);
  }

  /// android
  Future<bool> getFinger() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(strings.PREF_FINGERPRINT);
  }

  Future<void> setDisableDialog(bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('DISABLE', value);
  }

  Future<bool> getDisableDialog() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool('DISABLE');
  }

  /// check user set password or not (android, pwa)
  Future<bool> checkUserHasPassword() async {
    final _pref = await SharedPreferences.getInstance();

    /// check has password
    if (_pref.containsKey(strings.PREF_HAS_PASSWORD) &&
        _pref.getBool(strings.PREF_HAS_PASSWORD)) {
      return true;

      /// check password
    } else if (_pref.containsKey(strings.PREF_PASSWORD) &&
        _pref.getString(strings.PREF_PASSWORD).isNotEmpty) {
      return true;
    }
    return false;
  }

  /// set password in android
  /// set hasPassword in pwa & android
  Future<void> setUserPassword(String _password) async {
    final _pref = await SharedPreferences.getInstance();
    if (getPlatform() != PlatformType.web) {
      _pref.setString(strings.PREF_PASSWORD, _password);
    }
    if (_password != null && _password.isNotEmpty) {
      _pref.setBool(strings.PREF_HAS_PASSWORD, true);
    } else {
      _pref.setBool(strings.PREF_HAS_PASSWORD, false);
    }
  }

  Future<void> setJWT(String value) async {
    final pref = await SharedPreferences.getInstance();

    if (value != null && value.isNotEmpty) {
      final jwt = Jwt.fromString(value);
      _cachedJwt = jwt;
      publicKey = jwt.publicKey;
    }

    await pref.setString('APPSTATE_JWT', value);
  }

  Future<BankLoginInfo> getBankLoginInfo() async {
    final pref = await SharedPreferences.getInstance();
    final state = pref.getInt('APPSTATE_BANKLOGIN_STATE');
    final code = pref.getString('APPSTATE_BANKLOGIN_CODE');
    final expires = pref.getDouble('APPSTATE_BANKLOGIN_EXPIRES');

    return BankLoginInfo(
      state: state,
      code: code,
      expires: expires,
    );
  }

  Future<void> setBankLoginInfo(int state, String code, double expires) async {
    final pref = await SharedPreferences.getInstance();
    if (state == null || code == null || expires == null) {
      await pref.remove('APPSTATE_BANKLOGIN_STATE');
      await pref.remove('APPSTATE_BANKLOGIN_CODE');
      await pref.remove('APPSTATE_BANKLOGIN_EXPIRES');
      return;
    }

    await pref.setInt('APPSTATE_BANKLOGIN_STATE', state);
    await pref.setString('APPSTATE_BANKLOGIN_CODE', code);
    await pref.setDouble('APPSTATE_BANKLOGIN_EXPIRES', expires);
  }

  Future<void> setCreditCardLoginInfo(bool isLogin, String nationalCode) async {
    final pref = await SharedPreferences.getInstance();
    if (isLogin == null || nationalCode == null) {
      await pref.remove('APPSTATE_CREDIT_CARD_LOGIN');
      await pref.remove('APPSTATE_NATIONAL_CODE');
      return;
    }

    await pref.setBool('APPSTATE_CREDIT_CARD_LOGIN', isLogin);
    await pref.setString('APPSTATE_NATIONAL_CODE', nationalCode);
  }

  Future<String> getNationalCode() async {
    final pref = await SharedPreferences.getInstance();
    final nationalCode = pref.getString('APPSTATE_NATIONAL_CODE');
    return nationalCode;
  }

  Future<bool> getCreditCardLoginInfo() async {
    final pref = await SharedPreferences.getInstance();
    final isLogin = pref.getBool('APPSTATE_CREDIT_CARD_LOGIN');
    return isLogin;
  }
}

final appState = _AppState();

class _WalletState extends ChangeNotifier {
  int _balance;

  int get balance => _balance;

  set balance(int value) {
    _balance = value;
    notifyListeners();
  }
}
