import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/sun.dart';

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet({@required this.child, this.title});

  final Widget child;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: colors.greyColor.shade50,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                ),
              ),
            ],
          ),
          Divider(
            height: 0,
            color: colors.greyColor.shade50,
          ),
          if (title != null)
            DefaultTextStyle.merge(
              style: TextStyle(color: colors.accentColor),
              child: Container(
                padding: EdgeInsetsDirectional.fromSTEB(24, 0, 0, 0),
                color: colors.greyColor.shade50,
                child: title,
              ),
            ),
          Divider(
            height: 0,
            color: colors.greyColor.shade50,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              color: colors.greyColor.shade50,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomSheetHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;
    path.moveTo(0, 0);
    path.lineTo(0, 10 * sh / 12);
    path.lineTo(50, 10 * sh / 12);
    path.cubicTo(80, 10 * sh / 12, 80, 0, 110, 0);
    path.lineTo(sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
