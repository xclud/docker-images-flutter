import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:iran/iran.dart' as ir;
import 'package:novinpay/card_info.dart';
import 'package:novinpay/dialogs/persian_calender_dialog.dart';
import 'package:novinpay/services/platform_helper.dart' as ph;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:persian/persian.dart';

class CardTextFormField extends StatefulWidget {
  CardTextFormField({
    this.controller,
    this.labelText,
    this.hintText,
    this.showSelectionDialog,
    this.onChanged,
    this.onComplete,
    this.focusNode,
    this.onEditingComplete,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final VoidCallback showSelectionDialog;
  final ValueChanged<String> onChanged;
  final VoidCallback onComplete;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _CardTextFormFieldState();
}

class _CardTextFormFieldState extends State<CardTextFormField> {
  static final _translator = {
    '#': RegExp(r'[\d]'),
    '*': RegExp(r'[\d\*]'),
  };
  final _controller = MaskedTextController(
      mask: '####-##**-****-####', translator: _translator);

  //final _controller = TextEditingController();
  final _mutual = MutualTextEditingController();

  String _value;

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    _value = widget.controller?.text;
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _value = widget.controller.text;
        });
      }
    });
    super.initState();
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'وارد نمایید';
    }

    if (value.length != 19) {
      return 'معتبر نیست';
    }

    final pan = Pan(value);

    if (!pan.isValid()) {
      return 'معتبر نیست';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      onEditingComplete: widget.onEditingComplete,
      validator: _validator,
      controller: _controller,
      onChanged: (value) {
        widget.onChanged?.call(value);
        final error = _validator(value);
        setState(() {
          _value = value;
        });
        if (error == null) {
          //Form.of(context)?.validate();
          widget.onComplete?.call();
        }
      },
      decoration: _buildCardInputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText ?? '۶۲۷۴-۱۲**-****-****',
        onSelectionDialog: widget.showSelectionDialog,
        pan: _value,
      ),
    );
  }
}

