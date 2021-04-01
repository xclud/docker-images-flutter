import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/payment_method_dialog.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/pages/webview_page.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/webview/webviewhelper.dart';
import 'package:novinpay/widgets/custom_bottom_sheet.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/new_custom_bottom_sheet.dart';
import 'package:novinpay/widgets/pna_persian_datepicker/pna_persian_datepicker.dart';
import 'package:persian/persian.dart';
import 'package:url_launcher/url_launcher.dart';

final _numberFormat = NumberFormat('###,###,###,###', 'en_US');
const String lrm = '\u200E';
const String rlm = '\u200F';

extension ColorExtension on Color {
  Color darken([double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}

String separateThousand(int amount) {
  return _numberFormat.format(amount);
}

String protectCardNumber(String value, [bool withDashes = true]) {
  if (value == null || value.isEmpty) {
    return null;
  }
  value = value.withEnglishNumbers();
  value = value.replaceAll('-', '');

  if (value.length != 16) {
    return null;
  }

  final start4 = value.substring(0, 4);
  final next2 = value.substring(4, 6);
  final last4 = value.substring(12);

  if (withDashes) {
    return '$start4-$next2**-****-$last4';
  } else {
    return '$start4$next2******$last4';
  }
}

String formatCardNumber(String value, [bool addlrm = false]) {
  if (value == null || value.isEmpty) {
    return null;
  }

  value = value.replaceAll('-', '');
  value =
      value.replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)}-');

  if (value.endsWith('-')) {
    value = value.substring(0, value.length - 1);
  }
  if (addlrm == true) {
    return '$lrm$value';
  }

  return value;
}

String toRials(int amount, [bool isLrm = false]) {
  if (amount == null) return null;
  final a = _numberFormat.format(amount);

  if (isLrm) {
    return '$lrm$a ریال'.withPersianNumbers();
  } else {
    return '$rlm$a ریال'.withPersianNumbers();
  }
}

String toTomans(int amount) {
  final a = _numberFormat.format(amount);
  return '$rlm$a تومان'.withPersianNumbers();
}

List<TextInputFormatter> digitsOnly() {
  return [FilteringTextInputFormatter.digitsOnly];
}

List<TextInputFormatter> digitsAndHyphen() {
  return [FilteringTextInputFormatter.allow(RegExp(r'[\d-]+'))];
}

List<TextInputFormatter> iban() {
  return [FilteringTextInputFormatter.allow(RegExp(r'[irIR\d-]+'))];
}

TextInputFormatter pan() {
  return FilteringTextInputFormatter.allow(RegExp(r'[\d-\*]+'));
}

void _hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
  FocusScope.of(context).requestFocus(FocusNode());
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  //WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
}

void hideKeyboard(BuildContext context) {
  _hideKeyboard(context);

  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    _hideKeyboard(context);
  });
}

