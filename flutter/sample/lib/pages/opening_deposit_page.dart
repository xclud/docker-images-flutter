import 'package:flutter/material.dart';
import 'package:novinpay/dialogs/account_type_dialog.dart';
import 'package:novinpay/dialogs/branch_code_dialog.dart';
import 'package:novinpay/models/GetInformationResponse.dart';
import 'package:novinpay/pages/opening_deposit_get_info.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/faraboom_authenticator.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class OpeningDepositPage extends StatefulWidget {
  @override
  OpeningDepositPageState createState() => OpeningDepositPageState();
}

class OpeningDepositPageState extends State<OpeningDepositPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Branch _selectedBranch;
  AccountType _accountType;
  final List<Branch> _branches = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getBranchCodes();
    });
    super.initState();
  }

  void _getBranchCodes() async {
    final response = await nh.boomMarket.getInformation();
    if (!showError(context, response)) {
      return;
    }

    _branches.addAll(response.content.branchs);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      scaffoldKey: _scaffoldKey,
      title: CustomText('افتتاح حساب'),
      body: Form(
        key: _formKey,
        child: FaraboomAuthenticator(
          route: routes.opening_deposit,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                'افتتاح حساب در بانک اقتصاد نوین',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextButton(
                      child: Text(_accountType?.name ?? 'نوع سپرده'),
                      onPressed: () async {
                        final data = await showCustomDraggableBottomSheet<AccountType>(
                          context: context,
                          title: Text('نوع سپرده'),
                          initialChildSize: 0.7,
                          builder: (context, scrollController) =>
                              AccountTypeSelectionDialog(
                            scrollController: scrollController,
                          ),
                        );

                        setState(() {
                          _accountType = data;
                        });
                      },
                    ),
                    TextButton(
                      child: Text(_selectedBranch?.name ?? 'نام شعبه'),
                      onPressed: _selectBranch,
                    ),
                    TextButton(
                      child: Text(_selectedBranch?.code
                              ?.toString()
                              ?.withPersianNumbers() ??
                          'کد شعبه'),
                      onPressed: _selectBranch,
                    ),
                  ],
                ),
              ),
              ConfirmButton(
                onPressed: (_selectedBranch == null || _accountType == null)
                    ? null
                    : () async {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        if (_selectedBranch == null) {
                          return;
                        }

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OpeningDepositGetInfoPage(
                              accountType: _accountType,
                              branchCode: _selectedBranch.code,
                            ),
                          ),
                        );
                      },
                child: CustomText(
                  strings.action_ok,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _selectBranch() async {
    final data = await showCustomDraggableBottomSheet<Branch>(
      context: context,
      title: Text('شعبه'),
      initialChildSize: 0.7,
      builder: (context, scrollController) => BranchCodeDialog(),
    );

    if (data == null) {
      return;
    }

    setState(() {
      _selectedBranch = data;
    });
  }
}
