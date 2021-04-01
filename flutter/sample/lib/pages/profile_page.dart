import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iran/iran.dart' as ir;
import 'package:latlng/latlng.dart';
import 'package:map/map.dart' as map;
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/city_selection_dialog.dart';
import 'package:novinpay/dialogs/province_selection_dialog.dart';
import 'package:novinpay/iran.dart' as iran;
import 'package:novinpay/iran.dart';
import 'package:novinpay/mixins/try_cancel_dialog_mixin.dart';
import 'package:novinpay/models/GetUserProfileResponse.dart';
import 'package:novinpay/profile_info.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/location_picker.dart';
import 'package:novinpay/widgets/pna_persian_datepicker/pna_persian_datepicker.dart';
import 'package:novinpay/widgets/profile_image.dart';
import 'package:novinpay/widgets/profile_page_row.dart';
import 'package:novinpay/widgets/select_password_type.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

Widget _buildTile(BuildContext context, int x, int y, int z) {
  final url =
      'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

  return CachedNetworkImage(
    imageUrl: url,
    fit: BoxFit.cover,
  );
}

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TryCancelDialogMixin {
  bool _loading = true;
  bool _uploading = false;
  Response<GetUserProfileResponse> _data;

  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = ScrollController();
  String _mobileNumber;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _doRefresh();
      _scrollController.addListener(() => setState(() {}));

      _mobileNumber = await appState.getPhoneNumber();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildError(String error) {
    return Center(
        child: Column(
      children: [
        Text(error ?? ''),
        Space(2),
        TextButton(
          child: Text('تلاش دوباره'),
          onPressed: _doRefresh,
        ),
      ],
    ));
  }

  String _buildFullName() {
    if (_data?.content == null ||
        (appState.profileData.firstName == null &&
            appState.profileData.lastName == null)) {
      return strings.NAME_AND_FAMILY;
    }

    return appState.profileData.fullName.withPersianLetters();
  }

  String _buildNationalNumber() {
    if (_data?.content == null || appState.profileData.nationalNumber == null) {
      return strings.NATIONAL_NUMBER;
    }

    return appState.profileData.nationalNumber.withPersianNumbers();
  }

  String _buildEmail() {
    if (appState.profileData.email == null) {
      return strings.EMAIL;
    }

    return appState.profileData.email;
  }

  String _buildBirthDate() {
    if (_data?.content == null || appState.profileData.birthDate == null) {
      return strings.BIRTH_DATE;
    }

    return appState.profileData.birthDate.withPersianNumbers();
  }

  String _buildBirthPlace() {
    if (_data?.content == null) {
      return strings.BIRTH_PLACE;
    }

    final birthCityId = appState.profileData.birthCityId;

    final birthProvince = iran.provinces.firstWhere(
      (element) => element.cities
          .where((element) => element.id == birthCityId)
          .isNotEmpty,
      orElse: () => null,
    );

    final birthCity = birthProvince?.cities
        ?.where((element) => element.id == birthCityId)
        ?.first;

    if (birthCity == null) {
      return strings.BIRTH_PLACE;
    }

    return '${birthProvince.name}، ${birthCity.name}';
  }

  String _buildAddress() {
    if (_data?.content == null) {
      return strings.ADDRESS;
    }

    final addressCityId = appState.profileData.addressCityId;

    final addressProvince = iran.provinces.firstWhere(
      (element) => element.cities
          .where((element) => element.id == addressCityId)
          .isNotEmpty,
      orElse: () => null,
    );

    final addressCity = addressProvince?.cities
        ?.where((element) => element.id == addressCityId)
        ?.first;

    if (addressCity == null) {
      return strings.ADDRESS;
    }

    if (appState.profileData.address == null ||
        appState.profileData.address.isEmpty) {
      return '${addressProvince.name}، ${addressCity.name}';
    }

    return '${addressProvince.name}، ${addressCity.name}، ${appState.profileData.address}';
  }

  @override
  Widget build(BuildContext context) {
    bool isEmpty = _data?.content == null;

    if (_data != null && _data.hasErrors() && _loading != true) {
      return Scaffold(
        body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _onRefresh,
          child: _buildError(
              _data.content?.description ?? strings.connectionError),
        ),
      );
    }

    return HeadedPage(
      title: Text('پروفایل'),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        child: _uploading
                            ? Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                                height: 96,
                                width: 96,
                              )
                            : ProfileImage(true),
                        padding: const EdgeInsets.all(8),
                      ),
                      Positioned(
                        child: Container(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: colors.primaryColor,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primaryColor.shade100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: const EdgeInsets.all(4),
                          height: 36,
                          width: 36,
                        ),
                        left: 0,
                        bottom: 0,
                      ),
                    ],
                  ),
                  onTap: _pickImage,
                ),
                Space(
                  2,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            _mobileNumber?.withPersianNumbers() ??
                                'شماره موبایل',
                            style: colors.boldStyle(context).copyWith(
                                  color: colors.primaryColor,
                                ),
                          ),
                          Space(
                            1,
                          ),
                          GestureDetector(
                            child: Text(
                              _buildFullName() == null ||
                                      _buildFullName().isEmpty
                                  ? 'نام و نام خانوادگی'
                                  : _buildFullName(),
                              style: colors.boldStyle(context).copyWith(
                                  color: _buildFullName() == null ||
                                          _buildFullName().isEmpty
                                      ? colors.primaryColor.shade300
                                      : colors.primaryColor,
                                  decoration: _buildFullName() == null ||
                                          _buildFullName().isEmpty
                                      ? TextDecoration.underline
                                      : null),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                            onTap: isEmpty
                                ? null
                                : () async {
                                    final ProfileData profile =
                                        await showCustomBottomSheet<
                                            ProfileData>(
                                      context: context,
                                      child: ProfileEditNamePage(
                                          appState.profileData),
                                    );

                                    if (profile != null) {
                                      setState(() {
                                        appState.profileData.firstName =
                                            profile.firstName;

                                        appState.profileData.lastName =
                                            profile.lastName;
                                      });
                                    }
                                  },
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectPasswordType()));
                      },
                      elevation: 0.0,
                      child: Container(
                        child: Text(
                          'تنظیمات ورود',
                        ),
                        padding: EdgeInsets.all(8),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: colors.primaryColor,
                        ),
                      ),
                      highlightElevation: 0.0,
                      focusColor: colors.greyColor.shade100,
                      focusElevation: 0.0,
                      hoverColor: colors.greyColor.shade100,
                      hoverElevation: 0,
                      textColor: colors.primaryColor,
                      color: colors.greyColor.shade100,
                      autofocus: false,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                Space(
                  3,
                ),
                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        child: ProfileRow(
                          title: strings.NATIONAL_NUMBER,
                          value: _buildNationalNumber(),
                          isEmpty: _data?.content == null ||
                              appState.profileData.nationalNumber == null,
                        ),
                        onTap: isEmpty
                            ? null
                            : () async {
                                final ProfileData profile =
                                    await showCustomBottomSheet<ProfileData>(
                                  context: context,
                                  child: ProfileEditNationalNumberPage(
                                      appState.profileData),
                                );

                                if (profile != null) {
                                  setState(() {
                                    appState.profileData.nationalNumber =
                                        profile.nationalNumber;
                                  });
                                }
                              },
                      ),
                      Space(
                        1,
                      ),
                      GestureDetector(
                        child: ProfileRow(
                          title: strings.EMAIL,
                          value: _buildEmail(),
                          isEmpty: appState.profileData.email == null,
                        ),
                        onTap: isEmpty
                            ? null
                            : () async {
                                final ProfileData profile =
                                    await showCustomBottomSheet<ProfileData>(
                                  context: context,
                                  child: ProfileEditEmailPage(
                                      appState.profileData),
                                );

                                if (profile != null) {
                                  setState(() {
                                    appState.profileData.email = profile.email;
                                  });
                                }
                              },
                      ),
                      Space(
                        1,
                      ),
                      GestureDetector(
                        child: ProfileRow(
                          title: strings.BIRTH_DATE,
                          value: _buildBirthDate(),
                          isEmpty: _data?.content == null ||
                              appState.profileData.birthDate == null,
                        ),
                        onTap: isEmpty
                            ? null
                            : () async {
                                final ProfileData profile =
                                    await showCustomBottomSheet<ProfileData>(
                                  context: context,
                                  child: ProfileEditBirthDatePage(
                                      appState.profileData),
                                );

                                if (profile != null) {
                                  setState(() {
                                    appState.profileData.birthDate =
                                        profile.birthDate;
                                  });
                                }
                              },
                      ),
                      Space(
                        1,
                      ),
                      GestureDetector(
                        child: ProfileRow(
                          title: strings.BIRTH_PLACE,
                          value: _buildBirthPlace(),
                          isEmpty: (_data?.content == null ||
                              appState.profileData.birthCityId == null),
                        ),
                        onTap: isEmpty
                            ? null
                            : () async {
                                final profile = await Navigator.of(context)
                                    .push<ProfileData>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileEditPlaceOfBirthPage(
                                            appState.profileData),
                                  ),
                                );

                                if (profile != null) {
                                  setState(() {});
                                }
                              },
                      ),
                      Space(
                        1,
                      ),
                      GestureDetector(
                        child: ProfileRow(
                          title: strings.ADDRESS,
                          value: _buildAddress(),
                          isEmpty: (_data?.content == null ||
                              appState.profileData.addressCityId == null),
                          child: appState.profileData.location != null
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9.0,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          child: map.Map(
                                            controller: map.MapController(
                                              location:
                                                  appState.profileData.location,
                                            ),
                                            builder: _buildTile,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        Center(
                                          child: Container(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    2, 2, 2, 40),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.red,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        onTap: isEmpty
                            ? null
                            : () async {
                                final profile = await Navigator.of(context)
                                    .push<ProfileData>(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileEditAddressPage(
                                            appState.profileData),
                                  ),
                                );

                                if (profile != null) {
                                  setState(() {
                                    appState.profileData.addressCityId =
                                        profile.addressCityId;

                                    appState.profileData.address =
                                        profile.address;
                                    appState.profileData.location =
                                        profile.location;
                                  });
                                }
                              },
                      ),
                      Space(
                        1,
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
        ),
      ),
    );
  }

  void _doRefresh() {
    _refreshKey.currentState?.show();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _loading = true;
    });

    final data = await nh.profile.getUserProfile();

    if (!data.hasErrors()) {
      appState.profileData.addressCityId = data.content.addressCityId;
      appState.profileData.birthCityId = data.content.birthCityId;
      appState.profileData.birthDate = data.content.birthDate;
      appState.profileData.email = data.content.email;
      appState.profileData.firstName = data.content.firstName;
      appState.profileData.lastName = data.content.lastName;
      appState.profileData.location = data.content.location;
      appState.profileData.nationalNumber = data.content.nationalNumber;
      appState.profileData.address = data.content.address;
      appState.profileData.score = data.content.score;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
      _data = data;
    });
  }

  void _pickImage() async {
    bool preferCamera = false;

    if (getPlatform() != PlatformType.web) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('انتخاب عکس'),
          children: [
            SimpleDialogItem(
              icon: Icons.image,
              text: 'از گالری',
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            SimpleDialogItem(
              icon: Icons.camera_alt,
              text: 'از دوربین',
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );

      if (result == null) {
        return;
      }

      preferCamera = result;
    }

    var image = await pickImage(preferCamera: preferCamera);

    if (image == null) {
      return;
    }

    setState(() {
      _uploading = true;
    });

    //image = Uint8List.fromList(ensureImageSize(image.toList()));

    ProfileImage.emptyCache();

    /*final json = */
    await nh.uploadMultipart(
      path: 'profile/profilepicture',
      field: 'avatar',
      content: image,
    );

    setState(() {
      _uploading = false;
      appState.profileData.image++;
    });
  }
}

