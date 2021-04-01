import 'package:flutter/material.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/insurance_titles.dart';

class SamanIndividualInsurancePage extends StatelessWidget {
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _ageValidator(String value) {
    if (value == null || value.isEmpty) {
      return 'سن خود را وارد نمایید';
    }
    if (int.tryParse(value) > 99 || int.tryParse(value) < 1) {
      return 'سن معتبر نمیباشد';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('بیمه انفرادی سامان'),
      body: Split(
        header: Form(
          key: _formKey,
          child: TextFormField(
            controller: _ageController,
            validator: _ageValidator,
            textDirection: TextDirection.ltr,
            maxLength: 2,
            inputFormatters: digitsOnly(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'سن',
              counterText: '',
            ),
          ),
        ),
        footer: ConfirmButton(
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => InsuranceTitles(
                  age: int.tryParse(_ageController.text),
                ),
              ),
            );
          },
          child: CustomText(
            strings.action_ok,
            textAlign: TextAlign.center,
          ),
        ),
        child: Expanded(
          child: Center(
            child:
                Text('برای مشاهده بیمه های متناسب لطفا سن خود را وارد نمایید.'),
          ),
        ),
      ),
    );
  }
}
