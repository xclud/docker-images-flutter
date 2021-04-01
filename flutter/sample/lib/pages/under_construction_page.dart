import 'package:flutter/material.dart';
import 'package:novinpay/widgets/general/general.dart';

class UnderConstructionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('به زودی'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/comming-soon.png'),
            Space(2),
            Text(
              'به زودی راه اندازی میشود.',
            ),
          ],
        ),
      ),
    );
  }
}
