import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({@required this.child, this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(padding: EdgeInsets.all(8), child: child),
    );
  }
}
