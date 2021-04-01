import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/bill_payment.dart';
import 'package:novinpay/mixins/mru_selection_mixin.dart';
import 'package:novinpay/mixins/vehicle_selection_mixin.dart';
import 'package:novinpay/models/can_pay.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/plate.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class CarFinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CarFinePageState();
}

class _CarFinePageState extends State<CarFinePage>
    with MruSelectionMixin, VehicleSelectionMixin {
  final _formKey = GlobalKey<FormState>();
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _vehicleIdController = TextEditingController();
  Response<RahvarInquiryResponse> _data;
  bool _disable = false;
  bool _showInquiryButton = true;

  void _showVehicleSelectionDialog() async {
    final data = await showVehicleSelectionDialog();
    if (data == null) {
      return;
    }

    _vehicleIdController.text = data.value;
    _refreshKey.currentState.show();
  }

  Future<void> _refresh() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _showInquiryButton = false;
      _disable = true;
    });

    final vehicleId = _vehicleIdController.text;
    final data = await nh.canPay.rahvarInquiry(code: vehicleId);

    if (mounted) {
      setState(() {
        _disable = false;
      });
    }

    if (!data.hasErrors()) {
      nh.mru.addMru(
        type: MruType.vehicleId,
        title: data.content.data.number
            ?.withPersianLetters()
            ?.withPersianNumbers(),
        value: vehicleId,
      );
    }

    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  Widget _buildMessage(String message) => Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 48.0, left: 48.0),
          child: CustomText(
            message ?? '',
            textAlign: TextAlign.center,
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
          ),
        ),
      );

  Widget _buildWelcomeMessage() => _buildMessage(
      'برای مشاهده خلافی شماره بارکد کارت ماشین خود را وارد کنید');

  @override
  Widget build(BuildContext context) {
    Widget buildBillList() => ListView.builder(
          shrinkWrap: true,
          itemCount: _data.content.data.bills.length,
          itemBuilder: (context, index) {
            final item = _data.content.data.bills[index];
            return CarFineCard(item: item);
          },
        );

    Widget buildChild() {
      _showInquiryButton = true;
      if (_data == null) {
        return _buildWelcomeMessage();
      }

      if (_data.isError) {
        return _buildMessage(strings.connectionError);
      }

      if (_data.content.status != true) {
        return _buildMessage(_data.content.description);
      }

      if (_data.content.data == null || _data.content.data.bills.isEmpty) {
        return _buildMessage(_data.content.description);
      }

      _showInquiryButton = false;

      final plaque = _data.content.plaque;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
                top: 24.0, start: 24.0, end: 24.0),
            child: PlateNumber(
              part1: plaque.part01,
              part2: plaque.part02,
              part3: plaque.part03,
              part4: plaque.irNumber,
            ),
          ),
          Padding(
            padding:
                EdgeInsetsDirectional.only(top: 24.0, start: 32.0, end: 32.0),
            child: Text(
              'مجموع خلافی: ${toRials(_data.content.data.amount)}',
              style: colors
                  .boldStyle(context)
                  .copyWith(color: colors.ternaryColor),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 24.0),
            child: buildBillList(),
          ))
        ],
      );
    }

    final header = Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
                start: 24.0, end: 24.0, top: 8.0),
            child: VehicleIdTextFormField(
              controller: _vehicleIdController,
              showSelectionDialog: _showVehicleSelectionDialog,
              onChanged: (value) {
                setState(() {
                  _data = null;
                  _showInquiryButton = true;
                });
              },
            ),
          ),
        ],
      ),
    );

    final footer = Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 24.0, end: 24.0, bottom: 24.0),
      child: ConfirmButton(
        child: CustomText(
          strings.action_inquiry,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        onPressed: _disable ? null : _submit,
        color: colors.ternaryColor,
      ),
    );

    return HeadedPage(
      title: Text('خلافی خودرو'),
      actions: [
        FlatButton(
          onPressed: isSecureEnvironment ? _getBarcode : null,
          child: Row(
            children: [
              Text(
                'اسکن بارکد',
                style: colors
                    .boldStyle(context)
                    .copyWith(color: colors.ternaryColor),
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.qr_code_outlined,
                color: colors.ternaryColor,
              ),
            ],
          ),
        )
      ],
      body: Split(
        header: header,
        child: Expanded(
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: _refresh,
            child: buildChild(),
          ),
        ),
        footer: _showInquiryButton ? footer : Container(),
      ),
    );
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _refreshKey.currentState.show();
  }

  void _getBarcode() async {
    final barcode = await showBarcodeScanDialog(context);
    _vehicleIdController.text = barcode?.code;
    _refreshKey.currentState.show();
  }
}

