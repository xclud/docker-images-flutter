// ignore: avoid_web_libraries_in_flutter
import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:novinpay/barcode_data.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/webview/src/fake.dart' if (dart.library.html) 'dart:ui'
    as ui;

Uri getCurrentURI() {
  return Uri.tryParse(window.location.href);
}

Future<BankLoginInfo> openWebURL(
  BuildContext context, {
  @required String title,
  @required String url,
}) async {
  window.location.href = url;
  return null;
}

class WebView extends StatefulWidget {
  const WebView({
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
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
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
