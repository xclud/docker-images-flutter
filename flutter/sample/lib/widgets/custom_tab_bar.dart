import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:seamless/seamless.dart';

class CustomTabBarItem {
  CustomTabBarItem({@required this.title});

  String title;
}

class CustomTabBar extends StatefulWidget {
  CustomTabBar({
    @required this.items,
    this.onChange,
    this.activeColor = colors.primaryColor,
    this.inactiveColor,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = colors.primaryColor,
  });

  final List<CustomTabBarItem> items;
  final ValueChanged<int> onChange;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];
    final items = widget.items ?? [];

    void _setPage(int index) {
      setState(() {
        _selectedTab = index;
      });

      widget.onChange?.call(_selectedTab);
    }

    for (int i = 0; i < items.length; i++) {
      final copyOfI = i;
      final item = items[i];

      final first = i == 0;
      final last = i == items.length - 1;
      final zero = Radius.zero;
      final c6 = const Radius.circular(8);

      final textColor = _selectedTab == copyOfI
          ? widget.activeTextColor
          : widget.inactiveTextColor;

      final btn = InkWell(
        onTap: () => _setPage(copyOfI),
        child: Container(
          // elevation: 0,
          // disabledElevation: 0,
          // focusElevation: 0,
          // highlightElevation: 0,
          // hoverElevation: 0,
          padding: EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _selectedTab == copyOfI
                ? widget.activeColor
                : widget.inactiveColor ?? colors.primaryColor.shade100,
            borderRadius: BorderRadiusDirectional.only(
              topStart: first ? c6 : zero,
              bottomStart: first ? c6 : zero,
              topEnd: last ? c6 : zero,
              bottomEnd: last ? c6 : zero,
            ),
          ),
          child: CustomText(
            item.title ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

      buttons.add(
        Expanded(child: btn),
      );

      if (i < items.length - 1) {
        final selected = _selectedTab == i || _selectedTab == i + 1;
        ;

        final separator = Container(
          width: 2,
          height: 52,
          color: selected
              ? widget.inactiveColor ?? colors.primaryColor.shade100
              : colors.primaryColor.shade200,
        );

        buttons.add(separator);
      }
    }

    final mobile = Row(children: buttons);

    final tablet = LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(4),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: min(constraints.biggest.width, 360),
          ),
          child: Row(
            children: buttons
                .map((e) => Expanded(
                      child: ConstrainedBox(
                        child: e,
                        constraints: BoxConstraints(minWidth: 90),
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );

    final seamless = Seamless(
      mobile: (context) => mobile,
      tablet: (context) => tablet,
    );

    return seamless;
  }
}

class CustomTabContent extends StatefulWidget {
  CustomTabContent({@required this.children, @required this.controller});

  final List<Widget> children;
  final PageController controller;

  @override
  State<StatefulWidget> createState() => _CustomTabContentState();
}

class _CustomTabContentState extends State<CustomTabContent> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: widget.controller,
      children: widget.children,
    );
  }
}
