import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';

class WalletAddGroupDialog extends StatefulWidget {
  WalletAddGroupDialog({this.walletGroupInfo});

  final WalletGroupInfo walletGroupInfo;

  @override
  _WalletAddGroupDialogState createState() {
    return _WalletAddGroupDialogState();
  }
}

class _WalletAddGroupDialogState extends State<WalletAddGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _inputTextFieldName = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _confirmButtonFocusNode = FocusNode();

  int groupId;

  String _nameValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'نام را وارد نمایید.';
    }

    return null;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _inputTextFieldName.text = widget.walletGroupInfo?.groupName;
      _descriptionController.text = widget.walletGroupInfo?.description;
      groupId = widget.walletGroupInfo.groupId;
    });
    super.initState();
  }

  @override
  void dispose() {
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'لطفا جهت اضافه کردن یا ویرایش گروه، اطلاعات زیر را وارد نمایید',
                  style: colors.bodyStyle(context),
                ),
                Space(2),
                TextFormField(
                  focusNode: _nameFocusNode,
                  controller: _inputTextFieldName,
                  validator: _nameValidator,
                  onEditingComplete: () {
                    _nameFocusNode.unfocus();
                    _descriptionFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    labelText: 'نام گروه',
                    counterText: '',
                  ),
                ),
                Space(2),
                TextFormField(
                  focusNode: _descriptionFocusNode,
                  controller: _descriptionController,
                  onEditingComplete: () {
                    _descriptionFocusNode.unfocus();
                    _confirmButtonFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    labelText: 'توضیحات',
                    hintText: 'توضیحات',
                    counterText: '',
                  ),
                ),
                Space(2),
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
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            WalletGroupInfo walletGroupInfo = WalletGroupInfo(
                groupName: _inputTextFieldName.text,
                description: _descriptionController.text,
                groupId: groupId);
            Navigator.of(context).pop(walletGroupInfo);
          },
        ),
      ),
    );
  }
}

class WalletGroupInfo {
  WalletGroupInfo({
    this.groupName,
    this.description,
    this.groupId,
  });

  String groupName;
  String description;
  int groupId;
}
