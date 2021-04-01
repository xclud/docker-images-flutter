import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DualListTile extends StatelessWidget {
  DualListTile({
    @required this.start,
    @required this.end,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
  });

  final Widget start;
  final Widget end;
  final EdgeInsets padding;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [start, end],
    );

    if (onTap != null) {
      child = InkWell(
        child: child,
        onTap: onTap,
      );
    }

    if (padding != null) {
      child = Padding(
        padding: padding,
        child: child,
      );
    }

    return child;
  }
}
