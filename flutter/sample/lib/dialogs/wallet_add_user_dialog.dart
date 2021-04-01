import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/wallet.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/mobile_input.dart';
import 'package:persian/persian.dart';

class WalletAddUserDialog extends StatefulWidget {
  WalletAddUserDialog({this.user, this.isEdit});
  final WalletGroupUserListData user;
  final bool isEdit;

  @override
  _WalletAddUserDialogState createState() => _WalletAddUserDialogState();
}

class _WalletAddUserDialogState extends State<WalletAddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _mobileFocusNode = FocusNode();
  final _confirmButtonFocusNode = FocusNode();

  String _firstNameValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'نام را وارد نمایید';
    }
    return null;
  }

  String _lastNameValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'نام خانوادگی را وارد نمایید';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.user?.name != null && widget.user.name.isNotEmpty) {
        _firstNameController.text = widget.user.name;
      }
      if (widget.user?.family != null && widget.user.family.isNotEmpty) {
        _lastNameController.text = widget.user.family;
      }

      if (widget.user?.customerId != null &&
          widget.user.customerId.isNotEmpty) {
        _mobileController.text = widget.user.customerId;
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (widget.isEdit)
                  DualListTile(
                    start: Text('شماره موبایل'),
                    end: Text(
                        widget.user?.customerId?.withPersianNumbers() ?? ''),
                  ),
                if (widget.isEdit) Space(2),
                TextFormField(
                  focusNode: _firstNameFocusNode,
                  controller: _firstNameController,
                  validator: _firstNameValidator,
                  onEditingComplete: () {
                    _firstNameFocusNode.unfocus();
                    _lastNameFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'مثلا: محمد',
                    labelText: 'نام',
                  ),
                ),
                Space(2),
                TextFormField(
                  focusNode: _lastNameFocusNode,
                  controller: _lastNameController,
                  validator: _lastNameValidator,
                  onEditingComplete: () {
                    _lastNameFocusNode.unfocus();
                    _mobileFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'مثلا: محمدی',
                    labelText: 'نام خانوادگی',
                  ),
                ),
                Space(2),
                if (!widget.isEdit)
                  MobileWidget(
                    showMruIcon: true,
                    showSimCard: false,
                    focusNode: _mobileFocusNode,
                    controller: _mobileController,
                    onEditingComplete: () {
                      _mobileFocusNode.unfocus();
                      _confirmButtonFocusNode.requestFocus();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      footer: Padding(
        padding: EdgeInsets.only(bottom: 24.0, left: 24, right: 24.0),
        child: ConfirmButton(
          focusNode: _confirmButtonFocusNode,
          child: CustomText(
            strings.action_ok,
            style: colors
                .tabStyle(context)
                .copyWith(color: colors.greyColor.shade50),
            textAlign: TextAlign.center,
          ),
          onPressed: _submit,
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final user = WalletGroupUserListData(
        customerId: _mobileController.text,
        name: _firstNameController.text,
        family: _lastNameController.text);

    Navigator.of(context).pop(user);
  }
}