class ProfileEditNamePage extends StatefulWidget {
  ProfileEditNamePage(this.profileData);

  final ProfileData profileData;

  @override
  State<StatefulWidget> createState() => _ProfileEditNamePageState();
}

class _ProfileEditNamePageState extends State<ProfileEditNamePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    _firstNameController.text = widget.profileData.firstName;
    _lastNameController.text = widget.profileData.lastName;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _familyFocusNode = FocusNode();
    final _nameFocusNode = FocusNode();
    return Split(
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(top: 8.0, start: 24.0, end: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NameTextFormField(
                focusNode: _nameFocusNode,
                controller: _firstNameController,
                onEditingComplete: () {
                  _nameFocusNode.unfocus();
                  _familyFocusNode.requestFocus();
                },
              ),
              Space(2),
              LastNameTextFormField(
                focusNode: _familyFocusNode,
                controller: _lastNameController,
                onEditingComplete: () {
                  _familyFocusNode.unfocus();
                },
              ),
              Space(2),
            ],
          ),
        ),
      ),
      footer: Padding(
        padding:
            EdgeInsetsDirectional.only(start: 24.0, end: 24.0, bottom: 24.0),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            style: colors
                .tabStyle(context)
                .copyWith(color: colors.greyColor.shade50),
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            final firstName = _firstNameController.text;
            final lastName = _lastNameController.text;

            final data = await nh.profile
                .insertUserProfile(firstName: firstName, lastName: lastName);

            if (!showError(context, data)) {
              return;
            }

            widget.profileData.firstName = firstName;
            widget.profileData.lastName = lastName;

            Navigator.of(context).pop(widget.profileData);
          },
        ),
      ),
    );
  }
}