Future<void> showFailedTransaction(BuildContext context, String description,
    String stan, String rrn, String transactionType, int amount) {
  hideKeyboard(context);

  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            'تراکنش ناموفق',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(transactionType, textAlign: TextAlign.center),
                Space(2),
                if (amount != null)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.cyan.shade50,
                    ),
                    child: DualListTile(
                      start: Text('مبلغ:'),
                      end: Text(toRials(amount)),
                    ),
                  ),
                Space(2),
                if (description != null && description.isNotEmpty)
                  CustomText(description),
                if (stan != null && stan.isNotEmpty)
                  DualListTile(
                    start: Text('شماره پیگیری:'),
                    end: Text(stan?.withPersianNumbers() ?? ''),
                  ),
                if (rrn != null && rrn.isNotEmpty)
                  DualListTile(
                    start: Text('شماره مرجع:'),
                    end: Text(rrn?.withPersianNumbers() ?? ''),
                  ),
                DualListTile(
                  start: Text('پشتیبانی:'),
                  end: Text('${lrm}021-48320000'.withPersianNumbers()),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          actions: [
            RaisedButton(
              elevation: 0,
              color: Colors.cyan.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(strings.action_ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

bool showConnectionError(
  BuildContext context,
  Response response,
) {
  if (response.isError) {
    if (!response.isExpired) {
      ToastUtils.showCustomToast(context, strings.connectionError,
          Image.asset('assets/ic_error.png'), 'خطا');
    }
    return false;
  }
  return true;
}

bool showError<T extends ResponseBase>(
    BuildContext context, Response<T> response) {
  if (response.isError) {
    if (!response.isExpired) {
      ToastUtils.showCustomToast(
        context,
        strings.connectionError,
        Image.asset('assets/ic_error.png'),
      );
    }
    return false;
  }

  if (response.content.status != true) {
    ToastUtils.showCustomToast(
      context,
      response.content.description,
      Image.asset('assets/ic_error.png'),
    );
    return false;
  }
  return true;
}

/// show a draggable custom bottom sheet
Future<T> showCustomDraggableBottomSheet<T>({
  @required BuildContext context,
  @required ScrollableWidgetBuilder builder,
  Widget title,
  double initialChildSize = 0.95,
  double maxChildSize = 0.95,
  double minChildSize = 0.6,
}) {
  hideKeyboard(context);

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      maxChildSize: maxChildSize,
      minChildSize: minChildSize,
      builder: (context, scrollController) {
        return CustomBottomSheet(
          title: title,
          child: builder.call(context, scrollController),
        );
      },
    ),
  );
}

/// show a simple custom bottom sheet
Future<T> showCustomBottomSheet<T>({
  @required BuildContext context,
  @required Widget child,
  Widget title,
  double maxHeight,
}) {
  hideKeyboard(context);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (context) => NewCustomBottomSheet(
      child: child,
      title: title,
      childMaxHeight: maxHeight,
    ),
  );
}

Future<PayInfo> showPaymentBottomSheet({
  @required BuildContext context,
  @required Widget title,
  @required int amount,
  @required TransactionType transactionType,
  @required String acceptorName,
  @required String acceptorId,
  bool enableWallet = false,
  bool showWallet = true,
  List<Widget> children = const [],
  PayCallback onPay,
  //double heightFactor = 0.75,
}) {
  hideKeyboard(context);

  return Navigator.of(context).push<PayInfo>(
    MaterialPageRoute(
        builder: (context) => PaymentWithWalletDialog(
              title: title,
              amount: amount,
              enableWallet: enableWallet,
              showWallet: showWallet,
              children: children,
              transactionType: transactionType,
              acceptorName: acceptorName,
              acceptorId: acceptorId,
              onPay: onPay,
            ),
        fullscreenDialog: true),
  );
}

String removeDash(String card) {
  if (card == null) {
    return null;
  }
  return card.replaceAll('-', '');
}

class Utils {
  static bool checkPhoneNum(String phone) {
    if (!phone.contains(RegExp('(98|0)?9?(0|1|2|3|9)?()\\d{8}'))) {
      return false;
    }
    if (phone.length != 11) {
      return false;
    }
    return true;
  }

  static Color getOperatorInactiveColor(MobileOperator op) {
    switch (op) {
      case MobileOperator.mci:
        return colors.mci_inactive;
        break;
      case MobileOperator.irancell:
        return colors.irancell_inactive;
        break;
      case MobileOperator.rightel:
        return colors.rightel_inactive;
        break;
    }

    return null;
  }

  static Color getOperatorActiveColor(MobileOperator op) {
    switch (op) {
      case MobileOperator.mci:
        return colors.mci_active;
        break;
      case MobileOperator.irancell:
        return colors.irancell_active;
        break;
      case MobileOperator.rightel:
        return colors.rightel_active;
        break;
    }

    return null;
  }

  static Color getOperatorCardColor(MobileOperator op) {
    switch (op) {
      case MobileOperator.mci:
        return colors.mci_card;
        break;
      case MobileOperator.irancell:
        return colors.irancell_card;
        break;
      case MobileOperator.rightel:
        return colors.rightel_card;
        break;
    }

    return null;
  }

  static Color getOperatorTextColor(MobileOperator op) {
    switch (op) {
      case MobileOperator.mci:
        return colors.mci_text;
        break;
      case MobileOperator.irancell:
        return colors.irancell_text;
        break;
      case MobileOperator.rightel:
        return colors.rightel_text;
        break;
    }

    return null;
  }

  static String getOperatorName(MobileOperator op) {
    if (op == null) {
      return null;
    }

    switch (op) {
      case MobileOperator.mci:
        return 'همراه اول';
        break;
      case MobileOperator.irancell:
        return 'ایرانسل';
        break;
      case MobileOperator.rightel:
        return 'رایتل';
        break;
    }

    return null;
  }

  static String getOperatorLogo(MobileOperator op) {
    if (op == null) {
      return null;
    }

    switch (op) {
      case MobileOperator.mci:
        return 'assets/logo/mci.png';
        break;
      case MobileOperator.irancell:
        return 'assets/logo/mtn.png';
        break;
      case MobileOperator.rightel:
        return 'assets/logo/rightel.png';
        break;
    }

    return null;
  }

//  static String getBankName(String cardNumber) {
//    String cardNumber1 = cardNumber.substring(0, 6);
//    switch (cardNumber1) {
//      case '627412':return'';
//      break;
//      case '627381':;
//      break;
//      case '505785':;
//      break;
//
//
//    }
//  }

  static MobileOperator getOperatorType(String phoneNumber) {
    if (phoneNumber == null || phoneNumber.length < 4) {
      return null;
    }

    final str = phoneNumber.substring(0, 4).withEnglishNumbers();

    if (_mcis.contains(str)) {
      return MobileOperator.mci;
    }

    if (_irancells.contains(str)) {
      return MobileOperator.irancell;
    }

    if (_rightels.contains(str)) {
      return MobileOperator.rightel;
    }

    return null;
  }

  static String getBankLogo(String pan) {
    if (pan == null || pan.isEmpty) {
      return null;
    }
    pan = pan.withEnglishNumbers();
    pan = pan.replaceAll('-', '');
    if (pan.length < 6) {
      return null;
    }

    final bin = pan.substring(0, 6);

    switch (bin) {
      case '627412':
        return 'assets/banks/en.png';

      case '627381':
        return 'assets/banks/ansar.png';

      case '505785':
        return 'assets/banks/iranzamin.png';

      case '622106':
        return 'assets/banks/parsian.png';

      case '627884':
        return 'assets/banks/parsian.png';

      case '639194':
        return 'assets/banks/parsian.png';

      case '502229':
        return 'assets/banks/pasargad.png';

      case '639347':
        return 'assets/banks/pasargad.png';

      case '627760':
        return 'assets/banks/postbank.png';

      case '627353':
        return 'assets/banks/tejarat.png';

      case '585983':
        return 'assets/banks/tejarat.png';

      case '502908':
        return 'assets/banks/toseetaavon.png';

      case '207177':
        return 'assets/banks/toseesaderat.png';

      case '627648':
        return 'assets/banks/toseesaderat.png';

      case '636949':
        return 'assets/banks/hekmat.png';

      case '502938':
        return 'assets/banks/dey.png';

      case '589463':
        return 'assets/banks/refah.png';

      case '621986':
        return 'assets/banks/saman.png';

      case '589210':
        return 'assets/banks/sepah.png';

      case '639607':
        return 'assets/banks/sarmaye.png';

      case '639346':
        return 'assets/banks/sina.png';

      case '504706':
        return 'assets/banks/shahr.png';

      case '603769':
        return 'assets/banks/saderat.png';

      case '627961':
        return 'assets/banks/sanatmadan.png';

      case '502910':
        return 'assets/banks/kaarafarin.png';

      case '627488':
        return 'assets/banks/kaarafarin.png';

      case '603770':
        return 'assets/banks/keshavarzi.png';

      case '505416':
        return 'assets/banks/gardeshgari.png';

      case '628023':
        return 'assets/banks/maskan.png';

      case '610433':
        return 'assets/banks/mellat.png';

      case '504172':
        return 'assets/banks/resalat.png';

      case '991975':
        return 'assets/banks/mellat.png';

      case '603799':
        return 'assets/banks/melli.png';

      case '505801':
        return 'assets/banks/kosar.png';

      case '639599':
        return 'assets/banks/ghavaamin.png';

      case '636214':
        return 'assets/banks/ayande.png';

      case '606256':
        return 'assets/banks/melal.png';

      case '507677':
        return 'assets/banks/noor.png';

      case '606373':
        return 'assets/banks/gharzolhasanemehr.png';

      case '585947':
        return 'assets/banks/khavarmiane.png';
    }

    return null;
  }

  static String getBankName(String pan) {
    if (pan == null || pan.isEmpty) {
      return null;
    }
    pan = pan.withEnglishNumbers();
    pan = pan.replaceAll('-', '');
    if (pan.length < 6) {
      return null;
    }

    final first6 = pan.substring(0, 6);

    switch (first6) {
      case '603799':
        return 'ملی';
      case '589210':
        return 'سپه';
      case '627648':
        return 'توسعه صادرات';
      case '627961':
        return 'صنعت و معدن';
      case '603770':
        return 'کشاورزی';
      case '628023':
        return 'مسکن';
      case '627760':
        return 'پست بانک';
      case '627412':
        return 'اقتصاد نوین';
      case '622106':
        return 'پارسیان';
      case '502229':
        return 'پاسارگاد';
      case '639347':
        return 'پاسارگاد';
      case '627488':
        return 'کارآفرین';
      case '621986':
        return 'سامان';
      case '639346':
        return 'سینا';
      case '639607':
        return 'سرمایه';
      case '636214':
        return 'آینده';
      case '502806':
        return 'شهر';
      case '504706':
        return 'شهر';
      case '502938':
        return 'دی';
      case '603769':
        return 'صادرات';
      case '610433':
        return 'ملت';
      case '627353':
        return 'تجارت';
      case '585983':
        return 'تجارت';
      case '589463':
        return 'رفاه';
      case '627381':
        return 'انصار';
      case '504172':
        return 'قرض الحسنه رسالت';
      case '505801':
        return 'کوثر';
      case '636949':
        return 'حکمت ایرانیان';
      case '639599':
        return 'قوامین';
      case '606256':
        return 'موسسه مالی اعتباری ملل';
      case '507677':
        return 'موسسه مالی اعتباری نور';
      case '606373':
        return 'قرض الحسنه مهر ایران';
      case '585947':
        return 'خاورمیانه';
    }
    return '';
  }

  static String getSourceName(String source) {
    if (source == 'NovinPay') {
      return 'سان';
    } else {
      return 'وب سایت';
    }
  }

  static String getCurrentDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('HH:mm:ss');
    final String formatted = formatter.format(now);
    final nowPersian = now.toPersian().toString().withEnglishNumbers();

    return '$formatted $nowPersian';
  }

  static String jalaliToGregorian(int y, int m, int d, [String separator]) {
    int gY;
    if (y > 979) {
      gY = 1600;
      y -= 979;
    } else {
      gY = 621;
    }

    var days = (365 * y) +
        ((y / 33).floor() * 8) +
        (((y % 33) + 3) / 4) +
        78 +
        d +
        (((m < 7) ? (m - 1) * 31 : (((m - 7) * 30) + 186)));
    gY += 400 * (days ~/ 146097);
    days %= 146097;
    if (days.floor() > 36524) {
      gY += 100 * (--days ~/ 36524);
      days %= 36524;
      if (days >= 365) days++;
    }
    gY += 4 * (days ~/ 1461);
    days %= 1461;
    gY += (days - 1) ~/ 365;

    if (days > 365) days = (days - 1) % 365;
    var gD = (days + 1).floor();
    var montDays = [
      0,
      31,
      (((gY % 4 == 0) && (gY % 100 != 0)) || (gY % 400 == 0)) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    int i = 0;
    for (; i <= 12; i++) {
      if (gD <= montDays[i]) break;
      gD -= montDays[i];
    }
    separator ??= '';

    return '$gY$separator$i$separator$gD';
  }

  static String getBillName(int billTypeId) {
    switch (billTypeId) {
      case 0:
        return 'خدمات عمومی';
      case 1:
        return 'آب';
      case 2:
        return 'برق';
      case 3:
        return 'گاز';
      case 4:
        return 'تلفن ثابت';
      case 5:
        return 'تلفن همراه';
      case 6:
        return 'شهرداری1';
      case 7:
        return 'شهرداری2';
      case 9:
        return 'عوارض و جرايم';
    }
    return '';
  }

  static String getChargeTypeName(String chargeType) {
    if (chargeType == 'TOPUP') {
      return 'شارز مستقیم';
    } else if (chargeType == ' PIN') {
      return 'شارژ با پین کد';
    } else {
      return '';
    }
  }

  static String getPaymentSourceName(String source) {
    if (source == 'SUN') {
      return 'سان';
    } else {
      return 'وب سایت';
    }
  }

  static void customLaunch(BuildContext context, String url, {String title}) {
    final platform = getPlatform();
    if (platform != PlatformType.web) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => WebViewPage(
                  title: title,
                  url: url,
                )),
      );
    } else {
      launch(url);
    }
  }

  static String getCurrencyName(String value) {
    switch (value) {
      case 'EUR':
        return strings.eur;
      case 'USD':
        return strings.usd;
      case 'AED':
        return strings.aed;
      case 'RUB':
        return strings.rub;
    }
    return '';
  }
}

