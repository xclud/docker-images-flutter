import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/barcode_data.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/sun.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

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
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) wv.WebView.platform = wv.SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    final w = wv.WebView(
      javascriptMode: wv.JavascriptMode.unrestricted,
      debuggingEnabled: true,
      initialUrl: widget.url,
      onPageStarted: widget.onPageStarted,
      navigationDelegate: (req) {
        widget.onChange?.call(req.url);
        return wv.NavigationDecision.navigate;
      },
    );

    return w;
  }
}

Uri getCurrentURI() {
  return null;
}

Future<BankLoginInfo> openWebURL(
  BuildContext context, {
  @required String title,
  @required String url,
}) async {
  return Navigator.of(context).push<BankLoginInfo>(
    MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text(title ?? ''),
          centerTitle: true,
        ),
        body: WebView(
          url: url,
          onChange: (value) => _onChange(context, value),
        ),
      ),
    ),
  );
}

void _onChange(BuildContext context, String value) async {
  final url = Uri.tryParse(value ?? '');
  if (url != null) {
    final hasCode = url.queryParameters.containsKey('code');
    final hasState = url.queryParameters.containsKey('state');

    if (hasCode && hasState) {
      final code = url.queryParameters['code'];
      final state = int.tryParse(url.queryParameters['state'] ?? '');

      if (code != null && code.isNotEmpty && state != null && state > 0) {
        final data = await nh.boomMarket.boomToken(
          state: state,
          code: code,
        );

        if (data == null || data.hasErrors()) {
          return;
        }

        final now = DateTime.now().millisecondsSinceEpoch - 100;
        final expires = now + data.content.expires * 1000.0;

        final info = BankLoginInfo(state: state, code: code, expires: expires);
        await appState.setBankLoginInfo(state, code, expires);

        Navigator.of(context).pop<BankLoginInfo>(info);
      }
    }
  }
}
