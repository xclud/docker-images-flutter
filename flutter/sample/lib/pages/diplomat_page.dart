import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:novinpay/dialogs/diplomat_card_information_dialog.dart';
import 'package:novinpay/models/diplomat.dart';
import 'package:novinpay/pay_info.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/campaign/diplomat/diplomat_card.dart';
import 'package:novinpay/widgets/campaign/diplomat/transactions.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';

class DiplomatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DiplomatPageState();
}

class _DiplomatPageState extends State<DiplomatPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<GetDiplomatCardsResponse> _data;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  void _onIndexChanged(int index) {
    final itemCount = _data.content.cards.length;
    bool canAddNewOne = itemCount < 5;
    int itemsToBuild = itemCount;
    if (canAddNewOne) {
      itemsToBuild++;
    }

    if (canAddNewOne && index == itemsToBuild - 1) {
      setState(() {
        _selectedIndex = null;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildCardSwiper() {
    if (_data == null || _data.hasErrors()) {
      return RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: Container(),
        ),
      );
    }

    final itemCount = _data.content.cards.length;
    bool canAddNewOne = itemCount < 5;
    int itemsToBuild = itemCount;
    if (canAddNewOne) {
      itemsToBuild++;
    }

    final add = InkWell(
      onTap: _addCard,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.black26,
        child: Icon(
          Icons.add,
          color: Colors.black45,
          size: 96,
        ),
      ),
    );

    if (itemCount == 0) {
      return RefreshIndicator(
        key: _refreshKey,
        onRefresh: _onRefresh,
        child: AspectRatio(
          aspectRatio: 16.0 / 9.0,
          child: add,
        ),
      );
    }

    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: _onRefresh,
      child: AspectRatio(
        aspectRatio: 16.0 / 9.0,
        child: Swiper(
          pagination: SwiperPagination(),
          loop: false,
          onIndexChanged: _onIndexChanged,
          itemCount: itemsToBuild,
          itemBuilder: (context, index) {
            if (canAddNewOne && index == itemsToBuild - 1) {
              return add;
            }
            final item = _data.content.cards[index];
            return Material(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
                child: DiplomatCard(
                  id: item.id,
                  pan: item.panMasked,
                  index: index,
                  expDate: item.expDate,
                  name: item.cardHolder,
                  score: item.points,
                  onDelete: (value) {
                    _refreshKey.currentState.show();
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChild() {
    Widget child;

    if (_data == null) {
      child = Center(
        child: Text(
          strings.please_wait,
        ),
      );
    } else if (_data.isError) {
      child = Center(
        child: CustomText(
          strings.connectionError,
          textAlign: TextAlign.center,
        ),
      );
    } else if (_data.content.status != true) {
      child = Center(
        child: CustomText(
          _data.content.description ?? strings.connectionError,
          textAlign: TextAlign.center,
        ),
      );
    } else if (_selectedIndex == null ||
        _selectedIndex >= _data.content.cards.length) {
      child = Container();
    } else {
      final item = _data.content.cards[_selectedIndex];
      child = Transactions(item);
    }

    return Split(
      header: _buildCardSwiper(),
      child: Expanded(
        key: ValueKey(_selectedIndex ?? -1),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('باشگاه دیپلمات'),
      body: _buildChild(),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _selectedIndex = null;
    });

    final data = await nh.diplomat.getDiplomatCards();

    final cards = data?.content?.cards;
    if (cards != null && cards.isNotEmpty) {
      setState(() {
        _selectedIndex = 0;
      });
    }

    setState(() {
      _data = data;
    });

    showError(context, data);
  }

  void _addCard() async {
    final PayInfo payInfo = await showCustomBottomSheet<PayInfo>(
      context: context,
      child: DiplomatCardInformation(),
    );

    if (payInfo == null) {
      return;
    }

    final data = await Loading.run(
      context,
      nh.diplomat.addDiplomatCard(cardInfo: payInfo.cardInfo),
    );

    if (!showError(context, data)) {
      return;
    }

    _refreshKey.currentState.show();
  }
}
