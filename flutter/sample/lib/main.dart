import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/pages/account_inquiry_page.dart';
import 'package:novinpay/pages/bills_payment_page.dart';
import 'package:novinpay/pages/car_fine_page.dart';
import 'package:novinpay/pages/card_to_card_page.dart';
import 'package:novinpay/pages/charge_page.dart';
import 'package:novinpay/pages/charity_page.dart';
import 'package:novinpay/pages/cheque_page.dart';
import 'package:novinpay/pages/club_page.dart';
import 'package:novinpay/pages/contact_us_page.dart';
import 'package:novinpay/pages/currency_inquiry_page.dart';
import 'package:novinpay/pages/diplomat_page.dart';
import 'package:novinpay/pages/enter_password_page.dart';
import 'package:novinpay/pages/forget_password_page.dart';
import 'package:novinpay/pages/home_page.dart';
import 'package:novinpay/pages/iban_convert_page.dart';
import 'package:novinpay/pages/inbox_page.dart';
import 'package:novinpay/pages/insurer_information_page.dart';
import 'package:novinpay/pages/loan_pay_page.dart';
import 'package:novinpay/pages/login_page.dart';
import 'package:novinpay/pages/money_transfer_page.dart';
import 'package:novinpay/pages/my_pos_page.dart';
import 'package:novinpay/pages/net_package_page.dart';
import 'package:novinpay/pages/omid_club_page.dart';
import 'package:novinpay/pages/opening_deposit_page.dart';
import 'package:novinpay/pages/profile_page.dart';
import 'package:novinpay/pages/referral_page.dart';
import 'package:novinpay/pages/splash_page.dart';
import 'package:novinpay/pages/statement_page.dart';
import 'package:novinpay/pages/storage_management_page.dart';
import 'package:novinpay/pages/suggestion_page.dart';
import 'package:novinpay/pages/test_page.dart';
import 'package:novinpay/pages/transaction_report_page.dart';
import 'package:novinpay/pages/transfer_report_page.dart';
import 'package:novinpay/pages/under_construction_page.dart';
import 'package:novinpay/pages/wallet_home_page.dart';
import 'package:novinpay/routes.dart' as routes;
import 'package:novinpay/widgets/credit_card_login.dart';
import 'package:persian_flutter/persian_flutter.dart';

final _routes = <String, WidgetBuilder>{
  routes.account_inquiry: (context) => AccountInquiryPage(),
  routes.transaction_report: (context) => TransactionReportPage(),
  routes.bill_pay: (context) => BillsPaymentPage(),
  routes.card_to_card: (context) => CardToCardPage(),
  routes.charge: (context) => ChargePage(),
  routes.cheque: (context) => ChequePage(),
  routes.club: (context) => ClubPage(),
  routes.credit_card: (context) => CreditCardLogin(),
  routes.diplomat: (context) => DiplomatPage(),
  routes.iban_convert: (context) => IbanConvertPage(),
  routes.loan_pay: (context) => LoanPayPage(),
  routes.login: (context) => LoginPage(),
  routes.money_transfer: (context) => MoneyTransferPage(),
  routes.opening_deposit: (context) => OpeningDepositPage(),
  routes.statement: (context) => StatementPage(),
  routes.under_construction: (context) => UnderConstructionPage(),
  routes.net_package: (context) => NetPackagePage(),
  routes.suggestions: (context) => SuggestionPage(),
  routes.profile: (context) => ProfilePage(),
  routes.storage_management: (context) => StorageManagementPage(),
  routes.my_pos: (context) => MyPosPage(),
  routes.car_fine: (context) => CarFinePage(),
  routes.contact_us: (context) => ContactUsPage(),
  routes.referral: (context) => ReferralPage(),
  routes.transfer_report: (context) => TransferReportPage(),
  routes.test: (context) => TestPage(),
  routes.omidclub: (context) => OmidClubPage(),
  routes.inbox: (context) => InboxPage(),
  routes.saman_individual_insurance: (context) => InsurerInformationPage(),
  routes.currency_inquiry: (context) => CurrencyInquiryPage(),
  routes.wallet_home: (context) => WalletHomePage(),
  routes.password: (context) => EnterPasswordPage(),
  routes.forgetPassword: (context) => ForgetPassword(),
  routes.charity: (context) => CharityPage(),
  //This should be the last item. Please DO NOT move it up.
  routes.home: (context) => HomePage(),
  routes.splash: (context) => SplashPage(),
};

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: colors.theme,
      locale: Locale('fa'),
      localizationsDelegates: [_MyPersianLocalizationDelegate()],
      builder: (context, widget) => Container(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(maxWidth: 420),
          child: Directionality(
            child: widget,
            textDirection: TextDirection.rtl,
          ),
        ),
      ),
      initialRoute: routes.splash,
      routes: _routes,
      //navigatorObservers: [observer],
      onGenerateRoute: (settings) {
        final name = settings.name;
        final route = _routes.entries.firstWhere(
          (element) => name.toLowerCase().startsWith(element.key.toLowerCase()),
        );

        var data = name.substring(route.key.length);
        while (data.startsWith('?')) {
          data = data.substring(1);
        }

        final uri = Uri.tryParse('http://localhost?$data');

        final builder = route.value;

        return MaterialPageRoute(
          builder: builder,
          settings: RouteSettings(
            arguments: uri.queryParameters,
            name: route.key,
          ),
        );
      },
    );
  }
}

class _MyPersianLocalizationDelegate extends PersianLocalizationDelegate {
  @override
  bool isSupported(Locale locale) {
    return true;
  }
}
