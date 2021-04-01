import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/services/platform_helper.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

PlatformType getPlatform() {
  if (Platform.isAndroid) {
    return PlatformType.android;
  } else if (Platform.isFuchsia) {
    return PlatformType.fuchsia;
  } else if (Platform.isIOS) {
    return PlatformType.iOS;
  } else if (Platform.isLinux) {
    return PlatformType.linux;
  } else if (Platform.isMacOS) {
    return PlatformType.macOS;
  } else if (Platform.isWindows) {
    return PlatformType.windows;
  }

  return PlatformType.unknown;
}

Future<bool> showOtaUpdateDialog({
  @required BuildContext context,
  @required String link,
  bool forced = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => _OtaUpdateDialog(link: link, forced: forced),
  );
}

class _OtaUpdateDialog extends StatefulWidget {
  _OtaUpdateDialog({@required this.link, this.forced = false});

  final String link;
  final bool forced;

  @override
  State<StatefulWidget> createState() => _OtaUpdateDialogState();
}

class _OtaUpdateDialogState extends State<_OtaUpdateDialog> {
  bool _canPop = false;
  double _progress;
  bool _downloading;

  void _onProgress(double value) {
    if (mounted) {
      setState(() {
        _progress = value;
      });
    }
  }

  void _onDone(File file) {
    if (mounted) {
      setState(() {
        _downloading = false;
      });
    }

    if (mounted) {
      OpenFile.open(file.path);
    }
  }

  void _startDownloading(String url) async {
    _onProgress(null);

    int downloadedBytes = 0;
    List<int> tmp = [];

    try {
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);

      var contentLength = response.contentLength;
      contentLength ??=
          int.tryParse(response.headers['x-decompressed-content-length'] ?? '');

      response.stream.asBroadcastStream().listen((value) async {
        tmp.addAll(value);
        downloadedBytes += value.length;

        if (contentLength != null) {
          _progress = downloadedBytes.toDouble() / contentLength.toDouble();
        }

        _onProgress(_progress);
      }, onDone: () async {
        final file = await _createFile();
        await file.writeAsBytes(tmp, mode: FileMode.write, flush: true);
        _onDone(file);
      });
    } on Exception {
      //
    }
  }

  Widget buildChild() {
    if (_downloading == true) {
      return LinearProgressIndicator(value: _progress);
    }

    var message = 'نسخه جدید سان منتشر شده است.';
    if (widget.forced == true) {
      message = '$message برای ادامه میبایست برنامه را به روز رسانی نمایید.';
    } else {
      message = '$message آیا مایلید برنامه را به روز رسانی کنید؟';
    }
    return Text(message);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(widget.forced != true || _canPop == true),
      child: AlertDialog(
        title: Text('به روز رسانی'),
        content: buildChild(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: _downloading == true
                ? null
                : () async {
                    setState(() {
                      _downloading = true;
                    });

                    _startDownloading(widget.link);
                  },
            child: Text('به روز رسانی'),
          ),
          if (widget.forced != true)
            TextButton(
              onPressed: () {
                _canPop = true;
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(routes.home);
              },
              child: Text('بعدا'),
            )
        ],
      ),
    );
  }
}

Future<File> _createFile() async {
  final dir = (await getApplicationDocumentsDirectory()).path;
  final path = '$dir/update.apk';
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }

  await file.create(recursive: true);

  await file.writeAsBytes([], mode: FileMode.write, flush: true);

  return file;
}

Future<Uint8List> pickImage({bool preferCamera = false}) async {
  final file = await ImagePicker().getImage(
      source: preferCamera == true ? ImageSource.camera : ImageSource.gallery);

  return await file?.readAsBytes();
}

Future<void> share(String text, {String subject, String url}) {
  return Share.share(text, subject: subject);
}

Future<void> shareFiles(
  List<String> files, {
  List<String> mimeTypes,
  String subject,
  String text,
  String url,
}) {
  return Share.shareFiles(
    files,
    mimeTypes: mimeTypes,
    subject: subject,
    text: text,
  );
}
