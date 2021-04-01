import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:persian/persian.dart';

class TransactionFilterDialog extends StatefulWidget {
  TransactionFilterDialog({@required this.filterInfo});

  final FilterInfo filterInfo;

  @override
  _TransactionFilterDialogState createState() =>
      _TransactionFilterDialogState();
}

class _TransactionFilterDialogState extends State<TransactionFilterDialog> {
  final _dateStartController = TextEditingController();
  final _dateEndController = TextEditingController();
  FilterInfo _filterInfo;
  final _transactionTypeController =
      ExpandableController(initialExpanded: true);

  @override
  void initState() {
    _copyFilterInfo();
    _dateStartController.text = _filterInfo.startDay;
    _dateEndController.text = _filterInfo.endDay;
    super.initState();
  }

  void _copyFilterInfo() {
    _filterInfo = FilterInfo();
    _filterInfo.cardToCard = widget.filterInfo.cardToCard;
    _filterInfo.mobile = widget.filterInfo.mobile;
    _filterInfo.netPackage = widget.filterInfo.netPackage;
    _filterInfo.landPhone = widget.filterInfo.landPhone;
    _filterInfo.charge = widget.filterInfo.charge;
    _filterInfo.elcBill = widget.filterInfo.elcBill;
    _filterInfo.carFine = widget.filterInfo.carFine;
    _filterInfo.otherService = widget.filterInfo.otherService;
    _filterInfo.successful = widget.filterInfo.successful;
    _filterInfo.unSuccessful = widget.filterInfo.unSuccessful;
    _filterInfo.unknown = widget.filterInfo.unknown;
    _filterInfo.today = widget.filterInfo.today;
    _filterInfo.recentWeek = widget.filterInfo.recentWeek;
    _filterInfo.recentMonth = widget.filterInfo.recentMonth;
    _filterInfo.periodSelected = widget.filterInfo.periodSelected;
    _filterInfo.startDay = widget.filterInfo.startDay;
    _filterInfo.endDay = widget.filterInfo.endDay;
  }

