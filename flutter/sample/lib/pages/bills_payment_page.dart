import 'package:flutter/material.dart';
import 'package:novinpay/Item.dart';
import 'package:novinpay/widgets/bill/electricity.dart';
import 'package:novinpay/widgets/bill/mobile.dart';
import 'package:novinpay/widgets/bill/phone.dart';
import 'package:novinpay/widgets/bill/service.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/sun.dart';

class BillsPaymentPage extends StatefulWidget {
  @override
  _BillsPaymentPageState createState() => _BillsPaymentPageState();
}

class _BillsPaymentPageState extends State<BillsPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('قبض'),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(24.0, 8.0, 24.0, 0.0),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: _getItems().toList(),
        ),
      ),
    );
  }

  Iterable<Item> _getItems() sync* {
    yield Item(
        title: CustomText('موبایل'),
        image: Icon(
          SunIcons.mobile,
        ),
        onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MobileBill(),
                ),
              )
            });

    yield Item(
        title: CustomText('تلفن های ثابت'),
        image: Icon(
          SunIcons.mokhaberat,
        ),
        onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PhoneBill(),
                ),
              )
            });

    yield Item(
        title: CustomText('قبض برق'),
        image: Icon(
          SunIcons.bargh,
        ),
        onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ElectricityBill(),
                ),
              )
            });

    yield Item(
        title: CustomText('قبض خدماتی'),
        image: Icon(
          SunIcons.receipt_2,
        ),
        onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ServiceBill(),
                ),
              )
            });
  }
}
