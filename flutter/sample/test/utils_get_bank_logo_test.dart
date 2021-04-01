import 'package:flutter_test/flutter_test.dart';
import 'package:novinpay/utils.dart';

void main() {
  group('bank logo', () {
    test('get bank name of eghtesad novin', () {
      final result = Utils.getBankLogo('627412');
      expect(result, 'assets/banks/en.png');
    });
    test('get ansar bank name ', () {
      final result = Utils.getBankLogo('627381');
      expect(result, 'assets/banks/ansar.png');
    });
    test('get iranzamin  bank name ', () {
      final result = Utils.getBankLogo('505785');
      expect(result, 'assets/banks/iranzamin.png');
    });
    test('get gardeshgari  bank name ', () {
      final result = Utils.getBankLogo('505416');
      expect(result, 'assets/banks/gardeshgari.png');
    });
    test('get melli bank name  ', () {
      final result = Utils.getBankLogo('603799');
      expect(result, 'assets/banks/melli.png');
    });
    test('get seppah bank name ', () {
      final result = Utils.getBankLogo('589210');
      expect(result, 'assets/banks/sepah.png');
    });
    test('get  saderat bank name ', () {
      final result = Utils.getBankLogo('627648');
      expect(result, 'assets/banks/toseesaderat.png');
    });
    test('get  saderat bank name ', () {
      final result = Utils.getBankLogo('207177');
      expect(result, 'assets/banks/toseesaderat.png');
    });
    test('get sanat madan bank name ', () {
      final result = Utils.getBankLogo('627961');
      expect(result, 'assets/banks/sanatmadan.png');
    });
    test('get keshavarzi bank name of ', () {
      final result = Utils.getBankLogo('603770');
      expect(result, 'assets/banks/keshavarzi.png');
    });
    test('get maskan bank name ', () {
      final result = Utils.getBankLogo('628023');
      expect(result, 'assets/banks/maskan.png');
    });
    test('get postbank bank name ', () {
      final result = Utils.getBankLogo('627760');
      expect(result, 'assets/banks/postbank.png');
    });
    test('get parsian bank name ', () {
      final result = Utils.getBankLogo('622106');
      expect(result, 'assets/banks/parsian.png');
    });
    test('get parsian bank name ', () {
      final result = Utils.getBankLogo('627884');
      expect(result, 'assets/banks/parsian.png');
    });
    test('get parsian bank name ', () {
      final result = Utils.getBankLogo('639194');
      expect(result, 'assets/banks/parsian.png');
    });
    test('get pasargad bank name ', () {
      final result = Utils.getBankLogo('502229');
      expect(result, 'assets/banks/pasargad.png');
    });
    test('get pasargad bank name ', () {
      final result = Utils.getBankLogo('639347');
      expect(result, 'assets/banks/pasargad.png');
    });
    test('get toseetavon bank name ', () {
      final result = Utils.getBankLogo('502908');
      expect(result, 'assets/banks/toseetaavon.png');
    });
    test('get karafarin bank name ', () {
      final result = Utils.getBankLogo('627488');
      expect(result, 'assets/banks/kaarafarin.png');
    });
    test('get karafarin bank logo ', () {
      final result = Utils.getBankLogo('502910');
      expect(result, 'assets/banks/kaarafarin.png');
    });
    test('get saman bank logo ', () {
      final result = Utils.getBankLogo('621986');
      expect(result, 'assets/banks/saman.png');
    });
    test('get sina bank logo ', () {
      final result = Utils.getBankLogo('639346');
      expect(result, 'assets/banks/sina.png');
    });
    test('get sarmaye bank logo ', () {
      final result = Utils.getBankLogo('639607');
      expect(result, 'assets/banks/sarmaye.png');
    });
    test('get ayande bank logo ', () {
      final result = Utils.getBankLogo('636214');
      expect(result, 'assets/banks/ayande.png');
    });

    test('get shahr bank logo ', () {
      final result = Utils.getBankLogo('504706');
      expect(result, 'assets/banks/shahr.png');
    });
    test('get dey bank logo ', () {
      final result = Utils.getBankLogo('502938');
      expect(result, 'assets/banks/dey.png');
    });
    test('get saderat bank logo ', () {
      final result = Utils.getBankLogo('603769');
      expect(result, 'assets/banks/saderat.png');
    });
    test('get mellat bank logo ', () {
      final result = Utils.getBankLogo('991975');
      expect(result, 'assets/banks/mellat.png');
    });
    test('get tejarat bank logo ', () {
      final result = Utils.getBankLogo('627353');
      expect(result, 'assets/banks/tejarat.png');
    });
    test('get tejarat bank logo ', () {
      final result = Utils.getBankLogo('585983');
      expect(result, 'assets/banks/tejarat.png');
    });
    test('get refah bank logo ', () {
      final result = Utils.getBankLogo('589463');
      expect(result, 'assets/banks/refah.png');
    });

    test('get resalat bank logo ', () {
      final result = Utils.getBankLogo('504172');
      expect(result, 'assets/banks/resalat.png');
    });
    test('get kosar bank logo ', () {
      final result = Utils.getBankLogo('505801');
      expect(result, 'assets/banks/kosar.png');
    });
    test('get hekmat bank logo ', () {
      final result = Utils.getBankLogo('636949');
      expect(result, 'assets/banks/hekmat.png');
    });
    test('get ghavamin bank logo ', () {
      final result = Utils.getBankLogo('639599');
      expect(result, 'assets/banks/ghavaamin.png');
    });
    test('get melal bank logo ', () {
      final result = Utils.getBankLogo('606256');
      expect(result, 'assets/banks/melal.png');
    });
    test('get noor bank logo ', () {
      final result = Utils.getBankLogo('507677');
      expect(result, 'assets/banks/noor.png');
    });
    test('get khavarmiane bank logo ', () {
      final result = Utils.getBankLogo('585947');
      expect(result, 'assets/banks/khavarmiane.png');
    });
    test('get mehr bank logo ', () {
      final result = Utils.getBankLogo('606373');
      expect(result, 'assets/banks/gharzolhasanemehr.png');
    });
  });
}
