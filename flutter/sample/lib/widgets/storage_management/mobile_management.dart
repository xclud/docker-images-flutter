import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/storage_management/action_type.dart';
import 'package:novinpay/widgets/storage_management/add_mobile_dialog.dart';
import 'package:persian/persian.dart';

class MobileManagement extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MobileManagementState();
}

class _MobileManagementState extends State<MobileManagement> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<MruListResponse> _data;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  Future<void> _refresh() async {
    final data = await nh.mru.mruList(mruType: MruType.mobile);

    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildWelcomeMessage() => Center(
          child: Text(
            strings.please_wait,
            textAlign: TextAlign.center,
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
          ),
        );

    Widget _buildNoMobile(String error) => Center(
          child: Text(
            error ?? '',
            textAlign: TextAlign.center,
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
          ),
        );

    Widget _buildBillList() => ListView.builder(
          shrinkWrap: true,
          itemCount: _data.content.mruList.length,
          itemBuilder: (context, index) {
            final item = _data.content.mruList[index];
            return MobileCard(
                item: item,
                onPageRefresh: () {
                  _refreshKey.currentState.show();
                });
          },
        );

    Widget _buildChild() {
      if (_data == null) {
        return _buildWelcomeMessage();
      }

      if (_data.isError) {
        return _buildNoMobile('خطایی در دریافت اطلاعات رخ داده است');
      }

      if (_data.content.status != true) {
        return _buildNoMobile(_data.content.description);
      }

      if (_data.content.mruList == null || _data.content.mruList.isEmpty) {
        return _buildNoMobile(_data.content.description);
      }

      return _buildBillList();
    }

    final _footer = ConfirmButton(
        onPressed: _showAddMobileDialog,
        child: CustomText(
          'افزودن',
          textAlign: TextAlign.center,
        ));

    return HeadedPage(
      title: Text('موبایل ها'),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
        child: Split(
          child: Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: _refresh,
              child: Container(
                  margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                  child: _buildChild()),
            ),
          ),
          footer: _footer,
        ),
      ),
    );
  }

  void _showAddMobileDialog() async {
    final result = await showCustomBottomSheet<bool>(
      context: context,
      child: AddMobileDialog(
        type: ActionType.Add,
      ),
    );
    if (result != true) {
      return;
    }
    _refreshKey.currentState.show();
  }
}

class MobileCard extends StatefulWidget {
  MobileCard({@required this.item, @required this.onPageRefresh});

  final MruItem item;
  final VoidCallback onPageRefresh;

  @override
  State<StatefulWidget> createState() => _MobileCardState();
}

class _MobileCardState extends State<MobileCard> with AskYesNoMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Space(),
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
            child: DualListTile(
              start: (widget.item.title != null && widget.item.title.isNotEmpty)
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
                    onTap: _showEditMobileDialog,
                    child:
                        Icon(Icons.edit_outlined, color: colors.ternaryColor),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  InkWell(
                    onTap: () => _showRemoveMobileDialog(widget.item.value),
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
    );
  }

  void _showRemoveMobileDialog(String value) async {
    final result = await askYesNo(
      title: Text('حذف شماره موبایل'),
      content: Text(
        'از حذف شماره موبایل $lrm$value مطمئنید؟'.withPersianNumbers(),
      ),
    );

    if (result != true) {
      return;
    }
    final data =
        await Loading.run(context, nh.mru.deleteMru(id: widget.item.id));

    if (!showError(context, data)) {
      return;
    }
    widget.onPageRefresh();
  }

  void _showEditMobileDialog() async {
    final result = await showCustomBottomSheet<bool>(
      context: context,
      child: AddMobileDialog(
        type: ActionType.Update,
        mruItem: widget.item,
      ),
    );
    if (result != true) {
      return;
    }
    widget.onPageRefresh();
  }
}
