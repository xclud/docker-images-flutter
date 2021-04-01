import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/wallet_add_group_dialog.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/wallet.dart';
import 'package:novinpay/pages/wallet_user_list_page.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class WalletGroupManagement extends StatefulWidget {
  @override
  _WalletGroupManagementState createState() {
    return _WalletGroupManagementState();
  }
}

class _WalletGroupManagementState extends State<WalletGroupManagement>
    with AskYesNoMixin {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Widget _buildGroups() {
    final data = _response.content.ewalletGroupList;

    final items = data.map(
      (e) => _buildGroupItem(
        groupName: e.groupName,
        contactCount: e.ewalletGroupUser.length,
        groupDescription: e.ewalletDescription,
        groupId: e.groupId,
      ),
    );

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8.0),
      child: Column(
        children: items.toList(),
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('مدیریت گروه'),
      body: Split(
        child: Expanded(
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _refresh,
            child: Builder(
              builder: (context) {
                if (_response == null) {
                  return Container();
                }
                if (_response.isError) {
                  return _buildMessage(strings.connectionError);
                }

                if (_response.content.status != true) {
                  return _buildMessage(_response.content.description);
                }

                final billList = _response.content.ewalletGroupList;

                if (billList.isEmpty) {
                  return _buildMessage(strings.noItemsFound);
                }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _buildGroups(),
                );
              },
            ),
          ),
        ),
        footer: Padding(
          padding: EdgeInsets.only(bottom: 24.0, left: 24, right: 24.0),
          child: ConfirmButton(
            child: CustomText(
              'افزودن گروه جدید',
              textAlign: TextAlign.center,
              style: colors
                  .tabStyle(context)
                  .copyWith(color: colors.greyColor.shade50),
            ),
            onPressed: () => _addGroup(''),
          ),
        ),
      ),
    );
  }

  Response<WalletGroupListResponse> _response;

  Future<void> _refresh() async {
    final data = await nh.wallet.walletGroupList();
    _response = data;

    if (mounted) {
      setState(() {});
    }
  }

  void _addGroup(String billId) async {
    final WalletGroupInfo walletGroupInfo =
        await showCustomBottomSheet<WalletGroupInfo>(
            context: context,
            child: WalletAddGroupDialog(
              walletGroupInfo: WalletGroupInfo(),
            ));

    if (walletGroupInfo == null) {
      return;
    }

    final response = await Loading.run(
        context,
        nh.wallet.walletGroupAddNew(
          groupName: walletGroupInfo.groupName,
          description: walletGroupInfo.description,
        ));

    if (!showError(context, response)) {
      return;
    }

    _refreshKey.currentState.show();
  }

  Widget _buildGroupItem({
    @required int contactCount,
    @required int groupId,
    @required String groupName,
    @required String groupDescription,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 24.0, end: 24.0, bottom: 8.0),
      child: Container(
          decoration: BoxDecoration(
              color: colors.greyColor,
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 16.0, 8.0),
                child: DualListTile(
                  start: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupName
                                  ?.withPersianLetters()
                                  ?.withPersianNumbers() ??
                              '',
                          style: colors.boldStyle(context),
                        ),
                        Space(1),
                        Text(
                          groupDescription
                                  ?.withPersianLetters()
                                  ?.withPersianNumbers() ??
                              '',
                          maxLines: 2,
                          style: colors.bodyStyle(context),
                        ),
                      ],
                    ),
                  ),
                  end: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 24.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () =>
                              _onEdit(groupId, groupName, groupDescription),
                          child: Icon(
                            Icons.edit_outlined,
                            color: colors.ternaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: () => _onDelete(groupId, groupName),
                          child: Icon(
                            Icons.delete_outlined,
                            color: colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: colors.greyColor.shade800,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DualListTile(
                  start: Text(
                    '${contactCount.toString()?.withPersianNumbers() ?? '0'.withPersianNumbers()} نفر',
                    style: colors.boldStyle(context),
                  ),
                  end: FlatButton(
                    padding: EdgeInsetsDirectional.only(
                        start: 16.0, end: 16.0, top: 16.0, bottom: 16.0),
                    onPressed: () => _onGroupItemTap(context, groupId),
                    color: colors.ternaryColor,
                    child: Text(
                      'مدیریت اعضا',
                      style: colors
                          .bodyStyle(context)
                          .copyWith(color: colors.greyColor.shade50),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _onDelete(int id, String name) async {
    final result = await askYesNo(
      title: Text('حذف گروه'),
      content: Text(
        'از حذف گروه $lrm${name} مطمئنید؟'.withPersianNumbers(),
      ),
    );

    if (result != true) {
      return;
    }
    final data =
        await Loading.run(context, nh.wallet.walletGroupRemove(id: id));
    if (!showError(context, data)) {
      return;
    }
    _refreshKey.currentState.show();
  }

  void _onEdit(int id, String name, String description) async {
    WalletGroupInfo groupInfo = WalletGroupInfo(
      groupId: id,
      groupName: name,
      description: description,
    );
    final WalletGroupInfo walletGroupInfo =
        await showCustomBottomSheet<WalletGroupInfo>(
            context: context,
            child: WalletAddGroupDialog(
              walletGroupInfo: groupInfo,
            ));

    if (walletGroupInfo == null) {
      return;
    }

    final response = await Loading.run(
        context,
        nh.wallet.walletGroupUpdate(
          groupName: walletGroupInfo.groupName,
          description: walletGroupInfo.description,
          id: walletGroupInfo.groupId,
        ));

    if (!showConnectionError(context, response)) {
      return;
    }
    _refreshKey.currentState.show();
  }

  void _onGroupItemTap(BuildContext context, int groupId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletUserListPage(
          groupId: groupId,
        ),
      ),
    );
    _refreshKey.currentState.show();
  }

  Widget _buildMessage(String message) => Center(
        child: Text(
          message ?? '',
          textAlign: TextAlign.center,
          style: colors
              .regularStyle(context)
              .copyWith(color: colors.greyColor.shade900),
        ),
      );
}
