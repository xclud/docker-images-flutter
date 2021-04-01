import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/headed_page.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  LatLng loc;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String location1 = '';
    return HeadedPage(
      title: CustomText('تست'),
      body: Column(
        children: [
          RaisedButton(
            onPressed: () async {
              final barcode = await showBarcodeScanDialog(context);
              setState(() {
                ToastUtils.showCustomToast(context, barcode.code);
              });
            },
            child: Text('address'),
          ),
          RaisedButton(
            onPressed: () {},
            child: CustomText(location1),
          ),
        ],
      ),
    );
  }
}
