import 'package:flutter/material.dart';
import 'package:novinpay/card_info.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/models/insurance.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/pages/add_insured_page.dart';
import 'package:novinpay/pages/insurer_information_page.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/confirm_button.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/insurance_titles.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:persian/persian.dart';

class InsuredListPage extends StatefulWidget {
  InsuredListPage({@required this.orderCreator});

  final OrderCreator orderCreator;

  @override
  State<StatefulWidget> createState() => _InsuredListPageState();
}

class _InsuredListPageState extends State<InsuredListPage> with AskYesNoMixin {
  final List<InsuredModel> _insuredList = [];
  bool _showConfirmButton = true;
  final List<String> _warnings = [];
  bool _showAddMySellf = true;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> canPop() async {
    final ableTOPop = await askYesNo(
      title: null,
      content: Text(
        'با بازگشت از این قسمت تمامی اطلاعات شما پاک خواهد شد آیا میخواهید خارج شوید؟',
      ),
    );
    if (ableTOPop ?? false) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildMessage(String text) => Center(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 24, end: 24),
            child: Text(
              text ?? '',
              style: colors
                  .regularStyle(context)
                  .copyWith(color: colors.greyColor.shade900),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        );

    Widget _buildInsuredList() {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _insuredList.length,
        itemBuilder: (context, index) {
          _warnings.add(null);
          return item(
            _insuredList[index],
            index,
            _onEditItem,
          );
        },
      );
    }

    Widget _buildChild() {
      _showConfirmButton = true;
      if (_insuredList == null || _insuredList.isEmpty) {
        _showConfirmButton = false;
        return _buildMessage('موردی برای نمایش یافت نشد');
      }

      return _buildInsuredList();
    }

