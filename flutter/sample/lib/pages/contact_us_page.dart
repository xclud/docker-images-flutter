import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/config.dart';
import 'package:novinpay/dialogs/suggestion_dialog.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('تماس با ما'),
      body: Split(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/logo/launch_image.png',
                            width: 226,
                            height: 226,
                          ),
                          Space(3),
                          InkWell(
                            onTap: () {
                              launch('tel:$support_phone');
                            },
                            child: Text(support_phone.withPersianNumbers(),
                                style: colors.boldStyle(context).copyWith(
                                    color: colors.accentColor, fontSize: 32.0)),
                          ),
                          Space(1),
                          InkWell(
                              onTap: () {
                                Utils.customLaunch(
                                    context, 'https://pna.co.ir/',
                                    title: 'پرداخت نوین آرین');
                              },
                              child: Text('www.pna.co.ir',
                                  style: colors.regularStyle(context).copyWith(
                                        color: colors.ternaryColor,
                                        decoration: TextDecoration.underline,
                                      ))),
                          Space(2),
                          InkWell(
                            onTap: _openSuggestionDialog,
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                  left: 16.0,
                                  right: 16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: colors.primaryColor),
                              ),
                              child: Text('انتقادات و پیشنهادات',
                                  style: colors
                                      .tabStyle(context)
                                      .copyWith(color: colors.primaryColor)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, bottom: 32.0, left: 16.0, right: 16.0),
                  child: Container(
                      width: 300,
                      child: Text(
                        'کلیه حقوق این برنامه متعلق به شرکت پرداخت نوین می باشد',
                        textAlign: TextAlign.center,
                        style: colors
                            .bodyStyle(context)
                            .copyWith(color: colors.primaryColor),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openSuggestionDialog() async {
    final suggestion = await showCustomBottomSheet<String>(
      context: context,
      child: SuggestionDialog(),
    );

    if (suggestion == null) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.novinPay.application.insertCustomerSuggestion(suggestion: suggestion),
    );
    if (!showError(context, data)) {
      return;
    }
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'پیام شما ارسال شد',
              textAlign: TextAlign.center,
            ),
            content: Text('با تشکر از مشارکت شما، دیدگاه شما بررسی خواهد شد.'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            actions: [
              RaisedButton(
                elevation: 0,
                color: colors.accentColor.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  strings.action_ok,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