class CarFineCard extends StatefulWidget {
  CarFineCard({@required this.item});

  final RahvarBillData item;

  @override
  State<StatefulWidget> createState() => CarFineCardState();
}

class CarFineCardState extends State<CarFineCard> with BillPaymentMixin {
  //bool _isExpanded = false;

  Iterable<Widget> _buildList(bool expand) sync* {
    final item = widget.item;

    yield Padding(
      padding:
          const EdgeInsetsDirectional.only(top: 8.0, start: 16.0, end: 16.0),
      child: DualListTile(
        start: Text(
          '$lrm${item.datePersian.substring(0, 10)}'.withPersianNumbers() ?? '',
          style: colors.bodyStyle(context),
        ),
        end: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(4.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(item.delivery?.withPersianLetters() ?? '',
                style: colors.boldStyle(context)),
          ),
        ),
      ),
    );
    // if (expand) {
    //   yield DualListTile(
    //     start: Text('محل جریمه'),
    //     end: Text('${item.location}، ${item.city}'),
    //   );
    // }

    yield Padding(
      padding:
          const EdgeInsetsDirectional.only(top: 8.0, start: 24.0, end: 24.0),
      child: Text(
          item.type?.trim()?.withPersianLetters()?.withPersianNumbers() ?? '',
          style: colors.boldStyle(context)),
    );

    yield Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 16.0, start: 24.0, end: 24.0, bottom: 16.0),
      child: Text(
          '${item.location}، ${item.city}'
              .withPersianLetters()
              .withPersianNumbers(),
          style: colors.bodyStyle(context)),
    );

    yield Container(
      color: colors.greyColor.shade800,
      height: 1,
    );

    yield Padding(
      padding: const EdgeInsetsDirectional.only(
          top: 8.0, start: 16.0, end: 16.0, bottom: 8.0),
      child: DualListTile(
          start: Text(
            toRials(widget.item.billInfo.amount),
            style: colors.boldStyle(context),
          ),
          end: Container()),
    );
  }

  Widget _build(bool expand) {
    final items = _buildList(expand).toList();
    //final bill = widget.item.billInfo;

    // final canPay = bill != null &&
    //     bill.billId != null &&
    //     bill.billId.isNotEmpty &&
    //     bill.paymentId != null &&
    //     bill.paymentId.isNotEmpty;

    return Padding(
      padding: EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.greyColor.shade600,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...items,
            // Space(),
            // Divider(),
            // ButtonBar(
            //   children: [
            //     // TextButton(
            //     //     onPressed: () {
            //     //       setState(() {
            //     //         _isExpanded = !_isExpanded;
            //     //       });
            //     //     },
            //     //     child: Text('جزییات')),
            //     TextButton(
            //       onPressed: canPay
            //           ? () {
            //               payBill(
            //                   title: 'پرداخت خلافی',
            //                   billInfo: widget.item.billInfo,
            //                   acceptorName: 'جرایم رانندگی',
            //                   acceptorId: '9');
            //             }
            //           : null,
            //       child: Text('پرداخت'),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return AnimatedCrossFade(
    //   crossFadeState:
    //       _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    //   duration: const Duration(milliseconds: 500),
    //   firstChild: _build(false),
    //   secondChild: _build(true),
    // );

    return _build(true);
  }
}
