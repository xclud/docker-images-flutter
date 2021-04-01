import 'package:flutter/material.dart';
import 'package:novinpay/Item.dart';
import 'package:novinpay/app_analytics.dart' as analytics;
import 'package:novinpay/app_state.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/config.dart';
import 'package:novinpay/mixins/ask_yes_no.dart';
import 'package:novinpay/mixins/disable_manager_mixin.dart';
import 'package:novinpay/models/profile.dart';
import 'package:novinpay/novin_icons.dart';
import 'package:novinpay/pages/credit_card_page.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/strings.dart' as strings;
import 'package:novinpay/sun.dart';
import 'package:novinpay/toast_utils.dart';
import 'package:novinpay/utils.dart';
import 'package:novinpay/widgets/advertise.dart';
import 'package:novinpay/widgets/credit_card/bills.dart';
import 'package:novinpay/widgets/credit_card/card_dark.dart';
import 'package:novinpay/widgets/credit_card/choose_payment_type.dart';
import 'package:novinpay/widgets/credit_card/choose_statement_type.dart';
import 'package:novinpay/widgets/credit_card/transaction_history_page.dart';
import 'package:novinpay/widgets/general/general.dart';
import 'package:novinpay/widgets/loading.dart';
import 'package:novinpay/widgets/profile_image.dart';
import 'package:novinpay/widgets/set_password_dialog.dart';
import 'package:novinpay/widgets/text_form_fields.dart';
import 'package:novinpay/widgets/wallet.dart';
import 'package:persian/persian.dart';

class HomePage extends StatefulWidget {
  HomePage({this.shouldAskForPassword, this.shouldAskForUpdate, this.link});