bool get isSecureEnvironment {
  final uri = getCurrentURI();

  if (uri == null) return true;
  if (uri.hasScheme && uri.isScheme('https')) {
    return true;
  }

  return false;
}

bool get isNotWeb {
  final platform = getPlatform();
  return platform != PlatformType.web;
}

bool get isWeb {
  final platform = getPlatform();
  return platform == PlatformType.web;
}

bool isBirthDayValid(String value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  value = value.withEnglishNumbers();
  if (!RegExp('^1[3,4]\\d\\d\\/\\d\\d\\/\\d\\d\$').hasMatch(value)) {
    return false;
  }
  var parts = value.split('/');
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);

  final now = DateTime.now().toPersian();
  if (year > now.year) {
    return false;
  }
  if (year == now.year && month > now.month) {
    return false;
  }
  if (year == now.year && month == now.month && day > now.day) {
    return false;
  }
  return true;
}

int getAgeFromBirthDate(String birthDate) {
  if (birthDate == null) {
    return null;
  }
  String bd = birthDate.withEnglishNumbers();
  List<String> bds = bd.split('/');
  if (bds.length != 3) {
    return null;
  }
  int year = int.tryParse(bds[0]);
  PersianDate now = DateTime.now().toPersian();
  if (now.year < year) {
    return null;
  }
  return now.year - year;
}

