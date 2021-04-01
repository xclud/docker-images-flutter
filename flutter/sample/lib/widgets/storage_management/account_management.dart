import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/analytics_mixin.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/storage_management/add_account_dialog.dart';
import 'package:novinpay/widgets/storage_management/card_management.dart';
import 'package:persian/persian.dart';

class AccountManagement extends StatefulWidget {
  @override
  _AccountManagementState createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement>
    with AnalyticsMixin {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<MruListResponse> _data;
  MruType _sendType;
  int _index = 0;

  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        style: colors
            .regularStyle(context)
            .copyWith(color: colors.greyColor.shade900),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  Widget _buildList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _data.content.mruList.length,
      itemBuilder: (context, index) {
        return AccountManagementListItem(
          item: _data.content.mruList[index],
          onChange: (void item) => _refreshKey.currentState?.show(),
        );
      },
    );
  }

  Widget _buildChild() {
    if (_data == null) {
      return _buildMessage(strings.please_wait);
    }
    if (_data.isError) {
      return _buildMessage('خطایی در دریافت اطلاعات رخ داده است');
    }
    if (_data.content.status != true) {
      return _buildMessage(_data.content.description);
    }
    return _buildList();
  }

  @override
  Widget build(BuildContext context) {
    if (_index == 0) {
      _sendType = MruType.sourceAccount;
    }
    if (_index == 1) {
      _sendType = MruType.destinationAccount;
    }
    return HeadedPage(
      title: Text('حساب ها'),
      body: RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: Container(
          margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
          child: Split(
            header: CustomTabBar(
                onChange: (int index) {
                  setState(() {
                    _index = index;
                    _refreshKey.currentState?.show();
                    sendCurrentTabToAnalytics();
                  });
                },
                items: [
                  CustomTabBarItem(title: 'حساب های من'),
                  CustomTabBarItem(title: 'حساب های مقصد'),
                ]),
            child: Expanded(
                child: Container(
                    margin: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 24),
                    child: _buildChild())),
            footer: ConfirmButton(
                child: CustomText(
                  'افزودن',
                  textAlign: TextAlign.center,
                ),
                onPressed: _onAddPressed),
          ),
        ),
      ),
    );
  }

  void _onAddPressed() async {
    final value = await showCustomBottomSheet<ItemCardToCard>(
      child: AddAccountDialog(
        scrollController: ScrollController(),
      ),
      context: context,
    );
    if (value != null) {
      await nh.mru
          .addMru(type: _sendType, title: value.title, value: value.pan);
      _refreshKey.currentState?.show();
    }
  }

  Future<void> _onRefresh() async {
    final data = await nh.mru.mruList(mruType: _sendType);
    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  @override
  String getCurrentRoute() {
    return routes.storage_management;
  }

  @override
  int getCurrentTab() {
    return _index;
  }
}

class AccountManagementListItem extends StatefulWidget {
  AccountManagementListItem({@required this.item, this.onChange});

  final MruItem item;
  final ValueChanged onChange;

  @override
  State<StatefulWidget> createState() => _AccountManagementListItemState();
}

class _AccountManagementListItemState extends State<AccountManagementListItem>
    with AskYesNoMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.greyColor.shade600,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: DualListTile(
                start:
                    (widget.item.title != null && widget.item.title.isNotEmpty)
                        ? Text(
                            widget.item.title?.withPersianNumbers(),
                            style: colors.boldStyle(context),
                          )
                        : Text(
                            'بدون عنوان',
                            style: colors.boldStyle(context),
                          ),
                end: Row(
                  children: [
                    InkWell(
                      onTap: _onEdit,
                      child:
                          Icon(Icons.edit_outlined, color: colors.ternaryColor),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    InkWell(
                      onTap: () => _onDelete(widget.item.value),
                      child: Icon(
                        Icons.delete_outline,
                        color: colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: DualListTile(
                  start: Text(
                    '${widget.item.value}'?.withPersianNumbers(),
                    textDirection: TextDirection.ltr,
                    style: colors.boldStyle(context),
                  ),
                  end: Container()),
            )
          ],
        ),
      ),
    );
  }

  void _onDelete(String value) async {
    final result = await askYesNo(
      title: Text('حذف شماره حساب'),
      content: Text(
        'از حذف شماره حساب $lrm$value مطمئنید؟'.withPersianNumbers(),
      ),
    );

    if (result != true) {
      return;
    }
    await Loading.run(context, nh.mru.deleteMru(id: widget.item.id));
    widget.onChange?.call(null);
  }

  void _onEdit() async {
    final value = await showCustomBottomSheet<ItemCardToCard>(
      child: AddAccountDialog(
        scrollController: ScrollController(),
        item: widget.item,
      ),
      context: context,
    );
    if (value != null) {
      await Loading.run(
          context,
          nh.mru.updateMru(
              id: widget.item.id, title: value.title, mruValue: value.pan));
      widget.onChange?.call(null);
    }
  }
}