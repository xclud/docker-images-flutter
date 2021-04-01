import 'package:flutter_test/flutter_test.dart';
import 'package:novinpay/utils.dart';

void main() {
  group('bank names', () {
    test('get bank name of eghtesad novin', () {
      final result = Utils.getBankName('627412');
      expect(result, 'اقتصاد نوین');
    });
    test('get melli bank name  ', () {
      final result = Utils.getBankName('603799');
      expect(result, 'ملی');
    });
    test('get seppah bank name ', () {
      final result = Utils.getBankName('589210');
      expect(result, 'سپه');
    });
    test('get  saderat bank name ', () {
      final result = Utils.getBankName('627648');
      expect(result, 'توسعه صادرات');
    });
    test('get sanat madan bank name ', () {
      final result = Utils.getBankName('627961');
      expect(result, 'صنعت و معدن');
    });
    test('get keshavarzi bank name of ', () {
      final result = Utils.getBankName('603770');
      expect(result, 'کشاورزی');
    });
    test('get maskan bank name ', () {
      final result = Utils.getBankName('628023');
      expect(result, 'مسکن');
    });
    test('get postbank bank name ', () {
      final result = Utils.getBankName('627760');
      expect(result, 'پست بانک');
    });
    test('get parsian bank name ', () {
      final result = Utils.getBankName('622106');
      expect(result, 'پارسیان');
    });
    test('get pasargad bank name ', () {
      final result = Utils.getBankName('502229');
      expect(result, 'پاسارگاد');
    });
    test('get pasargad bank name ', () {
      final result = Utils.getBankName('639347');
      expect(result, 'پاسارگاد');
    });
    test('get karafarin bank name ', () {
      final result = Utils.getBankName('627488');
      expect(result, 'کارآفرین');
    });
    test('get saman bank name ', () {
      final result = Utils.getBankName('621986');
      expect(result, 'سامان');
    });
    test('get sina bank name ', () {
      final result = Utils.getBankName('639346');
      expect(result, 'سینا');
    });
    test('get sarmaye bank name ', () {
      final result = Utils.getBankName('639607');
      expect(result, 'سرمایه');
    });
    test('get ayande bank name ', () {
      final result = Utils.getBankName('636214');
      expect(result, 'آینده');
    });
    test('get shahr bank name ', () {
      final result = Utils.getBankName('502806');
      expect(result, 'شهر');
    });
    test('get shahr bank name ', () {
      final result = Utils.getBankName('504706');
      expect(result, 'شهر');
    });
    test('get dey bank name ', () {
      final result = Utils.getBankName('502938');
      expect(result, 'دی');
    });
    test('get saderat bank name ', () {
      final result = Utils.getBankName('603769');
      expect(result, 'صادرات');
    });
    test('get mellat bank name ', () {
      final result = Utils.getBankName('610433');
      expect(result, 'ملت');
    });
    test('get tejarat bank name ', () {
      final result = Utils.getBankName('627353');
      expect(result, 'تجارت');
    });
    test('get tejarat bank name ', () {
      final result = Utils.getBankName('585983');
      expect(result, 'تجارت');
    });
    test('get refah bank name ', () {
      final result = Utils.getBankName('589463');
      expect(result, 'رفاه');
    });
    test('get ansar bank name ', () {
      final result = Utils.getBankName('627381');
      expect(result, 'انصار');
    });
    test('get resalat bank name ', () {
      final result = Utils.getBankName('504172');
      expect(result, 'قرض الحسنه رسالت');
    });
    test('get kosar bank name ', () {
      final result = Utils.getBankName('505801');
      expect(result, 'کوثر');
    });
    test('get hekmat bank name ', () {
      final result = Utils.getBankName('636949');
      expect(result, 'حکمت ایرانیان');
    });
    test('get ghavamin bank name ', () {
      final result = Utils.getBankName('639599');
      expect(result, 'قوامین');
    });
    test('get melal bank name ', () {
      final result = Utils.getBankName('606256');
      expect(result, 'موسسه مالی اعتباری ملل');
    });
    test('get noor bank name ', () {
      final result = Utils.getBankName('507677');
      expect(result, 'موسسه مالی اعتباری نور');
    });
    test('get khavarmiane bank name ', () {
      final result = Utils.getBankName('585947');
      expect(result, 'خاورمیانه');
    });
    test('get mehr bank name ', () {
      final result = Utils.getBankName('606373');
      expect(result, 'قرض الحسنه مهر ایران');
    });
  });
}
