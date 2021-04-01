import 'package:flutter/material.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/models/diplomat.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class Transactions extends StatefulWidget {
  Transactions(this.card);

  final DiplomatCardInfo card;

  @override
  State<StatefulWidget> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<DiplomatCardTransactionsResponse> _data;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      child: _buildChild(),
    );
  }

  Future<void> _onRefresh() async {
    final card = widget.card;

    final cardInfo = CardInfo(sourceCardId: card.id);
    final data = await nh.diplomat.getDiplomatTransactions(cardInfo: cardInfo);

    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  Widget _buildChild() {
    if (_data == null) {
      return Center(
        child: Text(strings.please_wait),
      );
    }

    if (_data.isError) {
      return Center(
        child: Text(strings.connectionError),
      );
    }

    if (_data.content.status != true) {
      return Center(
        child: Text(_data.content.description ?? strings.connectionError),
      );
    }

    final transactions = _data.content.transactions;

    return ListView(
      children: transactions
          .map((e) => _buildItem(
              date: e.transactionShamsiDateTime,
              storeName: e.storeName,
              amount: e.amount))
          .toList(),
    );
  }

  Widget _buildItem({
    @required String date,
    @required String storeName,
    @required int amount,
  }) {
    return CustomCard(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        DualListTile(
          start: Text(
            'نام فروشگاه' ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          end: Text(
            storeName?.withPersianLetters() ?? '',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Space(2),
        DualListTile(
          start: Text(toRials(amount)),
          end: Text('$lrm$date'.withPersianNumbers()),
        ),
      ],
    ));
  }
}
