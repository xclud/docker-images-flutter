import 'package:flutter/material.dart';

class AccountType {
  const AccountType({
    @required this.code,
    @required this.name,
    @required this.group,
  });

  final int code;
  final String name;
  final String group;
}

final _accountTypes = [
  AccountType(
      group: 'SPECIAL_LONG_ACCOUNT', code: 515, name: 'سپرده های بلند مدت خاص'),
  AccountType(group: 'CURRENT_ACCOUNT', code: -1, name: 'سپرده جاری'),
  AccountType(group: 'SHORT_ACCOUNT', code: -1, name: 'سپرده کوتاه مدت'),
  AccountType(group: 'LONG_ACCOUNT', code: -1, name: 'سپرده بلند مدت'),
  AccountType(group: 'SAVING_ACCOUNT', code: -1, name: 'سپرده پس انداز'),
  AccountType(
      group: 'SPECIAL_SHORT_ACCOUNT',
      code: -1,
      name: 'سپرده سرمایه گذاری - کوتاه مدت ویژه'),
  AccountType(group: 'MANAGED_FUNDS_ACCOUNT', code: -1, name: 'وجوه اداره شده'),
  AccountType(group: 'RESERVE_ACCOUNT', code: -1, name: 'سپرده اندوخته'),
  AccountType(group: 'OTHERS', code: -1, name: 'سایر سپرده ها'),
];

class AccountTypeSelectionDialog extends StatefulWidget {
  AccountTypeSelectionDialog({this.scrollController});

  final ScrollController scrollController;

  @override
  _AccountTypeSelectionDialogState createState() =>
      _AccountTypeSelectionDialogState();
}

class _AccountTypeSelectionDialogState
    extends State<AccountTypeSelectionDialog> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 4),
      controller: widget.scrollController,
      itemCount: _accountTypes.length,
      itemBuilder: (context, index) {
        final item = _accountTypes[index];
        return ListTile(
          enabled: item.code > 0,
          title: Text(item.name),
          onTap: item.code < 0
              ? null
              : () {
                  Navigator.of(context).pop(item);
                },
        );
      },
    );
  }
}
