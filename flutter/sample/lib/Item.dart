import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/widgets/general/general.dart';

class Item extends StatelessWidget {

  Item({
    this.title,
    this.image,
    this.onTap,
    this.badge,
  });

  final Widget title;
  final Widget image;
  final VoidCallback onTap;
  final Widget badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IconTheme(
        data: IconThemeData(
          color: colors.primaryColor,
          size: 36,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: colors.primaryColor.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: image),
                    Space(),
                    Center(
                      child: DefaultTextStyle.merge(
                        child: title,
                        style: TextStyle(
                          color: colors.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: colors.red,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 8.0, 16.0, 8.0),
                        child: badge,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
