import 'package:flutter/material.dart';

class GradientDivider extends StatelessWidget {
  GradientDivider({
    this.height = 2,
    this.margin = const EdgeInsetsDirectional.only(start: 8, end: 8),
    this.color = const Color.fromARGB(255, 60, 57, 81),
  });

  final double height;
  final Color color;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0, 1],
          colors: [
            color.withAlpha(0),
            color,
          ],
        ),
      ),
    );
  }
}
