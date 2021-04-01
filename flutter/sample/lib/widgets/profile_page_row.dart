import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/space.dart';

class ProfileRow extends StatelessWidget {
  ProfileRow({
    @required this.title,
    @required this.isEmpty,
    this.value,
    this.child,
  });

  final String title;
  final String value;

  final bool isEmpty;
  final Widget child; // map for address

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: isEmpty
                    ? Text(
                        value,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 3,
                      )
                    : Column(
                        children: [
                          CustomText(
                            title,
                            style: colors.bodyStyle(context),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          CustomText(
                            value,
                            style: colors.boldStyle(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                Icons.edit_outlined,
                color: colors.ternaryColor,
                size: 20,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          child != null ? Space(2) : Container(),
          child ?? Container(),
        ],
      ),
      decoration: BoxDecoration(
        color: colors.greyColor.shade600,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      // margin: EdgeInsets.only(bottom: 8),
      width: MediaQuery.of(context).size.width,
    );
  }
}