int getBankCode(String cardNumber) {
  if (cardNumber == null || cardNumber.isEmpty) {
    return null;
  }
  cardNumber = cardNumber.withEnglishNumbers();
  cardNumber = cardNumber.replaceAll('-', '');
  if (cardNumber.length < 6) {
    return null;
  }

  final first6 = cardNumber.substring(0, 6);

  switch (first6) {
    case '627412':
      return 55;

    case '627381':
      return 63;

    case '505785':
      return 69;

    case '622106':
      return 54;

    case '627884':
      return 54;

    case '639194':
      return 54;

    case '502229':
      return 57;

    case '639347':
      return 57;

    case '627760':
      return 21;

    case '627353':
      return 18;

    case '585983':
      return 18;

    case '502908':
      return 22;

    case '207177':
      return 20;

    case '627648':
      return 20;

    case '636949':
      return 65;

    case '502938':
      return 66;

    case '589463':
      return 13;

    case '621986':
      return 56;

    case '589210':
      return 15;

    case '639607':
      return 58;

    case '639346':
      return 59;

    case '504706':
      return 61;

    case '603769':
      return 20;

    case '627961':
      return 11;

    case '502910':
      return 53;

    case '627488':
      return 53;

    case '603770':
      return 16;

    case '628023':
      return 14;

    case '610433':
      return 12;

    case '991975':
      return 12;

    case '603799':
      return 17;

    case '639599':
      return 52;
  }

  return null;
}

