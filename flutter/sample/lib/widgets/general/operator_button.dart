import 'package:flutter/material.dart';

class OperatorButton<T> extends StatelessWidget {
  OperatorButton({
    this.value,
    this.groupValue,
    this.onChanged,
    this.child,
    this.activeColor,
  });

  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Widget child;
  final Color activeColor;

  // Color _getInactiveColor(BuildContext context, bool enabled) {
  //   final themeData = Theme.of(context);

  //   return enabled ? themeData.unselectedWidgetColor : themeData.disabledColor;
  // }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        this.activeColor ?? Theme.of(context).toggleableActiveColor;

    //final inactiveColor = _getInactiveColor(context, onChanged != null);

    return FlatButton(
      color: value == groupValue ? activeColor : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
      onPressed: () {
        if (value != groupValue) {
          onChanged?.call(value);
        }
      },
    );
  }
}
