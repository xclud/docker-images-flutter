import 'package:flutter/material.dart';
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/mobile_selection_mixin.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/text_form_fields.dart';

class MobileWidget extends StatefulWidget {
  MobileWidget({
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.onItemClicked,
    this.showSimCard = true,
    this.showMruIcon = true,
    this.onEditingComplete,
    this.focusNode,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onItemClicked;
  final bool enabled;
  final bool showSimCard;
  final bool showMruIcon;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => _MobileWidgetState();
}

class _MobileWidgetState extends State<MobileWidget>
    with MruSelectionMixin, MobileNumberSelectionMixin {
  final _controller = TextEditingController();
  final _mutual = MutualTextEditingController();

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    super.initState();
  }

  void _onChanged(String value) {
    setState(() {});

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MobileTextFormField(
          onEditingComplete: widget.onEditingComplete,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          controller: _controller,
          onChanged: _onChanged,
          showSelectionDialog:
              widget.showMruIcon == true ? _showMobileSelectionDialog : null,
        ),
        if (widget.showSimCard == true) Space(),
        Row(
          children: [
            Expanded(
              child: Container(),
            ),
            if (widget.showSimCard == true)
              TextButton(
                child: Text('شماره من'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  side: MaterialStateProperty.all(
                    BorderSide(color: colors.primaryColor),
                  ),
                ),
                onPressed: () async {
                  final mobileNumber = await appState.getPhoneNumber();
                  _controller.text = mobileNumber;
                  _onChanged(mobileNumber);
                  widget.onItemClicked?.call(mobileNumber);
                },
              ),
          ],
        ),
      ],
    );
  }

  void _showMobileSelectionDialog() async {
    final data = await showMobileSelectionDialog();
    if (data == null) {
      return;
    }

    final mobileNumber = data.value.replaceAll('+98', '0').replaceAll(' ', '');
    _controller.text = mobileNumber;
    _onChanged(mobileNumber);
    widget.onItemClicked?.call(mobileNumber);
  }
}
