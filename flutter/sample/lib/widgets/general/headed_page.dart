import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/sun.dart';

class HeadedPage extends StatefulWidget {
  HeadedPage({
    @required this.body,
    this.title,
    this.hasAppBar = true,
    this.actions,
    this.scaffoldKey,
    this.floatingActionButton,
    this.persistentFooterButtons,
  });

  final Widget title;
  final Widget body;
  final bool hasAppBar;
  final List<Widget> actions;
  final Key scaffoldKey;
  final Widget floatingActionButton;
  final List<Widget> persistentFooterButtons;

  @override
  State<StatefulWidget> createState() => _HeadedPageState();
}

class _HeadedPageState extends State<HeadedPage> {
  @override
  Widget build(BuildContext context) {
    var content = widget.body;

    final appBar = AppBar(
      actions: widget.actions,
      backgroundColor: colors.greyColor.shade50,
      title: DefaultTextStyle.merge(
        style: Theme.of(context).textTheme.headline6.copyWith(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
        child: widget.title ?? Container(),
      ),
      elevation: 0,
    );

    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: colors.greyColor.shade50,
      persistentFooterButtons: widget.persistentFooterButtons,
      appBar: widget.hasAppBar != true ? null : appBar,
      body: content,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