  @override
  Widget build(BuildContext context) {
    final itemSelected = _getFilterCount();
    return HeadedPage(
      title: Text('تراکنش ها'),
      body: Split(
        child: Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colors.greyColor.shade600,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ExpandablePanel(
                    controller: _transactionTypeController,
                    header: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                      child: Text('نوع تراکنش'),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          Space(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'کارت به کارت',
                                    value: _filterInfo.cardToCard,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.cardToCard = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'موبایل',
                                    value: _filterInfo.mobile,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.mobile = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'بسته اینترنتی',
                                    value: _filterInfo.netPackage,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.netPackage = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'تلفن ثابت',
                                    value: _filterInfo.landPhone,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.landPhone = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'شارژ',
                                    value: _filterInfo.charge,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.charge = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'قبض برق',
                                    value: _filterInfo.elcBill,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.elcBill = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'خلافی',
                                    value: _filterInfo.carFine,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.carFine = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'قبوض خدماتی',
                                    value: _filterInfo.otherService,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.otherService = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Space(2),
                Container(
                  decoration: BoxDecoration(
                    color: colors.greyColor.shade600,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ExpandablePanel(
                    header: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                      child: Text('وضعیت تراکنش'),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          Space(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'موفق',
                                    value: _filterInfo.successful,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.successful = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'ناموفق',
                                    value: _filterInfo.unSuccessful,
                                    onChanged: (value) {
                                      setState(() {
                                        _filterInfo.unSuccessful = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Space(2),
                Container(
                  decoration: BoxDecoration(
                    color: colors.greyColor.shade600,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ExpandablePanel(
                    header: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 16),
                      child: Text('تاریخ تراکنش'),
                    ),
                    expanded: Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          Space(),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'امروز',
                                    value: _filterInfo.today,
                                    onChanged: (value) {
                                      setState(() {
                                        _setAllFalse();
                                        _filterInfo.today = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'هفته اخیر',
                                    value: _filterInfo.recentWeek,
                                    onChanged: (value) {
                                      setState(() {
                                        _setAllFalse();
                                        _filterInfo.recentWeek = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: LabeledCheckbox(
                                    label: 'ماه اخیر',
                                    value: _filterInfo.recentMonth,
                                    onChanged: (value) {
                                      setState(() {
                                        _setAllFalse();
                                        _filterInfo.recentMonth = value;
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                    child: LabeledCheckbox(
                                  label: 'بازه دلخواه',
                                  value: _filterInfo.periodSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      _setAllFalse();
                                      _filterInfo.periodSelected = value;
                                    });
                                  },
                                )),
                              ],
                            ),
                          ),
                          if (_filterInfo.periodSelected)
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: PersianDateTextFormField(
                                    controller: _dateStartController,
                                    labelText: 'از تاریخ',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: PersianDateTextFormField(
                                    controller: _dateEndController,
                                    labelText: 'تا تاریخ',
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        footer: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
          child: DismissibleRoundButton(
            onDismiss: itemSelected > 0
                ? () {
                    setState(() {
                      _filterInfo.unselectAll();
                    });
                  }
                : null,
            color: colors.accentColor,
            text: _getFilterCountText(itemSelected),
            buttonText: 'تایید',
            onPressed: () {
              _filterInfo.endDay = _dateEndController.text.toString();
              _filterInfo.startDay = _dateStartController.text.toString();
              if (_filterInfo.periodSelected) {
                if (_dateStartController.text.isEmpty ||
                    _dateEndController.text.isEmpty) {
                  ToastUtils.showCustomToast(
                    context,
                    'تاریخ را وارد نمایید',
                    Image.asset('assets/ic_error.png'),
                      'اخطار'
                  );
                  return;
                }
                if (int.tryParse(
                        _dateStartController.text.replaceAll('/', '')) >
                    int.tryParse(_dateEndController.text.replaceAll('/', ''))) {
                  ToastUtils.showCustomToast(
                      context,
                      'تاریخ را به درستی وارد نمایید',
                      Image.asset('assets/ic_error.png'),'خطا');
                  return;
                }
              }
              Navigator.of(context).pop(_filterInfo);
            },
          ),
        ),
      ),
    );
  }

  String _getFilterCountText(int count) {
    if (count == null || count == 0) {
      return 'بدون فیلتر';
    }

    return 'اعمال ${count} فیلتر'.withPersianNumbers();
  }

  void _setAllFalse() {
    _filterInfo.today = false;
    _filterInfo.recentWeek = false;
    _filterInfo.recentMonth = false;
    _filterInfo.periodSelected = false;
    _dateEndController.text = '';
    _dateStartController.text = '';
  }

  int _getFilterCount() {
    int count = 0;
    if (_filterInfo.cardToCard == true) {
      count++;
    }
    if (_filterInfo.mobile == true) {
      count++;
    }
    if (_filterInfo.netPackage == true) {
      count++;
    }
    if (_filterInfo.landPhone == true) {
      count++;
    }
    if (_filterInfo.charge == true) {
      count++;
    }
    if (_filterInfo.elcBill == true) {
      count++;
    }
    if (_filterInfo.carFine == true) {
      count++;
    }
    if (_filterInfo.otherService == true) {
      count++;
    }
    if (_filterInfo.successful == true) {
      count++;
    }
    if (_filterInfo.unSuccessful == true) {
      count++;
    }
    if (_filterInfo.unknown == true) {
      count++;
    }
    if (_filterInfo.today == true) {
      count++;
    }
    if (_filterInfo.recentWeek == true) {
      count++;
    }
    if (_filterInfo.recentMonth == true) {
      count++;
    }
    if (_filterInfo.periodSelected == true) {
      count++;
    }
    return count;
  }
}

class FilterInfo {
  bool cardToCard = false;
  bool mobile = false;
  bool netPackage = false;
  bool landPhone = false;
  bool charge = false;
  bool elcBill = false;
  bool carFine = false;
  bool otherService = false;
  bool successful = false;
  bool unSuccessful = false;
  bool unknown = false;
  bool today = false;
  bool recentWeek = false;
  bool recentMonth = false;
  bool periodSelected = false;
  String startDay = '';
  String endDay = '';

  void unselectAll() {
    cardToCard = false;
    mobile = false;
    netPackage = false;
    landPhone = false;
    charge = false;
    elcBill = false;
    carFine = false;
    otherService = false;
    successful = false;
    unSuccessful = false;
    unknown = false;
    today = false;
    recentWeek = false;
    recentMonth = false;
    periodSelected = false;
    startDay = '';
    endDay = '';
  }
}
