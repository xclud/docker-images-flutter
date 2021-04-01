import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/omid_club_filter_dialog.dart';
import 'package:novinpay/models/omid.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class OmidClubPage extends StatefulWidget {
  @override
  _OmidClubPageState createState() => _OmidClubPageState();
}

class _OmidClubPageState extends State<OmidClubPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<GetOmidMerchantsResponse> _data;
  OmidClubFilterInfo _omidClubFilterInfo = OmidClubFilterInfo();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _doRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('باشگاه امید'),
      actions: [
        IconButton(
          color: colors.primaryColor,
          icon: Icon(Icons.filter_list),
          onPressed: _onShowFilterPage,
        ),
      ],
      body: Padding(
        padding: EdgeInsetsDirectional.only(top: 8, bottom: 16),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                key: _refreshKey,
                onRefresh: _onRefresh,
                child: _buildChild(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (_data == null) {
      return Center(
        child: CustomText(
          strings.please_wait,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_data.isError) {
      return Center(
        child: CustomText(
          strings.connectionError,
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_data.content.status != true) {
      return Center(
        child: CustomText(
          _data.content.description ?? strings.connectionError,
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_data.content.merchants.isEmpty) {
      return Center(
        child: CustomText(
          'موردی یافت نشد',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _data.content.merchants.length,
      itemBuilder: (context, index) {
        final item = _data.content.merchants[index];
        final address = '${item.stateName}، ${item.city}، ${item.address}';
        return Container(
          decoration: BoxDecoration(
            color: colors.greyColor.shade600,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                child: DualListTile(
                  start: Text(
                    item.workTitle ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  end: Text(
                    item.phoneNumber.toString().withPersianNumbers(),
                  ),
                ),
              ),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  color: colors.greyColor.shade800,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                child: Text(address.withPersianLetters().withPersianNumbers()),
              ),
            ],
          ),
        );
      },
    );
  }

  void _doRefresh() {
    _refreshKey.currentState.show();
  }

  Future<void> _onRefresh() async {
    final data = await nh.diplomat.getOmidMerchants(
      stateId: _omidClubFilterInfo?.stateId,
      cityId: _omidClubFilterInfo?.cityId,
      guildId: _omidClubFilterInfo?.guildId,
    );

    setState(() {
      _data = data;
    });
  }

  void _onShowFilterPage() async {
    final filterInfo = await Navigator.push<OmidClubFilterInfo>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            OmidClubFilterDialog(omidClubFilterInfo: _omidClubFilterInfo),
        fullscreenDialog: true,
      ),
    );

    if (filterInfo != null) {
      _omidClubFilterInfo = filterInfo;

      _refreshKey.currentState?.show();
    }
  }
}