  final bool shouldAskForPassword;
  final bool shouldAskForUpdate;
  final String link;

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with AskYesNoMixin {
  int _selectedPage = 1;
  String _mobileNumber;

  Future<void> showPasswordDialog() async {
    final shouldSetPassWord = await askYesNo(
        title: Text(
          'آیا میخواهید با رمز عبور وارد شوید؟',
          textAlign: TextAlign.center,
          style: colors.regularStyle(context),
        ),
        barrierDismissible: false);

    if (shouldSetPassWord) {
      final set = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: SetPasswordDialog(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(
            'رمز ورود را وارد کنید',
            textAlign: TextAlign.center,
            style: colors.regularStyle(context),
          ),
        ),
      );
      if (set ?? false) {
        Navigator.of(context).pushReplacementNamed(routes.home);
      }
    } else {
      appState.setDisableDialog(true);
      await nh.profile.activeLogin(password: null, loginType: LoginType.none);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _mobileNumber = await appState.getPhoneNumber();

      final args =
          ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

      if (args != null && args.containsKey('selectedPage')) {
        final int page = args['selectedPage'];

        if (page != null && page >= 0 && page <= 4) {
          setState(() {
            _selectedPage = page;
          });
        }
      }

      setState(() {});
      final shouldDisable = await appState.getDisableDialog() ?? false;

      if (widget.shouldAskForPassword != null &&
          widget.shouldAskForPassword &&
          !shouldDisable) {
        showPasswordDialog();
      }
      _getProfileData();
    });
  }

  Future<void> _getProfileData() async {
    final data = await nh.profile.getUserProfile();

    if (data.hasErrors()) {
      return;
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.greyColor.shade50,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            label: 'کارت اعتباری',
            icon: Icon(SunIcons.credit_card),
          ),
          BottomNavigationBarItem(
            label: 'خدمات',
            icon: Icon(SunIcons.home),
          ),
          BottomNavigationBarItem(
            label: 'بانک',
            icon: Icon(SunIcons.bank_logo),
          ),
        ],
        currentIndex: _selectedPage,
        onTap: (index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: colors.primaryColor),
        backgroundColor: colors.greyColor.shade50,
        title: Text(
          'سوپر اپ نوین',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_selectedPage == 0 && appState.creditCardLogin)
            TextButton(
              onPressed: () {
                setState(() {
                  appState.setCreditCardLoginInfo(false, null);
                  appState.nationalCode = null;
                  appState.creditCardLogin = false;
                });
              },
              child: Text('تغییر کارت   '),
            ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'باز کردن منو',
            );
          },
        ),
      ),
      body: _buildTabPage(_selectedPage),
      drawer: IconTheme(
        data: IconThemeData(size: 36),
        child: Drawer(
          child: Container(
            color: colors.greyColor.shade50,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      Space(6),
                      InkWell(
                        child: Container(
                          child: Row(
                            children: [
                              _mobileNumber == null
                                  ? Icon(SunIcons.user_profile,
                                      size: 48,
                                      color: colors.primaryColor.shade400)
                                  : ProfileImage(false),
                              SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Column(
                                  children: [
                                    Text(
                                      (appState.profileData.fullName != '' &&
                                              appState.profileData.fullName !=
                                                  null)
                                          ? appState.profileData.fullName
                                          : 'نام کاربری',
                                      style: colors.boldStyle(context).copyWith(
                                            color: colors.primaryColor,
                                          ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      _mobileNumber?.withPersianNumbers() ?? '',
                                      style: colors.boldStyle(context).copyWith(
                                            color: colors.primaryColor,
                                          ),
                                    ),
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          // color: Colors.red,
                          padding: EdgeInsets.only(
                            right: 24,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(routes.profile);
                        },
                      ),
                      Space(4),
                      Container(
                        height: 1,
                        color: colors.primaryColor,
                        margin: EdgeInsets.symmetric(horizontal: 24),
                      ),
                      Space(
                        4,
                      ),
                      ListTile(
                        leading: Icon(
                          SunIcons.transaction,
                          color: colors.primaryColor,
                        ),
                        title: Text(
                          'تراکنش ها',
                          style: colors.regularStyle(context),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(routes.transaction_report);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          SunIcons.star,
                          color: colors.primaryColor,
                        ),
                        title: Text(
                          'مدیریت ذخیره های من',
                          style: colors.regularStyle(context),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushNamed(routes.storage_management);
                        },
                      ),
                      // ListTile(
                      //   leading: Icon(
                      //     Icons.mail_outline,
                      //     color: colors.primaryColor,
                      //   ),
                      //   title: Text('انتقادات و پیشنهادات'),
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.of(context).pushNamed(routes.suggestions);
                      //   },
                      // ),
                      ListTile(
                        leading: Icon(
                          SunIcons.share,
                          color: colors.primaryColor,
                        ),
                        title: Text(
                          'دعوت از دوستان',
                          style: colors.regularStyle(context),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(routes.referral);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          SunIcons.mail,
                          color: colors.primaryColor,
                        ),
                        title: Text(
                          'صندوق پیام',
                          style: colors.regularStyle(context),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(routes.inbox);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          SunIcons.contact_us,
                          color: colors.primaryColor,
                        ),
                        title: Text(
                          'تماس با ما',
                          style: colors.regularStyle(context),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed(routes.contact_us);
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          SunIcons.log_out,
                          color: colors.primaryColor,
                        ),
                        title: Text(
                          'خروج',
                          style: colors.regularStyle(context),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          final result = await askYesNo(
                            title: Text('خروج'),
                            content: Text('از حساب کاربری خود خارج می شوید؟'),
                          );

                          if (result != true) {
                            return;
                          }
                          await analytics.logLogout(
                              phoneNumber: await appState.getPhoneNumber());
                          await appState.setUserPassword(null);
                          await appState.setFinger(null);
                          await appState.setJWT(null);
                          await Navigator.of(context).popUntil((r) => true);
                          await Navigator.of(context).pushNamed(routes.login);
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Image.asset('assets/logo/sun.png', width: 36),
                  title: Text('سوپر اپ نوین'),
                  trailing: Text('نسخه $app_version'.withPersianNumbers()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabPage(int page) {
    if (page == 0) {
      return CreditCardTabPage();
    }

    if (page == 1) {
      return HomeShopTabPage();
    }

    if (page == 2) {
      return HomeBankTabPage();
    }

    return Container();
  }
}

class HomeShopTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeShopTabPageState();
}

class _HomeShopTabPageState extends State<HomeShopTabPage> {
  @override
  void initState() {
    super.initState();
    _getNovinMallLink();
  }

  @override
  Widget build(BuildContext context) {
    void _openWalletPage() async {
      if (appState.isActiveWallet) {
        _pushNamed(routes.wallet_home);
        return;
      }
      final data = await Loading.run(context, nh.wallet.activate());

      if (!showError(context, data)) {
        return;
      }

      if (data.hasErrors()) {
        ToastUtils.showCustomToast(context, data.content.description,
            Image.asset('assets/ic_error.png'), 'خطا');

        return;
      }
      appState.isActiveWallet = true;
      _pushNamed(routes.wallet_home);
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 24, right: 24),
            child: Wallet(onTap: _openWalletPage),
          ),
        ),
        SliverToBoxAdapter(
          child: Space(2),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 8),
            child: AspectRatio(
              aspectRatio: 2.75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: GestureDetector(
                  onTap: _openNovinMall,
                  child: AdvertiseBanner(),
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
          sliver: SliverGrid.count(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: _getTab2Items().toList(),
          ),
        ),
      ],
    );
  }

  Iterable<Item> _getTab2Items() sync* {
    yield Item(
      title: CustomText('بسته اینترنتی'),
      image: Icon(SunIcons.mobile_net),
      onTap: () => _pushNamed(routes.net_package),
    );
    yield Item(
      title: CustomText('کارت به کارت'),
      image: Icon(SunIcons.card_2_card),
      onTap: () => _pushNamed(routes.card_to_card),
    );
    yield Item(
      title: CustomText('خرید شارژ'),
      image: Icon(SunIcons.sim_card),
      onTap: () => _pushNamed(routes.charge),
    );
    yield Item(
      title: CustomText('پوزمن'),
      image: Icon(SunIcons.pos),
      onTap: () => _openMyPosPage(),
    );
    yield Item(
      title: CustomText('خلافی خودرو'),
      image: Icon(SunIcons.car_pay),
      onTap: () => _pushNamed(routes.car_fine),
    );
    yield Item(
      title: CustomText('پرداخت قبض'),
      image: Icon(
        Icons.receipt_long_rounded,
        size: 32,
      ),
      onTap: () => _pushNamed(routes.bill_pay),
    );
    yield Item(
      title: CustomText('باشگاه مشتریان'),
      image: Icon(SunIcons.loyalty),
      onTap: () => _pushNamed(routes.club),
    );
    yield Item(
      title: CustomText('نوین مال'),
      image: Icon(Icons.storefront_outlined),
      badge: Text(
        'به زودی',
        textAlign: TextAlign.center,
        style:
            colors.bodyStyle(context).copyWith(color: colors.greyColor.shade50),
      ),
      onTap: () => _openNovinMall(),
    );
    yield Item(
      title: CustomText('بیمه نوین'),
      image: Icon(SunIcons.bimeh_novin),
      onTap: () => Utils.customLaunch(context, 'https://www.e-bime.com/',
          title: 'بیمه نوین'),
    );

    yield Item(
      title: CustomText('بیمه انفرادی'),
      image: Icon(NovinIcons.umbrella_outlined),
      onTap: () => _pushNamed(routes.saman_individual_insurance),
    );
/*    yield Item(
      title: CustomText('سهام دولت'),
      image: Icon(SunIcons.sazman_bourse_2),
      onTap: () => Utils.customLaunch(
          context, 'https://pna.co.ir/Etf/GetCutomerInfo',
          title: 'عرضه سهام دولت'),
    );*/
    yield Item(
      title: CustomText('استعلام ارز'),
      image: Icon(
        Icons.euro_symbol_outlined,
      ),
      onTap: () => _pushNamed(routes.currency_inquiry),
    );
    yield Item(
      title: CustomText('خیریه'),
      image: Icon(
        SunIcons.heart,
      ),
      onTap: () => _pushNamed(routes.charity),
    );

//    yield Item(
//      title: CustomText('کارگزاری بورس'),
//      image: Icon(SunIcons.e_novin),
//      onTap: () => Utils.customLaunch(
//          context, 'https://mobile.enovinbourse.ir/Account/Login',
//          title: 'کارگزاری بورس'),
//    );

    /* yield Item(
      title: CustomText('چک برگشتی'),
      image: Icon(NovinIcons.umbrella_outlined),
      onTap: () => _pushNamed(routes.cheque),
    );*/

    // yield Item(
    //   'تست',
    //   NovinBorder(
    //     child: Icon(
    //       NovinIcons.bill,
    //
    //     ),
    //   ),
    // () {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => OverViewPage(
    //           title: 'تایتل',
    //           cardNumber: '5',
    //           stan: 'null',
    //           description: 'null',
    //           amount: 10000,
    //           isShaparak: false),
    //     ),
    //   );
    // },
    //);
  }

  void _openNovinMall() async {
    if (!isNovinMallLinkEmptyOrNull(appState.novinMallLink)) {
      Utils.customLaunch(context, appState.novinMallLink, title: 'نوین مال');
    } else {
      await _getNovinMallLink();
      if (!isNovinMallLinkEmptyOrNull(appState.novinMallLink)) {
        _openNovinMall();
      }
    }
  }

  Future<void> _getNovinMallLink() async {
    if (isNovinMallLinkEmptyOrNull(appState.novinMallLink)) {
      final data = await nh.novinMall.getUrl();

      if (data.hasErrors()) {
        return;
      }

      appState.novinMallLink = data.content.novinMallUrl;
    }
  }

  bool isNovinMallLinkEmptyOrNull(String link) {
    if (link == null || link.isEmpty) {
      return true;
    }
    return false;
  }

  void _openMyPosPage() async {
    final data = await Loading.run(context, nh.mms.getTerminals());

    if (!showError(context, data)) {
      return;
    }

    final terminals = data.content.listOfTerminals;

    if (terminals == null || terminals.isEmpty) {
      ToastUtils.showCustomToast(
        context,
        'اطلاعات پذیرندگی شما یافت نشد',
        Image.asset('assets/ic_error.png'),
      );

      return;
    }

    _pushNamed(routes.my_pos);
  }

  void _pushNamed(String name, {Object arguments}) {
    Navigator.of(context).pushNamed(name, arguments: arguments);
  }
}

class HomeBankTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeBankTabPageState();
}

class _HomeBankTabPageState extends State<HomeBankTabPage> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
      crossAxisCount: 3,
      childAspectRatio: 1,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: _getTab1Items().toList(),
    );
  }

  Iterable<Item> _getTab1Items() sync* {
    yield Item(
      title: CustomText('انتقال وجه'),
      image: Icon(
        SunIcons.money_trans,
      ),
      onTap: () => _pushNamed(routes.money_transfer),
    );
    yield Item(
      title: CustomText('حساب/شبا'),
      image: Icon(
        SunIcons.shaba_3,
      ),
      onTap: () => _pushNamed(routes.iban_convert),
    );
    yield Item(
      title: CustomText('گردش حساب'),
      image: Icon(
        SunIcons.transaction,
      ),
      onTap: () => _pushNamed(routes.statement),
    );

    // yield Item(
    //   'افتتاح حساب',
    //   NovinBorder(
    //     child: Icon(
    //       NovinIcons.transactions,
    //
    //     ),
    //   ),
    //   () => _pushNamed(routes.opening_deposit, arguments: {'selectedPage': 0}),
    // );

    yield Item(
      title: CustomText('استعلام حساب'),
      image: Icon(
        SunIcons.account_info,
      ),
      onTap: () => _pushNamed(routes.account_inquiry),
    );
    yield Item(
      title: CustomText('تسهیلات'),
      image: Icon(
        SunIcons.loan,
      ),
      onTap: () => _pushNamed(routes.loan_pay),
    );
    yield Item(
      title: CustomText('اینترنت بانک'),
      image: Icon(
        SunIcons.e_bank,
      ),
      onTap: () => Utils.customLaunch(context,
          'https://modern.enbank.ir/ibmob/mobi/login/loginPage.action?ibReq=GPRS',
          title: 'اینترنت بانک'),
    );

    // yield Item(
    //   'کارت اعتباری',
    //   Icon(
    //     NovinIcons.credit_card,
    //   ),
    //   () => _pushNamed(routes.credit_card),
    // );

    yield Item(
      title: CustomText('گزارشات '),
      image: Icon(
        SunIcons.satna,
      ),
      onTap: () => _pushNamed(routes.transfer_report),
    );
  }

  void _pushNamed(String name, {Object arguments}) {
    Navigator.of(context).pushNamed(name, arguments: arguments);
  }
}

class CreditCardTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CreditCardTabPageState();
}

class _CreditCardTabPageState extends State<CreditCardTabPage>
    with DisableManagerMixin {
  final _formKey = GlobalKey<FormState>();
  final _nationalNumberController = TextEditingController();
  bool hasData = appState.creditCardHasData ?? false;

  @override
  void initState() {
    if (appState.creditCardLogin == true) {
      _getCreditCardInfo();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (appState.creditCardLogin != true) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 24.0,
          right: 24,
          top: 16,
          bottom: 24,
        ),
        child: Split(
          child: Expanded(
            child: Form(
              key: _formKey,
              child: NationalNumberTextFormField(
                enabled: enabled,
                controller: _nationalNumberController,
              ),
            ),
          ),
          footer: FutureConfirmButton(
            child: Text(strings.action_ok),
            onPressed: _submit,
          ),
        ),
      );
    } else {
      if (hasData) {
        final customerInfo = appState.customerInfo;
        final cardCount =
            customerInfo?.customerCards?.cardInfoVOsField?.length ?? 0;

        String pan() =>
            customerInfo.customerCards.cardInfoVOsField[0].pan ?? '';

        final String firstName = customerInfo.data.firstName ?? '';
        final String lastName = customerInfo.data.lastName ?? '';
        Iterable<Item> _getItems() sync* {
          final generalInfo = appState.generalInfo;
          final customerNumber = appState.customerInfo.data.customerNo;
          final customerInfo = appState.customerInfo;
          final bedehi =
              customerInfo.paymentInfo.data?.currentTotalAmt?.toInt() ?? 0;
          final hasNotBedehi = bedehi == 0;
          final hasNotGeneralInfo =
              generalInfo == null || generalInfo.status != true;
          yield Item(
              title: CustomText('اقساط'),
              image: Icon(Icons.event),
              onTap: () {
                if (hasNotGeneralInfo) {
                  ToastUtils.showCustomToast(context, 'صورت حسابی وجود ندارد');
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreditCardChooseStatementTypePage(),
                    ),
                  );
                }
              });

          yield Item(
              title: CustomText('صورت حساب ها'),
              image: Icon(Icons.receipt),
              onTap: () {
                if (hasNotBedehi) {
                  ToastUtils.showCustomToast(context, 'صورت حسابی وجود ندارد');
                } else {
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CreditCardBills(customerNumber: customerNumber),
                      ),
                    );
                  }
                }
              });

          yield Item(
              title: CustomText('لیست پرداخت ها'),
              image: Icon(Icons.credit_card),
              onTap: () {
                if (hasNotBedehi) {
                  ToastUtils.showCustomToast(
                      context, 'سابقه پرداخت وجود ندارد');
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreditCardTransactionHistoryPage(
                          customerNumber: customerNumber),
                    ),
                  );
                }
              });

          yield Item(
            title: CustomText('پرداخت بدهی'),
            image: Icon(Icons.check_circle_outline),
            onTap: () {
              if (hasNotBedehi) {
                ToastUtils.showCustomToast(context, 'سابقه پرداخت وجود ندارد');
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreditCardChoosePaymentTypePage(),
                  ),
                );
              }
            },
          );
        }

        return Column(children: [
          if (cardCount > 0)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
              child: DarkCreditCard(
                holder: '$firstName $lastName',
                debit: customerInfo.paymentInfo.data?.payAmtWithoutDiscount
                    ?.toInt(),
                currentDebit: customerInfo
                    .paymentInfo.data?.currentTotalDebitAmt
                    ?.toInt(),
                pan: pan(),
              ),
            ),
          Space(1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ScrollConfiguration(
                behavior: CustomBehavior(),
                child: GridView.count(
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 3,
                  childAspectRatio: 60.0 / 60.0,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: _getItems().toList(),
                ),
              ),
            ),
          ),
        ]);
      } else {
        return Center(
          child: Padding(
            padding: EdgeInsetsDirectional.only(start: 24, end: 24),
            child: Text(
              'لطفا منتظر بمانید',
              style: colors
                  .regularStyle(context)
                  .copyWith(color: colors.greyColor.shade900),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        );
      }
    }
  }

  Future<T> _showNoDataDialog<T>(String message) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('کارت اعتباری'),
        content: CustomText(message ?? ''),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        actions: [
          TextButton(
            child: Text('فهمیدم'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _getCreditCardInfo() async {
    String nationalNumber;
    if (appState.creditCardLogin == true) {
      nationalNumber = appState.nationalCode;
    } else {
      nationalNumber = _nationalNumberController.text;
    }

    final customerInfo =
        await nh.creditCard.getCustomerInfo(customerNumber: nationalNumber);

    if (customerInfo.isError) {
      await _showNoDataDialog(strings.connectionError);
      return false;
    }

    if (customerInfo.content.status != true) {
      await _showNoDataDialog(customerInfo.content.description ?? '');
      return false;
    }

    final cards = customerInfo.content?.customerCards?.cardInfoVOsField;

    if (cards == null || cards.isEmpty) {
      await _showNoDataDialog('برای این کد ملی هیچ کارتی تعریف نشده است.');
      return false;
    }

    final creditCards =
        cards.where((element) => element.productTypeField == 1).toList();

    if (creditCards.isEmpty) {
      await _showNoDataDialog('برای این کد ملی هیچ کارتی تعریف نشده است.');
      return false;
    }

    appState.creditCards = creditCards;

    final generalInfo = await nh.creditCard
        .getGeneralInformation(customerNumber: nationalNumber);

    if (generalInfo.isError) {
      await _showNoDataDialog(strings.connectionError);
      return false;
    }

    final paymentInfo = await nh.creditCard.getPaymentInfo(
        cardNumber: customerInfo.content.customerCards.cardInfoVOsField[0].pan);

    if (paymentInfo.isError) {
      await _showNoDataDialog(strings.connectionError);
      return false;
    }

    if (paymentInfo.content.status != true) {
      await _showNoDataDialog(paymentInfo.content.description ?? '');
      return false;
    }

    appState.generalInfo = generalInfo.content;
    appState.paymentInfo = paymentInfo.content;
    appState.customerInfo = customerInfo.content;
    appState.creditCardHasData = true;
    hasData = true;
    if (appState.creditCardLogin != true) {
      appState.setCreditCardLoginInfo(true, _nationalNumberController.text);
      appState.creditCardLogin = true;
      appState.nationalCode = _nationalNumberController.text;
    }
    setState(() {});

    return true;
  }

  Future<void> _submit() async {
    if (appState.creditCardLogin != true) {
      if (!_formKey.currentState.validate()) {
        return;
      }
    }

    disable();

    final didGetInfo = await _getCreditCardInfo();

    enable();

    if (didGetInfo != true) {
      return;
    }

    if (mounted != true) {
      return;
    }
    setState(() {});
  }
}
