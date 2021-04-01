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
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/storage_management/add_card_dialog.dart';
import 'package:persian/persian.dart';

class CardToCardManagement extends StatefulWidget {
  @override
  _CardToCardManagementState createState() => _CardToCardManagementState();
}

class _CardToCardManagementState extends State<CardToCardManagement>
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
        return CardManagementListItem(
            item: _data.content.mruList[index],
            onChange: (void change) => _refreshKey.currentState?.show());
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
    if (!_data.content.status) {
      return _buildMessage(_data.content.description);
    }
    return _buildList();
  }

  @override
  Widget build(BuildContext context) {
    if (_index == 0) {
      _sendType = MruType.sourceCard;
    }
    if (_index == 1) {
      _sendType = MruType.destinationCard;
    }
    return HeadedPage(
      title: Text('کارت ها'),
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
                  CustomTabBarItem(title: 'کارت های من'),
                  CustomTabBarItem(title: 'کارت های مقصد'),
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
    final ItemCardToCard value = await showCustomBottomSheet<ItemCardToCard>(
      child: AddCardDialog(
        scrollController: ScrollController(),
        mruType: _sendType,
      ),
      context: context,
    );
    if (value.pan != null) {
      await nh.mru.addMru(
          type: _sendType,
          title: value.title,
          value: value.pan.replaceAll('-', ''),
          expDate: value.ExpDate);
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

class CardManagementListItem extends StatefulWidget {
  CardManagementListItem({@required this.item, this.onChange});

  final MruItem item;
  final ValueChanged onChange;

  @override
  State<StatefulWidget> createState() => _CardManagementListItemState();
}

class _CardManagementListItemState extends State<CardManagementListItem>
    with AskYesNoMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: DualListTile(
              start: (widget.item.title != null && widget.item.title.isNotEmpty)
                  ? Text(
                      widget.item.title?.withPersianLetters(),
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
                protectCardNumber('${widget.item.value}')?.withPersianNumbers(),
                textDirection: TextDirection.ltr,
                style: colors.boldStyle(context),
              ),
              end: (widget.item.expDate != null &&
                      widget.item.expDate.length == 4 &&
                      widget.item.mruType != MruType.destinationCard)
                  ? Text(
                      '${widget.item.expDate?.substring(0, 2) ?? ''}/${widget.item.expDate?.substring(2, 4) ?? ''}'
                          .withPersianNumbers(),
                      style: colors.boldStyle(context),
                    )
                  : Text(
                      '',
                      style: colors.boldStyle(context),
                    ),
            ),
          )
        ],
      ),
    );
  }

  void _onDelete(String value) async {
    final result = await askYesNo(
      title: Text('حذف شماره کارت'),
      content: Text(
        'از حذف شماره کارت $lrm${protectCardNumber(widget.item.value)} مطمئنید؟'
            .withPersianNumbers(),
      ),
    );

    if (result != true) {
      return;
    }
    await Loading.run(context, nh.mru.deleteMru(id: widget.item.id));
    widget.onChange?.call(null);
  }

  void _onEdit() async {
    final send = ItemCardToCard();
    send.pan = widget.item.value;
    send.title = widget.item.title;
    send.ExpDate = widget.item.expDate;
    final ItemCardToCard value = await showCustomBottomSheet<ItemCardToCard>(
      child: AddCardDialog(
        scrollController: ScrollController(),
        value: send,
        mruType: widget.item.mruType,
      ),
      context: context,
    );

    if (value?.ExpDate != null && value?.pan != null) {
      final response = await Loading.run(
          context,
          nh.mru.updateMru(
              id: widget.item.id,
              title: value.title,
              mruValue: value.pan.replaceAll('-', ''),
              expDate: value.ExpDate));
      if (!showError(context, response)) {
        return;
      }
      widget.onChange?.call(null);
    }
  }
}

class ItemCardToCard {
  String _pan;
  String _ExpDate;
  String _title;

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get pan => _pan;

  set pan(String value) {
    _pan = value;
  }

  String get ExpDate => _ExpDate;

  set ExpDate(String value) {
    _ExpDate = value;
  }
}
