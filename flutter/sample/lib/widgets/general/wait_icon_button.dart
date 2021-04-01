import 'package:flutter/material.dart';

typedef FutureCallback = Future<void> Function();

class WaitIconButton extends StatefulWidget {
  WaitIconButton({@required this.onPressed, @required this.icon, this.tooltip});

  final FutureCallback onPressed;
  final Widget icon;
  final String tooltip;

  @override
  State<StatefulWidget> createState() {
    return WaitIconButtonState();
  }
}

class WaitIconButtonState extends State<WaitIconButton> {
  bool _working = false;

  @override
  Widget build(BuildContext context) {
    if (_working) {
      return IconButton(
        icon: SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 2,
          ),
        ),
        tooltip: 'صبر کنید...',
        onPressed: () {},
      );
    } else {
      return IconButton(
        icon: widget.icon,
        tooltip: widget.tooltip,
        onPressed: () async {
          setState(() {
            _working = true;
          });

          try {
            await widget.onPressed?.call();
          } catch (exp) {
            rethrow;
          }

          setState(() {
            _working = false;
          });
        },
      );
    }
  }
}
