import 'dart:html' as html;
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:novinpay/services/platform_helper.dart';

PlatformType getPlatform() {
  return PlatformType.web;
}

Future<bool> showOtaUpdateDialog({
  @required String link,
  BuildContext context,
  bool forced = false,
}) {
  return Future.value(true);
}

Future<Uint8List> pickImage({bool preferCamera = false}) async {
  final data = await _pickImage();
  final imageData = base64.decode(data['data']);
  return imageData;
}

Future<Map<String, dynamic>> _pickImage() async {
  final Map<String, dynamic> data = {};
  final html.FileUploadInputElement input = html.FileUploadInputElement();
  input..accept = 'image/*';
  input.click();
  await input.onChange.first;
  if (input.files.isEmpty) return null;
  final reader = html.FileReader();
  reader.readAsDataUrl(input.files[0]);
  await reader.onLoad.first;
  final encoded = reader.result as String;
  // remove data:image/*;base64 preambule
  final stripped =
      encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');
  //final imageBase64 = base64.decode(stripped);
  final imageName = input.files?.first?.name;
  final imagePath = input.files?.first?.relativePath;
  data.addAll({'name': imageName, 'data': stripped, 'path': imagePath});
  return data;
}

Future<void> share(String text, {String subject, String url}) async {
  final data = {'text': text};

  if (subject != null && subject.isNotEmpty) {
    data['title'] = subject;
  }

  try {
    await html.window.navigator.share(data);
  } catch (exp) {
    //
  }
}

Future<void> shareFiles(
  List<String> files, {
  List<String> mimeTypes,
  String subject,
  String text,
  String url,
}) async {
  final data = {'files': files};

  try {
    await html.window.navigator.share(data);
  } catch (exp) {
    //
  }
}
