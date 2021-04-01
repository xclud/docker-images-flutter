import 'package:flutter/material.dart';
import 'package:novinpay/widgets/general/general.dart';

class RadioButton<T> extends StatelessWidget {
  RadioButton(
      {this.value,
      this.groupValue,
      this.onChanged,
      this.text,
      this.activeColor,
      this.image,
      this.inActiveColor});

  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final Widget text;
  final Widget image;
  final Color activeColor;
  final Color inActiveColor;

  // Color _getInactiveColor(BuildContext context, bool enabled) {
  //   final themeData = Theme.of(context);

  //   return enabled ? themeData.unselectedWidgetColor : themeData.disabledColor;
  // }

  @override
  Widget build(BuildContext context) {
    final activeColor =
        this.activeColor ?? Theme.of(context).toggleableActiveColor;

    //final inactiveColor = _getInactiveColor(context, onChanged != null);

    return GestureDetector(
      child: Container(
          height: 60,
          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 16, 0),
          margin: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 4),
          decoration: BoxDecoration(
            color: value == groupValue ? activeColor : inActiveColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DualListTile(
            start: image ?? Container(),
            end: text ?? Container(),
          )),
      onTap: () {
        if (value != groupValue) {
          onChanged?.call(value);
        }
      },
    );
  }
}
