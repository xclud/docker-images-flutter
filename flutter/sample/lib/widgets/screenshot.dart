import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:novinpay/services/platform_helper.dart';

class Screenshot extends StatelessWidget {
  Screenshot({@required this.child, this.controller}) {
    controller?._key = _key;
  }

  final _key = GlobalKey();
  final Widget child;
  final ScreenshotController controller;

  @override
  Widget build(BuildContext context) {
    final platform = getPlatform();

    if (platform == PlatformType.web) {
      return child;
    }

    return RepaintBoundary(
      key: _key,
      child: child,
    );
  }
}

class ScreenshotController {
  GlobalKey _key;

  Future<ui.Image> take({double pixelRatio = 1.0}) {
    if (_key == null) {
      return Future.value(null);
    }

    final platform = getPlatform();

    if (platform == PlatformType.web) {
      return Future.value(null);
    }

    final ro = _key.currentContext.findRenderObject() as RenderRepaintBoundary;
    return ro.toImage(pixelRatio: pixelRatio);
  }
}
