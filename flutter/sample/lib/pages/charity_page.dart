import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/charity.dart';
import 'package:novinpay/pages/charity_payment_page.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';

class CharityPage extends StatefulWidget {
  @override
  _CharityPageState createState() => _CharityPageState();
}

class _CharityPageState extends State<CharityPage> {
  Response<CharityInfoResponse> _data;
  final List<CharityInfoList> _items = [];

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: CustomText('خیریه'),
      body: _buildChild(),
    );
  }

  Widget _buildData() {
    final cards = _items.map(buildCard).toList();
    return Column(
      children: [
        Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
          padding: EdgeInsetsDirectional.fromSTEB(24, 24, 8, 24),
          decoration: BoxDecoration(
            color: colors.greyColor.shade600,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 8),
                  child: Icon(
                    SunIcons.event,
                    color: colors.primaryColor,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'تاریخ اخرین کمک: ${_data.content.lastTransaction.insertDateTime}',
                    style: colors
                        .bodyStyle(context)
                        .copyWith(color: colors.primaryColor),
                  ),
                )
              ],
            ),
            Space(),
            Row(
              children: [
                Image.asset(
                  'assets/logo/sun.png',
                  width: 44,
                  height: 44,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'آخرین واریزی',
                        style: colors
                            .boldStyle(context)
                            .copyWith(color: colors.primaryColor),
                      ),
                      Space(),
                      Text(
                        toRials(_data.content.lastTransaction.amount),
                        style: colors
                            .boldStyle(context)
                            .copyWith(color: colors.primaryColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...cards,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _getData() async {
    final data = await Loading.run(context, nh.charity.getCharityInfo());

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
    _items.clear();
    _items.addAll(_data.content.charityInfoList);
    return _buildData();
  }

  Widget _buildMessage(String text) => Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          softWrap: true,
          style: colors
              .regularStyle(context)
              .copyWith(color: colors.greyColor.shade900),
        ),
      );

  Widget _buildLoadingMessage() => _buildMessage(strings.please_wait);

  Widget buildCard(CharityInfoList item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharityPayPage(
              info: item,
            ),
          ),
        );
      },
      child: Container(
          decoration: BoxDecoration(
            color: colors.primaryColor.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsetsDirectional.only(bottom: 8),
          child: Row(children: [
            Padding(
              padding: EdgeInsetsDirectional.only(start: 24),
              child: Icon(
                SunIcons.heart,
                size: 32,
                color: colors.primaryColor,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                      child: Text(item.charityName)),
                  Space(),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 16),
                      child: Text(item.description)),
                ],
              ),
            ),
          ])),
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
