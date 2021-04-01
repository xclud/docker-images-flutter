import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;

//import 'package:novinpay/colors.dart' as colors;
const Color _ternaryColor = Color(0xFF2FBC9E); //Move this to colors.dart

class DismissibleRoundButton extends StatelessWidget {
  DismissibleRoundButton({
    this.onDismiss,
    this.text,
    this.buttonText,
    this.onPressed,
    this.color = _ternaryColor,
  });

  final VoidCallback onDismiss;
  final VoidCallback onPressed;
  final String text;
  final String buttonText;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: onDismiss != null
            ? IconButton(
                color: Colors.white,
                icon: Icon(Icons.close),
                onPressed: onDismiss,
              )
            : null,
        title: Text(
          text ?? '',
          style: colors.boldStyle(context).copyWith(color: Colors.white),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: onPressed,
        trailing: TextButton(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              TextStyle(color: Colors.white),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.white),
          ),
          child: Text(
            buttonText ?? '',
            style:
                colors.boldStyle(context).copyWith(color: colors.primaryColor),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
