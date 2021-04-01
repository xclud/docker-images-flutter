import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/dialogs/charge_wallet_dialog.dart';
import 'package:novinpay/dialogs/wallet_to_iban_dialog.dart';
import 'package:novinpay/models/shaparak.dart';
import 'package:novinpay/models/wallet.dart';
import 'package:novinpay/pages/overview_page.dart';
import 'package:novinpay/pages/wallet_group_management_page.dart';
import 'package:novinpay/pages/wallet_transfer_page.dart';
import 'package:novinpay/repository/network_helper.dart';
import 'package:novinpay/repository/response.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/general/custom_text.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';

class WalletHomePage extends StatefulWidget {
  @override
  _WalletHomePageState createState() => _WalletHomePageState();
}

class _WalletHomePageState extends State<WalletHomePage> {
  Response<WalletGetBalanceResponse> _data;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HeadedPage(
      title: Text('کیف پول'),
      actions: [
        InkWell(
          onTap: _onManageGroup,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                Text(
                  'مدیریت گروه ها',
                  style: TextStyle(
                      fontSize: 14,
                      color: colors.ternaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.contacts,
                  color: colors.ternaryColor,
                  size: 24,
                ),
              ],
            ),
          ),
        )
      ],
      body: Split(
        child: Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 24.0, end: 24.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: colors.ternaryColor,
                        borderRadius: BorderRadius.circular(16.0)),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Opacity(
                            opacity: 0.3,
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 150,
                              color: Colors.white,
                            ),
                          ),
                          left: -30,
                          bottom: -40,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 24.0,
                                  left: 24.0,
                                  top: 16.0,
                                  bottom: 12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('اعتبار شما',
                                      style:
                                          colors.regularStyle(context).copyWith(
                                                color: colors.greyColor.shade50,
                                              )),
                                  Space(),
                                  Text(
                                    toRials(
                                        _data?.content?.balance?.toInt() ?? 0),
                                    style: colors.boldStyle(context).copyWith(
                                        color: colors.greyColor.shade50,
                                        fontSize: 16.0),
                                  ),
                                  Space(),
                                  TextButton.icon(
                                    onPressed: _onRequestMoney,
                                    icon: Icon(
                                      Icons.arrow_downward,
                                      color: colors.primaryColor,
                                      size: 20,
                                    ),
                                    label: Text('درخواست دریافت وجه',
                                        style: colors
                                            .regularStyle(context)
                                            .copyWith(
                                                color: colors.primaryColor)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Space(3),
                  TextButton.icon(
                    onPressed: _onChargeWallet,
                    icon: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                              color: colors.primaryColor, width: 2.0)),
                      child: Icon(
                        Icons.add,
                        color: colors.primaryColor,
                        size: 20.0,
                      ),
                    ),
                    label: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: colors.primaryColor, // Text colour here
                        width: 1.0, // Underline width
                      ))),
                      child: Text('افزایش اعتبار',
                          textAlign: TextAlign.center,
                          style: colors
                              .boldStyle(context)
                              .copyWith(color: colors.primaryColor)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        footer: Padding(
          padding:
              EdgeInsetsDirectional.only(bottom: 24.0, end: 24, start: 24.0),
          child: ConfirmButton(
            child: CustomText(
              'انتقال اعتبار',
              textAlign: TextAlign.center,
              style: colors
                  .tabStyle(context)
                  .copyWith(color: colors.greyColor.shade50),
            ),
            onPressed: _onWalletTransfer,
          ),
        ),
      ),
    );
  }

  void _getData([bool showLoading = true]) async {
    setState(() {
      _data = null;
    });

    final task = nh.wallet.getBalance();

    if (showLoading) {
      _data = await Loading.run(context, task);
    } else {
      _data = await task;
    }

    setState(() {});
  }

  void _onManageGroup() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletGroupManagement(),
      ),
    );
  }

  void _onRequestMoney() async {
    await showCustomBottomSheet(
      context: context,
      child: WalletToIbanDialog(),
    );
  }

  void _onChargeWallet() async {
    final amount = await showCustomBottomSheet<int>(
        context: context, child: ChargeWalletDialog());

    if (amount == null || amount <= 0) {
      return;
    }

    final payInfo = await showPaymentBottomSheet(
        context: context,
        title: Text('شارژ کیف پول'),
        amount: amount,
        transactionType: TransactionType.buy,
        acceptorName: '',
        acceptorId: '19',
        showWallet: false);

    if (payInfo == null) {
      return;
    }

    final response = await Loading.run(
        context,
        nh.wallet.eWalletCharge(
          cardInfo: payInfo.cardInfo,
          amount: amount,
        ));

    if (!showConnectionError(context, response)) {
      return;
    }

    if (response.content.status != true) {
      await showFailedTransaction(context, response.content.description,
          response.content.stan, response.content.rrn, 'شارژ کیف پول', amount);
      return;
    }
    _getData(false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OverViewPage(
          title: 'شارژ کیف پول',
          cardNumber: payInfo.cardInfo.pan,
          stan: response.content.stan,
          rrn: response.content.rrn,
          topupPin: null,
          description: 'شارژ کیف پول',
          amount: amount,
          isShaparak: true,
        ),
      ),
    );
  }

  void _onWalletTransfer() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WalletTransferPage(),
      ),
    );
    _getData(false);
  }
}
