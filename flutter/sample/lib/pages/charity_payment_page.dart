import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/charity.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';
import 'package:url_launcher/url_launcher.dart';

class CharityPayPage extends StatefulWidget {
  CharityPayPage({@required this.info});

  @override
  _CharityPayPageState createState() => _CharityPayPageState();
  final CharityInfoList info;
}

class _CharityPayPageState extends State<CharityPayPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: CustomText('خیریه'),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
        child: Split(
          child: Expanded(
            child: Container(
              margin: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //  margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),

                          decoration: BoxDecoration(
                            color: colors.greyColor.shade600,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(24, 8, 8, 8),
                              child: Row(
                                children: [
                                  Icon(
                                    SunIcons.loan,
                                    color: colors.primaryColor,
                                    size: 32,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Space(2),
                                        Text(
                                          widget.info.charityName,
                                          style: colors
                                              .boldStyle(context)
                                              .copyWith(
                                                  color: colors.primaryColor),
                                        ),
                                        Space(),
                                        Text(
                                          widget.info.description,
                                          style: colors
                                              .boldStyle(context)
                                              .copyWith(
                                                  color: colors.primaryColor),
                                        ),
                                        Space(2),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            Space(),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 8, 24, 16),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: RaisedButton(
                                    color: colors.accentColor,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 16, 16, 16),
                                    onPressed: () => {
                                      if (widget.info.phoneNumber.isNotEmpty)
                                        launch('tel:02148006')
                                    },
                                    child: Text(
                                      'تماس با خیریه',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                  )),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                    child: RaisedButton(
                                      color: colors.accentColor,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16, 16, 16, 16),
                                      onPressed: () => {
                                        if (widget.info.website.isNotEmpty)
                                          Utils.customLaunch(
                                              context, widget.info.website)
                                      },
                                      child: Text(
                                        'سایت خیریه',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      elevation: 0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                        Space(2),
                        MoneyTextFormField(
                          controller: _amountController,
                          minimum: 1,
                          maximum: 2000000000,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        Space(2),
                        Text(_getPersianAmount()),
                      ]),
                ),
              ),
            ),
          ),
          footer: ConfirmButton(
            child: CustomText(
              strings.action_ok,
              textAlign: TextAlign.center,
            ),
            onPressed: _submit,
          ),
        ),
      ),
    );
  }

  String _getPersianAmount() {
    final text = _amountController.text?.replaceAll(',', '');
    final amount = int.tryParse(text ?? '');
    if (amount == null) {
      return '';
    }
    final toman = (amount ~/ 10).toPersianString();
    return '$toman تومان';
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final amount =
        int.tryParse(_amountController.text?.replaceAll(',', '') ?? '');

    final payInfo = await showPaymentBottomSheet(
      context: context,
      title: Text('خیریه'),
      amount: amount,
      transactionType: TransactionType.buy,
      acceptorName: '',
      acceptorId: '20',
      children: [
        DualListTile(
          start: Text(widget.info.charityName),
          end: Text(widget.info.description),
        ),
      ],
    );

    if (payInfo == null) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.charity.charityPayment(
        cardInfo: payInfo.cardInfo,
        amount: amount,
        charityServiceId: widget.info.charityServiceId.toString(),
      ),
    );

    if (!showConnectionError(context, data)) {
      return;
    }
    if (data.content.status != true) {
      await showFailedTransaction(context, data.content.description,
          data.content.stan, data.content.rrn, 'خیریه', amount * 10);

      return;
    }
    nh.mru.addMru(
      type: MruType.sourceCard,
      title: Utils.getBankName(payInfo.cardInfo.pan),
      value: removeDash(payInfo.cardInfo.pan),
      expDate: payInfo.cardInfo.expire,
    );
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'خیریه',
          cardNumber: payInfo.cardInfo.pan,
          stan: data.content.stan,
          rrn: data.content.rrn,
          topupPin: null,
          description: 'کمک به خیریه ${widget.info.charityName}',
          amount: int.parse(_amountController.text.replaceAll(',', '')),
          isShaparak: true,
        ),
      ),
    );
  }
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
