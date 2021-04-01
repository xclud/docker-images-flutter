import 'package:flutter/material.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/mixins/phone_selection_mixin.dart';
import 'package:novinpay/pages/insured_list_page.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/mobile_input.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class InsurerInformationPage extends StatefulWidget {
  @override
  _InsurerInformationPageState createState() => _InsurerInformationPageState();
}

class _InsurerInformationPageState extends State<InsurerInformationPage>
    with MruSelectionMixin, PhoneSelectionMixin, AskYesNoMixin {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _familyController = TextEditingController();
  final _mobileController = TextEditingController();
  final _nationalCodeController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _idNumberCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _familyFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _nationalFocusNode = FocusNode();
  final _idFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _familyController.dispose();
    _mobileController.dispose();
    _nationalCodeController.dispose();
    _birthDateController.dispose();
    _idNumberCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<bool> canPop() async {
    final ableTOPop = await askYesNo(
      title: null,
      content: Text(
        'با بازگشت از این قسمت تمامی اطلاعات شما پاک خواهد شد آیا میخواهید خارج شوید؟',
      ),
    );

    if (ableTOPop ?? false) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('اطلاعات بیمه کننده'),
        body: WillPopScope(
          onWillPop: () => canPop(),
          child: Split(
            child: Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                child: SingleChildScrollView(
                  child: Form(
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
                        Space(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            footer: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
              child: ConfirmButton(
                child: CustomText(
                  'بعدی',
                  textAlign: TextAlign.center,
                ),
                onPressed: _submit,
              ),
            ),
          ),
        ));
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    OrderCreator orderCreator = OrderCreator(
        name: _nameController.text,
        lastName: _familyController.text,
        mobile: _mobileController.text,
        nationalCode: _nationalCodeController.text,
        birthDate: _birthDateController.text,
        idNumber: _idNumberCodeController.text,
        phone: _phoneController.text);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsuredListPage(
          orderCreator: orderCreator,
        ),
      ),
    );
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

class OrderCreator {
  OrderCreator(
      {this.name,
      this.lastName,
      this.mobile,
      this.nationalCode,
      this.birthDate,
      this.phone,
      this.idNumber});

  String name;
  String lastName;
  String mobile;
  String nationalCode;
  String birthDate;
  String idNumber;
  String phone;
}
