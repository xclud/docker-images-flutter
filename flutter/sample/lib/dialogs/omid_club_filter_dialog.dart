import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/city_selection_dialog.dart';
import 'package:novinpay/dialogs/guild_selection_dialog.dart';
import 'package:novinpay/dialogs/province_selection_dialog.dart';
import 'package:novinpay/iran.dart';
import 'package:novinpay/models/novinpay.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/custom_card.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';

class OmidClubFilterDialog extends StatefulWidget {
  OmidClubFilterDialog({@required this.omidClubFilterInfo});

  final OmidClubFilterInfo omidClubFilterInfo;

  @override
  _OmidClubFilterDialogState createState() => _OmidClubFilterDialogState();
}

class _OmidClubFilterDialogState extends State<OmidClubFilterDialog> {
  OmidClubFilterInfo _omidClubFilterInfo;
  Province _province;
  City _city;

  @override
  void initState() {
    _copyFilterInfo();
    super.initState();
  }

  void _copyFilterInfo() {
    _omidClubFilterInfo = OmidClubFilterInfo();
    _omidClubFilterInfo.guild = widget.omidClubFilterInfo.guild;
    _omidClubFilterInfo.state = widget.omidClubFilterInfo.state;
    _omidClubFilterInfo.city = widget.omidClubFilterInfo.city;
    _omidClubFilterInfo.guildId = widget.omidClubFilterInfo.guildId;
    _omidClubFilterInfo.stateId = widget.omidClubFilterInfo.stateId;
    _omidClubFilterInfo.cityId = widget.omidClubFilterInfo.cityId;
  }

  @override
  Widget build(BuildContext context) {
    final province = 'استان: ${_omidClubFilterInfo?.state ?? 'انتخاب کنید'}';
    final city = 'شهر: ${_omidClubFilterInfo?.city ?? 'انتخاب کنید'}';
    final guild = 'صنف: ${_omidClubFilterInfo?.guild ?? 'انتخاب کنید'}';

    return HeadedPage(
      title: Text('باشگاه امید'),
      body: Split(
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 16),
                  child: CustomCard(
                    child: Column(
                      children: [
                        ListTile(
                          onTap: _showProvinceSelectionDialog,
                          title: CustomText(province),
                          trailing: IconButton(
                            onPressed: _omidClubFilterInfo.state == null
                                ? null
                                : () {
                                    setState(() {
                                      _province = null;
                                      _omidClubFilterInfo.state = null;
                                      _omidClubFilterInfo.stateId = null;
                                    });
                                  },
                            icon: Icon(Icons.close),
                            tooltip: 'حذف فیلتر',
                          ),
                        ),
                        ListTile(
                          onTap: _province == null
                              ? null
                              : _showCitySelectionDialog,
                          enabled: _province != null,
                          title: CustomText(city),
                          trailing: IconButton(
                            onPressed: _omidClubFilterInfo.city == null
                                ? null
                                : () {
                                    setState(() {
                                      _city = null;
                                      _omidClubFilterInfo.city = null;
                                      _omidClubFilterInfo.cityId = null;
                                    });
                                  },
                            icon: Icon(Icons.close),
                            tooltip: 'حذف فیلتر',
                          ),
                        ),
                        ListTile(
                          onTap: _showGuildSelectionDialog,
                          title: CustomText(guild),
                          trailing: IconButton(
                            onPressed: _omidClubFilterInfo.guild == null
                                ? null
                                : () {
                                    setState(() {
                                      _omidClubFilterInfo.guild = null;
                                      _omidClubFilterInfo.guildId = null;
                                    });
                                  },
                            icon: Icon(Icons.close),
                            tooltip: 'حذف فیلتر',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        footer: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
          child: ConfirmButton(
            onPressed: () {
              Navigator.of(context).pop(_omidClubFilterInfo);
            },
            child: CustomText(
              strings.action_ok,
              style: colors
                  .tabStyle(context)
                  .copyWith(color: colors.greyColor.shade50),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showProvinceSelectionDialog() async {
    final Province selectedProvince = await showCustomBottomSheet<Province>(
      context: context,
      maxHeight: 500,
      child: ProvinceSelectionDialog(
        scrollController: ScrollController(),
      ),
    );

    if (_province == selectedProvince) {
      return;
    }

    if (selectedProvince == null) {
      return;
    }
    _province = selectedProvince;
    _city = null;
    _omidClubFilterInfo.state = selectedProvince.name;
    _omidClubFilterInfo.stateId = selectedProvince.id;

    setState(() {});
  }

  void _showCitySelectionDialog() async {
    final City selectedCity = await showCustomBottomSheet<City>(
      context: context,
      maxHeight: 500,
      child: CitySelectionDialog(
        scrollController: ScrollController(),
        province: _province,
      ),
    );

    if (selectedCity == null) {
      return;
    }
    _omidClubFilterInfo.city = selectedCity.name;
    _omidClubFilterInfo.cityId = selectedCity.id;
    setState(() {
      _city = selectedCity;
    });
  }

  void _showGuildSelectionDialog() async {
    final Guild selectedGuild = await showCustomBottomSheet<Guild>(
      context: context,
      maxHeight: 500,
      child: GuildSelectionDialog(_province, _city),
    );

    if (selectedGuild == null) {
      return;
    }
    _omidClubFilterInfo.guild = selectedGuild.title;
    _omidClubFilterInfo.guildId = selectedGuild.id;
    setState(() {});
  }
}

class OmidClubFilterInfo {
  int stateId;
  int cityId;
  int guildId;
  String state;
  String city;
  String guild;
}
