import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/widgets/general/general.dart';

mixin AskYesNoMixin<T extends StatefulWidget> on State<T> {
  Future<bool> askYesNo({
    @required Widget title,
    Widget content,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 16, 12),
        title: title,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            content ?? Container(),
            Space(2),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    elevation: 0.0,
                    color: colors.accentColor,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'بله',
                        style: colors
                            .regularStyle(context)
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: colors.ternaryColor, width: 2)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'خیر',
                        style: colors
                            .regularStyle(context)
                            .copyWith(color: colors.ternaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
