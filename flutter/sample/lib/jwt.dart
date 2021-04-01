import 'dart:convert';
import 'dart:typed_data';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:xml/xml.dart';

const _publicKey =
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/authentication';

const _mobilephone =
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/mobilephone';

class Jwt {
  Jwt._({
    this.value,
    this.expires,
    this.notBefore,
    this.publicKey,
    this.mobile,
  });

  factory Jwt.fromString(String jwt) {
    final json = JwtDecoder.decode(jwt);

    final String publicKey = json[_publicKey];
    final String mobile = json[_mobilephone];

    final int notBefore = json['nbf'];
    final int expires = json['exp'];

    final nbf = DateTime.fromMillisecondsSinceEpoch(notBefore * 1000);
    final exp = DateTime.fromMillisecondsSinceEpoch(expires * 1000);

    final pub = _createPublicKey(publicKey);

    return Jwt._(
      value: jwt,
      mobile: mobile,
      expires: exp,
      notBefore: nbf,
      publicKey: pub,
    );
  }

  final DateTime notBefore;
  final DateTime expires;
  final RSAPublicKey publicKey;
  final String value;
  final String mobile;
}

RSAPublicKey _createPublicKey(String publicKeyXml) {
  final document = XmlDocument.parse(publicKeyXml);
  final rootNode = document.getElement('RSAKeyValue');
  final modulusNode = rootNode.getElement('Modulus');
  final exponentNode = rootNode.getElement('Exponent');

  final modulus = _base64ToBigInt(modulusNode.text);
  final exponent = _base64ToBigInt(exponentNode.text);

  return RSAPublicKey(modulus, exponent);
}

String _toHex(Uint8List bytes) {
  List<String> c = [];
  for (int bx = 0, cx = 0; bx < bytes.length; ++bx, ++cx) {
    final b0 = bytes[bx] >> 4;
    c.add(String.fromCharCode(b0 > 9 ? b0 + 0x37 + 0x20 : b0 + 0x30));

    final b1 = bytes[bx] & 0x0F;
    c.add(String.fromCharCode(b1 > 9 ? b1 + 0x37 + 0x20 : b1 + 0x30));
  }

  return c.join();
}

BigInt _base64ToBigInt(String base64) {
  final bytes = base64Decode(base64);
  final hex = _toHex(bytes);
  return BigInt.tryParse(hex, radix: 16);
}
