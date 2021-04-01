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
import 'package:novinpay/widgets/storage_management/add_loan_dialog.dart';
import 'package:novinpay/widgets/storage_management/card_management.dart';
import 'package:persian/persian.dart';

class LoanManagement extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoanManagementState();
}

class _LoanManagementState extends State<LoanManagement> {
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
    final data = await nh.mru.mruList(mruType: MruType.loan);

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

    Widget _buildNoLoan(String error) => Center(
          child: Text(
            error,
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
            return LoanManagementListItem(
                item: item,
                onChange: (void item) {
                  _refreshKey.currentState.show();
                });
          },
        );

    Widget _buildChild() {
      if (_data == null) {
        return _buildWelcomeMessage();
      }

      if (_data.isError) {
        return _buildNoLoan('خطایی در دریافت اطلاعات رخ داده است');
      }

      if (_data.content.status != true) {
        return _buildNoLoan(_data.content.description);
      }

      if (_data.content.mruList == null || _data.content.mruList.isEmpty) {
        return _buildNoLoan(_data.content.description);
      }

      return _buildBillList();
    }

    final footer = ConfirmButton(
        onPressed: _onAddPressed,
        child: CustomText(
          'افزودن',
          textAlign: TextAlign.center,
        ));

    return HeadedPage(
      title: Text('تسهیلات'),
      body: Container(
        margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
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
          footer: footer,
        ),
      ),
    );
  }

  void _onAddPressed() async {
    final result = await showCustomBottomSheet<ItemCardToCard>(
        context: context,
        child: AddLoanDialog(
          scrollController: ScrollController(),
        ));
    if (result != null) {
      Loading.run(
          context,
          nh.mru.addMru(
              type: MruType.loan, title: result.title, value: result.pan));
      _refreshKey.currentState.show();
    }
  }
}

class LoanManagementListItem extends StatefulWidget {
  LoanManagementListItem({@required this.item, this.onChange});

  final MruItem item;
  final ValueChanged onChange;

  @override
  State<StatefulWidget> createState() => _LoanManagementListItemState();
}

class _LoanManagementListItemState extends State<LoanManagementListItem>
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
      title: Text('حذف شماره تسهیلات'),
      content: Text(
        'از حذف شماره تسهیلات $lrm$value مطمئنید؟'.withPersianNumbers(),
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
      child: AddLoanDialog(
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
