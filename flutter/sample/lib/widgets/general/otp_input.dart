import 'package:flutter/material.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    Key key,
    this.controller,
    this.onChanged,
  }) : super(key: key);
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _pin1FN = FocusNode();
  final _pin2FN = FocusNode();
  final _pin3FN = FocusNode();
  final _pin4FN = FocusNode();

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final controller4 = TextEditingController();

  String _value;

  void _populateString() {
    if (controller1.text.length > 1) {
      controller1.text = controller1.text[0];
    }
    if (controller2.text.length > 1) {
      controller2.text = controller2.text[0];
    }
    if (controller3.text.length > 1) {
      controller3.text = controller3.text[0];
    }
    if (controller4.text.length > 1) {
      controller4.text = controller4.text[0];
    }

    controller2.text + controller3.text + controller4.text;

    final all = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text;

    if (_value != all) {
      _value = all;

      widget.onChanged?.call(all);
      widget.controller?.text = all;
    }
  }

  final pinStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();

    controller1.addListener(_populateString);
    controller2.addListener(_populateString);
    controller3.addListener(_populateString);
    controller4.addListener(_populateString);
  }

  @override
  void dispose() {
    super.dispose();
    _pin1FN.dispose();
    _pin2FN.dispose();
    _pin3FN.dispose();
    _pin4FN.dispose();

    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
  }

  void nextField(String value, FocusNode prev, FocusNode next) {
    if (value.isEmpty) {
      prev?.requestFocus();
    } else {
      next?.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: controller1,
                  focusNode: _pin1FN,
                  autofocus: true,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: _inputDecoration,
                  onChanged: (value) {
                    nextField(value, null, _pin2FN);
                  },
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: controller2,
                  focusNode: _pin2FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: _inputDecoration,
                  onChanged: (value) => nextField(value, _pin1FN, _pin3FN),
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: controller3,
                  focusNode: _pin3FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: _inputDecoration,
                  onChanged: (value) => nextField(value, _pin2FN, _pin4FN),
                ),
              ),
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: controller4,
                  focusNode: _pin4FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: _inputDecoration,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      nextField(value, _pin3FN, null);
                    } else {
                      _pin4FN.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

final _inputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
  border: _inputBorder,
  focusedBorder: _inputBorder,
  enabledBorder: _inputBorder,
);

final _inputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade400),
);
