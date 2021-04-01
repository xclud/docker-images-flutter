import 'package:novinpay/widgets/pna_persian_datepicker/jalaali_js.dart';

class PersianDateTime {
  PersianDateTime({jalaaliDateTime}) {
    _makeStandardDateTimeFromJalaaliString(jalaaliDateTime);
  }

  PersianDateTime.fromGregorian({String gregorianDateTime}) {
    if (gregorianDateTime == null) {
      DateTime now = DateTime.now();
      gregorianDateTime = '${now.year}-${now.month}-${now.day}';
    }
    List<String> datetimeParts = gregorianDateTime.split('-');
    Gregorian gregorian = Gregorian(int.parse(datetimeParts[0]),
        int.parse(datetimeParts[1]), int.parse(datetimeParts[2]));
    _makeStandardDateTimeFromJalaaliString(gregorian.toJalaali().toString());
  }

  DateTime datetime;
  Jalaali _jalaaliDateTime;

  int jalaaliYear;
  int jalaaliMonth;
  int jalaaliDay;
  int jalaaliShortYear;
  String jalaaliZeroLeadingDay;
  String jalaaliZeroLeadingMonth;
  String jalaaliMonthName;

  int gregorianYear;
  int gregorianMonth;
  int gregorianDay;
  int gregorianShortYear;
  String gregorianZeroLeadingDay;
  String gregorianZeroLeadingMonth;
  String gregorianMonthName;
  String gregorianShortMonthName;

  String toJalaali({String format = 'YYYY/MM/DD'}) {
    return translate(format, _jalaaliDateTime, false);
  }

  String toGregorian({String format = 'YYYY-MM-DD'}) {
    return translateStandardDateTime(format, datetime);
  }

  bool isAfter(PersianDateTime otherDate) {
    return datetime.isAfter(otherDate.datetime) ? true : false;
  }

  bool isBefore(PersianDateTime otherDate) {
    return datetime.isBefore(otherDate.datetime) ? true : false;
  }

  bool isEqual(PersianDateTime otherDate) {
    return datetime.compareTo(otherDate.datetime) == 0 ? true : false;
  }

  PersianDateTime add(Duration duration) {
    DateTime newDateTime = datetime.add(duration);
    return PersianDateTime(
        jalaaliDateTime:
            Gregorian(newDateTime.year, newDateTime.month, newDateTime.day)
                .toJalaali()
                .toString());
  }

  PersianDateTime subtract(Duration duration) {
    DateTime newDateTime = datetime.subtract(duration);
    return PersianDateTime(
        jalaaliDateTime:
            Gregorian(newDateTime.year, newDateTime.month, newDateTime.day)
                .toJalaali()
                .toString());
  }

  Duration difference(PersianDateTime otherDate) {
    return datetime.difference(otherDate.datetime);
  }

  @override
  String toString() {
    return translate('YYYY/MM/DD', _jalaaliDateTime, false);
  }

  void _makeJalaaliDateTimeFromJalaaliString(String jalaaliString) {
    if (jalaaliString == null) {
      _jalaaliDateTime = Jalaali.now();
    } else {
      List<String> datetimeParts = jalaaliString.split('/');
      _jalaaliDateTime = Jalaali(int.parse(datetimeParts[0]),
          int.parse(datetimeParts[1]), int.parse(datetimeParts[2]));
    }
  }

  void _makeStandardDateTimeFromJalaaliString(String jalaaliString) {
    _makeJalaaliDateTimeFromJalaaliString(jalaaliString);
    datetime = _jalaaliDateTime.toGregorian().toDateTime();

    jalaaliYear = _jalaaliDateTime.year;
    jalaaliMonth = _jalaaliDateTime.month;
    jalaaliDay = _jalaaliDateTime.day;
    jalaaliShortYear =
        int.parse(_jalaaliDateTime.year.toString().substring(2, 4));
    jalaaliZeroLeadingDay = _jalaaliDateTime.day.toString().padLeft(2, '0');
    jalaaliZeroLeadingMonth = _jalaaliDateTime.month.toString().padLeft(2, '0');
    jalaaliMonthName = getJalaaliMonthName(_jalaaliDateTime.month);

    gregorianYear = datetime.year;
    gregorianMonth = datetime.month;
    gregorianDay = datetime.day;
    gregorianShortYear = int.parse(datetime.year.toString().substring(2, 4));
    gregorianZeroLeadingDay = datetime.day.toString().padLeft(2, '0');
    gregorianZeroLeadingMonth = datetime.month.toString().padLeft(2, '0');
    gregorianMonthName = getGregorianMonthName(datetime.month);
    gregorianShortMonthName = getGregorianMonthNameAbbr(datetime.month);
  }
}
