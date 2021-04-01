import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

RSAPublicKey publicKey;

class RSAHelper {
//   static const String _publicKeyXml = '''
//  <?xml version="1.0" encoding="UTF-8"?>
//  <RSAKeyValue>
//     <Modulus>wnu+gd09uIKQ+9D5vcBIQuhtz6xaECEmtBhY+vp+iqlI/VJBA8Oc18KWj6gHSi1ynFdzP2coGL+F9GpVmc4MdpNT3ILNP43YLfek3SpYeBJlW8cIZr6Wivy6en1J6wnM8p4ckdHh99r0jtES8TB7N35RTKhXTFfLqg6Etwt3lzHP4JOpgoExLxip0kQke8z2VIPgPhULHxM8UhepJh23jymv1qqJEobS6vMneyv9d8CnWN28ldfurawgptQh1D+guZ7cEH6NzomDeZj/11QfEfm8QPialy3gkJbkpd+Z5Pj5FmxvlF52DTLijXNjVxQcIMV0BBbbdx4QAvUagx+KMQ==</Modulus>
//     <Exponent>AQAB</Exponent>
//  </RSAKeyValue>
//        ''';
//  static const String _publicKeyXml = '''
//<?xml version="1.0" encoding="UTF-8"?>
//<RSAKeyValue>
//   <Modulus>tsnmXInKZRCPEHBym96BhewfAsKYwGmvCfhhyntjuFYF5/s1UfkEDsRB+k/NRk8a0duJuZK7vhulze/ZdUq9e80ZgoK4s8E8eNgtoJIQpYdSwOdm7Y3Hh5K4UooVUKS+B8atAiioNEsuXZZNDxotVM26r/EZzWg0L6xUaVTVIHB9IUNckD9rt4rjvZu9B1G31j1wke9dsSxJ8Rlr3M9Kvg/V9w4TB3pzfjKwSLMipjgekXYsWa+QwgRBiZ+QaQ22cmmtxQg7FVlE+l+sJyfXypKj0Xtglp3OdZ3Kv9pW2xyJTwQFW9q5h6R6TWlQxkV+CyVJOYbavmi2kyBio8vOkQ==</Modulus>
//   <Exponent>AQAB</Exponent>
//</RSAKeyValue>
//      ''';

  static String encrypt(String text) {
    //assert(publicKey != null);
    if (publicKey == null) {
      return null;
    }

    final encrypter = Encrypter(
      RSA(
        publicKey: publicKey,
        //privateKey: privKey,
        encoding: RSAEncoding.OAEP,
      ),
    );

    final utf = utf8.encoder.convert(text);

    const segmentSize = 200;
    final segmentCount = (utf.length / segmentSize.toDouble()).ceil();
    final segmentsEncrypted = <String>[];

    for (int i = 0; i < segmentCount; i++) {
      final segment = utf.skip(i * segmentSize).take(segmentSize);
      final encrypted = encrypter.encryptBytes(segment.toList());
      segmentsEncrypted.add(encrypted.base64);
    }

    final all = segmentsEncrypted.join('||');

    return all;
  }
}