final _mcis = [
  '0910',
  '0911',
  '0912',
  '0913',
  '0914',
  '0915',
  '0916',
  '0917',
  '0918',
  '0919',
  '0990',
  '0991',
  '0992',
  '0993',
  '0994',
];

final _irancells = [
  '0930',
  '0933',
  '0935',
  '0936',
  '0937',
  '0938',
  '0939',
  '0901',
  '0902',
  '0903',
  '0904',
  '0905',
  '0941',
];

final _rightels = [
  '0920',
  '0921',
  '0922',
];

// //ANARESTAN------
// 0994
// //ANARESTAN------
// //TELEKISH-------
// 0934
// //TELEKISH-------
// //APTEL----------
// *** 099910
// *** 099911
// *** 099913
// //APTEL----------
// //AZARTEL--------
// *** 099914
// //AZARTEL--------
// //SAMANTEL-------
// *** 099999
// *** 099998
// *** 099997
// *** 099996
// //SAMANTEL-------
// //LOTUSTEL-------
// *** 09990
// //LOTUSTEL-------
// //SHATELMOBILE---
// *** 099810
// *** 099811
// *** 099812
// *** 099814
// *** 099815
// //SHATELMOBILE---
// //ARIANTEL-------
// *** 09998
// //ARIANTEL-------
Widget getPersianDatePicker(TextEditingController _controller) {
  return PersianDatePicker(
    monthSelectionHighlightBackgroundColor: colors.primaryColor,
    yearSelectionHighlightBackgroundColor: colors.primaryColor,
    monthSelectionBackgroundColor: colors.greyColor.shade100,
    currentDayBackgroundColor: colors.primaryColor.shade200,
    currentDayBorderColor: colors.primaryColor,
    selectedDayBackgroundColor: colors.primaryColor,
    weekCaptionsBackgroundColor: colors.primaryColor,
    headerBackgroundColor: colors.primaryColor,
    headerTextStyle: TextStyle(
      color: colors.greyColor.shade100,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
    monthSelectionHighlightTextStyle: TextStyle(
      fontSize: 16,
      color: colors.greyColor.shade100,
      fontWeight: FontWeight.bold,
    ),
    yearSelectionHighlightTextStyle: TextStyle(
      fontSize: 16,
      color: colors.greyColor.shade100,
      fontWeight: FontWeight.bold,
    ),
    selectedDayTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: colors.greyColor.shade100,
    ),
    currentDayTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
    disabledDayTextStyle: TextStyle(
      fontSize: 16,
      color: colors.greyColor.shade700,
    ),
    disabledDayBackgroundColor: null,
    maxDatetime: DateTime.now().toString(),
    dayBlockRadius: 8,
    fontFamily: 'Shabnam',
    farsiDigits: true,
    showGregorianDays: false,
    controller: _controller,
  ).init();
}
