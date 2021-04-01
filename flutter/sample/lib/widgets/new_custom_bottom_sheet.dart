import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/sun.dart';

class NewCustomBottomSheet extends StatelessWidget {
  NewCustomBottomSheet({
    @required this.child,
    this.title,
    this.childMinHeight,
    this.childMaxHeight,
  });

  final Widget child;
  final Widget title;
  final double childMinHeight;
  final double childMaxHeight;

  @override
  Widget build(BuildContext context) {
    if (childMaxHeight != null) {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        width: 64,
                        margin: EdgeInsets.only(top: 16),
                        child: Icon(
                          SunIcons.down_shit,
                          size: 46,
                          color: colors.primaryColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                decoration: BoxDecoration(
                  color: colors.greyColor.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: colors.greyColor.shade50,
              ),
              Container(
                child: ConstrainedBox(
                  child: child,
                  constraints: BoxConstraints(
                    maxHeight: childMaxHeight,
                  ),
                ),
                color: colors.greyColor.shade50,
              ),
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
      );
    } else {
      return Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Row(
                  children: [
                    InkWell(
                      child: Container(
                        width: 64,
                        margin: EdgeInsets.only(top: 16),
                        child: Icon(
                          SunIcons.down_shit,
                          size: 46,
                          color: colors.primaryColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                decoration: BoxDecoration(
                  color: colors.greyColor.shade50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
              Divider(
                height: 0,
                color: colors.greyColor.shade50,
              ),
              title ?? Container(),
              if (title != null)
                Divider(
                  height: 0,
                  color: colors.greyColor.shade50,
                ),
              Container(
                child: child,
                color: colors.greyColor.shade50,
              ),
            ],
          ),
        ),
        width: MediaQuery.of(context).size.width,
      );
    }
  }
}
