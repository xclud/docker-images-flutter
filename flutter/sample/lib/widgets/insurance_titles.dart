import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/models/insurance.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/insurance_detail.dart';

class InsuranceTitles extends StatefulWidget {
  InsuranceTitles({@required this.age});

  final int age;

  @override
  _InsuranceTitlesState createState() => _InsuranceTitlesState();
}

class _InsuranceTitlesState extends State<InsuranceTitles> {
  Response<PlanAgeResponse> _data;
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  int _age;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _age = widget.age;
      _refreshKey.currentState.show();
    });
  }

  Future<void> _getList() async {
    final data = await nh.insuranceAgency.planAge(age: _age);
    setState(() {
      _data = data;
    });
  }

  Widget _buildList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _data.content.plans.length,
            itemBuilder: (context, index) {
              return InsuranceItem(
                item: _data.content.plans[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChild() {
    if (_data == null) {
      return _buildMessage(strings.please_wait);
    }
    if (_data.isError) {
      return _buildMessage(strings.connectionError);
    }
    if (_data.content.status != true) {
      return _buildMessage(_data.content.description);
    }
    if (_data.content.plans.isEmpty) {
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
      title: Text('لیست طرح ها'),
        body: RefreshIndicator(
          key: _refreshKey,
          child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 24),
              child: _buildChild()),
          onRefresh: _getList,
        ));
  }
}

class InsuranceItem extends StatelessWidget {
  InsuranceItem({@required this.item});

  final PlanItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(24, 8, 8, 8),
      margin: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 4),
      decoration: BoxDecoration(
        color: colors.primaryColor.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  item.name ?? '',
                  style: colors
                      .boldStyle(context)
                      .copyWith(color: colors.primaryColor),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                child: FlatButton(
                  color: Colors.white,
                  padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                  onPressed: () async {
                    final choosed = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                            builder: (context) => InsuranceDetail(
                                planName: item.name,
                                message:
                                    ' بازه سنی از${item?.parameters[0]?.valueFrom}تا${item?.parameters[0]?.valueTo}سال',
                                benefits: item.benefits,
                                orderingId: item.parameters[0].orderingId)));
                    if (choosed) {
                      Navigator.of(context).pop(item);
                    }
                  },
                  child: Text(
                    'جزئیات',
                    style: TextStyle(color: colors.primaryColor),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
