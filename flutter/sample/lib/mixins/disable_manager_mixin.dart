import 'package:flutter/material.dart';

mixin DisableManagerMixin<T extends StatefulWidget> on State<T> {
  bool _disable = false;
  bool get enabled => _disable != true;

  void disable() {
    _disable = true;
    if (mounted) {
      setState(() {});
    }
  }

  void enable() {
    _disable = false;
    if (mounted) {
      setState(() {});
    }
  }
}
