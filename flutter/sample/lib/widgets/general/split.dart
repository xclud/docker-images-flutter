import 'package:flutter/material.dart';

class Split extends StatelessWidget {
  Split({
    @required this.child,
    this.header,
    this.footer,
  });

  final Widget header;
  final Widget child;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    if (header != null) {
      children.add(header);
    }

    children.add(child);

    if (footer != null) {
      children.add(footer);
    }

    if (children.length == 1) {
      return children[0];
    }

    return Column(
      children: children,
    );
  }
}
