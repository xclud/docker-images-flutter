import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/card_selection_mixin.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/models/types.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class AccountInquiryPage extends StatefulWidget {
  @override
  _AccountInquiryPageState createState() => _AccountInquiryPageState();
}

class _AccountInquiryPageState extends State<AccountInquiryPage>
    with MruSelectionMixin, CardSelectionMixin {
  final _formKey = GlobalKey<FormState>();
  final _panController = TextEditingController();
  int _sourceCardId;
  Response<CardToIbanResponse> _data;
  bool _disable = false;
  bool _showInquiryButton = true;

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  Widget _buildEmpty() {
    return Center(
        child: Text(
      'لطفا شماره کارت خود را وارد نمایید.',
      style: colors
          .regularStyle(context)
          .copyWith(color: colors.greyColor.shade900),
    ));
  }

  Widget _buildData() {
    final x = _data.content;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                child: Text(x.ownerName?.withPersianLetters() ?? '',
                    style: colors.boldStyle(context))),
            Space(2),
            Container(
              decoration: BoxDecoration(
                color: colors.greyColor.shade600,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: DualListTile(
                      end: FlatButton(
                        color: colors.accentColor,
                        onPressed: () => _saveIban(x.iban, x.ownerName),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                          child: Text('ذخیره',
                              style: colors
                                  .bodyStyle(context)
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                      start: Text(
                        strings.label_iban_number,
                        style: colors.regularStyle(context),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                          child: SelectableText(
                              x.iban?.withPersianNumbers() ?? '',
                              style: colors.boldStyle(context))),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                        child: InkWell(
                          child: Icon(
                            SunIcons.copy,
                          ),
                          onTap: () => _copy(x.iban),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Space(),
            Container(
              decoration: BoxDecoration(
                color: colors.greyColor.shade600,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                    child: DualListTile(
                      end: FlatButton(
                        color: colors.accentColor,
                        onPressed: () =>
                            _saveAccount(x.depositNumber, x.ownerName),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                          child: Text('ذخیره',
                              style: colors
                                  .bodyStyle(context)
                                  .copyWith(color: Colors.white)),
                        ),
                      ),
                      start: Text(
                        strings.label_account_number,
                        style: colors.regularStyle(context),
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                          child: SelectableText(
                            x.depositNumber?.withPersianNumbers() ?? '',
                            style: colors.boldStyle(context),
                          )),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                        child: InkWell(
                          child: Icon(
                            SunIcons.copy,
                          ),
                          onTap: () => _copy(x.depositNumber),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final footer = Container(
      margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
      child: ConfirmButton(
        child: CustomText(
          strings.action_inquiry,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        onPressed: _disable ? null : _submit,
        color: colors.ternaryColor,
      ),
    );
    return HeadedPage(
      title: Text('استعلام حساب'),
      body: Split(
        header: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Space(),
                CardTextFormField(
                  labelText: 'شماره کارت',
                  controller: _panController,
                  showSelectionDialog: _showCardSelectionDialog,
                  onChanged: (value) {
                    setState(() {
                      _data = null;
                      _showInquiryButton = true;
                      _disable = false;
                      _sourceCardId = null;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        child: Expanded(
          child: _data == null ? Center(child: _buildEmpty()) : _buildData(),
        ),
        footer: _showInquiryButton ? footer : Container(),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _disable = true;
    });
    final cardInfo = CardInfo(
      cvv: '1234',
      pin: '1111',
      pan: _panController.text,
      sourceCardId: _sourceCardId,
    );

    final data = await Loading.run(
      context,
      nh.finnoTech.cardToIban(cardInfo: cardInfo),
    );

    if (!showError(context, data)) {
      setState(() {
        _data = null;
        _showInquiryButton = true;
      });
      return;
    }
    setState(() {
      _showInquiryButton = false;
      _data = data;
    });
    nh.mru.addMru(
      type: MruType.sourceCard,
      title: data.content.ownerName,
      value: removeDash(cardInfo.pan),
      expDate: cardInfo.expire,
    );
  }

  void _showCardSelectionDialog() async {
    _sourceCardId = null;
    final data = await showSourceCardSelectionDialog();

    if (data == null) {
      return;
    }

    setState(() {
      _panController.text = data.value;
      _sourceCardId = data.id;
      _showInquiryButton = true;
      _disable = false;
      _data = null;
    });
  }

  void _copy(String data) {
    Clipboard.setData(ClipboardData(text: data ?? '')).then((value) =>
        ToastUtils.showCustomToast(
            context, 'کپی شد', Image.asset('assets/ok.png')));
  }

  void _saveIban(String iban, String title) {
    nh.mru.addMru(type: MruType.sourceIban, title: title, value: iban);
    ToastUtils.showCustomToast(
        context, 'افزوده شد', Image.asset('assets/ok.png'));
  }

  void _saveAccount(String account, String title) {
    nh.mru.addMru(type: MruType.sourceAccount, title: title, value: account);
    ToastUtils.showCustomToast(
        context, 'افزوده شد', Image.asset('assets/ok.png'));
  }
}
