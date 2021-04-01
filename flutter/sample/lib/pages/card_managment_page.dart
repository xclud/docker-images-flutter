import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/novin_icons.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/custom_tab_bar.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class CardManagementPage extends StatefulWidget {
  @override
  _CardManagementPageState createState() => _CardManagementPageState();
}

class _CardManagementPageState extends State<CardManagementPage>
    with AskYesNoMixin {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('مدیریت کارت ها'),
      body: Column(
        children: [
          CustomTabBar(
            onChange: (int index) {
              setState(() {
                _index = index;
              });
            },
            items: [
              CustomTabBarItem(title: 'کارت های من'),
              CustomTabBarItem(title: 'کارت های مقصد')
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _index,
              children: [
                _CardManagementList(
                  mru: MruType.sourceCard,
                  showLoading: true,
                ),
                _CardManagementList(
                  mru: MruType.destinationCard,
                  showLoading: false,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardManagementList extends StatefulWidget {
  _CardManagementList({@required this.mru, this.showLoading = false});

  final MruType mru;
  final bool showLoading;

  @override
  _CardManagementListState createState() => _CardManagementListState();
}

class _CardManagementListState extends State<_CardManagementList>
    with AskYesNoMixin {
  final _completer = Completer<Response<MruListResponse>>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getCards(widget.mru);
    });
    super.initState();
  }

  void _getCards(MruType mru) async {
    Response<MruListResponse> data;
    if (widget.showLoading == true) {
      data = await Loading.run(context, nh.mru.mruList(mruType: widget.mru));
    } else {
      data = await nh.mru.mruList(mruType: widget.mru);
    }

    if (data.isError) {
      _completer.completeError(data);
      return;
    }

    if (data.content.status != true) {
      _completer.completeError(data);

      return;
    }
    _completer.complete(data);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<MruListResponse>>(
      future: _completer.future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildEmpty();
        }

        if (snapshot.hasData) {
          final resp = snapshot.data;
          final cardList = resp.content.mruList;

          if (cardList.isEmpty) {
            return _buildEmpty();
          }

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: cardList.length,
            itemBuilder: (context, index) {
              final item = cardList[index];

              void _delete() async {
                final result = await askYesNo(
                    title: Text('حذف کارت'),
                    content: Text('از حذف کارت خود مطمئنید؟'));

                if (result != true) {
                  return;
                }
                final data =
                    //   await nh.novinPay.application.removeCard(cardId: item.id);
                    await nh.mru.deleteMru(id: item.id);

                if (!showError(context, data)) {
                  return;
                }

                cardList.removeAt(index);
                setState(() {});
              }

              final name =
                  item.title?.withPersianLetters()?.withPersianNumbers() ?? '';
              final pan = item.value?.withPersianNumbers() ?? '';
              final bankName = item.title;
              final bankIcon = Utils.getBankLogo(item.value);

              final listTile = ListTile(
                leading: bankIcon != null
                    ? Tooltip(
                        message: bankName ?? '',
                        child: Image.asset(bankIcon),
                      )
                    : null,
                title: Text(name),
                subtitle: Text('$lrm${protectCardNumber(pan)}'),
                trailing: IconButton(
                  icon: Icon(NovinIcons.trash),
                  onPressed: _delete,
                ),
              );

              return listTile;
            },
          );
        }

        return _buildEmpty();
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        'کارتی جهت نمایش یافت نشد.',
        textAlign: TextAlign.center,
      ),
    );
  }
}
