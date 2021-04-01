import 'package:novinpay/card_info.dart';

class PayInfo {
  PayInfo({this.cardInfo, this.type});

  PayInfo.normal(this.cardInfo) : type = PaymentType.normal;

  PayInfo.wallet()
      : type = PaymentType.wallet,
        cardInfo = null;
  final PaymentType type;
  final CardInfo cardInfo;
}

enum PaymentType { normal, wallet }
