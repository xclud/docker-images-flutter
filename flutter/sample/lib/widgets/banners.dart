import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/config.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/utils.dart';

String _getBannerUri(int i) {
  return '$end_point/assets/images/home/banner-$i.jpg';
}

class Banners extends StatefulWidget {
  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        BannerItem(
          imageUrl: _getBannerUri(0),
          linkUrl: routes.club,
        ),
        NovinMallBannerItem(),
        BannerItem(
          imageUrl: _getBannerUri(2),
          linkUrl: routes.credit_card,
        ),
        // BannerItem(
        //   imageUrl: _getBannerUri(3),
        //   linkUrl: routes.opening_deposit,
        //   arguments: {'selectedPage': 2},
        // ),
        BannerItem(
          imageUrl: _getBannerUri(4),
          linkUrl: routes.card_to_card,
        ),
        BannerItem(
          imageUrl: _getBannerUri(5),
          linkUrl: routes.charge,
        ),
      ],
    );
  }
}

class BannerItem extends StatelessWidget {
  BannerItem({@required this.imageUrl, @required this.linkUrl, this.arguments});

  final String imageUrl;
  final String linkUrl;
  final Object arguments;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (linkUrl.startsWith('http://') ||
            linkUrl.startsWith('https://') ||
            linkUrl.startsWith('HTTP://') ||
            linkUrl.startsWith('HTTPS://')) {
          Utils.customLaunch(context, linkUrl);
        } else {
          Navigator.of(context).pushNamed(linkUrl, arguments: arguments);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          child: CachedNetworkImage(imageUrl: imageUrl),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class NovinMallBannerItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NovinMallBannerItemState();
}

class _NovinMallBannerItemState extends State<NovinMallBannerItem> {
  @override
  Widget build(BuildContext context) {
    Widget child = InkWell(
      onTap: () {
        if (appState.novinMallLink == null || appState.novinMallLink.isEmpty) {
          return;
        } else {
          Utils.customLaunch(context, appState.novinMallLink,
              title: 'نوین مال');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          child: CachedNetworkImage(imageUrl: _getBannerUri(1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    return child;
  }
}
