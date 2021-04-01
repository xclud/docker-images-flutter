import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;

class NovinBorder extends StatelessWidget {
  NovinBorder({this.child, this.size});

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          minWidth: (size == null) ? 60 : size,
          minHeight: (size == null) ? 60 : size),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular((size == null) ? 16 : 8)),
          border: Border.all(color: colors.primaryColor, width: 0.8)),
      child: child,
    );
  }
}
