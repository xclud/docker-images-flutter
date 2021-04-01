import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;

class ConfirmButton extends StatelessWidget {
  ConfirmButton({
    @required this.onPressed,
    @required this.child,
    this.color,
    this.focusNode,
  });

  final Widget child;
  final GestureTapCallback onPressed;
  final Color color;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: DefaultTextStyle(
        style:
            colors.tabStyle(context).copyWith(color: colors.greyColor.shade50),
        child: RaisedButton(
          focusNode: focusNode,
          color: color ?? colors.accentColor,
          colorBrightness: Brightness.dark,
          child: child,
          onPressed: onPressed,
          elevation: 0,
        ),
      ),
    );
  }
}

class FutureConfirmButton extends StatefulWidget {
  FutureConfirmButton({
    @required this.onPressed,
    @required this.child,
    this.color,
    this.focusNode,
  });

  final Widget child;
  final RefreshCallback onPressed;
  final Color color;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => _FutureConfirmButtonState();
}

class _FutureConfirmButtonState extends State<FutureConfirmButton> {
  bool _working = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: RaisedButton.icon(
        focusNode: widget.focusNode,
        color: widget.color ?? colors.accentColor,
        colorBrightness: Brightness.dark,
        label: widget.child,
        icon: _buildIcon(),
        onPressed: _buildOnPressed(),
        elevation: 0,
      ),
    );
  }

  Widget _buildIcon() {
    if (_working) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor:
              AlwaysStoppedAnimation(widget.color ?? colors.accentColor),
        ),
      );
    } else {
      return Container();
    }
  }

  VoidCallback _buildOnPressed() {
    if (widget.onPressed == null) {
      return null;
    }

    if (_working) {
      return null;
    }

    return _onPressed;
  }

  void _onPressed() async {
    setState(() {
      _working = true;
    });
    try {
      await widget.onPressed.call();
    } catch (exp) {
      //
    }

    _working = false;
    if (mounted) {
      setState(() {});
    }
  }
}

class FutureOutlineButton extends StatefulWidget {
  FutureOutlineButton({
    @required this.onPressed,
    @required this.child,
    this.color,
    this.focusNode,
  });

  final Widget child;
  final RefreshCallback onPressed;
  final Color color;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => _FutureOutlineButtonState();
}

class _FutureOutlineButtonState extends State<FutureOutlineButton> {
  bool _working = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlineButton.icon(
        focusNode: widget.focusNode,
        color: widget.color ?? colors.accentColor,
        borderSide: BorderSide(
          color: widget.color ?? colors.accentColor,
          width: 2,
        ),
        textColor: widget.color ?? colors.accentColor,
        label: widget.child,
        icon: _buildIcon(),
        onPressed: _buildOnPressed(),
      ),
    );
  }

  Widget _buildIcon() {
    if (_working) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor:
              AlwaysStoppedAnimation(widget.color ?? colors.accentColor),
        ),
      );
    } else {
      return Container();
    }
  }

  VoidCallback _buildOnPressed() {
    if (widget.onPressed == null) {
      return null;
    }

    if (_working) {
      return null;
    }

    return _onPressed;
  }

  void _onPressed() async {
    setState(() {
      _working = true;
    });
    try {
      await widget.onPressed.call();
    } catch (exp) {
      //
    }

    _working = false;
    if (mounted) {
      setState(() {});
    }
  }
}
