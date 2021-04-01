import 'dart:convert';

import 'package:novinpay/encryption/rsa_helper.dart';

abstract class CardInfoBase {
  String generateSecure();
}

class Pan {
  Pan(this.value);

  final String value;

  bool isValid() {
    String pan = value;

    if (pan == null || pan.isEmpty) {
      return false;
    }

    if (pan.contains('*')) {
      return true;
    }

    pan = pan.replaceAll('-', '').replaceAll(' ', '');

    if (pan.length < 16) {
      return false;
    }

    var sum = 0;
    for (int i = 0; i < pan.length; i++) {
      var x = int.tryParse(pan[i]);

      if (i % 2 == 0) {
        x *= 2;
        if (x >= 9) {
          x -= 9;
        }
      }

      sum += x;
    }

    return sum % 10 == 0;
  }
}

class CardInfo implements CardInfoBase {
  CardInfo({
    this.pan,
    this.pin,
    this.cvv,
    this.expire,
    this.destinationPan,
    this.saveCard,
    this.sourceCardId,
    this.destinationCardId,
  });

  final String pan;
  final String pin;
  final String cvv;
  final String expire;
  final String destinationPan;
  final int sourceCardId;
  final int destinationCardId;
  final bool saveCard;

  @override
  String generateSecure() {
    final secureData = <String, Object>{};

    secureData['pin'] = pin;
    secureData['cvv2'] = cvv;

    if (expire != null && expire.isNotEmpty) {
      secureData['expDate'] = expire.replaceAll('/', '');
    }

    if (sourceCardId != null && sourceCardId > 0) {
      secureData['sourceCardId'] = sourceCardId;
    } else if (pan != null && pan.isNotEmpty) {
      secureData['pan'] = pan.replaceAll('-', '');
    }

    if (destinationCardId != null && destinationCardId > 0) {
      secureData['destinationCardId'] = destinationCardId;
    } else if (destinationPan != null && destinationPan.isNotEmpty) {
      secureData['destinationPan'] = destinationPan.replaceAll('-', '');
    }

    var x = jsonEncode(secureData);
    var sec = RSAHelper.encrypt(x);

    return sec;
  }
}
