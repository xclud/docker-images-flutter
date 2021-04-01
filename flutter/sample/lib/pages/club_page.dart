import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:novinpay/config.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/general/general.dart';

class ClubPage extends StatefulWidget {
  @override
  _ClubPageState createState() => _ClubPageState();
}

class _ClubPageState extends State<ClubPage> {
  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('باشگاه مشتریان'),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(routes.omidclub);
                },
                child: CachedNetworkImage(
                  imageUrl: '$end_point/assets/images/club/omid.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Space(2),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(routes.diplomat);
                },
                child: CachedNetworkImage(
                  imageUrl: '$end_point/assets/images/club/diplomat.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
