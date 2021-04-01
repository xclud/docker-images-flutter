import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/wallet_add_user_dialog.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/wallet.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class WalletUserListPage extends StatefulWidget {
  WalletUserListPage({@required this.groupId});

  final int groupId;

  @override
  State<StatefulWidget> createState() => _WalletUserListPageState();
}

class _WalletUserListPageState extends State<WalletUserListPage>
    with AskYesNoMixin {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Response<WalletGroupUserListResponse> _data;

  Future<void> _refresh() async {
    final data = await nh.wallet.eWalletGroupUserList(groupId: widget.groupId);

    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  Widget _buildMessage(String message) => Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 24.0, end: 24.0),
          child: Text(
            message ?? '',
            textAlign: TextAlign.center,
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
          ),
        ),
      );

  Widget _buildWelcomeMessage() => _buildMessage(strings.please_wait);

  @override
  Widget build(BuildContext context) {
    Widget buildUserList() => ListView.builder(
          shrinkWrap: true,
          itemCount: _data.content.walletGroupUserList.length,
          itemBuilder: (context, index) {
            final item = _data.content.walletGroupUserList[index];
            return UserItem(
              user: item,
              index: index,
              onItemRemoved: () => _removeUser(item),
              onItemEdited: () => _editUser(item),
            );
          },
        );

    Widget buildChild() {
      if (_data == null) {
        return _buildWelcomeMessage();
      }

      if (_data.isError) {
        return _buildMessage(strings.connectionError);
      }

      if (_data.content.status != true) {
        return _buildMessage(_data.content.description);
      }

      if (_data.content.walletGroupUserList == null ||
          _data.content.walletGroupUserList.isEmpty) {
        return _buildMessage(strings.noItemsFound);
      }

      return buildUserList();
    }

    final footer = Padding(
      padding: EdgeInsets.only(right: 24, left: 24, bottom: 24.0),
      child: ConfirmButton(
        child: CustomText(
          'افزودن مخاطب',
          style: colors
              .tabStyle(context)
              .copyWith(color: colors.greyColor.shade50),
          textAlign: TextAlign.center,
        ),
        onPressed: _addUser,
      ),
    );

    return HeadedPage(
      title: Text('لیست مخاطبین'),
      body: Split(
        child: Expanded(
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _refresh,
            child: buildChild(),
          ),
        ),
        footer: footer,
      ),
    );
  }

  void _addUser() async {
    final WalletGroupUserListData user =
        await showCustomBottomSheet<WalletGroupUserListData>(
      context: context,
      child: WalletAddUserDialog(
        isEdit: false,
      ),
    );
    if (user == null) {
      return;
    }
    final data = await Loading.run(
        context,
        nh.wallet.walletGroupUserAddNew(
            name: user.name,
            family: user.family,
            customerId: user.customerId,
            groupId: widget.groupId));
    if (!showError(context, data)) {
      return;
    }
    _refreshKey.currentState.show();
  }

  void _removeUser(WalletGroupUserListData user) async {
    final result = await askYesNo(
      title: Text('حذف مخاطب'),
      content: Text(
        'از حذف ${user.name} ${user.family} مطمئن هستید؟'.withPersianNumbers(),
      ),
    );

    if (result != true) {
      return;
    }

    final data = await Loading.run(
        context,
        nh.wallet.eWalletGroupUserRemove(
            groupId: widget.groupId, customerId: user.customerId));

    if (!showError(context, data)) {
      return;
    }

    _refreshKey.currentState?.show();
  }

  void _editUser(WalletGroupUserListData walletGroupUserListData) async {
    final user = await showCustomBottomSheet<WalletGroupUserListData>(
      context: context,
      child: WalletAddUserDialog(
        user: walletGroupUserListData,
        isEdit: true,
      ),
    );
    if (user == null) {
      return;
    }
    final data = await Loading.run(
        context,
        nh.wallet.walletGroupUserUpdate(
            name: user.name,
            family: user.family,
            customerId: user.customerId,
            groupId: widget.groupId));
    if (!showError(context, data)) {
      return;
    }
    _refreshKey.currentState.show();
  }
}

class UserItem extends StatelessWidget {
  UserItem(
      {@required this.user,
      @required this.index,
      @required this.onItemRemoved,
      @required this.onItemEdited});

  final WalletGroupUserListData user;
  final int index;
  final VoidCallback onItemRemoved;
  final VoidCallback onItemEdited;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(end: 24.0, start: 24.0, top: 8.0),
      child: Container(
          decoration: BoxDecoration(
              color: colors.greyColor,
              borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DualListTile(
                  start: Expanded(
                    child: Text(
                      ('${user?.name ?? ''} ${user?.family ?? ''}')
                          .withPersianNumbers(),
                      style: colors.boldStyle(context),
                    ),
                  ),
                  end: Row(
                    children: [
                      InkWell(
                        onTap: () => onItemEdited(),
                        child: Icon(
                          Icons.edit_outlined,
                          color: colors.ternaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () => onItemRemoved(),
                        child: Icon(
                          Icons.delete_outlined,
                          color: colors.red,
                        ),
                      )
                    ],
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
                    (user?.customerId ?? '').withPersianNumbers(),
                    style: colors.boldStyle(context),
                  ),
                  end: Container(),
                ),
              ),
            ],
          )),
    );
  }
}
