import 'package:flutter/material.dart';
import 'package:novinpay/barcode_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

Future<BarcodeData> showBarcodeScanDialog(BuildContext context) async {
  final allow = await Permission.camera.request();
  if (allow == PermissionStatus.granted) {
    String code = await scanner.scan();
    return BarcodeData('code_128', code);
  } else {
    return null;
  }
}
