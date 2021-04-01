import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:persian/persian.dart';

class PlateNumber extends StatelessWidget {
  PlateNumber({
    @required this.part1,
    @required this.part2,
    @required this.part3,
    @required this.part4,
  });

  final int part1;
  final String part2;
  final int part3;
  final int part4;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: colors.greyColor.shade600),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  //Do not edit or refactor this color.
                  color: Color.fromARGB(255, 0, 51, 153),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      'assets/plaque.jpg',
                      width: 36,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$part1'.withPersianNumbers().withPersianLetters(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '$part2'.withPersianNumbers().withPersianLetters(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '$part3'.withPersianNumbers().withPersianLetters(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black,
              width: 1,
              height: 56,
            ),
            Expanded(
              flex: 2,
              child: Text(
                'ایران\n$part4'.withPersianNumbers(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