    Widget _buildFooter() {
      return Column(
        children: [
          if (_showConfirmButton)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
              child: ConfirmButton(
                child: CustomText(
                  'صدور',
                  textAlign: TextAlign.center,
                ),
                onPressed: _onConfirm,
              ),
            ),
        ],
      );
    }

    return HeadedPage(
      title: Text('لیست بیمه شونده ها'),
      actions: [
        IconButton(
          icon: Icon(
            Icons.add,
            color: colors.primaryColor,
          ),
          onPressed: _addNewInsured,
        ),
      ],
      body: WillPopScope(
        onWillPop: () => canPop(),
        child: Split(
          child: Expanded(
            child: _buildChild(),
          ),
          footer: _buildFooter(),
        ),
      ),
    );
  }

  void _onConfirm() async {
    for (int i = 0; i < _insuredList.length; i++) {
      if (_insuredList[i].orderingId == null) {
        setState(() {
          _warnings[i] = 'لطفا طرح بیمه مورد نظر خود را انتخاب نمایید';
        });
      }
    }
    final anyUnSelected =
        _insuredList.any((element) => element.orderingId == null);
    if (anyUnSelected) {
      return;
    }
    final data = await Loading.run(context,
        nh.insuranceAgency.CreateOrder(widget.orderCreator, _insuredList));

    if (!showError(context, data)) {
      return;
    }

    final payInfo = await showPaymentBottomSheet(
        transactionType: TransactionType.buy,
        acceptorName: '',
        context: context,
        title: Text('خرید بیمه'),
        amount: data?.content?.totalPrice,
        acceptorId: '18');

    if (payInfo == null) {
      return;
    }

    insurancePayment(
        payInfo.cardInfo, data.content.paymentToken, data.content.totalPrice);
  }

  void insurancePayment(CardInfo cardInfo, String token, int amount) async {
    final data = await Loading.run(context,
        nh.insuranceAgency.InsuranceAgencyPayment(cardInfo, amount, token));

    if (!showConnectionError(context, data)) {
      return;
    }

    if (data.content.status != true) {
      await showFailedTransaction(context, data.content.description,
          data.content.stan, data.content.rrn, 'خرید بیمه', amount);
      return;
    }

    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
            title: 'خرید بیمه',
            cardNumber: cardInfo.pan,
            stan: data.content.stan,
            rrn: data.content.rrn,
            description:
                'بیمه انفرادی سامان توسط ${widget?.orderCreator?.name ?? ''} ${widget?.orderCreator?.lastName ?? ''} پرداخت شد',
            amount: amount,
            isShaparak: true),
      ),
    );
  }

  void _addNewInsured() async {
    final forMe = await showDialog<SelectedItem>(
      context: context,
      builder: (context) => AlertDialog(
        title: CustomText(
          'افزودن بیمه شونده',
          textAlign: TextAlign.center,
        ),
        content: CustomText('درخواست افزودن بیمه نامه برای چه کسی را دارید؟'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            onPressed: _showAddMySellf
                ? () {
                    Navigator.of(context).pop(SelectedItem.Me);
                  }
                : null,
            child: Text('خودم'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(SelectedItem.Other);
            },
            child: Text('دیگران'),
          ),
        ],
      ),
    );
    if (forMe == SelectedItem.Me) {
      _showAddMySellf = false;
      final my = widget.orderCreator;
      setState(() {
        _insuredList.add(InsuredModel(
          name: my.name,
          birthDate: my.birthDate,
          nationalCode: my.nationalCode,
          lastName: my.lastName,
          mobile: my.mobile,
          phone: my.phone,
          idNumber: my.idNumber,
        ));
      });
      return;
    }
    if (forMe == SelectedItem.Other) {
      final insuredModel = await Navigator.of(context).push<InsuredModel>(
        MaterialPageRoute(
          builder: (context) => AddInsuredPage(
            type: PageType.Add,
            insuredModel: InsuredModel(),
          ),
        ),
      );

      if (insuredModel != null) {
        setState(() {
          _insuredList.add(insuredModel);
        });
      }
    }
  }

  void _onItemRemoved(int index) async {
    final result = await askYesNo(
      title: Text('حذف بیمه شونده'),
      content: Text(
        'آیا ${_insuredList[index].name} ${_insuredList[index].lastName} حذف شود؟'
            .withPersianNumbers(),
      ),
    );

    if (result != true) {
      return;
    }
    setState(() {
      _insuredList.removeAt(index);
      _warnings.removeAt(index);
    });
    if (!_showAddMySellf) {
      _showAddMySellf = true;
    }
  }

  void _onEditItem(EditItem editItem) {
    InsuredModel oldItem = _insuredList[editItem.index];
    InsuredModel newItem = editItem.insuredModel;
    setState(() {
      _copyInsuredModel(oldItem, newItem);
    });
  }

  void _copyInsuredModel(InsuredModel oldItem, InsuredModel newItem) {
    oldItem.name = newItem.name;
    oldItem.lastName = newItem.lastName;
    oldItem.mobile = newItem.mobile;
    oldItem.nationalCode = newItem.nationalCode;
    oldItem.phone = newItem.phone;
    if (oldItem.birthDate != newItem.birthDate) {
      if (_isServiceSelected(oldItem)) {
        if (!_isAgeInRange(newItem, oldItem)) {
          oldItem.orderingId = null;
          oldItem.InsuranceName = null;
          oldItem.valueFrom = null;
          oldItem.valueTo = null;
        }
      }
    }
    oldItem.birthDate = newItem.birthDate;
    oldItem.idNumber = newItem.idNumber;
  }

  bool _isAgeInRange(InsuredModel newItem, InsuredModel oldItem) {
    int age = (DateTime.now().toPersian().year) -
        int.tryParse(newItem.birthDate.substring(0, 4));
    return age < int.tryParse(oldItem.valueTo) &&
        age > int.tryParse(oldItem.valueFrom);
  }

  bool _isServiceSelected(InsuredModel oldItem) {
    if (oldItem.orderingId != null &&
        oldItem.valueFrom != null &&
        oldItem.valueTo != null) {
      return true;
    }
    return false;
  }

  Widget item(
      InsuredModel insuredModel, int index, ValueChanged<EditItem> onChanged) {
    void _onItemEdit(
        InsuredModel model, int index, BuildContext context) async {
      final insuredModel =
          await Navigator.of(context).push<InsuredModel>(MaterialPageRoute(
        builder: (context) => AddInsuredPage(
          type: PageType.Edit,
          insuredModel: model,
        ),
      ));
      if (insuredModel != null) {
        onChanged(EditItem(index: index, insuredModel: insuredModel));
      }
    }

    void _chooseInsuranceModel(InsuredModel model, int index) async {
      int age = (DateTime.now().toPersian().year) -
          int.tryParse(model.birthDate.substring(0, 4));
      final item = await Navigator.of(context).push<PlanItem>(
          MaterialPageRoute(builder: (context) => InsuranceTitles(age: age)));
      if (item != null && item.parameters.isNotEmpty) {
        setState(() {
          model.InsuranceName = item.name;
          model.orderingId = item.parameters[0].orderingId;
          model.valueFrom = item.parameters[0].valueFrom;
          model.valueTo = item.parameters[0].valueTo;
          _warnings[index] = null;
        });
      }
    }

    final _expanded = Padding(
      padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
      child: Column(children: [
        if (insuredModel.mobile != null && insuredModel.mobile.isNotEmpty)
          DualListTile(
              start: Text('موبایل'),
              end: Text(insuredModel?.mobile?.withPersianNumbers() ?? '')),
        if (insuredModel.nationalCode != null &&
            insuredModel.nationalCode.isNotEmpty)
          DualListTile(
              start: Text(strings.label_national_number),
              end:
                  Text(insuredModel?.nationalCode?.withPersianNumbers() ?? '')),
        if (insuredModel.idNumber != null)
          DualListTile(
              start: Text('شماره شناسنامه'),
              end: Text(
                  insuredModel?.idNumber?.toString()?.withPersianNumbers() ??
                      '')),
        if (insuredModel.birthDate != null && insuredModel.birthDate.isNotEmpty)
          DualListTile(
              start: Text('تاریخ تولد'),
              end: Text(insuredModel?.birthDate?.withPersianNumbers() ?? '')),
        if (insuredModel.phone != null && insuredModel.phone.isNotEmpty)
          DualListTile(
            start: Text('تلفن ثابت'),
            end: Text(insuredModel?.phone?.withPersianNumbers() ?? ''),
          ),
        if (insuredModel.InsuranceName != null)
          DualListTile(
            start: RaisedButton(
              color: colors.accentColor,
              padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              onPressed: () => _chooseInsuranceModel(insuredModel, index),
              child: Text(
                'تغییر نوع طرح',
                style: TextStyle(color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              elevation: 0,
            ),
            end: Container(),
          )
      ]),
    );
    final _header =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (insuredModel.name != null &&
          insuredModel.name.isNotEmpty &&
          insuredModel.lastName != null &&
          insuredModel.lastName.isNotEmpty)
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16.0, end: 16.0),
          child: DualListTile(
            start: Row(
              children: [
                Text(
                  insuredModel?.name?.withPersianNumbers() ?? '',
                ),
                Space(),
                Text(insuredModel?.lastName?.withPersianNumbers() ?? ''),
              ],
            ),
            end: Row(
              children: [
                InkWell(
                  onTap: () => _onItemEdit(insuredModel, index, context),
                  child: Icon(
                    Icons.edit_outlined,
                    color: colors.ternaryColor,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                InkWell(
                  onTap: () => _onItemRemoved(index),
                  child: Icon(Icons.delete_outline, color: colors.red),
                ),
              ],
            ),
          ),
        ),
      Divider(),
      Padding(
        padding: const EdgeInsetsDirectional.only(
            start: 16.0, end: 16.0, top: 8.0, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (insuredModel?.InsuranceName == null)
                ? RaisedButton(
                    color: colors.accentColor,
                    padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
                    onPressed: () => _chooseInsuranceModel(insuredModel, index),
                    child: Text(
                      'انتخاب نوع طرح',
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 0,
                  )
                : DualListTile(
                    start: Text('نام طرح'),
                    end: Text(
                      insuredModel?.InsuranceName?.withPersianNumbers() ?? '',
                    ),
                  ),
            if (_warnings[index] != null)
              Text(
                _warnings[index],
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
      ),
    ]);
    return Container(
        decoration: BoxDecoration(
          color: colors.primaryColor.shade50,
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.fromLTRB(24, 4, 24, 4),
        padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
        child: ExpandablePanel(
          hasIcon: false,
          header: Container(color: colors.primaryColor.shade50, child: _header),
          expanded: _expanded,
        ));
  }
}

class EditItem {
  EditItem({this.index, this.insuredModel});

  int index;
  InsuredModel insuredModel;
}

class InsuredModel {
  InsuredModel({
    this.name,
    this.lastName,
    this.mobile,
    this.idNumber,
    this.nationalCode,
    this.birthDate,
    this.phone,
    this.orderingId,
  });

  String name;
  String lastName;
  String mobile;
  String idNumber;
  String nationalCode;
  String birthDate;
  String phone;
  int orderingId;
  String InsuranceName;
  String valueFrom;
  String valueTo;

  Map<String, Object> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['lastName'] = lastName;
    data['mobile'] = mobile;
    data['idNumber'] = idNumber;
    data['nationalCode'] = nationalCode;
    data['birthDate'] = birthDate;
    data['phone'] = phone;
    data['OrderingID'] = orderingId;
    return data;
  }
}

enum SelectedItem { Me, Other }
enum PageType { Edit, Add }
