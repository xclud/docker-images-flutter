import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/get_invitation_link_response.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class ReferralPage extends StatefulWidget {
  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  Response<GetInvitationLinkResponse> _data;
  String _phoneNumber = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('دعوت از دوستان'),
      body: _buildChild(),
    );
  }

  Widget _buildInvitationData() {
    return ListView(
      children: [
        SizedBox(
          height: 24,
        ),
        Text(
          'کد معرف یا لینک دعوت را برای دوستان خود ارسال فرمایید',
          textAlign: TextAlign.center,
          style: colors.bodyStyle(context),
        ),
        Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 8),
          padding: EdgeInsetsDirectional.fromSTEB(24, 8, 8, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.accentColor, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'کد معرف :${_phoneNumber}'.withPersianNumbers(),
                  style: colors
                      .boldStyle(context)
                      .copyWith(color: colors.primaryColor),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    Clipboard.setData(ClipboardData(text: _phoneNumber ?? ''));
                    ToastUtils.showCustomToast(
                        context, 'کپی شد', Image.asset('assets/ok.png'));
                  },
                  icon: Icon(SunIcons.copy)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 24),
          margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.accentColor, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _data.content.invitationModel.header?.withPersianNumbers() ??
                    '',
                style: colors
                    .boldStyle(context)
                    .copyWith(color: colors.primaryColor),
              ),
              Space(),
              Text(
                _data.content.invitationModel.slogan?.withPersianNumbers() ??
                    '',
                style: colors
                    .regularStyle(context)
                    .copyWith(color: colors.primaryColor),
              ),
              Space(),
              Text(
                'لینک دانلود نسخه:',
                style: colors
                    .tabStyle(context)
                    .copyWith(color: colors.primaryColor),
              ),
              Space(),
              Text(
                _data.content.invitationModel.androidInvitationLink
                        ?.withPersianNumbers() ??
                    '',
                textAlign: TextAlign.end,
                style: colors
                    .bodyStyle(context)
                    .copyWith(color: colors.primaryColor),
              ),
              Space(),
              Space(),
              Text(
                _data.content.invitationModel.iosInvitationLink
                        ?.withPersianNumbers() ??
                    '',
                textAlign: TextAlign.end,
                style: colors
                    .bodyStyle(context)
                    .copyWith(color: colors.primaryColor),
              ),
              Space(),
              Text(
                'پشتیبانی: $rlm${_data.content.invitationModel.supportTel[0]}'
                        ?.withPersianNumbers() ??
                    '',
                style: colors
                    .bodyStyle(context)
                    .copyWith(color: colors.primaryColor),
              ),
              Space(2),
              Align(
                alignment: Alignment.bottomCenter,
                child: ConfirmButton(
                  onPressed: () async {
                    Clipboard.setData(
                            ClipboardData(text: _data.content.text ?? ''))
                        .then((value) => ToastUtils.showCustomToast(
                            context, 'کپی شد', Image.asset('assets/ok.png')));
                  },
                  child: CustomText(
                    'کپی متن دعوت از دوستان',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _getData() async {
    final data =
        await Loading.run(context, nh.novinPay.application.getInvitationLink());
    _phoneNumber = await appState.getPhoneNumber();

    setState(() {
      _data = data;
    });
  }

  Widget _buildChild() {
    if (_data == null) {
      return _buildLoadingMessage();
    }
    if (_data.isError || _data.content == null) {
      return _buildMessage(strings.connectionError);
    }

    if (_data.content.status != true) {
      return _buildMessage(
          _data.content.description ?? strings.connectionError);
    }
    return _buildInvitationData();
  }

  Widget _buildMessage(String text) => Center(
        child: Text(
          text ?? '',
          textAlign: TextAlign.center,
          softWrap: true,
          style: colors
              .regularStyle(context)
              .copyWith(color: colors.greyColor.shade900),
        ),
      );

  Widget _buildLoadingMessage() => _buildMessage(strings.please_wait);
}
