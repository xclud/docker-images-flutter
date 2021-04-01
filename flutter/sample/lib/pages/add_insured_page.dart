import 'package:flutter/material.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/mixins/phone_selection_mixin.dart';
import 'package:novinpay/pages/insured_list_page.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/space.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/mobile_input.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class AddInsuredPage extends StatefulWidget {
  AddInsuredPage({
    @required this.type,
    this.insuredModel,
  });

  final InsuredModel insuredModel;
  final PageType type;

  @override
  _AddInsuredPageState createState() {
    return _AddInsuredPageState();
  }
}

class _AddInsuredPageState extends State<AddInsuredPage>
    with MruSelectionMixin, PhoneSelectionMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _familyController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nationalCodeController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idNumberCodeController = TextEditingController();
  final _familyFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _nationalFocusNode = FocusNode();
  final _idFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = widget.insuredModel?.name ?? '';
      _familyController.text = widget.insuredModel?.lastName ?? '';
      _mobileController.text = widget.insuredModel?.mobile ?? '';
      _nationalCodeController.text = widget.insuredModel?.nationalCode ?? '';
      _birthDateController.text = widget.insuredModel?.birthDate ?? '';
      _phoneController.text = widget.insuredModel?.phone ?? '';
      _idNumberCodeController.text =
          widget.insuredModel?.idNumber?.toString() ?? '';
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _familyController.dispose();
    _mobileController.dispose();
    _nationalCodeController.dispose();
    _birthDateController.dispose();
    _phoneController.dispose();
    _idNumberCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: widget.type == PageType.Add
          ? Text('افزودن بیمه شونده')
          : Text('ویرایش بیمه شونده'),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
        child: Split(
          child: Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Space(),
                        NameTextFormField(
                          focusNode: _nameFocusNode,
                          controller: _nameController,
                          onEditingComplete: () {
                            _nameFocusNode.unfocus();
                            _familyFocusNode.requestFocus();
                          },
                        ),
                        Space(2),
                        LastNameTextFormField(
                          focusNode: _familyFocusNode,
                          controller: _familyController,
                          onEditingComplete: () {
                            _familyFocusNode.unfocus();
                            _mobileFocusNode.requestFocus();
                          },
                        ),
                        Space(2),
                        MobileWidget(
                          focusNode: _mobileFocusNode,
                          controller: _mobileController,
                          showSimCard: false,
                          onChanged: (value) {
                            if (value.length == 11) {
                              _mobileFocusNode.unfocus();
                              _nationalFocusNode.requestFocus();
                            }
                          },
                          onEditingComplete: () {
                            _mobileFocusNode.unfocus();
                            _nationalFocusNode.requestFocus();
                          },
                        ),
                        Space(2),
                        NationalNumberTextFormField(
                          focusNode: _nationalFocusNode,
                          controller: _nationalCodeController,
                          onEditingComplete: () {
                            _nationalFocusNode.unfocus();
                            _idFocusNode.requestFocus();
                          },
                        ),
                        Space(2),
                        IdNumberTextFormField(
                          focusNode: _idFocusNode,
                          controller: _idNumberCodeController,
                          onEditingComplete: () {
                            _idFocusNode.unfocus();
                            _phoneFocusNode.requestFocus();
                          },
                        ),
                        Space(2),
                        PhoneTextFormField(
                          showSelectionDialog: _showPhoneSelectionDialog,
                          focusNode: _phoneFocusNode,
                          controller: _phoneController,
                          onComplete: () {
                            _phoneFocusNode.unfocus();
                          },
                          onEditingComplete: () {
                            _phoneFocusNode.unfocus();
                          },
                        ),
                        Space(2),
                        PersianDateTextFormField(
                          allowEmpty: false,
                          labelText: 'تاریخ تولد',
                          name: 'تاریخ تولد',
                          controller: _birthDateController,
                        ),
                        Space(2),
                      ],
                    ),
                  ),
                ],
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

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    InsuredModel insuredModel = InsuredModel(
      name: _nameController.text,
      lastName: _familyController.text,
      mobile: _mobileController.text,
      idNumber: _idNumberCodeController.text,
      nationalCode: _nationalCodeController.text,
      birthDate: _birthDateController.text,
      phone: _phoneController.text,
      orderingId: widget?.insuredModel?.orderingId,
    );
    Navigator.of(context).pop(insuredModel);
  }

  void _showPhoneSelectionDialog() async {
    final data = await showPhoneSelectionDialog();
    if (data == null) {
      return;
    }

    final phone = data.value;
    _phoneController.text = phone;
    _submit();
  }
}
