import 'package:flutter/material.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/general/split.dart';
import 'package:novinpay/widgets/pna_persian_datepicker/pna_persian_datepicker.dart';
import 'package:persian/persian.dart';

class PersianCalenderDialog extends StatefulWidget {
  PersianCalenderDialog({@required this.value, this.maximum});

  final String value;
  final DateTime maximum;

  @override
  _PersianCalenderDialogState createState() => _PersianCalenderDialogState();
}

class _PersianCalenderDialogState extends State<PersianCalenderDialog> {
  final TextEditingController _controller = TextEditingController();
  String warning = '';
  PersianDatePickerWidget _datePickerWidget;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
    _datePickerWidget = getPersianDatePicker(_controller);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Split(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _datePickerWidget,
            if (warning.isNotEmpty)
              Text(
                warning,
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
      footer: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
        child: ConfirmButton(
          onPressed: () {
            if (widget.maximum != null) {
              String value = _controller.text;

              final persianDateRegex =
                  RegExp(r'(1[3,4]\d\d)\/(\d\d?)\/(\d\d?)');
              final matches = persianDateRegex.allMatches(value).toList();

              if (matches.length != 1) {
                return;
              }
              if (matches[0].groupCount != 3) {
                return;
              }
              String yearGroup = matches[0].group(1);
              String monthGroup = matches[0].group(2);
              String dayGroup = matches[0].group(3);

              if (monthGroup.length == 1) {
                monthGroup = '0$monthGroup';
              }
              if (dayGroup.length == 1) {
                dayGroup = '0$dayGroup';
              }
              value = '$yearGroup/$monthGroup/$dayGroup';
              if (value == null || value.isEmpty) {
                setState(() {
                  warning = '';
                });
              }
              value = value.withEnglishNumbers();
              if (!RegExp('^1[3,4]\\d\\d\\/\\d\\d\\/\\d\\d\$')
                  .hasMatch(value)) {
                setState(() {
                  warning = 'تاریخ را به فرمت خواسته شده وارد نمایید';
                });
                return;
              }
              var parts = value.split('/');
              final year = int.tryParse(parts[0]);
              final month = int.tryParse(parts[1]);
              final day = int.tryParse(parts[2]);

              final maximum = widget.maximum.toPersian();
              if (year > maximum.year) {
                setState(() {
                  warning = 'تاریخ تولد نامعتبر است';
                });
                return;
              }
              if (year == maximum.year && month > maximum.month) {
                setState(() {
                  warning = 'تاریخ تولد نامعتبر است';
                });
                return;
              }
              if (year == maximum.year &&
                  month == maximum.month &&
                  day >= maximum.day) {
                setState(() {
                  warning = 'تاریخ تولد نامعتبر است';
                });
                return;
              }
            }
            if (_controller.text == '') {
              DateTime now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              _controller.text =
                  today.toPersian().toString().withEnglishNumbers();
            }
            Navigator.of(context).pop(_controller.text);
          },
          child: CustomText(
            strings.action_ok,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