class ProfileEditNationalNumberPage extends StatefulWidget {
  ProfileEditNationalNumberPage(this.profileData);

  final ProfileData profileData;

  @override
  State<StatefulWidget> createState() => _ProfileEditNationalNumberPageState();
}

class _ProfileEditNationalNumberPageState
    extends State<ProfileEditNationalNumberPage> {
  final _formKey = GlobalKey<FormState>();
  final _nationalNumberController = TextEditingController();

  @override
  void initState() {
    _nationalNumberController.text = widget.profileData.nationalNumber;

    super.initState();
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'کد ملی را وارد نمایید';
    }

    if (value.length != 10) {
      return 'کد ملی باید ده رقم باشد';
    }

    if (!ir.validateNationalNumber(value.withEnglishNumbers())) {
      return 'کد ملی معتبر نیست';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 24.0, end: 24.0, top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                validator: _validator,
                maxLength: 10,
                controller: _nationalNumberController,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                    hintText: 'مثلا: 0123456789'.withPersianNumbers(),
                    labelText: strings.label_national_number,
                    counterText: ''),
              ),
            ),
            Space(2),
          ],
        ),
      ),
      footer: Padding(
        padding:
            EdgeInsetsDirectional.only(start: 24.0, end: 24.0, bottom: 24.0),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            style: colors
                .tabStyle(context)
                .copyWith(color: colors.greyColor.shade50),
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              return;
            }

            final nationalNumber = _nationalNumberController.text;

            final data = await nh.profile
                .insertUserProfile(nationalNumber: nationalNumber);

            if (!showError(context, data)) {
              return;
            }

            widget.profileData.nationalNumber = nationalNumber;

            Navigator.of(context).pop(widget.profileData);
          },
        ),
      ),
    );
  }
}

