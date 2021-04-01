import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/mru.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/services/platform_helper.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/storage_management/action_type.dart';
import 'package:novinpay/widgets/storage_management/add_car_fine_dialog.dart';
import 'package:persian/persian.dart';

class CarFineManagement extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CarFineManagementState();
}

class _CarFineManagementState extends State<CarFineManagement> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  Response<MruListResponse> _data;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshKey.currentState.show();
    });
  }

  Future<void> _refresh() async {
    final data = await nh.mru.mruList(mruType: MruType.vehicleId);

    if (mounted) {
      setState(() {
        _data = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildWelcomeMessage() => Center(
          child: Text(
            strings.please_wait,
            textAlign: TextAlign.center,
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
          ),
        );

    Widget _buildNoCarFine(String error) => Center(
          child: Text(
            error,
            style: colors
                .regularStyle(context)
                .copyWith(color: colors.greyColor.shade900),
          ),
        );

    Widget _buildBillList() => ListView.builder(
          shrinkWrap: true,
          itemCount: _data.content.mruList.length,
          itemBuilder: (context, index) {
            final item = _data.content.mruList[index];
            return CarFineCard(
                item: item,
                onPageRefresh: () {
                  _refreshKey.currentState.show();
                });
          },
        );

    Widget _buildChild() {
      if (_data == null) {
        return _buildWelcomeMessage();
      }

      if (_data.isError) {
        return _buildNoCarFine('خطایی در دریافت اطلاعات رخ داده است');
      }

      if (_data.content.status != true) {
        return _buildNoCarFine(_data.content.description);
      }

      if (_data.content.mruList == null || _data.content.mruList.isEmpty) {
        return _buildNoCarFine(_data.content.description);
      }

      return _buildBillList();
    }

    final _footer = ConfirmButton(
        onPressed: _showAddCarFineDialog,
        child: CustomText(
          'افزودن',
          textAlign: TextAlign.center,
        ));

    return HeadedPage(
      title: Text('پلاک ها'),
      body: Container(
        margin: EdgeInsetsDirectional.fromSTEB(24, 8, 24, 24),
        child: Split(
          child: Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: _refresh,
              child: Container(
                  margin: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                  child: _buildChild()),
            ),
          ),
          footer: _footer,
        ),
      ),
    );
  }

  void _getBarcode() async {
    final barcode = await showBarcodeScanDialog(context);
    _controller.text = barcode?.code;
  }

  void _showAddCarFineDialog() async {
    final result = await showCustomBottomSheet<bool>(
      context: context,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 4,
            ),
            Text('افزودن بارکد کارت ماشین'),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: FlatButton(
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
              ),
            ),
          ],
        ),
        color: colors.greyColor.shade50,
      ),
      child: AddCarFineDialog(
        controller: _controller,
        scrollController: ScrollController(),
        type: ActionType.Add,
      ),
    );
    if (result != true) {
      return;
    }
    _refreshKey.currentState.show();
  }
}

class CarFineCard extends StatefulWidget {
  CarFineCard({@required this.item, @required this.onPageRefresh});

  final MruItem item;
  final VoidCallback onPageRefresh;

  @override
  State<StatefulWidget> createState() => _CarFineCardState();
}

class _CarFineCardState extends State<CarFineCard> with AskYesNoMixin {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool _showPlate = false;
    String _plate1;
    String _p1part1;
    String _p1part2;
    String _p1part3;
    String _plate2;
    String _plate3;
    if (widget.item.title.isNotEmpty && widget.item.title != null) {
      _showPlate = true;
      final plate = widget.item.title;
      _plate1 = plate.substring(14, 20);
      _p1part1 = _plate1.substring(0, 3).withPersianNumbers();
      _p1part2 = _plate1.substring(3, 4).withPersianNumbers();
      _p1part3 = _plate1.substring(4, 6).withPersianNumbers();
      _plate2 = plate.substring(7, 9).withPersianNumbers();
      _plate3 = plate.substring(1, 6).withPersianNumbers();
    }
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: colors.greyColor.shade600,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: DualListTile(
                start: Expanded(
                    child: CustomText(
                  'شماره بارکد کارت ماشین',
                  style: colors.boldStyle(context),
                )),
                end: Row(
                  children: [
                    GestureDetector(
                      onTap: _showEditCarFineDialog,
                      child:
                          Icon(Icons.edit_outlined, color: colors.ternaryColor),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () => _showRemoveCarFineDialog(widget.item.value),
                      child: Icon(
                        Icons.delete_outline,
                        color: colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: DualListTile(
                start: Text(
                  widget.item.value.withPersianNumbers(),
                  style: colors.boldStyle(context),
                ),
                end: (_showPlate)
                    ? Container(
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0, bottom: 0.0, right: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    _plate3,
                                    style: colors.boldStyle(context),
                                  ),
                                  Text(
                                    _plate2,
                                    style: colors.boldStyle(context),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              width: 1,
                              height: 40,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    _p1part1,
                                    style: colors.boldStyle(context),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    _p1part2,
                                    style: colors.boldStyle(context),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    _p1part3,
                                    style: colors.boldStyle(context),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveCarFineDialog(String value) async {
    final result = await askYesNo(
      title: Text('حذف شماره بارکد کارت ماشین'),
      content: Text(
        'از حذف شماره بارکد کارت ماشین $lrm$value مطمئنید؟'
            .withPersianNumbers(),
      ),
    );

    if (result != true) {
      return;
    }
    final data =
        await Loading.run(context, nh.mru.deleteMru(id: widget.item.id));

    if (!showError(context, data)) {
      return;
    }
    widget.onPageRefresh();
  }

  void _getBarcode() async {
    final barcode = await showBarcodeScanDialog(context);
    _controller.text = barcode?.code;
  }

  void _showEditCarFineDialog() async {
    final bool result = await showCustomBottomSheet<bool>(
      context: context,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 4,
            ),
            Text('ویرایش بارکد کارت ماشین'),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: FlatButton(
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
              ),
            ),
          ],
        ),
        color: colors.greyColor.shade50,
      ),
      child: AddCarFineDialog(
        controller: _controller,
        scrollController: ScrollController(),
        type: ActionType.Update,
        mruItem: widget.item,
      ),
    );
    if (result != true) {
      return;
    }
    widget.onPageRefresh();
  }
}
