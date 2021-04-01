import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  Space([this.count = 1]);

  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: count * 8.0);
  }
}