class ProfileEditEmailPage extends StatefulWidget {
  ProfileEditEmailPage(this.profileData);

  final ProfileData profileData;

  @override
  State<StatefulWidget> createState() => _ProfileEditEmailPageState();
}

class _ProfileEditEmailPageState extends State<ProfileEditEmailPage> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _controller.text = widget.profileData.email;

    super.initState();
  }

  String _emailValidator(String eml) {
    if (eml == null || eml.isEmpty) {
      return 'ایمیل خود را وارد نمایید';
    }
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(eml)) {
      return 'ایمیل وارد شده صحیح نیست.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
            start: 24.0, end: 24.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                validator: _emailValidator,
                controller: _controller,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  hintText: 'you@example.com'.withPersianNumbers(),
                  hintTextDirection: TextDirection.ltr,
                  labelText: 'آدرس ایمیل',
                ),
              ),
            ),
            Space(2),
          ],
        ),
      ),
      footer: Padding(
        padding:
            EdgeInsetsDirectional.only(start: 24.0, end: 24.0, bottom: 24.0),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            style: colors
                .tabStyle(context)
                .copyWith(color: colors.greyColor.shade50),
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              return;
            }
            final email = _controller.text;
            final data = await nh.profile.insertUserProfile(email: email);

            if (!showError(context, data)) {
              return;
            }

            widget.profileData.email = email;

            Navigator.of(context).pop(widget.profileData);
          },
        ),
      ),
    );
  }
}

class ProfileEditPlaceOfBirthPage extends StatefulWidget {
  ProfileEditPlaceOfBirthPage(this.profileData);

  final ProfileData profileData;

  @override
  State<StatefulWidget> createState() => _ProfileEditPlaceOfBirthPageState();
}

