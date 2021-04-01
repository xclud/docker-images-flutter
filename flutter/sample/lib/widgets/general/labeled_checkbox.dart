import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;

class LabeledCheckbox extends StatelessWidget {
  LabeledCheckbox({
    @required this.label,
    @required this.value,
    @required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: ThemeData(
            primarySwatch: Colors.yellow,
            unselectedWidgetColor: Colors.yellow.shade800,
          ),
          child: Checkbox(
            value: value,
            onChanged: (v) {
              onChanged?.call(v);
            },
          ),
        ),
        Text(
          label,
          style: TextStyle(color: colors.ternaryColor),
        ),
      ],
    );
  }
}
