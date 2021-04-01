// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:novinpay/barcode_data.dart';
import 'package:novinpay/webview/src/fake.dart' if (dart.library.html) 'dart:ui'
    as ui;
import 'package:novinpay/widgets/general/general.dart';

Future<BarcodeData> showBarcodeScanDialog(BuildContext context) {
  final result = Navigator.of(context).push<BarcodeData>(
      MaterialPageRoute(builder: (context) => _BarcodeScannerPage()));
  return result;
}

class _BarcodeScannerWebview extends StatefulWidget {
  const _BarcodeScannerWebview({
    @required this.url,
    this.onChange,
    this.onPageStarted,
    this.onBarcode,
  });

  final String url;
  final ValueChanged<BarcodeData> onBarcode;
  final ValueChanged<String> onChange;
  final ValueChanged<String> onPageStarted;

  @override
  _BarcodeScannerWebviewState createState() => _BarcodeScannerWebviewState();
}

class _BarcodeScannerWebviewState extends State<_BarcodeScannerWebview> {
  Widget _iframeWidget;

  final IFrameElement _iframeElement = IFrameElement();

  @override
  void initState() {
    super.initState();

    _iframeElement.height = '500';
    _iframeElement.width = '500';

    _iframeElement.src = widget.url;
    _iframeElement.style.border = 'none';
    _iframeElement.attributes['is'] = 'x-frame-bypass';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );

    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
    _iframeElement.onLoad.listen((event) {
      final href = _iframeElement.src;
      widget.onChange?.call(href);
    });

    window.addEventListener('barcode', (event) {
      if (event is CustomEvent) {
        final String data = event.detail;
        final json = jsonDecode(data);

        final barcode = BarcodeData.fromJson(json);
        widget.onBarcode?.call(barcode);
      }
    }, false);
  }

  @override
  Widget build(BuildContext context) {
    final lb = LayoutBuilder(
      builder: (context, c) {
        final sz = c.biggest;
        final w = sz.width;
        final h = sz.height;

        _iframeElement.height = h.toString();
        _iframeElement.width = w.toString();

        return SizedBox(
          height: h,
          width: w,
          child: _iframeWidget,
        );
      },
    );

    return lb;
  }
}

class _BarcodeScannerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: CustomText('بارکد خوان'),
      body: _BarcodeScannerWebview(
        url: '/qrcode.html',
     /* title: Text('بارکد خوان'),
      body: _BarcodeScannerWebview(
        url: '/barcode.html',*/
        onBarcode: (barcode) {
          Navigator.of(context).pop(barcode);
        },
      ),
    );
  }
}
