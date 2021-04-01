import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/insurance.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:persian/persian.dart';

class InsuranceDetail extends StatefulWidget {
  InsuranceDetail(
      {@required this.benefits,
      @required this.orderingId,
      @required this.message,
      @required this.planName});

  final List<Benefits> benefits;
  final int orderingId;
  final String planName;
  final String message;

  @override
  _InsuranceDetailState createState() => _InsuranceDetailState();
}

class _InsuranceDetailState extends State<InsuranceDetail> {
  List<Benefits> _benefits;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.benefits.removeWhere((element) => element.value == '-');
      _benefits = widget.benefits;
      setState(() {});
    });
    super.initState();
  }

  Widget _buildList() {
    return ListView.separated(
      separatorBuilder: (context, index) => Container(
        width: 1,
        color: Colors.black54,
      ),
      itemCount: _benefits.length,
      itemBuilder: (context, index) {
        return InsuranceItem(
          item: _benefits[index],
          isLastItem: index == _benefits.length - 1,
        );
      },
    );
  }

  Widget _buildChild() {
    if (_benefits == null) {
      return _buildMessage('خطا در دریافت اطلاعات');
    }

    if (_benefits.isEmpty) {
      return _buildMessage('موردی جهت نمایش یافت نشد');
    }

    return _buildList();
  }

  Widget _buildMessage(String msg) {
    return Center(
      child: Text(
        msg,
        style: colors
            .regularStyle(context)
            .copyWith(color: colors.greyColor.shade900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('جزئیات طرح'),
        body: Split(
          child: Expanded(
              child: Container(
            padding: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 8),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colors.primaryColor.shade400,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsetsDirectional.fromSTEB(24, 16, 0, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.planName ?? '',
                        style: colors
                            .boldStyle(context)
                            .copyWith(color: Colors.white),
                      ),
                      Space(2),
                      Text(
                        widget.message?.withPersianNumbers() ?? '',
                        style: colors
                            .regularStyle(context)
                            .copyWith(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsetsDirectional.only(bottom: 16),
                        child: _buildChild())),
              ],
            ),
          )),
          footer: Container(
            margin: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
            child: ConfirmButton(
              child: CustomText(
                'صدور طرح',
                textAlign: TextAlign.center,
              ),
              onPressed: _onConfirm,
            ),
          ),
        ));
  }

  void _onConfirm() {
    Navigator.of(context).pop(true);
  }
}

class InsuranceItem extends StatelessWidget {
  InsuranceItem({@required this.item, @required this.isLastItem});

  final Benefits item;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            color: colors.primaryColor.shade50,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      item.benefit?.withPersianNumbers() ?? '',
                      style: colors.boldStyle(context),
                    ),
                  ),
                ],
              ),
              Space(2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      'سقف پرداخت',
                      style: colors
                          .bodyStyle(context)
                          .copyWith(color: colors.accentColor),
                    ),
                  ),
                  Expanded(
                    child: CustomText(
                      toRials(int.tryParse(item.value) ?? 0) ?? '',
                      textAlign: TextAlign.end,
                      style: colors
                          .bodyStyle(context)
                          .copyWith(color: colors.accentColor),
                    ),
                  ),
                ],
              ),
              Space(),
              if (item.comments != null && item.comments.isNotEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('توضیحات'),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: CustomText(
                        item.comments ?? '',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (isLastItem != null && !isLastItem)
          Container(
            color: Colors.black54,
            height: 1,
          )
      ],
    );
  }
}
