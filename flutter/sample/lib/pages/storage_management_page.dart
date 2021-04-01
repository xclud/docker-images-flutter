import 'package:flutter/material.dart';
import 'package:novinpay/Item.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/storage_management/account_management.dart';
import 'package:novinpay/widgets/storage_management/car_fine_management.dart';
import 'package:novinpay/widgets/storage_management/card_management.dart';
import 'package:novinpay/widgets/storage_management/iban_management.dart';
import 'package:novinpay/widgets/storage_management/loan_management.dart';
import 'package:novinpay/widgets/storage_management/mobile_management.dart';
import 'package:novinpay/widgets/storage_management/phone_management.dart';

class StorageManagementPage extends StatefulWidget {
  @override
  _StorageManagementPageState createState() => _StorageManagementPageState();
}

class _StorageManagementPageState extends State<StorageManagementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('مدیریت ذخیره های من'),
      body: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: GridView.count(
          padding: EdgeInsets.all(24),
          crossAxisCount: 3,
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: _getTab1Items().toList(),
        ),
      ),
    );
  }

  Iterable<Item> _getTab1Items() sync* {
    yield Item(
      title: CustomText('شماره موبایل'),
      image: Icon(
        SunIcons.mobile,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MobileManagement(),
        ),
      ),
    );
    yield Item(
      title: CustomText('کارت ها'),
      image: Icon(
        SunIcons.card,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardToCardManagement(),
        ),
      ),
    );
    yield Item(
      title: CustomText('حساب ها'),
      image: Icon(
        SunIcons.bank_account,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountManagement(),
        ),
      ),
    );
    yield Item(
      title: CustomText('شباها'),
      image: Icon(
        SunIcons.shaba_3,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IbanManagement(),
        ),
      ),
    );
    yield Item(
      title: CustomText('تلفن های ثابت'),
      image: Icon(
        SunIcons.mokhaberat,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneManagement(),
        ),
      ),
    );
    yield Item(
      title: CustomText('پلاک ها'),
      image: Icon(
        SunIcons.car,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarFineManagement(),
        ),
      ),
    );
    yield Item(
      title: CustomText('تسهیلات'),
      image: Icon(
        SunIcons.loan,
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoanManagement(),
        ),
      ),
    );
  }
}

class CustomBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
