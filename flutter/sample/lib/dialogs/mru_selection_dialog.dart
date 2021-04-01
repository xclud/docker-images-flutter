import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:persian/persian.dart';

class MruSelectionDialog extends StatefulWidget {
  MruSelectionDialog({@required this.mru, this.scrollController});

  final ScrollController scrollController;
  final MruType mru;

  @override
  _MruSelectionDialogState createState() => _MruSelectionDialogState();
}

class _MruSelectionDialogState extends State<MruSelectionDialog>
    with AskYesNoMixin {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final List<MruItem> _items = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState?.show();
    });
  }

  Future<void> _refresh() async {
    final data = await nh.mru.mruList(mruType: widget.mru);

    if (data.hasErrors()) {
      return;
    }

    final items = data.content.mruList;

    _items.clear();
    _items.addAll(items);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _refresh,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final title = item.title?.withPersianLetters()?.withPersianNumbers();
          var value = item.value?.withPersianLetters()?.withPersianNumbers();

          Widget leading;

          if (widget.mru == MruType.sourceCard ||
              widget.mru == MruType.destinationCard) {
            final bankName = Utils.getBankName(item.value);
            final bankLogo = Utils.getBankLogo(item.value);

            leading = Tooltip(
              message: bankName,
              child: SizedBox(child: Image.asset(bankLogo), width: 32),
            );

            value = protectCardNumber(value);
            value = '$lrm$value'.withPersianNumbers();
          }

          if (item.title == null || item.title.isEmpty) {
            return Container(
              margin: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: colors.greyColor),
              child: ListTile(
                contentPadding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 4),
                title: Text(value),
                leading: leading,
                onTap: () {
                  Navigator.of(context).pop(item);
                },
              ),
            );
          }

          return Container(
            margin: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: colors.greyColor),
            child: ListTile(
              contentPadding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 4),
              title: Container(
                padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [Text(title ?? ''), Text(value ?? '')],
                ),
              ),
              leading: leading,
              onTap: () {
                Navigator.of(context).pop(item);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _refresh,
      child: Center(
        child: Text(
          'هنوز موردی در لیست اضافه نشده است',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
