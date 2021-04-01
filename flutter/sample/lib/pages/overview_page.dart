import 'dart:io' as io;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/novin_icons.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persian/persian.dart';

class OverViewPage extends StatefulWidget {
  OverViewPage({
    @required this.title,
    @required this.cardNumber,
    @required this.stan,
    @required this.description,
    @required this.amount,
    @required this.isShaparak,
    this.rrn,
    this.topupPin,
    this.destinationCardNumber,
  });

  final String title;
  final String cardNumber;
  final String destinationCardNumber;
  final String stan;
  final String rrn;
  final String topupPin;
  final String description;
  final int amount;
  final bool isShaparak;

  @override
  OverViewState createState() => OverViewState();
}

class OverViewState extends State<OverViewPage> {
  bool _hasDestinationCardNumber = false;
  bool _hasCardNumber = false;
  final _screenshotController = ScreenshotController();

  void _share() async {
    final image = await _screenshotController.take();
    if (image == null) {
      share(_getShareDescription());
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final path = '${tempDir.path}/screenshot.png';

    final bytes = await image.toByteData(format: ImageByteFormat.png);
    try {
      final file = await io.File(path)
          .writeAsBytes(bytes.buffer.asUint8List(), flush: true);

      shareFiles([file.path]);
    } catch (exp) {
      exp?.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _hasDestinationCardNumber = widget.destinationCardNumber != null &&
        widget.destinationCardNumber.isNotEmpty;

    _hasCardNumber = widget.cardNumber != null && widget.cardNumber.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final bankName = Utils.getBankName(widget.cardNumber);

    return HeadedPage(
      actions: [
        IconButton(
          icon: Icon(Icons.share),
          onPressed: isSecureEnvironment ? _share : null,
        )
      ],
      title: CustomText(widget.title ?? 'صورت حساب'),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: _screenshotController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset('assets/overview/header.png'),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                          child: Image.asset('assets/ok.png'),
                        ),
                        SizedBox(width: 8),
                        Text('عملیات موفق'),
                        if (widget.isShaparak)
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Image.asset('assets/shaparak.png'),
                            ),
                          )
                      ],
                    ),
                    Space(2),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                      child: Text(
                        'شرح عملیات',
                        style: colors.boldStyle(context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                      child: Text(
                          widget.description
                                  ?.withPersianNumbers()
                                  ?.withPersianLetters() ??
                              '',
                          style: colors.boldStyle(context)),
                    ),
                    Space(1),
                    if (_hasCardNumber)
                      DualListTile(
                        start: Text(_hasDestinationCardNumber
                            ? 'کارت مبدا'
                            : 'شماره کارت'),
                        end: Directionality(
                          child: Text(
                            protectCardNumber(widget.cardNumber)
                                    ?.withPersianNumbers() ??
                                '',
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    if (_hasDestinationCardNumber)
                      DualListTile(
                        start: Text('کارت مقصد'),
                        end: Directionality(
                          child: Text(
                            protectCardNumber(widget.destinationCardNumber)
                                    ?.withPersianNumbers() ??
                                '',
                          ),
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    if (bankName != null && bankName.isNotEmpty)
                      DualListTile(
                        start: Text('بانک صادر کننده'),
                        end: Text(bankName),
                      ),
                    DualListTile(
                      start: Text('زمان تراکنش'),
                      end: Text(Utils.getCurrentDateTime()
                              ?.withPersianNumbers()
                              ?.withPersianLetters() ??
                          ''),
                    ),
                    if (widget.rrn != null && widget.rrn.isNotEmpty)
                      DualListTile(
                        start: Text('شماره مرجع'),
                        end: Text(widget.rrn
                                ?.withPersianNumbers()
                                ?.withPersianLetters() ??
                            ''),
                      ),
                    if (widget.topupPin != null)
                      DualListTile(
                        start: Text('کد شارژ'),
                        end: Text(widget.topupPin
                                ?.withPersianNumbers()
                                ?.withPersianLetters() ??
                            ''),
                      ),
                    DualListTile(
                      start: Text('مبلغ',
                          style: colors
                              .boldStyle(context)
                              .copyWith(color: colors.accentColor)),
                      end: Text(toRials(widget.amount ?? 0),
                          style: colors
                              .boldStyle(context)
                              .copyWith(color: colors.accentColor)),
                    ),
                    DualListTile(
                      start: Row(
                        children: [
                          Icon(
                            NovinIcons.logo,
                            color: colors.primaryColor,
                          ),
                          SizedBox(width: 8),
                          Text('پشتیبانی'),
                        ],
                      ),
                      end: Text('${lrm}021-48320000'.withPersianNumbers()),
                    ),
                  ],
                ),
              ),
              Image.asset('assets/overview/bottom.png'),
              Space(3),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Image.asset('assets/logo/sun_typo.png'),
              ),
              Space(3),
            ],
          ),
        ),
      ),
    );
  }

  String _getShareDescription() {
    String _description = '';

    _description = '\n عملیات موفق \n ${widget.title ?? 'صورت حساب'}\n';

    if (_hasCardNumber) {
      _description +=
          ' ${_hasDestinationCardNumber ? 'کارت مبدا:' : 'شماره کارت:'} $lrm${protectCardNumber(widget.cardNumber).withPersianNumbers().withPersianLetters() ?? ''}\n';
    }
    if (_hasDestinationCardNumber) {
      _description +=
          ' کارت مقصد: $lrm${protectCardNumber(widget.destinationCardNumber).withPersianNumbers().withPersianLetters() ?? ''}\n';
    }

    _description +=
        'مبلغ: ${toRials(widget.amount).toString().withPersianNumbers().withPersianLetters() ?? 0}\n';

    _description +=
        'زمان تراکنش: ${Utils.getCurrentDateTime()?.withPersianNumbers()?.withPersianLetters() ?? ''} \n';

    if (widget.stan != null && widget.stan.isNotEmpty) {
      _description +=
          'شماره پیگیری: ${widget.stan?.withPersianNumbers()?.withPersianLetters() ?? ''}\n';
    }
    if (widget.rrn != null && widget.rrn.isNotEmpty) {
      _description +=
          'شماره مرجع: ${widget.rrn?.withPersianNumbers()?.withPersianLetters() ?? ''}\n';
    }

    _description +=
        'شرح عملیات: ${widget.description?.withPersianNumbers()?.withPersianLetters() ?? ''}\n';

    _description +=
        'پشتیبانی سان: ${'${lrm}021-48320000'.withPersianNumbers()}';

    return _description;
  }
}
