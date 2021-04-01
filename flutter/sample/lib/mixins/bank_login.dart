import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/dialogs/national_number_dialog.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/webview/webviewhelper.dart';
import 'package:novinpay/widgets/loading.dart';

mixin BankLogin<T extends StatefulWidget> on State<T> {
  Future<BankLoginInfo> ensureBankLogin(String route) async {
    final bankLogin = await appState.getBankLoginInfo();
    if (DateTime.now().millisecondsSinceEpoch < (bankLogin.expires ?? -1)) {
      return bankLogin;
    }

    final nationalCode = await showCustomBottomSheet<String>(
      context: context,
      child: NationalNumberDialog(scrollController: ScrollController()),
    );

    if (nationalCode == null || nationalCode.isEmpty) {
      return null;
    }

    String _generateReturnURI() {
      final uri = getCurrentURI();
      if (uri == null || uri.origin == null || uri.origin.isEmpty) {
        return null;
      }

      final origin = uri.origin.replaceAll(RegExp(r'/+$'), '');
      final path = '#/$route'.replaceAll('//', '/');
      return '$origin/$path';
    }

    final returnUrl = _generateReturnURI();

    final data = await Loading.run(
      context,
      nh.boomMarket.generateBankUrl(
        returnUrl: returnUrl,
        nationalCode: nationalCode,
      ),
    );

    if (data.hasErrors()) {
      return null;
    }

    final loginResult = await openWebURL(
      context,
      title: 'ورود به بانک',
      url: data.content.bankUrl,
    );

    if (loginResult == null) {
      return null;
    }

    appState.setBankLoginInfo(
      loginResult.state,
      loginResult.code,
      loginResult.expires,
    );

    return loginResult;
  }
}
