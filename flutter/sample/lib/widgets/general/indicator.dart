import 'dart:math';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;

class Indicator extends StatefulWidget {
  Indicator({@required this.steps, this.selected = 0}) : assert(steps > 0);
  final int steps;
  final int selected;

  @override
  State<StatefulWidget> createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  double _positionOfStep(double stepWidth) {
    final step = widget.selected;
    if (step == 0) return 0;
    if (step == widget.steps - 1) return step * stepWidth;

    return (step) * stepWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.biggest.width;
      final maxStepWidth = maxWidth / widget.steps;

      final start = _positionOfStep(maxStepWidth);
      final maxIndicatorWidth = min(16, maxStepWidth);
      final offset = (maxStepWidth - maxIndicatorWidth) / 2.0;

      return SizedBox(
        height: 2,
        child: Stack(
          children: [
            AnimatedPositionedDirectional(
              duration: Duration(milliseconds: 350),
              top: 0,
              start: start + offset,
              child: Container(
                width: min(16, maxStepWidth),
                height: 2,
                color: colors.primaryColor,
                //decoration: BoxDecoration(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
