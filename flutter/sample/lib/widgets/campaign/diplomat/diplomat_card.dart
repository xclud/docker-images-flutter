import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:novinpay/config.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:persian/persian.dart';

String _getCardUri(int i) {
  return '$end_point/assets/images/diplomat/diplomat$i.png';
}

class DiplomatCard extends StatefulWidget {
  DiplomatCard({
    @required this.id,
    @required this.pan,
    @required this.expDate,
    @required this.index,
    @required this.name,
    @required this.score,
    @required this.onDelete,
  });

  final int id;
  final String pan;
  final String expDate;
  final int index;
  final String name;
  final int score;
  final ValueChanged<int> onDelete;

  @override
  State<StatefulWidget> createState() => _DiplomatCardState();
}

class _DiplomatCardState extends State<DiplomatCard> with AskYesNoMixin {
  @override
  Widget build(BuildContext context) {
    final pan = widget.pan;
    final expDate = widget.expDate;
    final index = widget.index;
    final name = widget.name;
    final score = widget.score;

    final textStyle = TextStyle(color: Colors.white);
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: _getCardUri(index),
          fit: BoxFit.fill,
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(24, 24, 24, 24),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        Utils.getBankLogo(pan) ?? 'assets/ic_error.png',
                        height: 40,
                      ),
                      SizedBox(width: 8),
                      Text(
                        Utils.getBankName(pan) ?? 'نامشخص',
                        style: textStyle,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        score == null
                            ? '0'.withPersianNumbers()
                            : score.toString().withPersianNumbers(),
                        style: textStyle,
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        'assets/icons/gem.png',
                        color: Colors.white,
                        height: 32,
                      ),
                      SizedBox(width: 8),
                      IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            final yesNo = await askYesNo(
                              title: Text('حذف کارت'),
                              content: Text(
                                'کارت $lrm$pan$rlm حذف شود؟'
                                    .withPersianNumbers(),
                              ),
                            );

                            if (yesNo != true) {
                              return;
                            }

                            final data = await nh.diplomat
                                .deleteDiplomatCard(id: widget.id);

                            if (!showError(context, data)) {
                              return;
                            }

                            widget.onDelete?.call(widget.id);

                            ToastUtils.showCustomToast(context, 'حذف شد',
                                Image.asset('assets/ok.png'));
                          }),
                    ],
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(top: 24),
                  child: Text(
                    formatCardNumber(pan, true)
                            ?.withPersianNumbers()
                            ?.replaceAll('-', ' ') ??
                        '',
                    style: textStyle.copyWith(fontSize: 24),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(bottom: 8),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          name?.withPersianLetters()?.withPersianNumbers() ??
                              '',
                          style: textStyle,
                        ),
                      ),
                      Text(
                        expDate?.withPersianNumbers() ?? '',
                        style: textStyle,
                      ),
                      SizedBox(width: 8),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