class IbanTextFormField extends StatefulWidget {
  IbanTextFormField({
    this.enabled,
    this.controller,
    this.showSelectionDialog,
    this.labelText,
    this.onEditingComplete,
    this.onChanged,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String labelText;
  final TextEditingController controller;
  final VoidCallback showSelectionDialog;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final AutovalidateMode autovalidateMode;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _IbanTextFormFieldState();
}

class _IbanTextFormFieldState extends State<IbanTextFormField> {
  final _controller =
      MaskedTextController(mask: 'IR-00-0000-0000-0000-0000-0000-00');
  final _mutual = MutualTextEditingController();

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    super.initState();
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'شماره شبا را وارد نمایید';
    }

    if (value.length != 33) {
      return 'شماره شبا معتبر نیست';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      inputFormatters: iban(),
      keyboardType: TextInputType.number,
      controller: _controller,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      textInputAction: TextInputAction.next,
      textDirection: TextDirection.ltr,
      validator: _validator,
      onChanged: (value) {
        widget.onChanged?.call(value);

        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'شماره شبا',
        hintText: 'IR-00-0000-0000-0000-0000-00',
        hintTextDirection: TextDirection.ltr,
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class LoanTextFormField extends StatefulWidget {
  LoanTextFormField({
    this.controller,
    this.showSelectionDialog,
    this.labelText,
    this.focusNode,
    this.onEditingComplete,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String labelText;
  final TextEditingController controller;
  final VoidCallback showSelectionDialog;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _LoanTextFormFieldState();
}

class _LoanTextFormFieldState extends State<LoanTextFormField> {
  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'شماره تسهیلات را وارد نمایید';
    }
    if (value.length < 15) {
      return 'شماره تسهیلات کوتاه است';
    }
    if (!value.contains('.')) {
      return 'شماره تسهیلات صحیح نیست';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      keyboardType: TextInputType.number,
      controller: widget.controller,
      textInputAction: TextInputAction.next,
      textDirection: TextDirection.ltr,
      validator: _validator,
      maxLength: 20,
      onChanged: (value) {
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'شماره تسهیلات',
        hintText: '000',
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class VehicleIdTextFormField extends StatefulWidget {
  VehicleIdTextFormField({
    this.controller,
    this.showSelectionDialog,
    this.labelText,
    this.onChanged,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String labelText;
  final TextEditingController controller;
  final VoidCallback showSelectionDialog;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _VehicleIdTextFormFieldState();
}

class _VehicleIdTextFormFieldState extends State<VehicleIdTextFormField> {
  //final _controller = MaskedTextController(mask: '000000000');
  //final _mutual = MutualTextEditingController();

  @override
  void initState() {
    //_mutual.start(_controller, widget.controller);
    super.initState();
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'بارکد را وارد نمایید';
    }

    if (value.length < 8 || value.length > 10) {
      return 'بارکد معتبر نیست';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      inputFormatters: digitsOnly(),
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      controller: widget.controller,
      maxLength: 11,
      validator: _validator,
      onChanged: (value) {
        widget.onChanged?.call(value);

        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'بارکد کارت خودرو',
        hintText: '000000000',
        hintTextDirection: TextDirection.ltr,
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class NationalNumberTextFormField extends StatefulWidget {
  NationalNumberTextFormField({
    this.enabled,
    this.controller,
    this.labelText,
    this.onEditingComplete,
    this.focusNode,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final String labelText;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _NationalNumberTextFormFieldState();
}

class _NationalNumberTextFormFieldState
    extends State<NationalNumberTextFormField> {
  final _controller = MaskedTextController(mask: '0000000000');
  final _mutual = MutualTextEditingController();

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    super.initState();
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'کد ملی را وارد نمایید';
    }

    if (value.length != 10) {
      return 'کد ملی باید ده رقم باشد';
    }

    if (!ir.validateNationalNumber(value.withEnglishNumbers())) {
      return 'کد ملی معتبر نیست';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: digitsOnly(),
      keyboardType: TextInputType.number,
      controller: _controller,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      validator: _validator,
      onChanged: (value) {
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'کد ملی',
        hintText: '0123456789',
        hintTextDirection: TextDirection.ltr,
      ),
    );
  }
}

class MobileTextFormField extends StatefulWidget {
  MobileTextFormField({
    this.controller,
    this.onChanged,
    this.enabled = true,
    this.ignoreValidation,
    this.labelText,
    this.showSelectionDialog,
    this.focusNode,
    this.onEditingComplete,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final bool ignoreValidation;
  final String labelText;
  final VoidCallback showSelectionDialog;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;

  @override
  State<StatefulWidget> createState() => _MobileTextFormFieldState();
}

class _MobileTextFormFieldState extends State<MobileTextFormField> {
  final _controller = MaskedTextController(mask: '00000000000');
  final _mutual = MutualTextEditingController();
  String _value;

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    _value = widget.controller?.text;
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _value = widget.controller.text;
        });
      }
    });
    super.initState();
  }

  String _validator(String value) {
    if (widget.ignoreValidation == true) {
      return null;
    }

    if (value == null || value.isEmpty) {
      return 'شماره موبایل را وارد نمایید';
    }

    if (value.length != 11) {
      return 'شماره موبایل را وارد نمایید';
    }

    value = value.withEnglishNumbers();

    final regex = RegExp(r'09[01239]\d\d\d\d\d\d\d\d');
    if (!regex.hasMatch(value)) {
      return 'شماره موبایل صحیح نیست';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      onEditingComplete: widget.onEditingComplete,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      inputFormatters: digitsOnly(),
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      controller: _controller,
      validator: _validator,
      onChanged: (value) {
        widget.onChanged?.call(value);
        final error = _validator(value);
        setState(() {
          _value = value;
        });
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      textInputAction: TextInputAction.next,
      decoration: _buildMobileInputDecoration(
        labelText: widget.labelText ?? strings.label_mobile_number,
        hintText: '۰۹۱۲۳۴۵۶۷۸۹',
        hintTextDirection: TextDirection.ltr,
        phoneNumber: _value,
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class PhoneTextFormField extends StatefulWidget {
  PhoneTextFormField({
    this.controller,
    this.hintText,
    this.showSelectionDialog,
    this.onComplete,
    this.focusNode,
    this.onChanged,
    this.enabled,
    this.labelText,
    this.onEditingComplete,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback showSelectionDialog;
  final VoidCallback onComplete;
  final ValueChanged<String> onChanged;
  final FocusNode focusNode;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final String labelText;
  final VoidCallback onEditingComplete;

  @override
  State<StatefulWidget> createState() => _PhoneTextFormFieldState();
}

class _PhoneTextFormFieldState extends State<PhoneTextFormField> {
  final _controller = MaskedTextController(mask: '00000000000');
  final _mutual = MutualTextEditingController();

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    super.initState();
  }

  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'شماره تلفن را وارد نمایید';
    }
    if (!value.startsWith('0') || value.length < 11) {
      return 'شماره تلفن صحیح نمیباشد';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      maxLength: 11,
      validator: _validator,
      controller: _controller,
      onChanged: (value) {
        widget.onChanged?.call(value);

        final error = _validator(value);
        if (error == null) {
          widget.onComplete?.call();
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'تلفن ثابت',
        hintText: widget.hintText ?? '۰۲۱۲۲۳۴۵۶۷۸',
        hintTextDirection: TextDirection.ltr,
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class AccountTextFormField extends StatefulWidget {
  AccountTextFormField({
    this.controller,
    this.showSelectionDialog,
    this.labelText,
    this.focusNode,
    this.onEditingComplete,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String labelText;
  final TextEditingController controller;
  final VoidCallback showSelectionDialog;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _AccountTextFormFieldState();
}

class _AccountTextFormFieldState extends State<AccountTextFormField> {
  //final _controller = MaskedTextController(mask: '000-000-0000000-0');

  @override
  void initState() {
    // _controller.addListener(() {
    //   widget.controller?.text = _controller.text;
    // });
    super.initState();
  }

  String _validator(String text) {
    if (text == null || text.isEmpty) {
      return 'لطفا شماره حساب را وارد نمایید';
    }

    RegExp exp = RegExp(r'^\d[\d-]+\d$');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    if (matches.length != 1) {
      return 'شماره حساب وارد شده صحیح نیست';
    }

    if (text.contains('--')) {
      return 'شماره حساب وارد شده صحیح نیست';
    }

    if (!text.contains('-')) {
      return 'شماره حساب وارد شده صحیح نیست';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      //inputFormatters: digitsAndHyphen(),
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      controller: widget.controller,
      textInputAction: TextInputAction.next,
      maxLength: 19,
      validator: _validator,
      onChanged: (value) {
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? strings.label_account_number,
        hintText: '000-000-0000000-0',
        hintTextDirection: TextDirection.ltr,
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class MoneyTextFormField extends StatefulWidget {
  MoneyTextFormField({
    this.controller,
    this.name,
    this.labelText,
    this.minimum,
    this.maximum,
    this.onChanged,
    this.focusNode,
    this.onEditingComplete,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final String name;
  final String labelText;
  final int minimum;
  final int maximum;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => _MoneyTextFormFieldState();
}

class _MoneyTextFormFieldState extends State<MoneyTextFormField> {
  // final _controller =
  //     MoneyMaskedTextController(precision: 0, thousandSeparator: ',');
  // final _mutual = MutualTextEditingController();

  @override
  void initState() {
    //_mutual.start(_controller, widget.controller);
    super.initState();
  }

  String _validator(String text) {
    final name = widget.name ?? 'عدد';
    if (text == null || text.isEmpty) {
      return 'لطفا $name را وارد نمایید';
    }

    final v = text?.replaceAll(',', '');
    final number = int.tryParse(v ?? '');

    if (number == null) {
      return '$name وارد شده صحیح نیست';
    }

    if (widget.minimum != null && number < widget.minimum) {
      return '$name وارد شده در بازه مناسب نیست';
    }

    if (widget.maximum != null && number > widget.maximum) {
      return '$name وارد شده در بازه مناسب نیست';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      controller: widget.controller,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: digitsOnly()..add(MoneyTextInputFormatter()),
      textInputAction: TextInputAction.next,
      maxLength: 13,
      validator: _validator,
      onChanged: (value) {
        widget.onChanged?.call(value);
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: InputDecoration(
        suffixText: ' ریال ',
        counterText: '',
        hintText: '۱۰,۰۰۰',
        labelText: widget.labelText ?? 'مبلغ',
        hintTextDirection: TextDirection.ltr,
      ),
    );
  }
}

class ExpireYearTextFormField extends StatefulWidget {
  ExpireYearTextFormField({
    this.controller,
    this.validator,
    this.focusNode,
    this.onComplete,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final FocusNode focusNode;
  final VoidCallback onComplete;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _ExpireYearTextFormFieldState();
}

class _ExpireYearTextFormFieldState extends State<ExpireYearTextFormField> {
  final _controller = MaskedTextController(mask: '00');
  final _mutual = MutualTextEditingController();

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      autovalidateMode: widget.autovalidateMode,
      focusNode: widget.focusNode,
      validator: widget.validator,
      inputFormatters: digitsOnly(),
      maxLength: 2,
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      controller: _controller,
      onChanged: (value) {
        final valid = widget.validator?.call(value);
        if (valid == null) {
          widget.onComplete?.call();
        }
      },
      decoration: _buildSelectionInputDecoration(hintText: 'سال'),
    );
  }
}

class ExpireMonthTextFormField extends StatefulWidget {
  ExpireMonthTextFormField({
    this.controller,
    this.validator,
    this.focusNode,
    this.onComplete,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final FocusNode focusNode;
  final VoidCallback onComplete;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _ExpireMonthTextFormFieldState();
}

class _ExpireMonthTextFormFieldState extends State<ExpireMonthTextFormField> {
  final _controller = MaskedTextController(mask: '00');
  final _mutual = MutualTextEditingController();

  @override
  void initState() {
    _mutual.start(_controller, widget.controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      validator: widget.validator,
      inputFormatters: digitsOnly(),
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      maxLength: 2,
      controller: _controller,
      onChanged: (value) {
        final valid = widget.validator?.call(value);
        if (valid == null) {
          widget.onComplete?.call();
        }
      },
      decoration: _buildSelectionInputDecoration(hintText: 'ماه'),
    );
  }
}

class PersianDateTextFormField extends StatefulWidget {
  PersianDateTextFormField({
    this.controller,
    this.allowEmpty = true,
    this.name,
    this.labelText,
    this.maximum,
    this.focusNode,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final bool allowEmpty;
  final String name;
  final String labelText;
  final DateTime maximum;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => _PersianDateTextFormFieldState();
}

class _PersianDateTextFormFieldState extends State<PersianDateTextFormField> {
  String _validator(String value) {
    final name = widget.name ?? 'تاریخ';
    if (value == null || value.isEmpty) {
      if (widget.allowEmpty != true) {
        return '$name را وارد نمایید';
      }
    }

    value = value.withEnglishNumbers();
    if (!RegExp('^1[3,4]\\d\\d\\/\\d\\d\\/\\d\\d\$').hasMatch(value)) {
      return 'تاریخ را وارد نمایید';
    }

    var parts = value.split('/');
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || year < 1300 || year > 1400) return 'سال نامعتبر است';
    if (month == null || month < 1 || month > 12) return 'ماه نامعتبر است';
    if (day == null || day < 1 || day > 31) return 'روز نامعتبر است';

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      onTap: _onTap,
      validator: _validator,
      keyboardType: TextInputType.number,
      textDirection: TextDirection.ltr,
      textInputAction: TextInputAction.next,
      controller: widget.controller,
      focusNode: widget.focusNode,
      onChanged: (value) {
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText,
        hintText: '۱۳۷۰/۰۱/۰۱',
        hintTextDirection: TextDirection.ltr,
      ),
    );
  }

  void _onTap() async {
    if (!widget.controller.text.contains('/') ||
        widget.controller.text.contains('-')) {
      widget.controller.text = '';
    }

    String result = await showCustomBottomSheet<String>(
      context: context,
      child: PersianCalenderDialog(
        value: widget.controller.text,
        maximum: widget.maximum,
      ),
    );

    if (result == null) {
      return;
    }
    // calender return persian date
    result = result?.withEnglishNumbers();

    final persianDateRegex = RegExp(r'(1[3,4]\d\d)\/(\d\d?)\/(\d\d?)');
    final matches = persianDateRegex.allMatches(result).toList();

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
    widget.controller.text = '$yearGroup/$monthGroup/$dayGroup';
  }
}

class MutualTextEditingController {
  TextEditingController _left;
  TextEditingController _right;
  bool _listen = true;

  void start(TextEditingController left, TextEditingController right) {
    _left = left;
    _right = right;

    _left?.addListener(() {
      if (_listen) {
        _right?.text = _left?.text;
      }
    });

    _right?.addListener(() {
      _listen = false;
      _left?.text = _right?.text;
      _listen = true;
    });
  }
}

class MoneyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      final v = newValue.text.replaceAll(',', '');
      final i = int.tryParse(v);
      String newString = separateThousand(i);

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

class PanTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      int selectionIndexFromTheRight =
          newValue.text.length - newValue.selection.extentOffset;
      String newString = formatCardNumber(newValue.text);

      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndexFromTheRight,
        ),
      );
    } else {
      return newValue;
    }
  }
}

class NameTextFormField extends StatefulWidget {
  NameTextFormField({
    this.controller,
    this.showSelectionDialog,
    this.labelText,
    this.onEditingComplete,
    this.focusNode,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String labelText;
  final TextEditingController controller;
  final VoidCallback showSelectionDialog;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _NameTextFormFieldState();
}

class _NameTextFormFieldState extends State<NameTextFormField> {
  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'نام را وارد نمایید';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      controller: widget.controller,
      maxLength: 30,
      validator: _validator,
      textInputAction: TextInputAction.next,
      onEditingComplete: widget.onEditingComplete,
      onChanged: (value) {
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'نام',
        hintText: 'نام',
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class LastNameTextFormField extends StatefulWidget {
  LastNameTextFormField({
    this.controller,
    this.showSelectionDialog,
    this.labelText,
    this.onEditingComplete,
    this.focusNode,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String labelText;
  final TextEditingController controller;
  final VoidCallback showSelectionDialog;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _LastNameTextFormFieldState();
}

class _LastNameTextFormFieldState extends State<LastNameTextFormField> {
  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'نام خانوادگی را وارد نمایید';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      keyboardType: TextInputType.text,
      controller: widget.controller,
      maxLength: 30,
      validator: _validator,
      onChanged: (value) {
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'نام خانوادگی',
        hintText: 'نام خانوادگی',
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class IdNumberTextFormField extends StatefulWidget {
  IdNumberTextFormField({
    this.controller,
    this.showSelectionDialog,
    this.labelText,
    this.onEditingComplete,
    this.focusNode,
    this.enabled,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String labelText;
  final TextEditingController controller;
  final VoidCallback showSelectionDialog;
  final VoidCallback onEditingComplete;
  final FocusNode focusNode;
  final bool enabled;
  final AutovalidateMode autovalidateMode;

  @override
  State<StatefulWidget> createState() => _IdNumberTextFormFieldState();
}

class _IdNumberTextFormFieldState extends State<IdNumberTextFormField> {
  String _validator(String value) {
    if (value == null || value.isEmpty) {
      return 'شماره شناسنامه را وارد نمایید';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: widget.autovalidateMode,
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: digitsOnly(),
      keyboardType: TextInputType.number,
      controller: widget.controller,
      textDirection: TextDirection.ltr,
      maxLength: 10,
      validator: _validator,
      onChanged: (value) {
        final error = _validator(value);
        if (error == null) {
          //Form.of(context)?.validate();
        }
      },
      decoration: _buildSelectionInputDecoration(
        labelText: widget.labelText ?? 'شماره شناسنامه',
        hintText: '1234567890',
        hintTextDirection: TextDirection.ltr,
        onSelectionDialog: widget.showSelectionDialog,
      ),
    );
  }
}

class PasswordTextFormField extends StatefulWidget {
  PasswordTextFormField({
    @required this.controller,
    this.enabled = true,
    this.ignoreValidation,
    this.labelText,
    this.showSelectionDialog,
    this.focusNode,
    this.hintText,
    this.onEditingComplete,
    this.validator,
    this.keyboardType = TextInputType.number,
    this.maxLength,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.textDirection = TextDirection.ltr,
    this.hintTextDirection = TextDirection.ltr,
    this.counterText = '',
    this.obscureText = true,
    this.onChanged,
  });

  final TextEditingController controller;
  final bool enabled;
  final AutovalidateMode autoValidateMode;
  final bool ignoreValidation;
  final String labelText;
  final String hintText;
  final VoidCallback showSelectionDialog;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;
  final int maxLength;
  final TextDirection textDirection;
  final TextDirection hintTextDirection;
  final String counterText;
  final bool obscureText;
  final ValueChanged<String> onChanged;

  @override
  State<StatefulWidget> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  String _value = '';
  final TextEditingController _textEditingController = TextEditingController();
  final platform = ph.getPlatform();
  var browser;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (widget.controller.text.isNotEmpty) {
        _textEditingController.text = '';
        for (int _i = 0; _i < widget.controller.text.length; _i++) {
          _textEditingController.text += '•';
        }
        _value = widget.controller.text;
      }
    });
    if (platform == ph.PlatformType.web) {
      browser = ph.Browser();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Safari
    if (platform == ph.PlatformType.web && browser.browser == 'Safari') {
      return TextFormField(
        autovalidateMode: widget.autoValidateMode,
        onEditingComplete: widget.onEditingComplete,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        textDirection: widget.textDirection,
        keyboardType: widget.keyboardType,
        controller: _textEditingController,
        validator: (value) => widget.validator?.call(value),
        maxLength: widget.maxLength,
        textInputAction: TextInputAction.next,
        obscureText: false,
        maxLines: 1,
        onChanged: (value) async {
          if (value.isNotEmpty) {
            // when value has only dot, it means user remove characters
            if (RegExp(r'^(•){0,}$').hasMatch(value)) {
              int _baseOffset = _textEditingController.selection.baseOffset;
              // offset of changed character
              int _deletedCount = _value.length - value.length;
              String _part1 = _value.substring(0, _baseOffset);
              String _part2 = _value.substring(_baseOffset + _deletedCount);
              _value = _part1 + _part2;
              _textEditingController.text = '';
              for (int _i = 0; _i < _value.length; _i++) {
                _textEditingController.text += '•';
              }
            } else {
              // add a character and replace it with a dot
              _textEditingController.text = '';
              _value = _value + value.replaceAll('•', '');
              for (int _i = 0; _i < _value.length; _i++) {
                _textEditingController.text += '•';
              }
            }
          } else {
            // when user delete all characters
            _value = '';
            _textEditingController.text = '';
          }
          widget.controller.text = _value;
          // move cursor to end of text
          _textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textEditingController.text.length),
          );
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintTextDirection: widget.hintTextDirection,
          counterText: widget.counterText,
        ),
      );
    } else {
      /// android, chrome & others
      return TextFormField(
        autovalidateMode: widget.autoValidateMode,
        onEditingComplete: () {
          widget.onEditingComplete?.call();
        },
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        textDirection: widget.textDirection,
        keyboardType: widget.keyboardType,
        controller: widget.controller,
        validator: (value) => widget.validator?.call(value),
        maxLength: widget.maxLength,
        textInputAction: TextInputAction.next,
        obscureText: widget.obscureText,
        maxLines: 1,
        onChanged: (value) async {
          widget.onChanged?.call(value);
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintTextDirection: widget.hintTextDirection,
          counterText: widget.counterText,
        ),
      );
    }
  }
}

InputDecoration _buildSelectionInputDecoration({
  String labelText,
  String hintText,
  TextDirection hintTextDirection,
  VoidCallback onSelectionDialog,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    hintTextDirection: hintTextDirection,
    counterText: '',
    suffixIcon: onSelectionDialog != null
        ? IconButton(
            onPressed: () {
              onSelectionDialog?.call();
            },
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
          )
        : null,
  );
}

InputDecoration _buildCardInputDecoration({
  String labelText,
  String hintText,
  String pan,
  VoidCallback onSelectionDialog,
}) {
  final logo = Utils.getBankLogo(pan);
  final bank = Utils.getBankName(pan);

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    hintTextDirection: TextDirection.ltr,
    counterText: '',
    prefixIcon: logo != null
        ? Tooltip(
            message: bank ?? '',
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: Image.asset(logo),
            ),
          )
        : null,
    prefixIconConstraints: BoxConstraints(maxWidth: 32, maxHeight: 32),
    suffixIcon: onSelectionDialog != null
        ? IconButton(
            onPressed: () {
              onSelectionDialog?.call();
            },
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
          )
        : null,
  );
}

InputDecoration _buildMobileInputDecoration({
  String labelText,
  String hintText,
  TextDirection hintTextDirection,
  String phoneNumber,
  VoidCallback onSelectionDialog,
}) {
  final op = Utils.getOperatorType(phoneNumber);
  final logo = Utils.getOperatorLogo(op);
  final bank = Utils.getOperatorName(op);

  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    hintTextDirection: hintTextDirection,
    counterText: '',
    prefixIcon: logo != null
        ? Tooltip(
            message: bank ?? '',
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: Image.asset(logo),
            ),
          )
        : null,
    prefixIconConstraints: BoxConstraints(maxWidth: 32, maxHeight: 32),
    suffixIcon: onSelectionDialog != null
        ? IconButton(
            onPressed: () {
              onSelectionDialog?.call();
            },
            icon: Icon(Icons.arrow_drop_down_circle_outlined),
          )
        : null,
  );
}
