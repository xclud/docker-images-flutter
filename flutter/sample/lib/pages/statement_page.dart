import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/account_selection.dart';
import 'package:novinpay/mixins/bank_login.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/models/StatementResponse.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/faraboom_authenticator.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class StatementPage extends StatefulWidget {
  @override
  _StatementPageState createState() => _StatementPageState();
}

class _StatementPageState extends State<StatementPage>
    with BankLogin, MruSelectionMixin, AccountSelection {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final List<Statement> _items = [];
  bool _hasData = false;

//  String _accountValidator(String value) {
//    if (value == null || value.isEmpty) {
//      return 'شماره حساب را وارد نمایید';
//    }
//    if (value.length < 17) {
//      return 'شماره حساب را به صورت صحیح وارد نمایید';
//    }
//    return null;
//  }

  @override
  Widget build(BuildContext context) {
    final form = Form(
      key: _formKey,
      child: AccountTextFormField(
        controller: _accountController,
        showSelectionDialog: _showSelectionDialog,
      ),
    );

    final cards = _items.map(buildCard).toList();

    final message = Text(
      'لطفا شماره حساب خود را وارد نمایید.',
      textAlign: TextAlign.center,
      softWrap: true,
    );

    Widget child;

    if (_hasData) {
      child = Expanded(
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...cards,
              ],
            ),
          ),
        ),
      );
    } else {
      child = Expanded(
        child: Center(child: message),
      );
    }

    return HeadedPage(
      title: Text('گردش حساب'),
      body: FaraboomAuthenticator(
        route: routes.statement,
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
          child: Split(
            header: form,
            child: child,
            footer: ConfirmButton(
              child: CustomText(
                strings.action_inquiry,
                textAlign: TextAlign.center,
              ),
              onPressed: _submit,
              color: colors.ternaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Statement item) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: colors.greyColor.shade600,
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 16,
                    right: 24,
                    bottom: 0,
                  ),
                  child: Text(
                    '$lrm${item.datePersian}'.withPersianNumbers(),
                    style: colors.bodyStyle(context),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 6,
                  right: 24,
                  bottom: 6,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    top: 0,
                    right: 0,
                    bottom: 6,
                  ),
                  child: Text(
                    toRials(item.transferAmount, true),
                    style: colors.boldStyle(context),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  top: 16,
                  right: 24,
                  bottom: 16,
                ),
                child: Text(
                  item.description
                          ?.withPersianLetters()
                          ?.withPersianNumbers() ??
                      '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: colors.bodyStyle(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSelectionDialog() async {
    final data = await showSourceAccountSelectionDialog();
    if (data == null) {
      return;
    }

    _accountController.text = data.value;
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    final result = await ensureBankLogin(routes.statement);
    if (result == null) {
      return;
    }
    setState(() {
      _hasData = false;
    });

    final data = await Loading.run(
      context,
      nh.boomMarket.statement(
        depositNumber: _accountController.text,
      ),
    );

    setState(() {
      _hasData = true;
    });

    if (!showError(context, data)) {
      return;
    }

    _items.clear();
    _items.addAll(data.content.statements);
    nh.mru.addMru(
        type: MruType.sourceAccount,
        title: null,
        value: _accountController.text);
    setState(() {});
  }
}