class _ProfileEditPlaceOfBirthPageState
    extends State<ProfileEditPlaceOfBirthPage> {
  Province _province;
  City _city;

  @override
  void initState() {
    int cityId = widget.profileData.birthCityId;
    _province = iran.findProvinceByCityId(cityId);
    _city = iran.findCityById(cityId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('ویرایش محل تولد'),
      body: Split(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 24.0, end: 24.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(children: [
                  InkWell(
                    onTap: _showProvinceSelectionDialog,
                    child: Container(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.primaryColor),
                      ),
                      child: DualListTile(
                        start: Text(
                          _province?.name ?? 'استان محل تولد',
                          textAlign: TextAlign.center,
                        ),
                        end: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: colors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ]),
                Space(2),
                Column(children: [
                  InkWell(
                    onTap: _province == null ? null : _showCitySelectionDialog,
                    child: Container(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.primaryColor),
                      ),
                      child: DualListTile(
                        start: Text(
                          _city?.name ?? 'شهر محل تولد',
                          textAlign: TextAlign.center,
                        ),
                        end: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: colors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ]),
                Space(3),
                Text(
                  'لطفا استان و شهر محل تولد خود را به درستی انتخاب نمایید',
                  style: colors.bodyStyle(context),
                ),
              ],
            ),
          ),
        ),
        footer: Padding(
          padding:
              EdgeInsetsDirectional.only(start: 24.0, end: 24.0, bottom: 24.0),
          child: ConfirmButton(
            child: CustomText(
              strings.action_ok,
              style: colors
                  .tabStyle(context)
                  .copyWith(color: colors.greyColor.shade50),
              textAlign: TextAlign.center,
            ),
            onPressed: (_province == null || _city == null)
                ? null
                : () async {
                    final city = _city?.id ?? -1;

                    final data =
                        await nh.profile.insertUserProfile(birthCityId: city);

                    if (!showError(context, data)) {
                      return;
                    }

                    widget.profileData.birthCityId = city;

                    Navigator.of(context).pop(widget.profileData);
                  },
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

    setState(() {
      _province = selectedProvince;
      _city = null;
    });
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

    setState(() {
      _city = selectedCity;
    });
  }
}

class ProfileEditAddressPage extends StatefulWidget {
  ProfileEditAddressPage(this.profileData);

  final ProfileData profileData;

  @override
  State<StatefulWidget> createState() => _ProfileEditAddressPageState();
}

class _ProfileEditAddressPageState extends State<ProfileEditAddressPage> {
  final _addressController = TextEditingController();
  Province _province;
  City _city;
  LatLng _location;

  @override
  void initState() {
    _addressController.text = widget.profileData.address;
    _location = widget.profileData.location;
    int cityId = widget.profileData.addressCityId;
    _province = iran.findProvinceByCityId(cityId);
    _city = iran.findCityById(cityId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('ویرایش محل سکونت'),
      body: Split(
        child: Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsetsDirectional.only(
                start: 24.0, end: 24.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(children: [
                  InkWell(
                    onTap: _showProvinceSelectionDialog,
                    child: Container(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: colors.primaryColor),
                      ),
                      child: DualListTile(
                        start: Text(
                          _province?.name ?? 'استان محل سکونت',
                          textAlign: TextAlign.center,
                        ),
                        end: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: colors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ]),
                Space(2),
                Column(children: [
                  InkWell(
                    onTap: _province == null ? null : _showCitySelectionDialog,
                    child: Container(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 4.0, 16.0, 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: colors.primaryColor),
                        ),
                        child: DualListTile(
                          start: Text(
                            _city?.name ?? 'شهر محل سکونت',
                            textAlign: TextAlign.center,
                          ),
                          end: Icon(
                            Icons.arrow_drop_down_outlined,
                            color: colors.primaryColor,
                          ),
                        )),
                  ),
                ]),
                Space(2),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'خیابان، کوچه، پلاک، طبقه، واحد',
                    labelText: 'آدرس پستی',
                  ),
                  minLines: 2,
                ),
                Space(3),
                Text(
                  'لطفا استان و شهر محل سکونت خود را به درستی انتخاب نمایید.',
                  style: colors.bodyStyle(context),
                ),
                if (_location != null) Space(1),
                if (_location != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: InkWell(
                      onTap: _showMap,
                      child: AspectRatio(
                        aspectRatio: 16 / 9.0,
                        child: Stack(
                          children: [
                            map.Map(
                              controller: map.MapController(
                                location: _location,
                              ),
                              builder: _buildTile,
                            ),
                            Center(
                              child: Container(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(2, 2, 2, 40),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.red,
                                  size: 50,
                                ),
                              ),
                            ),
                            Positioned(
                                left: 8,
                                top: 8,
                                child: IconButton(
                                  color: colors.primaryColor,
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _location = null;
                                    });
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_location == null) Space(1),
                if (_location == null)
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      constraints: BoxConstraints(minWidth: 80, maxWidth: 180),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: RaisedButton(
                            colorBrightness: Brightness.dark,
                            color: colors.ternaryColor,
                            child: Text('انتخاب نقشه'),
                            onPressed: _showMap),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        footer: Padding(
          padding: EdgeInsetsDirectional.only(
              start: 24.0, end: 24.0, bottom: 24.0, top: 24.0),
          child: ConfirmButton(
            child: CustomText(
              strings.action_ok,
              style: colors
                  .tabStyle(context)
                  .copyWith(color: colors.greyColor.shade50),
              textAlign: TextAlign.center,
            ),
            onPressed: (_province == null || _city == null)
                ? null
                : () async {
                    final city = _city?.id == widget.profileData.addressCityId
                        ? null
                        : _city.id;

                    final address =
                        _addressController.text == widget.profileData.address
                            ? null
                            : _addressController.text;

                    LatLng location = _location;

                    if (location == null) {
                      if (widget.profileData != null) {
                        location = LatLng(-1000, -1000);
                      }
                    }

                    final data = await nh.profile.insertUserProfile(
                        addressCityId: city,
                        address: address,
                        location: location);

                    if (!showError(context, data)) {
                      return;
                    }

                    if (city != null) {
                      widget.profileData.addressCityId = city;
                    }

                    if (address != null) {
                      widget.profileData.address = address;
                    }
                    if (_location == null) {
                      widget.profileData.location = null;
                    } else {
                      widget.profileData.location = location;
                    }

                    analytics.setProvinceUserProperty(value: _province?.name);
                    analytics.setCityUserProperty(value: _city?.name);

                    Navigator.of(context).pop(widget.profileData);
                  },
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

    setState(() {
      _province = selectedProvince;
      _city = null;
    });
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

    setState(() {
      _city = selectedCity;
    });
  }

  void _showMap() async {
    final latlong = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          initialZoom: _location == null ? 9 : 14,
          initialLocation: _location ?? LatLng(35.79, 51.41),
        ),
      ),
    );

    if (latlong != null) {
      setState(() {
        _location = latlong;
      });
    }
  }
}

class ProfileEditBirthDatePage extends StatefulWidget {
  ProfileEditBirthDatePage(this.profileData);

  final ProfileData profileData;

  @override
  State<StatefulWidget> createState() => _ProfileEditBirthDatePageState();
}

class _ProfileEditBirthDatePageState extends State<ProfileEditBirthDatePage> {
  final _controller = TextEditingController();
  PersianDatePickerWidget _datePickerWidget;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.profileData.birthDate?.replaceAll('-', '');
    _datePickerWidget = getPersianDatePicker(_controller);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: Padding(
        padding:
            const EdgeInsetsDirectional.only(start: 24.0, end: 24.0, top: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _datePickerWidget,
            ],
          ),
        ),
      ),
      footer: Padding(
        padding:
            EdgeInsetsDirectional.only(start: 24.0, end: 24.0, bottom: 24.0),
        child: ConfirmButton(
          child: CustomText(
            strings.action_ok,
            style: colors
                .tabStyle(context)
                .copyWith(color: colors.greyColor.shade50),
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            final birthDate = _controller.text;
            if (birthDate != null) {
              final data =
                  await nh.profile.insertUserProfile(birthDate: birthDate);

              if (!showError(context, data)) {
                return;
              }

              widget.profileData.birthDate = birthDate;
              int age = getAgeFromBirthDate(birthDate);
              if (age != null) {
                analytics.setAgeUserProperty(value: age.toString());
              }
            }

            Navigator.of(context).pop(widget.profileData);
          },
        ),
      ),
    );
  }
}

class SimpleDialogItem extends StatelessWidget {
  const SimpleDialogItem(
      {Key key, this.icon, this.color, this.text, this.onPressed})
      : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(child: Icon(icon), backgroundColor: color),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 16.0),
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
