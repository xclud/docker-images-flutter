City findCityById(int cityId) {
  final province = provinces.firstWhere(
    (element) =>
        element.cities.where((element) => element.id == cityId).isNotEmpty,
    orElse: () => null,
  );
  if (province != null) {
    final city = province.cities
        .firstWhere((element) => element.id == cityId, orElse: () => null);
    return city;
  }

  return null;
}

Province findProvinceByCityId(int cityId) {
  final province = provinces.firstWhere(
    (element) =>
        element.cities.where((element) => element.id == cityId).isNotEmpty,
    orElse: () => null,
  );

  return province;
}

class Province {
  const Province._({this.id, this.name, this.cities});

  final int id;
  final String name;
  final List<City> cities;
}

class City {
  const City._({this.id, this.name, this.stateId});

  final int id;
  final String name;
  final int stateId;
}

final _p_01_c0420 = City._(id: 420, name: 'گوگان', stateId: 1);
final _p_01_c0421 = City._(id: 421, name: 'تیکمه داش', stateId: 1);
final _p_01_c0422 = City._(id: 422, name: 'بناب', stateId: 1);
final _p_01_c0423 = City._(id: 423, name: 'باسمنج', stateId: 1);
final _p_01_c0424 = City._(id: 424, name: 'تبریز', stateId: 1);
final _p_01_c0425 = City._(id: 425, name: 'خسروشهر', stateId: 1);
final _p_01_c0426 = City._(id: 426, name: 'جلفا', stateId: 1);
final _p_01_c0427 = City._(id: 427, name: 'هادیشهر', stateId: 1);
final _p_01_c0428 = City._(id: 428, name: 'خمارلو', stateId: 1);
final _p_01_c0429 = City._(id: 429, name: 'سراب', stateId: 1);
final _p_01_c0430 = City._(id: 430, name: 'شربیان', stateId: 1);
final _p_01_c0431 = City._(id: 431, name: 'تسوج', stateId: 1);
final _p_01_c0432 = City._(id: 432, name: 'خامنه', stateId: 1);
final _p_01_c0433 = City._(id: 433, name: 'سیس', stateId: 1);
final _p_01_c0434 = City._(id: 434, name: 'شبستر', stateId: 1);
final _p_01_c0435 = City._(id: 435, name: 'شرفخانه', stateId: 1);
final _p_01_c0436 = City._(id: 436, name: 'صوفیان', stateId: 1);
final _p_01_c0437 = City._(id: 437, name: 'آبش احمد', stateId: 1);
final _p_01_c0438 = City._(id: 438, name: 'کلیبر', stateId: 1);
final _p_01_c0439 = City._(id: 439, name: 'مراغه', stateId: 1);
final _p_01_c0440 = City._(id: 440, name: 'بناب جدید', stateId: 1);
final _p_01_c0441 = City._(id: 441, name: 'زنوز', stateId: 1);
final _p_01_c0442 = City._(id: 442, name: 'کشکسرای', stateId: 1);
final _p_01_c0443 = City._(id: 443, name: 'مرند', stateId: 1);
final _p_01_c0444 = City._(id: 444, name: 'لیلان', stateId: 1);
final _p_01_c0445 = City._(id: 445, name: 'آقکند', stateId: 1);
final _p_01_c0446 = City._(id: 446, name: 'ترک', stateId: 1);
final _p_01_c0447 = City._(id: 447, name: 'میانه', stateId: 1);
final _p_01_c0448 = City._(id: 448, name: 'بخشایش', stateId: 1);
final _p_01_c0449 = City._(id: 449, name: 'زرنق', stateId: 1);
final _p_01_c0450 = City._(id: 450, name: 'هریس', stateId: 1);
final _p_01_c0451 = City._(id: 451, name: 'نظرکهریزی', stateId: 1);
final _p_01_c0452 = City._(id: 452, name: 'ورزقان', stateId: 1);
final _p_01_c0544 = City._(id: 544, name: 'ترکمانچای', stateId: 1);
final _p_01_c0564 = City._(id: 564, name: 'سیه رود', stateId: 1);
final _p_01_c0596 = City._(id: 596, name: 'ملکان', stateId: 1);
final _p_01_c0604 = City._(id: 604, name: 'یامچی', stateId: 1);
final _p_01_c0635 = City._(id: 635, name: 'عجب شیر', stateId: 1);
final _p_01_c0700 = City._(id: 700, name: 'خاروانا', stateId: 1);
final _p_01_c0702 = City._(id: 702, name: 'خداجو(خراجو)', stateId: 1);
final _p_01_c0720 = City._(id: 720, name: 'دوزدوزان', stateId: 1);
final _p_01_c0747 = City._(id: 747, name: 'سردرود', stateId: 1);
final _p_01_c0758 = City._(id: 758, name: 'شندآباد', stateId: 1);
final _p_01_c0779 = City._(id: 779, name: 'قره آغاج', stateId: 1);
final _p_01_c0793 = City._(id: 793, name: 'کلوانق', stateId: 1);
final _p_01_c0799 = City._(id: 799, name: 'کوزه کنان', stateId: 1);
final _p_01_c1068 = City._(id: 1068, name: 'اسکو', stateId: 1);
final _p_01_c1069 = City._(id: 1069, name: 'ایلخچی', stateId: 1);
final _p_01_c1070 = City._(id: 1070, name: 'سهند', stateId: 1);
final _p_01_c1071 = City._(id: 1071, name: 'اهر', stateId: 1);
final _p_01_c1072 = City._(id: 1072, name: 'هوراند', stateId: 1);
final _p_01_c1073 = City._(id: 1073, name: 'آذرشهر', stateId: 1);
final _p_01_c1083 = City._(id: 1083, name: 'مهربان', stateId: 1);
final _p_01_c1104 = City._(id: 1104, name: 'هشترود', stateId: 1);
final _p_01_c1109 = City._(id: 1109, name: 'وایقان', stateId: 1);
final _p_01_c1114 = City._(id: 1114, name: 'ممقان', stateId: 1);
final _p_01_c1115 = City._(id: 1115, name: 'بستان آباد', stateId: 1);
final _p_01_c1130 = City._(id: 1130, name: 'خواجه', stateId: 1);
final _p_01_c1231 = City._(id: 1231, name: 'لامر', stateId: 1);
final _prov_01 = Province._(id: 1, name: 'آذربایجان شرقی', cities: [
  _p_01_c0420,
  _p_01_c0421,
  _p_01_c0422,
  _p_01_c0423,
  _p_01_c0424,
  _p_01_c0425,
  _p_01_c0426,
  _p_01_c0427,
  _p_01_c0428,
  _p_01_c0429,
  _p_01_c0430,
  _p_01_c0431,
  _p_01_c0432,
  _p_01_c0433,
  _p_01_c0434,
  _p_01_c0435,
  _p_01_c0436,
  _p_01_c0437,
  _p_01_c0438,
  _p_01_c0439,
  _p_01_c0440,
  _p_01_c0441,
  _p_01_c0442,
  _p_01_c0443,
  _p_01_c0444,
  _p_01_c0445,
  _p_01_c0446,
  _p_01_c0447,
  _p_01_c0448,
  _p_01_c0449,
  _p_01_c0450,
  _p_01_c0451,
  _p_01_c0452,
  _p_01_c0544,
  _p_01_c0564,
  _p_01_c0596,
  _p_01_c0604,
  _p_01_c0635,
  _p_01_c0700,
  _p_01_c0702,
  _p_01_c0720,
  _p_01_c0747,
  _p_01_c0758,
  _p_01_c0779,
  _p_01_c0793,
  _p_01_c0799,
  _p_01_c1068,
  _p_01_c1069,
  _p_01_c1070,
  _p_01_c1071,
  _p_01_c1072,
  _p_01_c1073,
  _p_01_c1083,
  _p_01_c1104,
  _p_01_c1109,
  _p_01_c1114,
  _p_01_c1115,
  _p_01_c1130,
  _p_01_c1231
]);
final _p_02_c0089 = City._(id: 89, name: 'میرآباد', stateId: 2);
final _p_02_c0379 = City._(id: 379, name: 'چهاربرج', stateId: 2);
final _p_02_c0380 = City._(id: 380, name: 'میاندوآب', stateId: 2);
final _p_02_c0381 = City._(id: 381, name: 'محمدیار', stateId: 2);
final _p_02_c0382 = City._(id: 382, name: 'نقده', stateId: 2);
final _p_02_c0453 = City._(id: 453, name: 'ارومیه', stateId: 2);
final _p_02_c0454 = City._(id: 454, name: 'سرو', stateId: 2);
final _p_02_c0455 = City._(id: 455, name: 'سیلوانه', stateId: 2);
final _p_02_c0456 = City._(id: 456, name: 'قوشچی', stateId: 2);
final _p_02_c0457 = City._(id: 457, name: 'نوشین', stateId: 2);
final _p_02_c0458 = City._(id: 458, name: 'اشنویه', stateId: 2);
final _p_02_c0459 = City._(id: 459, name: 'نالوس', stateId: 2);
final _p_02_c0460 = City._(id: 460, name: 'بوکان', stateId: 2);
final _p_02_c0461 = City._(id: 461, name: 'پلدشت', stateId: 2);
final _p_02_c0462 = City._(id: 462, name: 'تکاب', stateId: 2);
final _p_02_c0463 = City._(id: 463, name: 'سیه چشمه', stateId: 2);
final _p_02_c0464 = City._(id: 464, name: 'قره ضیاء الدین', stateId: 2);
final _p_02_c0465 = City._(id: 465, name: 'خوی', stateId: 2);
final _p_02_c0466 = City._(id: 466, name: 'دیزج دیز', stateId: 2);
final _p_02_c0467 = City._(id: 467, name: 'فیرورق', stateId: 2);
final _p_02_c0468 = City._(id: 468, name: 'قطور', stateId: 2);
final _p_02_c0469 = City._(id: 469, name: 'ربط', stateId: 2);
final _p_02_c0470 = City._(id: 470, name: 'سردشت', stateId: 2);
final _p_02_c0471 = City._(id: 471, name: 'سلماس', stateId: 2);
final _p_02_c0472 = City._(id: 472, name: 'شاهین دژ', stateId: 2);
final _p_02_c0473 = City._(id: 473, name: 'شوط', stateId: 2);
final _p_02_c0474 = City._(id: 474, name: 'مرگنلر', stateId: 2);
final _p_02_c0475 = City._(id: 475, name: 'بازرگان', stateId: 2);
final _p_02_c0476 = City._(id: 476, name: 'ماکو', stateId: 2);
final _p_02_c0477 = City._(id: 477, name: 'خلیفان', stateId: 2);
final _p_02_c0478 = City._(id: 478, name: 'مهاباد', stateId: 2);
final _p_02_c0479 = City._(id: 479, name: 'باروق', stateId: 2);
final _p_02_c0534 = City._(id: 534, name: 'ایواوغلی', stateId: 2);
final _p_02_c0540 = City._(id: 540, name: 'پیرانشهر', stateId: 2);
final _p_02_c0542 = City._(id: 542, name: 'تازه شهر', stateId: 2);
final _p_02_c0563 = City._(id: 563, name: 'سیمینه', stateId: 2);
final _p_02_c0638 = City._(id: 638, name: 'محمودآباد', stateId: 2);
final _p_02_c0661 = City._(id: 661, name: 'آواجیق', stateId: 2);
final _p_02_c0737 = City._(id: 737, name: 'زرآباد', stateId: 2);
final _p_02_c0789 = City._(id: 789, name: 'کشاورز', stateId: 2);
final _p_02_c0806 = City._(id: 806, name: 'گردکشانه', stateId: 2);
final _p_02_c1091 = City._(id: 1091, name: 'نازک علیا', stateId: 2);
final _prov_02 = Province._(id: 2, name: 'آذربایجان غربی', cities: [
  _p_02_c0089,
  _p_02_c0379,
  _p_02_c0380,
  _p_02_c0381,
  _p_02_c0382,
  _p_02_c0453,
  _p_02_c0454,
  _p_02_c0455,
  _p_02_c0456,
  _p_02_c0457,
  _p_02_c0458,
  _p_02_c0459,
  _p_02_c0460,
  _p_02_c0461,
  _p_02_c0462,
  _p_02_c0463,
  _p_02_c0464,
  _p_02_c0465,
  _p_02_c0466,
  _p_02_c0467,
  _p_02_c0468,
  _p_02_c0469,
  _p_02_c0470,
  _p_02_c0471,
  _p_02_c0472,
  _p_02_c0473,
  _p_02_c0474,
  _p_02_c0475,
  _p_02_c0476,
  _p_02_c0477,
  _p_02_c0478,
  _p_02_c0479,
  _p_02_c0534,
  _p_02_c0540,
  _p_02_c0542,
  _p_02_c0563,
  _p_02_c0638,
  _p_02_c0661,
  _p_02_c0737,
  _p_02_c0789,
  _p_02_c0806,
  _p_02_c1091
]);
final _p_03_c0383 = City._(id: 383, name: 'اردبیل', stateId: 3);
final _p_03_c0384 = City._(id: 384, name: 'هیر', stateId: 3);
final _p_03_c0385 = City._(id: 385, name: 'جعفرآباد', stateId: 3);
final _p_03_c0386 = City._(id: 386, name: 'اصلاندوز', stateId: 3);
final _p_03_c0387 = City._(id: 387, name: 'پارس آباد', stateId: 3);
final _p_03_c0388 = City._(id: 388, name: 'تازه کند', stateId: 3);
final _p_03_c0389 = City._(id: 389, name: 'خلخال', stateId: 3);
final _p_03_c0390 = City._(id: 390, name: 'کلور', stateId: 3);
final _p_03_c0391 = City._(id: 391, name: 'سرعین', stateId: 3);
final _p_03_c0392 = City._(id: 392, name: 'گیوی', stateId: 3);
final _p_03_c0393 = City._(id: 393, name: 'تازه کندانگوت', stateId: 3);
final _p_03_c0394 = City._(id: 394, name: 'گرمی', stateId: 3);
final _p_03_c0395 = City._(id: 395, name: 'لاهرود', stateId: 3);
final _p_03_c0396 = City._(id: 396, name: 'مشگین شهر', stateId: 3);
final _p_03_c0397 = City._(id: 397, name: 'عنبران', stateId: 3);
final _p_03_c0398 = City._(id: 398, name: 'کوراییم', stateId: 3);
final _p_03_c0399 = City._(id: 399, name: 'نیر', stateId: 3);
final _p_03_c0573 = City._(id: 573, name: 'فخرآباد', stateId: 3);
final _p_03_c0600 = City._(id: 600, name: 'نمین', stateId: 3);
final _p_03_c0618 = City._(id: 618, name: 'هشتجین', stateId: 3);
final _p_03_c0640 = City._(id: 640, name: 'بیله سوار', stateId: 3);
final _p_03_c0654 = City._(id: 654, name: 'آبی بیگلو', stateId: 3);
final _p_03_c0732 = City._(id: 732, name: 'رضی', stateId: 3);
final _p_03_c1078 = City._(id: 1078, name: 'مرادلو', stateId: 3);
final _prov_03 = Province._(id: 3, name: 'اردبیل', cities: [
  _p_03_c0383,
  _p_03_c0384,
  _p_03_c0385,
  _p_03_c0386,
  _p_03_c0387,
  _p_03_c0388,
  _p_03_c0389,
  _p_03_c0390,
  _p_03_c0391,
  _p_03_c0392,
  _p_03_c0393,
  _p_03_c0394,
  _p_03_c0395,
  _p_03_c0396,
  _p_03_c0397,
  _p_03_c0398,
  _p_03_c0399,
  _p_03_c0573,
  _p_03_c0600,
  _p_03_c0618,
  _p_03_c0640,
  _p_03_c0654,
  _p_03_c0732,
  _p_03_c1078
]);
final _p_04_c0113 = City._(id: 113, name: 'طالخونچه', stateId: 4);
final _p_04_c0400 = City._(id: 400, name: 'اردستان', stateId: 4);
final _p_04_c0401 = City._(id: 401, name: 'مهاباد', stateId: 4);
final _p_04_c0402 = City._(id: 402, name: 'اصفهان', stateId: 4);
final _p_04_c0403 = City._(id: 403, name: 'بهارستان', stateId: 4);
final _p_04_c0404 = City._(id: 404, name: 'تودشک', stateId: 4);
final _p_04_c0405 = City._(id: 405, name: 'حسن اباد', stateId: 4);
final _p_04_c0406 = City._(id: 406, name: 'محمدآباد', stateId: 4);
final _p_04_c0407 = City._(id: 407, name: 'نصرآباد', stateId: 4);
final _p_04_c0408 = City._(id: 408, name: 'هرند', stateId: 4);
final _p_04_c0409 = City._(id: 409, name: 'ابوزیدآباد', stateId: 4);
final _p_04_c0410 = City._(id: 410, name: 'آران وبیدگل', stateId: 4);
final _p_04_c0411 = City._(id: 411, name: 'سفیدشهر', stateId: 4);
final _p_04_c0412 = City._(id: 412, name: 'نوش آباد', stateId: 4);
final _p_04_c0413 = City._(id: 413, name: 'حبیب آباد', stateId: 4);
final _p_04_c0414 = City._(id: 414, name: 'خورزوق', stateId: 4);
final _p_04_c0415 = City._(id: 415, name: 'دستگرد', stateId: 4);
final _p_04_c0416 = City._(id: 416, name: 'شاپورآباد', stateId: 4);
final _p_04_c0417 = City._(id: 417, name: 'کمشچه', stateId: 4);
final _p_04_c0418 = City._(id: 418, name: 'تیران', stateId: 4);
final _p_04_c0419 = City._(id: 419, name: 'رضوانشهر', stateId: 4);
final _p_04_c0527 = City._(id: 527, name: 'قمصر', stateId: 4);
final _p_04_c0529 = City._(id: 529, name: 'اژیه', stateId: 4);
final _p_04_c0531 = City._(id: 531, name: 'افوس', stateId: 4);
final _p_04_c0533 = City._(id: 533, name: 'ایمانشهر', stateId: 4);
final _p_04_c0555 = City._(id: 555, name: 'درچه', stateId: 4);
final _p_04_c0569 = City._(id: 569, name: 'عسگران', stateId: 4);
final _p_04_c0575 = City._(id: 575, name: 'قهدریجان', stateId: 4);
final _p_04_c0579 = City._(id: 579, name: 'گوگد', stateId: 4);
final _p_04_c0619 = City._(id: 619, name: 'کوهپایه', stateId: 4);
final _p_04_c0622 = City._(id: 622, name: 'نطنز', stateId: 4);
final _p_04_c0641 = City._(id: 641, name: 'ابریشم', stateId: 4);
final _p_04_c0650 = City._(id: 650, name: 'انارک', stateId: 4);
final _p_04_c0665 = City._(id: 665, name: 'بافران', stateId: 4);
final _p_04_c0668 = City._(id: 668, name: 'برزک', stateId: 4);
final _p_04_c0677 = City._(id: 677, name: 'بهاران شهر', stateId: 4);
final _p_04_c0683 = City._(id: 683, name: 'جندق', stateId: 4);
final _p_04_c0685 = City._(id: 685, name: 'جوزدان', stateId: 4);
final _p_04_c0704 = City._(id: 704, name: 'خوراسگان', stateId: 4);
final _p_04_c0709 = City._(id: 709, name: 'دامنه', stateId: 4);
final _p_04_c0718 = City._(id: 718, name: 'دهق', stateId: 4);
final _p_04_c0722 = City._(id: 722, name: 'دولت آباد', stateId: 4);
final _p_04_c0736 = City._(id: 736, name: 'زاینده رود', stateId: 4);
final _p_04_c0739 = City._(id: 739, name: 'زواره', stateId: 4);
final _p_04_c0750 = City._(id: 750, name: 'سگزی', stateId: 4);
final _p_04_c0768 = City._(id: 768, name: 'فرخی', stateId: 4);
final _p_04_c0771 = City._(id: 771, name: 'فریدونشهر', stateId: 4);
final _p_04_c0773 = City._(id: 773, name: 'فلاورجان', stateId: 4);
final _p_04_c0787 = City._(id: 787, name: 'کرکوند', stateId: 4);
final _p_04_c0794 = City._(id: 794, name: 'کمه', stateId: 4);
final _p_04_c0800 = City._(id: 800, name: 'کوشک', stateId: 4);
final _p_04_c0809 = City._(id: 809, name: 'گزبرخوار', stateId: 4);
final _p_04_c0810 = City._(id: 810, name: 'چادگان', stateId: 4);
final _p_04_c0811 = City._(id: 811, name: 'رزوه', stateId: 4);
final _p_04_c0812 = City._(id: 812, name: 'خمینی شهر', stateId: 4);
final _p_04_c0813 = City._(id: 813, name: 'خوانسار', stateId: 4);
final _p_04_c0814 = City._(id: 814, name: 'خور', stateId: 4);
final _p_04_c0815 = City._(id: 815, name: 'دهاقان', stateId: 4);
final _p_04_c0816 = City._(id: 816, name: 'گلشن', stateId: 4);
final _p_04_c0817 = City._(id: 817, name: 'حنا', stateId: 4);
final _p_04_c0818 = City._(id: 818, name: 'سمیرم', stateId: 4);
final _p_04_c0819 = City._(id: 819, name: 'شاهین شهر', stateId: 4);
final _p_04_c0820 = City._(id: 820, name: 'گرگاب', stateId: 4);
final _p_04_c0821 = City._(id: 821, name: 'لای بید', stateId: 4);
final _p_04_c0822 = City._(id: 822, name: 'وزوان', stateId: 4);
final _p_04_c0823 = City._(id: 823, name: 'شهرضا', stateId: 4);
final _p_04_c0824 = City._(id: 824, name: 'منظریه', stateId: 4);
final _p_04_c0825 = City._(id: 825, name: 'بویین ومیاندشت', stateId: 4);
final _p_04_c0826 = City._(id: 826, name: 'داران', stateId: 4);
final _p_04_c0827 = City._(id: 827, name: 'برف انبار', stateId: 4);
final _p_04_c0828 = City._(id: 828, name: 'پیربکران', stateId: 4);
final _p_04_c0829 = City._(id: 829, name: 'کلیشادوسودرجان', stateId: 4);
final _p_04_c0830 = City._(id: 830, name: 'جوشقان وکامو', stateId: 4);
final _p_04_c0831 = City._(id: 831, name: 'کاشان', stateId: 4);
final _p_04_c0832 = City._(id: 832, name: 'مشکات', stateId: 4);
final _p_04_c0833 = City._(id: 833, name: 'گلپایگان', stateId: 4);
final _p_04_c0834 = City._(id: 834, name: 'باغ بهادران', stateId: 4);
final _p_04_c0835 = City._(id: 835, name: 'چرمهین', stateId: 4);
final _p_04_c0836 = City._(id: 836, name: 'چمگردان', stateId: 4);
final _p_04_c0837 = City._(id: 837, name: 'زرین شهر', stateId: 4);
final _p_04_c0838 = City._(id: 838, name: 'سده لنجان', stateId: 4);
final _p_04_c0839 = City._(id: 839, name: 'فولادشهر', stateId: 4);
final _p_04_c0840 = City._(id: 840, name: 'دیزیچه', stateId: 4);
final _p_04_c0863 = City._(id: 863, name: 'مبارکه', stateId: 4);
final _p_04_c0864 = City._(id: 864, name: 'مجلسی', stateId: 4);
final _p_04_c0865 = City._(id: 865, name: 'نایین', stateId: 4);
final _p_04_c0866 = City._(id: 866, name: 'علویجه', stateId: 4);
final _p_04_c0867 = City._(id: 867, name: 'کهریزسنگ', stateId: 4);
final _p_04_c0868 = City._(id: 868, name: 'گلدشت', stateId: 4);
final _p_04_c0869 = City._(id: 869, name: 'نجف آباد', stateId: 4);
final _p_04_c0870 = City._(id: 870, name: 'بادرود', stateId: 4);
final _p_04_c0871 = City._(id: 871, name: 'خالدآباد', stateId: 4);
final _p_04_c0955 = City._(id: 955, name: 'زیباشهر', stateId: 4);
final _p_04_c1089 = City._(id: 1089, name: 'میمه', stateId: 4);
final _p_04_c1098 = City._(id: 1098, name: 'نیاسر', stateId: 4);
final _p_04_c1100 = City._(id: 1100, name: 'نیک آباد', stateId: 4);
final _p_04_c1111 = City._(id: 1111, name: 'ورزنه', stateId: 4);
final _p_04_c1112 = City._(id: 1112, name: 'ورنامخواست', stateId: 4);
final _p_04_c1113 = City._(id: 1113, name: 'ونک', stateId: 4);
final _p_04_c1139 = City._(id: 1139, name: 'گلشهر', stateId: 4);
final _prov_04 = Province._(id: 4, name: 'اصفهان', cities: [
  _p_04_c0113,
  _p_04_c0400,
  _p_04_c0401,
  _p_04_c0402,
  _p_04_c0403,
  _p_04_c0404,
  _p_04_c0405,
  _p_04_c0406,
  _p_04_c0407,
  _p_04_c0408,
  _p_04_c0409,
  _p_04_c0410,
  _p_04_c0411,
  _p_04_c0412,
  _p_04_c0413,
  _p_04_c0414,
  _p_04_c0415,
  _p_04_c0416,
  _p_04_c0417,
  _p_04_c0418,
  _p_04_c0419,
  _p_04_c0527,
  _p_04_c0529,
  _p_04_c0531,
  _p_04_c0533,
  _p_04_c0555,
  _p_04_c0569,
  _p_04_c0575,
  _p_04_c0579,
  _p_04_c0619,
  _p_04_c0622,
  _p_04_c0641,
  _p_04_c0650,
  _p_04_c0665,
  _p_04_c0668,
  _p_04_c0677,
  _p_04_c0683,
  _p_04_c0685,
  _p_04_c0704,
  _p_04_c0709,
  _p_04_c0718,
  _p_04_c0722,
  _p_04_c0736,
  _p_04_c0739,
  _p_04_c0750,
  _p_04_c0768,
  _p_04_c0771,
  _p_04_c0773,
  _p_04_c0787,
  _p_04_c0794,
  _p_04_c0800,
  _p_04_c0809,
  _p_04_c0810,
  _p_04_c0811,
  _p_04_c0812,
  _p_04_c0813,
  _p_04_c0814,
  _p_04_c0815,
  _p_04_c0816,
  _p_04_c0817,
  _p_04_c0818,
  _p_04_c0819,
  _p_04_c0820,
  _p_04_c0821,
  _p_04_c0822,
  _p_04_c0823,
  _p_04_c0824,
  _p_04_c0825,
  _p_04_c0826,
  _p_04_c0827,
  _p_04_c0828,
  _p_04_c0829,
  _p_04_c0830,
  _p_04_c0831,
  _p_04_c0832,
  _p_04_c0833,
  _p_04_c0834,
  _p_04_c0835,
  _p_04_c0836,
  _p_04_c0837,
  _p_04_c0838,
  _p_04_c0839,
  _p_04_c0840,
  _p_04_c0863,
  _p_04_c0864,
  _p_04_c0865,
  _p_04_c0866,
  _p_04_c0867,
  _p_04_c0868,
  _p_04_c0869,
  _p_04_c0870,
  _p_04_c0871,
  _p_04_c0955,
  _p_04_c1089,
  _p_04_c1098,
  _p_04_c1100,
  _p_04_c1111,
  _p_04_c1112,
  _p_04_c1113,
  _p_04_c1139
]);
final _p_05_c0545 = City._(id: 545, name: 'تنکمان', stateId: 5);
final _p_05_c0592 = City._(id: 592, name: 'ماهدشت', stateId: 5);
final _p_05_c0694 = City._(id: 694, name: 'چهارباغ', stateId: 5);
final _p_05_c0762 = City._(id: 762, name: 'شهرجدیدهشتگرد', stateId: 5);
final _p_05_c0803 = City._(id: 803, name: 'کوهسار', stateId: 5);
final _p_05_c0872 = City._(id: 872, name: 'هشتگرد', stateId: 5);
final _p_05_c0873 = City._(id: 873, name: 'طالقان', stateId: 5);
final _p_05_c0874 = City._(id: 874, name: 'اشتهارد', stateId: 5);
final _p_05_c0875 = City._(id: 875, name: 'آسارا', stateId: 5);
final _p_05_c0876 = City._(id: 876, name: 'کرج', stateId: 5);
final _p_05_c0877 = City._(id: 877, name: 'کمال شهر', stateId: 5);
final _p_05_c0879 = City._(id: 879, name: 'مشکین دشت', stateId: 5);
final _p_05_c0880 = City._(id: 880, name: 'نظرآباد', stateId: 5);
final _p_05_c1076 = City._(id: 1076, name: 'محمدشهر', stateId: 5);
final _p_05_c1138 = City._(id: 1138, name: 'گلسار', stateId: 5);
final _prov_05 = Province._(id: 5, name: 'البرز', cities: [
  _p_05_c0545,
  _p_05_c0592,
  _p_05_c0694,
  _p_05_c0762,
  _p_05_c0803,
  _p_05_c0872,
  _p_05_c0873,
  _p_05_c0874,
  _p_05_c0875,
  _p_05_c0876,
  _p_05_c0877,
  _p_05_c0879,
  _p_05_c0880,
  _p_05_c1076,
  _p_05_c1138
]);
final _p_06_c0547 = City._(id: 547, name: 'توحید', stateId: 6);
final _p_06_c0623 = City._(id: 623, name: 'ایوان', stateId: 6);
final _p_06_c0652 = City._(id: 652, name: 'آبدانان', stateId: 6);
final _p_06_c0657 = City._(id: 657, name: 'آسمان آباد', stateId: 6);
final _p_06_c0713 = City._(id: 713, name: 'دلگشا', stateId: 6);
final _p_06_c0744 = City._(id: 744, name: 'سراب باغ', stateId: 6);
final _p_06_c0881 = City._(id: 881, name: 'ایلام', stateId: 6);
final _p_06_c0882 = City._(id: 882, name: 'چوار', stateId: 6);
final _p_06_c0883 = City._(id: 883, name: 'زرنه', stateId: 6);
final _p_06_c0884 = City._(id: 884, name: 'بدره', stateId: 6);
final _p_06_c0885 = City._(id: 885, name: 'دره شهر', stateId: 6);
final _p_06_c0886 = City._(id: 886, name: 'پهله', stateId: 6);
final _p_06_c0887 = City._(id: 887, name: 'دهلران', stateId: 6);
final _p_06_c0888 = City._(id: 888, name: 'موسیان', stateId: 6);
final _p_06_c0889 = City._(id: 889, name: 'سرابله', stateId: 6);
final _p_06_c0890 = City._(id: 890, name: 'لومار', stateId: 6);
final _p_06_c0891 = City._(id: 891, name: 'ارکواز', stateId: 6);
final _p_06_c0892 = City._(id: 892, name: 'صالح آباد', stateId: 6);
final _p_06_c0893 = City._(id: 893, name: 'مهران', stateId: 6);
final _p_06_c1085 = City._(id: 1085, name: 'مورموری', stateId: 6);
final _p_06_c1090 = City._(id: 1090, name: 'میمه', stateId: 6);
final _prov_06 = Province._(id: 6, name: 'ایلام', cities: [
  _p_06_c0547,
  _p_06_c0623,
  _p_06_c0652,
  _p_06_c0657,
  _p_06_c0713,
  _p_06_c0744,
  _p_06_c0881,
  _p_06_c0882,
  _p_06_c0883,
  _p_06_c0884,
  _p_06_c0885,
  _p_06_c0886,
  _p_06_c0887,
  _p_06_c0888,
  _p_06_c0889,
  _p_06_c0890,
  _p_06_c0891,
  _p_06_c0892,
  _p_06_c0893,
  _p_06_c1085,
  _p_06_c1090
]);
final _p_07_c0559 = City._(id: 559, name: 'سعد آباد', stateId: 7);
final _p_07_c0667 = City._(id: 667, name: 'بردخون', stateId: 7);
final _p_07_c0674 = City._(id: 674, name: 'بندردیر', stateId: 7);
final _p_07_c0675 = City._(id: 675, name: 'بندرکنگان', stateId: 7);
final _p_07_c0691 = City._(id: 691, name: 'چغادک', stateId: 7);
final _p_07_c0699 = City._(id: 699, name: 'خارک', stateId: 7);
final _p_07_c0706 = City._(id: 706, name: 'خورموج', stateId: 7);
final _p_07_c0755 = City._(id: 755, name: 'شبانکاره', stateId: 7);
final _p_07_c0792 = City._(id: 792, name: 'کلمه', stateId: 7);
final _p_07_c0894 = City._(id: 894, name: 'بوشهر', stateId: 7);
final _p_07_c0895 = City._(id: 895, name: 'اهرم', stateId: 7);
final _p_07_c0896 = City._(id: 896, name: 'دلوار', stateId: 7);
final _p_07_c0897 = City._(id: 897, name: 'انارستان', stateId: 7);
final _p_07_c0898 = City._(id: 898, name: 'جم', stateId: 7);
final _p_07_c0899 = City._(id: 899, name: 'ریز', stateId: 7);
final _p_07_c0900 = City._(id: 900, name: 'آب پخش', stateId: 7);
final _p_07_c0901 = City._(id: 901, name: 'برازجان', stateId: 7);
final _p_07_c0902 = City._(id: 902, name: 'تنگ ارم', stateId: 7);
final _p_07_c0903 = City._(id: 903, name: 'دالکی', stateId: 7);
final _p_07_c0904 = City._(id: 904, name: 'وحدتیه', stateId: 7);
final _p_07_c0905 = City._(id: 905, name: 'شنبه', stateId: 7);
final _p_07_c0906 = City._(id: 906, name: 'کاکی', stateId: 7);
final _p_07_c0956 = City._(id: 956, name: 'آبدان', stateId: 7);
final _p_07_c0957 = City._(id: 957, name: 'بردستان', stateId: 7);
final _p_07_c0958 = City._(id: 958, name: 'امام حسن', stateId: 7);
final _p_07_c0959 = City._(id: 959, name: 'بندردیلم', stateId: 7);
final _p_07_c0960 = City._(id: 960, name: 'بنک', stateId: 7);
final _p_07_c0961 = City._(id: 961, name: 'سیراف', stateId: 7);
final _p_07_c0962 = City._(id: 962, name: 'عسلویه', stateId: 7);
final _p_07_c0963 = City._(id: 963, name: 'نخل تقی', stateId: 7);
final _p_07_c0964 = City._(id: 964, name: 'بندرریگ', stateId: 7);
final _p_07_c0965 = City._(id: 965, name: 'بندرگناوه', stateId: 7);
final _prov_07 = Province._(id: 7, name: 'بوشهر', cities: [
  _p_07_c0559,
  _p_07_c0667,
  _p_07_c0674,
  _p_07_c0675,
  _p_07_c0691,
  _p_07_c0699,
  _p_07_c0706,
  _p_07_c0755,
  _p_07_c0792,
  _p_07_c0894,
  _p_07_c0895,
  _p_07_c0896,
  _p_07_c0897,
  _p_07_c0898,
  _p_07_c0899,
  _p_07_c0900,
  _p_07_c0901,
  _p_07_c0902,
  _p_07_c0903,
  _p_07_c0904,
  _p_07_c0905,
  _p_07_c0906,
  _p_07_c0956,
  _p_07_c0957,
  _p_07_c0958,
  _p_07_c0959,
  _p_07_c0960,
  _p_07_c0961,
  _p_07_c0962,
  _p_07_c0963,
  _p_07_c0964,
  _p_07_c0965
]);
final _p_08_c0626 = City._(id: 626, name: 'بومهن', stateId: 8);
final _p_08_c0627 = City._(id: 627, name: 'پاکدشت', stateId: 8);
final _p_08_c0628 = City._(id: 628, name: 'ورامین', stateId: 8);
final _p_08_c0653 = City._(id: 653, name: 'آبسرد', stateId: 8);
final _p_08_c0714 = City._(id: 714, name: 'دماوند', stateId: 8);
final _p_08_c0770 = City._(id: 770, name: 'فرون آباد', stateId: 8);
final _p_08_c0776 = City._(id: 776, name: 'فیروزکوه', stateId: 8);
final _p_08_c0878 = City._(id: 878, name: 'گرمدره', stateId: 8);
final _p_08_c0966 = City._(id: 966, name: 'اسلامشهر', stateId: 8);
final _p_08_c0967 = City._(id: 967, name: 'چهاردانگه', stateId: 8);
final _p_08_c0968 = City._(id: 968, name: 'صالح آباد', stateId: 8);
final _p_08_c0969 = City._(id: 969, name: 'گلستان', stateId: 8);
final _p_08_c0970 = City._(id: 970, name: 'نسیم شهر', stateId: 8);
final _p_08_c0971 = City._(id: 971, name: 'شریف آباد', stateId: 8);
final _p_08_c0972 = City._(id: 972, name: 'پیشوا', stateId: 8);
final _p_08_c0973 = City._(id: 973, name: 'پردیس', stateId: 8);
final _p_08_c0974 = City._(id: 974, name: 'تهران', stateId: 8);
final _p_08_c0975 = City._(id: 975, name: 'آبعلی', stateId: 8);
final _p_08_c0976 = City._(id: 976, name: 'رودهن', stateId: 8);
final _p_08_c0977 = City._(id: 977, name: 'کیلان', stateId: 8);
final _p_08_c0978 = City._(id: 978, name: 'رباط کریم', stateId: 8);
final _p_08_c0979 = City._(id: 979, name: 'نصیرآباد', stateId: 8);
final _p_08_c0980 = City._(id: 980, name: 'باقرشهر', stateId: 8);
final _p_08_c0981 = City._(id: 981, name: 'حسن آباد', stateId: 8);
final _p_08_c0982 = City._(id: 982, name: 'کهریزک', stateId: 8);
final _p_08_c0983 = City._(id: 983, name: 'فشم', stateId: 8);
final _p_08_c0984 = City._(id: 984, name: 'لواسان', stateId: 8);
final _p_08_c0985 = City._(id: 985, name: 'اندیشه', stateId: 8);
final _p_08_c0986 = City._(id: 986, name: 'باغستان', stateId: 8);
final _p_08_c0987 = City._(id: 987, name: 'شاهدشهر', stateId: 8);
final _p_08_c0988 = City._(id: 988, name: 'شهریار', stateId: 8);
final _p_08_c0989 = City._(id: 989, name: 'فردوسیه', stateId: 8);
final _p_08_c0990 = City._(id: 990, name: 'وحیدیه', stateId: 8);
final _p_08_c0991 = City._(id: 991, name: 'ارجمند', stateId: 8);
final _p_08_c0992 = City._(id: 992, name: 'قدس', stateId: 8);
final _p_08_c0993 = City._(id: 993, name: 'صفادشت', stateId: 8);
final _p_08_c0994 = City._(id: 994, name: 'ملارد', stateId: 8);
final _p_08_c0995 = City._(id: 995, name: 'جوادآباد', stateId: 8);
final _p_08_c0996 = City._(id: 996, name: 'قرچک', stateId: 8);
final _p_08_c1066 = City._(id: 1066, name: 'سلطان آباد', stateId: 8);
final _p_08_c1136 = City._(id: 1136, name: 'صباشهر', stateId: 8);
final _p_08_c1144 = City._(id: 1144, name: 'پرند', stateId: 8);
final _p_08_c1145 = City._(id: 1145, name: 'ری', stateId: 8);
final _p_08_c1223 = City._(id: 1223, name: 'شمشک', stateId: 8);
final _prov_08 = Province._(id: 8, name: 'تهران', cities: [
  _p_08_c0626,
  _p_08_c0627,
  _p_08_c0628,
  _p_08_c0653,
  _p_08_c0714,
  _p_08_c0770,
  _p_08_c0776,
  _p_08_c0878,
  _p_08_c0966,
  _p_08_c0967,
  _p_08_c0968,
  _p_08_c0969,
  _p_08_c0970,
  _p_08_c0971,
  _p_08_c0972,
  _p_08_c0973,
  _p_08_c0974,
  _p_08_c0975,
  _p_08_c0976,
  _p_08_c0977,
  _p_08_c0978,
  _p_08_c0979,
  _p_08_c0980,
  _p_08_c0981,
  _p_08_c0982,
  _p_08_c0983,
  _p_08_c0984,
  _p_08_c0985,
  _p_08_c0986,
  _p_08_c0987,
  _p_08_c0988,
  _p_08_c0989,
  _p_08_c0990,
  _p_08_c0991,
  _p_08_c0992,
  _p_08_c0993,
  _p_08_c0994,
  _p_08_c0995,
  _p_08_c0996,
  _p_08_c1066,
  _p_08_c1136,
  _p_08_c1144,
  _p_08_c1145,
  _p_08_c1223
]);
final _p_09_c0528 = City._(id: 528, name: 'اردل', stateId: 9);
final _p_09_c0572 = City._(id: 572, name: 'فارسان', stateId: 9);
final _p_09_c0578 = City._(id: 578, name: 'گهرو', stateId: 9);
final _p_09_c0584 = City._(id: 584, name: 'لردگان', stateId: 9);
final _p_09_c0598 = City._(id: 598, name: 'نقنه', stateId: 9);
final _p_09_c0625 = City._(id: 625, name: 'کیان', stateId: 9);
final _p_09_c0660 = City._(id: 660, name: 'آلونی', stateId: 9);
final _p_09_c0686 = City._(id: 686, name: 'جونقان', stateId: 9);
final _p_09_c0740 = City._(id: 740, name: 'سامان', stateId: 9);
final _p_09_c0753 = City._(id: 753, name: 'سورشجان', stateId: 9);
final _p_09_c0757 = City._(id: 757, name: 'شلمزار', stateId: 9);
final _p_09_c0766 = City._(id: 766, name: 'فرادنبه', stateId: 9);
final _p_09_c0997 = City._(id: 997, name: 'بروجن', stateId: 9);
final _p_09_c0998 = City._(id: 998, name: 'بلداجی', stateId: 9);
final _p_09_c0999 = City._(id: 999, name: 'سفیددشت', stateId: 9);
final _p_09_c1000 = City._(id: 1000, name: 'گندمان', stateId: 9);
final _p_09_c1001 = City._(id: 1001, name: 'بن', stateId: 9);
final _p_09_c1002 = City._(id: 1002, name: 'سودجان', stateId: 9);
final _p_09_c1003 = City._(id: 1003, name: 'شهرکرد', stateId: 9);
final _p_09_c1004 = City._(id: 1004, name: 'طاقانک', stateId: 9);
final _p_09_c1005 = City._(id: 1005, name: 'فرخ شهر', stateId: 9);
final _p_09_c1006 = City._(id: 1006, name: 'هفشجان', stateId: 9);
final _p_09_c1007 = City._(id: 1007, name: 'باباحیدر', stateId: 9);
final _p_09_c1008 = City._(id: 1008, name: 'پردنجان', stateId: 9);
final _p_09_c1009 = City._(id: 1009, name: 'چلگرد', stateId: 9);
final _p_09_c1010 = City._(id: 1010, name: 'دستنا', stateId: 9);
final _p_09_c1011 = City._(id: 1011, name: 'ناغان', stateId: 9);
final _p_09_c1012 = City._(id: 1012, name: 'مال خلیفه', stateId: 9);
final _p_09_c1013 = City._(id: 1013, name: 'منج', stateId: 9);
final _p_09_c1092 = City._(id: 1092, name: 'نافچ', stateId: 9);
final _p_09_c1110 = City._(id: 1110, name: 'وردنجان', stateId: 9);
final _p_09_c1224 = City._(id: 1224, name: 'دشتک', stateId: 9);
final _p_09_c1225 = City._(id: 1225, name: 'سرخون', stateId: 9);
final _p_09_c1226 = City._(id: 1226, name: 'کاج', stateId: 9);
final _p_09_c1227 = City._(id: 1227, name: 'گوجان', stateId: 9);
final _p_09_c1228 = City._(id: 1228, name: 'چلیچه', stateId: 9);
final _p_09_c1229 = City._(id: 1229, name: 'صمصامی', stateId: 9);
final _p_09_c1230 = City._(id: 1230, name: 'بازفت', stateId: 9);
final _prov_09 = Province._(id: 9, name: 'چهارمحال وبختیاری', cities: [
  _p_09_c0528,
  _p_09_c0572,
  _p_09_c0578,
  _p_09_c0584,
  _p_09_c0598,
  _p_09_c0625,
  _p_09_c0660,
  _p_09_c0686,
  _p_09_c0740,
  _p_09_c0753,
  _p_09_c0757,
  _p_09_c0766,
  _p_09_c0997,
  _p_09_c0998,
  _p_09_c0999,
  _p_09_c1000,
  _p_09_c1001,
  _p_09_c1002,
  _p_09_c1003,
  _p_09_c1004,
  _p_09_c1005,
  _p_09_c1006,
  _p_09_c1007,
  _p_09_c1008,
  _p_09_c1009,
  _p_09_c1010,
  _p_09_c1011,
  _p_09_c1012,
  _p_09_c1013,
  _p_09_c1092,
  _p_09_c1110,
  _p_09_c1224,
  _p_09_c1225,
  _p_09_c1226,
  _p_09_c1227,
  _p_09_c1228,
  _p_09_c1229,
  _p_09_c1230
]);
final _p_10_c0114 = City._(id: 114, name: 'طبس مسینا', stateId: 10);
final _p_10_c0115 = City._(id: 115, name: 'زهان', stateId: 10);
final _p_10_c0371 = City._(id: 371, name: 'طبس', stateId: 10);
final _p_10_c0671 = City._(id: 671, name: 'بشرویه', stateId: 10);
final _p_10_c1014 = City._(id: 1014, name: 'ارسک', stateId: 10);
final _p_10_c1015 = City._(id: 1015, name: 'بیرجند', stateId: 10);
final _p_10_c1016 = City._(id: 1016, name: 'خوسف', stateId: 10);
final _p_10_c1017 = City._(id: 1017, name: 'محمدشهر', stateId: 10);
final _p_10_c1018 = City._(id: 1018, name: 'اسدیه', stateId: 10);
final _p_10_c1019 = City._(id: 1019, name: 'قهستان', stateId: 10);
final _p_10_c1020 = City._(id: 1020, name: 'گزیک', stateId: 10);
final _p_10_c1021 = City._(id: 1021, name: 'آیسک', stateId: 10);
final _p_10_c1022 = City._(id: 1022, name: 'سرایان', stateId: 10);
final _p_10_c1023 = City._(id: 1023, name: 'سه قلعه', stateId: 10);
final _p_10_c1024 = City._(id: 1024, name: 'سربیشه', stateId: 10);
final _p_10_c1025 = City._(id: 1025, name: 'مود', stateId: 10);
final _p_10_c1026 = City._(id: 1026, name: 'اسلامیه', stateId: 10);
final _p_10_c1027 = City._(id: 1027, name: 'فردوس', stateId: 10);
final _p_10_c1028 = City._(id: 1028, name: 'اسفدن', stateId: 10);
final _p_10_c1029 = City._(id: 1029, name: 'آرین شهر', stateId: 10);
final _p_10_c1030 = City._(id: 1030, name: 'حاجی آباد', stateId: 10);
final _p_10_c1031 = City._(id: 1031, name: 'خضری دشت بیاض', stateId: 10);
final _p_10_c1032 = City._(id: 1032, name: 'قاین', stateId: 10);
final _p_10_c1033 = City._(id: 1033, name: 'نیمبلوک', stateId: 10);
final _p_10_c1034 = City._(id: 1034, name: 'شوسف', stateId: 10);
final _p_10_c1035 = City._(id: 1035, name: 'نهبندان', stateId: 10);
final _prov_10 = Province._(id: 10, name: 'خراسان جنوبی', cities: [
  _p_10_c0114,
  _p_10_c0115,
  _p_10_c0371,
  _p_10_c0671,
  _p_10_c1014,
  _p_10_c1015,
  _p_10_c1016,
  _p_10_c1017,
  _p_10_c1018,
  _p_10_c1019,
  _p_10_c1020,
  _p_10_c1021,
  _p_10_c1022,
  _p_10_c1023,
  _p_10_c1024,
  _p_10_c1025,
  _p_10_c1026,
  _p_10_c1027,
  _p_10_c1028,
  _p_10_c1029,
  _p_10_c1030,
  _p_10_c1031,
  _p_10_c1032,
  _p_10_c1033,
  _p_10_c1034,
  _p_10_c1035
]);
final _p_11_c0108 = City._(id: 108, name: 'درگز', stateId: 11);
final _p_11_c0109 = City._(id: 109, name: 'شهرزو', stateId: 11);
final _p_11_c0116 = City._(id: 116, name: 'شاندیز', stateId: 11);
final _p_11_c0117 = City._(id: 117, name: 'نیل شهر', stateId: 11);
final _p_11_c0118 = City._(id: 118, name: 'قاسم آباد', stateId: 11);
final _p_11_c0585 = City._(id: 585, name: 'لطف آباد', stateId: 11);
final _p_11_c0730 = City._(id: 730, name: 'رشتخوار', stateId: 11);
final _p_11_c0734 = City._(id: 734, name: 'روداب', stateId: 11);
final _p_11_c0745 = City._(id: 745, name: 'سرخس', stateId: 11);
final _p_11_c0778 = City._(id: 778, name: 'قدمگاه', stateId: 11);
final _p_11_c0790 = City._(id: 790, name: 'کلات', stateId: 11);
final _p_11_c0841 = City._(id: 841, name: 'نوخندان', stateId: 11);
final _p_11_c0842 = City._(id: 842, name: 'جنگل', stateId: 11);
final _p_11_c0843 = City._(id: 843, name: 'دولت آباد', stateId: 11);
final _p_11_c0844 = City._(id: 844, name: 'داورزن', stateId: 11);
final _p_11_c0845 = City._(id: 845, name: 'سبزوار', stateId: 11);
final _p_11_c0846 = City._(id: 846, name: 'ششتمد', stateId: 11);
final _p_11_c0847 = City._(id: 847, name: 'مزدآوند', stateId: 11);
final _p_11_c0848 = City._(id: 848, name: 'سفیدسنگ', stateId: 11);
final _p_11_c0849 = City._(id: 849, name: 'فرهادگرد', stateId: 11);
final _p_11_c0850 = City._(id: 850, name: 'فریمان', stateId: 11);
final _p_11_c0851 = City._(id: 851, name: 'قلندرآباد', stateId: 11);
final _p_11_c0852 = City._(id: 852, name: 'باجگیران', stateId: 11);
final _p_11_c0853 = City._(id: 853, name: 'قوچان', stateId: 11);
final _p_11_c0854 = City._(id: 854, name: 'ریوش', stateId: 11);
final _p_11_c0855 = City._(id: 855, name: 'کاشمر', stateId: 11);
final _p_11_c0856 = City._(id: 856, name: 'بیدخت', stateId: 11);
final _p_11_c0857 = City._(id: 857, name: 'کاخک', stateId: 11);
final _p_11_c0858 = City._(id: 858, name: 'گناباد', stateId: 11);
final _p_11_c0859 = City._(id: 859, name: 'رضویه', stateId: 11);
final _p_11_c0860 = City._(id: 860, name: 'مشهد', stateId: 11);
final _p_11_c0861 = City._(id: 861, name: 'ملک آباد', stateId: 11);
final _p_11_c0862 = City._(id: 862, name: 'شادمهر', stateId: 11);
final _p_11_c0907 = City._(id: 907, name: 'فیض آباد', stateId: 11);
final _p_11_c0908 = City._(id: 908, name: 'بار', stateId: 11);
final _p_11_c0909 = City._(id: 909, name: 'چکنه', stateId: 11);
final _p_11_c0910 = City._(id: 910, name: 'خرو', stateId: 11);
final _p_11_c0911 = City._(id: 911, name: 'درود', stateId: 11);
final _p_11_c0912 = City._(id: 912, name: 'عشق آباد', stateId: 11);
final _p_11_c0913 = City._(id: 913, name: 'نیشابور', stateId: 11);
final _p_11_c1036 = City._(id: 1036, name: 'باخرز', stateId: 11);
final _p_11_c1037 = City._(id: 1037, name: 'بجستان', stateId: 11);
final _p_11_c1038 = City._(id: 1038, name: 'یونسی', stateId: 11);
final _p_11_c1039 = City._(id: 1039, name: 'انابد', stateId: 11);
final _p_11_c1040 = City._(id: 1040, name: 'بردسکن', stateId: 11);
final _p_11_c1041 = City._(id: 1041, name: 'شهرآباد', stateId: 11);
final _p_11_c1042 = City._(id: 1042, name: 'طرقبه', stateId: 11);
final _p_11_c1043 = City._(id: 1043, name: 'تایباد', stateId: 11);
final _p_11_c1044 = City._(id: 1044, name: 'کاریز', stateId: 11);
final _p_11_c1045 = City._(id: 1045, name: 'مشهدریزه', stateId: 11);
final _p_11_c1046 = City._(id: 1046, name: 'فیروزه', stateId: 11);
final _p_11_c1047 = City._(id: 1047, name: 'همت آباد', stateId: 11);
final _p_11_c1048 = City._(id: 1048, name: 'احمدابادصولت', stateId: 11);
final _p_11_c1049 = City._(id: 1049, name: 'تربت جام', stateId: 11);
final _p_11_c1050 = City._(id: 1050, name: 'صالح آباد', stateId: 11);
final _p_11_c1051 = City._(id: 1051, name: 'نصرآباد', stateId: 11);
final _p_11_c1052 = City._(id: 1052, name: 'بایک', stateId: 11);
final _p_11_c1053 = City._(id: 1053, name: 'تربت حیدریه', stateId: 11);
final _p_11_c1054 = City._(id: 1054, name: 'رباط سنگ', stateId: 11);
final _p_11_c1055 = City._(id: 1055, name: 'کدکن', stateId: 11);
final _p_11_c1056 = City._(id: 1056, name: 'جغتای', stateId: 11);
final _p_11_c1057 = City._(id: 1057, name: 'نقاب', stateId: 11);
final _p_11_c1058 = City._(id: 1058, name: 'چناران', stateId: 11);
final _p_11_c1059 = City._(id: 1059, name: 'گلمکان', stateId: 11);
final _p_11_c1060 = City._(id: 1060, name: 'خلیل آباد', stateId: 11);
final _p_11_c1061 = City._(id: 1061, name: 'کندر', stateId: 11);
final _p_11_c1062 = City._(id: 1062, name: 'خواف', stateId: 11);
final _p_11_c1063 = City._(id: 1063, name: 'سلامی', stateId: 11);
final _p_11_c1064 = City._(id: 1064, name: 'سنگان', stateId: 11);
final _p_11_c1065 = City._(id: 1065, name: 'نشتیفان', stateId: 11);
final _p_11_c1067 = City._(id: 1067, name: 'چاپشلو', stateId: 11);
final _p_11_c1081 = City._(id: 1081, name: 'مشهد ثامن', stateId: 11);
final _prov_11 = Province._(id: 11, name: 'خراسان رضوی', cities: [
  _p_11_c0108,
  _p_11_c0109,
  _p_11_c0116,
  _p_11_c0117,
  _p_11_c0118,
  _p_11_c0585,
  _p_11_c0730,
  _p_11_c0734,
  _p_11_c0745,
  _p_11_c0778,
  _p_11_c0790,
  _p_11_c0841,
  _p_11_c0842,
  _p_11_c0843,
  _p_11_c0844,
  _p_11_c0845,
  _p_11_c0846,
  _p_11_c0847,
  _p_11_c0848,
  _p_11_c0849,
  _p_11_c0850,
  _p_11_c0851,
  _p_11_c0852,
  _p_11_c0853,
  _p_11_c0854,
  _p_11_c0855,
  _p_11_c0856,
  _p_11_c0857,
  _p_11_c0858,
  _p_11_c0859,
  _p_11_c0860,
  _p_11_c0861,
  _p_11_c0862,
  _p_11_c0907,
  _p_11_c0908,
  _p_11_c0909,
  _p_11_c0910,
  _p_11_c0911,
  _p_11_c0912,
  _p_11_c0913,
  _p_11_c1036,
  _p_11_c1037,
  _p_11_c1038,
  _p_11_c1039,
  _p_11_c1040,
  _p_11_c1041,
  _p_11_c1042,
  _p_11_c1043,
  _p_11_c1044,
  _p_11_c1045,
  _p_11_c1046,
  _p_11_c1047,
  _p_11_c1048,
  _p_11_c1049,
  _p_11_c1050,
  _p_11_c1051,
  _p_11_c1052,
  _p_11_c1053,
  _p_11_c1054,
  _p_11_c1055,
  _p_11_c1056,
  _p_11_c1057,
  _p_11_c1058,
  _p_11_c1059,
  _p_11_c1060,
  _p_11_c1061,
  _p_11_c1062,
  _p_11_c1063,
  _p_11_c1064,
  _p_11_c1065,
  _p_11_c1067,
  _p_11_c1081
]);
final _p_12_c0535 = City._(id: 535, name: 'ایور', stateId: 12);
final _p_12_c0541 = City._(id: 541, name: 'پیش قلعه', stateId: 12);
final _p_12_c0550 = City._(id: 550, name: 'تیتکانلو', stateId: 12);
final _p_12_c0568 = City._(id: 568, name: 'صفی آباد', stateId: 12);
final _p_12_c0587 = City._(id: 587, name: 'لوجلی', stateId: 12);
final _p_12_c0637 = City._(id: 637, name: 'آشخانه', stateId: 12);
final _p_12_c0724 = City._(id: 724, name: 'راز', stateId: 12);
final _p_12_c0752 = City._(id: 752, name: 'سنخواست', stateId: 12);
final _p_12_c0808 = City._(id: 808, name: 'گرمه', stateId: 12);
final _p_12_c0914 = City._(id: 914, name: 'اسفراین', stateId: 12);
final _p_12_c0915 = City._(id: 915, name: 'بجنورد', stateId: 12);
final _p_12_c0916 = City._(id: 916, name: 'حصارگرمخان', stateId: 12);
final _p_12_c0917 = City._(id: 917, name: 'جاجرم', stateId: 12);
final _p_12_c0918 = City._(id: 918, name: 'شوقان', stateId: 12);
final _p_12_c0919 = City._(id: 919, name: 'شیروان', stateId: 12);
final _p_12_c0920 = City._(id: 920, name: 'فاروج', stateId: 12);
final _p_12_c0921 = City._(id: 921, name: 'درق', stateId: 12);
final _p_12_c0922 = City._(id: 922, name: 'قاضی', stateId: 12);
final _prov_12 = Province._(id: 12, name: 'خراسان شمالی', cities: [
  _p_12_c0535,
  _p_12_c0541,
  _p_12_c0550,
  _p_12_c0568,
  _p_12_c0587,
  _p_12_c0637,
  _p_12_c0724,
  _p_12_c0752,
  _p_12_c0808,
  _p_12_c0914,
  _p_12_c0915,
  _p_12_c0916,
  _p_12_c0917,
  _p_12_c0918,
  _p_12_c0919,
  _p_12_c0920,
  _p_12_c0921,
  _p_12_c0922
]);
final _p_13_c0090 = City._(id: 90, name: 'سماله', stateId: 13);
final _p_13_c0110 = City._(id: 110, name: 'جایزان', stateId: 13);
final _p_13_c0111 = City._(id: 111, name: 'سالند', stateId: 13);
final _p_13_c0112 = City._(id: 112, name: 'حر', stateId: 13);
final _p_13_c0480 = City._(id: 480, name: 'ترکالکی', stateId: 13);
final _p_13_c0481 = City._(id: 481, name: 'گتوند', stateId: 13);
final _p_13_c0482 = City._(id: 482, name: 'مسجدسلیمان', stateId: 13);
final _p_13_c0483 = City._(id: 483, name: 'هندیجان', stateId: 13);
final _p_13_c0484 = City._(id: 484, name: 'رفیع', stateId: 13);
final _p_13_c0556 = City._(id: 556, name: 'دزآب', stateId: 13);
final _p_13_c0565 = City._(id: 565, name: 'شادگان', stateId: 13);
final _p_13_c0583 = City._(id: 583, name: 'لالی', stateId: 13);
final _p_13_c0594 = City._(id: 594, name: 'ملاثانی', stateId: 13);
final _p_13_c0624 = City._(id: 624, name: 'سوسنگرد', stateId: 13);
final _p_13_c0632 = City._(id: 632, name: 'آغاجاری', stateId: 13);
final _p_13_c0648 = City._(id: 648, name: 'الوان', stateId: 13);
final _p_13_c0663 = City._(id: 663, name: 'باغ ملک', stateId: 13);
final _p_13_c0682 = City._(id: 682, name: 'جنت مکان', stateId: 13);
final _p_13_c0692 = City._(id: 692, name: 'چمران', stateId: 13);
final _p_13_c0696 = City._(id: 696, name: 'حسینیه', stateId: 13);
final _p_13_c0697 = City._(id: 697, name: 'حمیدیه', stateId: 13);
final _p_13_c0726 = City._(id: 726, name: 'رامهرمز', stateId: 13);
final _p_13_c0756 = City._(id: 756, name: 'شرافت', stateId: 13);
final _p_13_c0764 = City._(id: 764, name: 'شیبان', stateId: 13);
final _p_13_c0923 = City._(id: 923, name: 'امیدیه', stateId: 13);
final _p_13_c0924 = City._(id: 924, name: 'قلعه خواجه', stateId: 13);
final _p_13_c0925 = City._(id: 925, name: 'اندیمشک', stateId: 13);
final _p_13_c0926 = City._(id: 926, name: 'اهواز', stateId: 13);
final _p_13_c0927 = City._(id: 927, name: 'ایذه', stateId: 13);
final _p_13_c0928 = City._(id: 928, name: 'دهدز', stateId: 13);
final _p_13_c0929 = City._(id: 929, name: 'اروندکنار', stateId: 13);
final _p_13_c0930 = City._(id: 930, name: 'آبادان', stateId: 13);
final _p_13_c0931 = City._(id: 931, name: 'چویبده', stateId: 13);
final _p_13_c0932 = City._(id: 932, name: 'صیدون', stateId: 13);
final _p_13_c0933 = City._(id: 933, name: 'قلعه تل', stateId: 13);
final _p_13_c0934 = City._(id: 934, name: 'ویس', stateId: 13);
final _p_13_c0935 = City._(id: 935, name: 'بندرامام خمینی', stateId: 13);
final _p_13_c0936 = City._(id: 936, name: 'بندرماهشهر', stateId: 13);
final _p_13_c0937 = City._(id: 937, name: 'بهبهان', stateId: 13);
final _p_13_c0938 = City._(id: 938, name: 'سردشت', stateId: 13);
final _p_13_c0939 = City._(id: 939, name: 'خرمشهر', stateId: 13);
final _p_13_c0940 = City._(id: 940, name: 'مینوشهر', stateId: 13);
final _p_13_c0941 = City._(id: 941, name: 'چغامیش', stateId: 13);
final _p_13_c0942 = City._(id: 942, name: 'حمزه', stateId: 13);
final _p_13_c0943 = City._(id: 943, name: 'دزفول', stateId: 13);
final _p_13_c0944 = City._(id: 944, name: 'صفی آباد', stateId: 13);
final _p_13_c0945 = City._(id: 945, name: 'میانرود', stateId: 13);
final _p_13_c0946 = City._(id: 946, name: 'بستان', stateId: 13);
final _p_13_c0947 = City._(id: 947, name: 'رامشیر', stateId: 13);
final _p_13_c0948 = City._(id: 948, name: 'مشراگه', stateId: 13);
final _p_13_c0949 = City._(id: 949, name: 'دارخوین', stateId: 13);
final _p_13_c0950 = City._(id: 950, name: 'شاوور', stateId: 13);
final _p_13_c0951 = City._(id: 951, name: 'شوش', stateId: 13);
final _p_13_c0952 = City._(id: 952, name: 'صالح مشطت', stateId: 13);
final _p_13_c0953 = City._(id: 953, name: 'شوشتر', stateId: 13);
final _p_13_c0954 = City._(id: 954, name: 'گوریه', stateId: 13);
final _p_13_c1087 = City._(id: 1087, name: 'میداود', stateId: 13);
final _p_13_c1105 = City._(id: 1105, name: 'هفتگل', stateId: 13);
final _p_13_c1107 = City._(id: 1107, name: 'هویزه', stateId: 13);
final _p_13_c1132 = City._(id: 1132, name: 'زهره', stateId: 13);
final _p_13_c1135 = City._(id: 1135, name: 'صالح شهر', stateId: 13);
final _prov_13 = Province._(id: 13, name: 'خوزستان', cities: [
  _p_13_c0090,
  _p_13_c0110,
  _p_13_c0111,
  _p_13_c0112,
  _p_13_c0480,
  _p_13_c0481,
  _p_13_c0482,
  _p_13_c0483,
  _p_13_c0484,
  _p_13_c0556,
  _p_13_c0565,
  _p_13_c0583,
  _p_13_c0594,
  _p_13_c0624,
  _p_13_c0632,
  _p_13_c0648,
  _p_13_c0663,
  _p_13_c0682,
  _p_13_c0692,
  _p_13_c0696,
  _p_13_c0697,
  _p_13_c0726,
  _p_13_c0756,
  _p_13_c0764,
  _p_13_c0923,
  _p_13_c0924,
  _p_13_c0925,
  _p_13_c0926,
  _p_13_c0927,
  _p_13_c0928,
  _p_13_c0929,
  _p_13_c0930,
  _p_13_c0931,
  _p_13_c0932,
  _p_13_c0933,
  _p_13_c0934,
  _p_13_c0935,
  _p_13_c0936,
  _p_13_c0937,
  _p_13_c0938,
  _p_13_c0939,
  _p_13_c0940,
  _p_13_c0941,
  _p_13_c0942,
  _p_13_c0943,
  _p_13_c0944,
  _p_13_c0945,
  _p_13_c0946,
  _p_13_c0947,
  _p_13_c0948,
  _p_13_c0949,
  _p_13_c0950,
  _p_13_c0951,
  _p_13_c0952,
  _p_13_c0953,
  _p_13_c0954,
  _p_13_c1087,
  _p_13_c1105,
  _p_13_c1107,
  _p_13_c1132,
  _p_13_c1135
]);
final _p_14_c0091 = City._(id: 91, name: 'صایین قلعه', stateId: 14);
final _p_14_c0485 = City._(id: 485, name: 'ابهر', stateId: 14);
final _p_14_c0486 = City._(id: 486, name: 'هیدج', stateId: 14);
final _p_14_c0487 = City._(id: 487, name: 'حلب', stateId: 14);
final _p_14_c0488 = City._(id: 488, name: 'زرین رود', stateId: 14);
final _p_14_c0489 = City._(id: 489, name: 'سهرورد', stateId: 14);
final _p_14_c0490 = City._(id: 490, name: 'گرماب', stateId: 14);
final _p_14_c0491 = City._(id: 491, name: 'خرمدره', stateId: 14);
final _p_14_c0492 = City._(id: 492, name: 'ارمغانخانه', stateId: 14);
final _p_14_c0493 = City._(id: 493, name: 'زنجان', stateId: 14);
final _p_14_c0494 = City._(id: 494, name: 'آب بر', stateId: 14);
final _p_14_c0495 = City._(id: 495, name: 'چورزق', stateId: 14);
final _p_14_c0496 = City._(id: 496, name: 'دندی', stateId: 14);
final _p_14_c0591 = City._(id: 591, name: 'ماه نشان', stateId: 14);
final _p_14_c0620 = City._(id: 620, name: 'قیدار', stateId: 14);
final _p_14_c0738 = City._(id: 738, name: 'زرین آباد', stateId: 14);
final _p_14_c0743 = City._(id: 743, name: 'سجاس', stateId: 14);
final _p_14_c0751 = City._(id: 751, name: 'سلطانیه', stateId: 14);
final _prov_14 = Province._(id: 14, name: 'زنجان', cities: [
  _p_14_c0091,
  _p_14_c0485,
  _p_14_c0486,
  _p_14_c0487,
  _p_14_c0488,
  _p_14_c0489,
  _p_14_c0490,
  _p_14_c0491,
  _p_14_c0492,
  _p_14_c0493,
  _p_14_c0494,
  _p_14_c0495,
  _p_14_c0496,
  _p_14_c0591,
  _p_14_c0620,
  _p_14_c0738,
  _p_14_c0743,
  _p_14_c0751
]);
final _p_15_c0092 = City._(id: 92, name: 'امیریه', stateId: 15);
final _p_15_c0093 = City._(id: 93, name: 'درجزین', stateId: 15);
final _p_15_c0497 = City._(id: 497, name: 'دامغان', stateId: 15);
final _p_15_c0498 = City._(id: 498, name: 'دیباج', stateId: 15);
final _p_15_c0499 = City._(id: 499, name: 'سرخه', stateId: 15);
final _p_15_c0500 = City._(id: 500, name: 'سمنان', stateId: 15);
final _p_15_c0501 = City._(id: 501, name: 'بسطام', stateId: 15);
final _p_15_c0502 = City._(id: 502, name: 'بیارجمند', stateId: 15);
final _p_15_c0503 = City._(id: 503, name: 'شاهرود', stateId: 15);
final _p_15_c0504 = City._(id: 504, name: 'کلاته خیج', stateId: 15);
final _p_15_c0505 = City._(id: 505, name: 'مجن', stateId: 15);
final _p_15_c0506 = City._(id: 506, name: 'میامی', stateId: 15);
final _p_15_c0507 = City._(id: 507, name: 'ایوانکی', stateId: 15);
final _p_15_c0508 = City._(id: 508, name: 'شهمیرزاد', stateId: 15);
final _p_15_c0509 = City._(id: 509, name: 'مهدی شهر', stateId: 15);
final _p_15_c0655 = City._(id: 655, name: 'آرادان', stateId: 15);
final _p_15_c0807 = City._(id: 807, name: 'گرمسار', stateId: 15);
final _prov_15 = Province._(id: 15, name: 'سمنان', cities: [
  _p_15_c0092,
  _p_15_c0093,
  _p_15_c0497,
  _p_15_c0498,
  _p_15_c0499,
  _p_15_c0500,
  _p_15_c0501,
  _p_15_c0502,
  _p_15_c0503,
  _p_15_c0504,
  _p_15_c0505,
  _p_15_c0506,
  _p_15_c0507,
  _p_15_c0508,
  _p_15_c0509,
  _p_15_c0655,
  _p_15_c0807
]);
final _p_16_c0001 = City._(id: 1, name: 'زابلی', stateId: 16);
final _p_16_c0002 = City._(id: 2, name: 'بنت', stateId: 16);
final _p_16_c0003 = City._(id: 3, name: 'فنوج', stateId: 16);
final _p_16_c0004 = City._(id: 4, name: 'ادیمی', stateId: 16);
final _p_16_c0005 = City._(id: 5, name: 'علی اکبر', stateId: 16);
final _p_16_c0006 = City._(id: 6, name: 'محمدآباد', stateId: 16);
final _p_16_c0007 = City._(id: 7, name: 'دوست محمد', stateId: 16);
final _p_16_c0094 = City._(id: 94, name: 'نصرت آباد', stateId: 16);
final _p_16_c0510 = City._(id: 510, name: 'محمدان', stateId: 16);
final _p_16_c0511 = City._(id: 511, name: 'چابهار', stateId: 16);
final _p_16_c0512 = City._(id: 512, name: 'خاش', stateId: 16);
final _p_16_c0513 = City._(id: 513, name: 'گلمورتی', stateId: 16);
final _p_16_c0514 = City._(id: 514, name: 'بنجار', stateId: 16);
final _p_16_c0515 = City._(id: 515, name: 'زابل', stateId: 16);
final _p_16_c0516 = City._(id: 516, name: 'زاهدان', stateId: 16);
final _p_16_c0517 = City._(id: 517, name: 'میرجاوه', stateId: 16);
final _p_16_c0518 = City._(id: 518, name: 'زهک', stateId: 16);
final _p_16_c0519 = City._(id: 519, name: 'سراوان', stateId: 16);
final _p_16_c0520 = City._(id: 520, name: 'گشت', stateId: 16);
final _p_16_c0521 = City._(id: 521, name: 'پیشین', stateId: 16);
final _p_16_c0522 = City._(id: 522, name: 'سرباز', stateId: 16);
final _p_16_c0523 = City._(id: 523, name: 'سوران', stateId: 16);
final _p_16_c0524 = City._(id: 524, name: 'هیدوچ', stateId: 16);
final _p_16_c0525 = City._(id: 525, name: 'زرآباد', stateId: 16);
final _p_16_c0526 = City._(id: 526, name: 'کنارک', stateId: 16);
final _p_16_c0551 = City._(id: 551, name: 'جالق', stateId: 16);
final _p_16_c0561 = City._(id: 561, name: 'سیرکان', stateId: 16);
final _p_16_c0599 = City._(id: 599, name: 'نگور', stateId: 16);
final _p_16_c0602 = City._(id: 602, name: 'نوک آباد', stateId: 16);
final _p_16_c0621 = City._(id: 621, name: 'ایرانشهر', stateId: 16);
final _p_16_c0644 = City._(id: 644, name: 'اسپکه', stateId: 16);
final _p_16_c0669 = City._(id: 669, name: 'بزمان', stateId: 16);
final _p_16_c0673 = City._(id: 673, name: 'بمپور', stateId: 16);
final _p_16_c0725 = City._(id: 725, name: 'راسک', stateId: 16);
final _p_16_c0781 = City._(id: 781, name: 'قصرقند', stateId: 16);
final _p_16_c1077 = City._(id: 1077, name: 'محمدی', stateId: 16);
final _p_16_c1101 = City._(id: 1101, name: 'نیک شهر', stateId: 16);
final _prov_16 = Province._(id: 16, name: 'سیستان وبلوچستان', cities: [
  _p_16_c0001,
  _p_16_c0002,
  _p_16_c0003,
  _p_16_c0004,
  _p_16_c0005,
  _p_16_c0006,
  _p_16_c0007,
  _p_16_c0094,
  _p_16_c0510,
  _p_16_c0511,
  _p_16_c0512,
  _p_16_c0513,
  _p_16_c0514,
  _p_16_c0515,
  _p_16_c0516,
  _p_16_c0517,
  _p_16_c0518,
  _p_16_c0519,
  _p_16_c0520,
  _p_16_c0521,
  _p_16_c0522,
  _p_16_c0523,
  _p_16_c0524,
  _p_16_c0525,
  _p_16_c0526,
  _p_16_c0551,
  _p_16_c0561,
  _p_16_c0599,
  _p_16_c0602,
  _p_16_c0621,
  _p_16_c0644,
  _p_16_c0669,
  _p_16_c0673,
  _p_16_c0725,
  _p_16_c0781,
  _p_16_c1077,
  _p_16_c1101
]);
final _p_17_c0008 = City._(id: 8, name: 'استهبان', stateId: 17);
final _p_17_c0009 = City._(id: 9, name: 'ایج', stateId: 17);
final _p_17_c0010 = City._(id: 10, name: 'رونیز', stateId: 17);
final _p_17_c0011 = City._(id: 11, name: 'اقلید', stateId: 17);
final _p_17_c0012 = City._(id: 12, name: 'حسن آباد', stateId: 17);
final _p_17_c0013 = City._(id: 13, name: 'دژکرد', stateId: 17);
final _p_17_c0014 = City._(id: 14, name: 'سده', stateId: 17);
final _p_17_c0015 = City._(id: 15, name: 'ایزدخواست', stateId: 17);
final _p_17_c0016 = City._(id: 16, name: 'آباده', stateId: 17);
final _p_17_c0017 = City._(id: 17, name: 'بهمن', stateId: 17);
final _p_17_c0018 = City._(id: 18, name: 'سورمق', stateId: 17);
final _p_17_c0019 = City._(id: 19, name: 'صغاد', stateId: 17);
final _p_17_c0020 = City._(id: 20, name: 'حسامی', stateId: 17);
final _p_17_c0021 = City._(id: 21, name: 'کره ای', stateId: 17);
final _p_17_c0022 = City._(id: 22, name: 'سعادت شهر', stateId: 17);
final _p_17_c0023 = City._(id: 23, name: 'باب انار', stateId: 17);
final _p_17_c0024 = City._(id: 24, name: 'جهرم', stateId: 17);
final _p_17_c0025 = City._(id: 25, name: 'دوزه', stateId: 17);
final _p_17_c0026 = City._(id: 26, name: 'قطب آباد', stateId: 17);
final _p_17_c0027 = City._(id: 27, name: 'خرامه', stateId: 17);
final _p_17_c0028 = City._(id: 28, name: 'صفاشهر', stateId: 17);
final _p_17_c0029 = City._(id: 29, name: 'قادرآباد', stateId: 17);
final _p_17_c0030 = City._(id: 30, name: 'جنت شهر', stateId: 17);
final _p_17_c0031 = City._(id: 31, name: 'فدامی', stateId: 17);
final _p_17_c0032 = City._(id: 32, name: 'مصیری', stateId: 17);
final _p_17_c0033 = City._(id: 33, name: 'اردکان', stateId: 17);
final _p_17_c0034 = City._(id: 34, name: 'بیضا', stateId: 17);
final _p_17_c0035 = City._(id: 35, name: 'هماشهر', stateId: 17);
final _p_17_c0036 = City._(id: 36, name: 'سروستان', stateId: 17);
final _p_17_c0037 = City._(id: 37, name: 'کوهنجان', stateId: 17);
final _p_17_c0038 = City._(id: 38, name: 'خانه زنیان', stateId: 17);
final _p_17_c0039 = City._(id: 39, name: 'زرقان', stateId: 17);
final _p_17_c0040 = City._(id: 40, name: 'شهرصدرا', stateId: 17);
final _p_17_c0041 = City._(id: 41, name: 'شیراز', stateId: 17);
final _p_17_c0042 = City._(id: 42, name: 'دهرم', stateId: 17);
final _p_17_c0043 = City._(id: 43, name: 'ششده', stateId: 17);
final _p_17_c0044 = City._(id: 44, name: 'فسا', stateId: 17);
final _p_17_c0045 = City._(id: 45, name: 'افزر', stateId: 17);
final _p_17_c0046 = City._(id: 46, name: 'بالاده', stateId: 17);
final _p_17_c0047 = City._(id: 47, name: 'خشت', stateId: 17);
final _p_17_c0048 = City._(id: 48, name: 'کازرون', stateId: 17);
final _p_17_c0049 = City._(id: 49, name: 'نودان', stateId: 17);
final _p_17_c0050 = City._(id: 50, name: 'گراش', stateId: 17);
final _p_17_c0051 = City._(id: 51, name: 'اوز', stateId: 17);
final _p_17_c0052 = City._(id: 52, name: 'بیرم', stateId: 17);
final _p_17_c0053 = City._(id: 53, name: 'خور', stateId: 17);
final _p_17_c0054 = City._(id: 54, name: 'عمادده', stateId: 17);
final _p_17_c0055 = City._(id: 55, name: 'لار', stateId: 17);
final _p_17_c0056 = City._(id: 56, name: 'لامرد', stateId: 17);
final _p_17_c0057 = City._(id: 57, name: 'رامجرد', stateId: 17);
final _p_17_c0058 = City._(id: 58, name: 'سیدان', stateId: 17);
final _p_17_c0059 = City._(id: 59, name: 'مرودشت', stateId: 17);
final _p_17_c0060 = City._(id: 60, name: 'خومه زار', stateId: 17);
final _p_17_c0061 = City._(id: 61, name: 'نورآباد', stateId: 17);
final _p_17_c0062 = City._(id: 62, name: 'وراوی', stateId: 17);
final _p_17_c0063 = City._(id: 63, name: 'قطرویه', stateId: 17);
final _p_17_c0064 = City._(id: 64, name: 'مشکان', stateId: 17);
final _p_17_c0095 = City._(id: 95, name: 'اهل', stateId: 17);
final _p_17_c0096 = City._(id: 96, name: 'گله دار', stateId: 17);
final _p_17_c0636 = City._(id: 636, name: 'اشکنان', stateId: 17);
final _p_17_c0643 = City._(id: 643, name: 'ارسنجان', stateId: 17);
final _p_17_c0646 = City._(id: 646, name: 'اسیر', stateId: 17);
final _p_17_c0649 = City._(id: 649, name: 'امام شهر', stateId: 17);
final _p_17_c0651 = City._(id: 651, name: 'آباده طشک', stateId: 17);
final _p_17_c0678 = City._(id: 678, name: 'بوانات', stateId: 17);
final _p_17_c0701 = City._(id: 701, name: 'خاوران', stateId: 17);
final _p_17_c0703 = City._(id: 703, name: 'خنج', stateId: 17);
final _p_17_c0708 = City._(id: 708, name: 'داراب', stateId: 17);
final _p_17_c0710 = City._(id: 710, name: 'دبیران', stateId: 17);
final _p_17_c0719 = City._(id: 719, name: 'دوبرجی', stateId: 17);
final _p_17_c0735 = City._(id: 735, name: 'زاهدشهر', stateId: 17);
final _p_17_c0761 = City._(id: 761, name: 'شهرپیر', stateId: 17);
final _p_17_c0765 = City._(id: 765, name: 'علامرودشت', stateId: 17);
final _p_17_c0767 = City._(id: 767, name: 'فراشبند', stateId: 17);
final _p_17_c0775 = City._(id: 775, name: 'فیروزآباد', stateId: 17);
final _p_17_c0777 = City._(id: 777, name: 'قایمیه', stateId: 17);
final _p_17_c0783 = City._(id: 783, name: 'قیر', stateId: 17);
final _p_17_c0784 = City._(id: 784, name: 'کارزین (فتح آباد)', stateId: 17);
final _p_17_c0797 = City._(id: 797, name: 'کوار', stateId: 17);
final _p_17_c1074 = City._(id: 1074, name: 'مبارک آباددیز', stateId: 17);
final _p_17_c1082 = City._(id: 1082, name: 'مهر', stateId: 17);
final _p_17_c1088 = City._(id: 1088, name: 'میمند', stateId: 17);
final _p_17_c1095 = City._(id: 1095, name: 'نوجین', stateId: 17);
final _p_17_c1097 = City._(id: 1097, name: 'نی ریز', stateId: 17);
final _p_17_c1116 = City._(id: 1116, name: 'داریان', stateId: 17);
final _p_17_c1117 = City._(id: 1117, name: 'لپویی', stateId: 17);
final _p_17_c1118 = City._(id: 1118, name: 'نوبندگان', stateId: 17);
final _p_17_c1119 = City._(id: 1119, name: 'کنارتخته', stateId: 17);
final _p_17_c1120 = City._(id: 1120, name: 'بنارویه', stateId: 17);
final _p_17_c1121 = City._(id: 1121, name: 'جویم', stateId: 17);
final _p_17_c1122 = City._(id: 1122, name: 'لطیفی', stateId: 17);
final _p_17_c1123 = City._(id: 1123, name: 'کامفیروز', stateId: 17);
final _p_17_c1129 = City._(id: 1129, name: 'حاجی آباد', stateId: 17);
final _prov_17 = Province._(id: 17, name: 'فارس', cities: [
  _p_17_c0008,
  _p_17_c0009,
  _p_17_c0010,
  _p_17_c0011,
  _p_17_c0012,
  _p_17_c0013,
  _p_17_c0014,
  _p_17_c0015,
  _p_17_c0016,
  _p_17_c0017,
  _p_17_c0018,
  _p_17_c0019,
  _p_17_c0020,
  _p_17_c0021,
  _p_17_c0022,
  _p_17_c0023,
  _p_17_c0024,
  _p_17_c0025,
  _p_17_c0026,
  _p_17_c0027,
  _p_17_c0028,
  _p_17_c0029,
  _p_17_c0030,
  _p_17_c0031,
  _p_17_c0032,
  _p_17_c0033,
  _p_17_c0034,
  _p_17_c0035,
  _p_17_c0036,
  _p_17_c0037,
  _p_17_c0038,
  _p_17_c0039,
  _p_17_c0040,
  _p_17_c0041,
  _p_17_c0042,
  _p_17_c0043,
  _p_17_c0044,
  _p_17_c0045,
  _p_17_c0046,
  _p_17_c0047,
  _p_17_c0048,
  _p_17_c0049,
  _p_17_c0050,
  _p_17_c0051,
  _p_17_c0052,
  _p_17_c0053,
  _p_17_c0054,
  _p_17_c0055,
  _p_17_c0056,
  _p_17_c0057,
  _p_17_c0058,
  _p_17_c0059,
  _p_17_c0060,
  _p_17_c0061,
  _p_17_c0062,
  _p_17_c0063,
  _p_17_c0064,
  _p_17_c0095,
  _p_17_c0096,
  _p_17_c0636,
  _p_17_c0643,
  _p_17_c0646,
  _p_17_c0649,
  _p_17_c0651,
  _p_17_c0678,
  _p_17_c0701,
  _p_17_c0703,
  _p_17_c0708,
  _p_17_c0710,
  _p_17_c0719,
  _p_17_c0735,
  _p_17_c0761,
  _p_17_c0765,
  _p_17_c0767,
  _p_17_c0775,
  _p_17_c0777,
  _p_17_c0783,
  _p_17_c0784,
  _p_17_c0797,
  _p_17_c1074,
  _p_17_c1082,
  _p_17_c1088,
  _p_17_c1095,
  _p_17_c1097,
  _p_17_c1116,
  _p_17_c1117,
  _p_17_c1118,
  _p_17_c1119,
  _p_17_c1120,
  _p_17_c1121,
  _p_17_c1122,
  _p_17_c1123,
  _p_17_c1129
]);
final _p_18_c0065 = City._(id: 65, name: 'الوند', stateId: 18);
final _p_18_c0066 = City._(id: 66, name: 'بیدستان', stateId: 18);
final _p_18_c0067 = City._(id: 67, name: 'شریفیه', stateId: 18);
final _p_18_c0068 = City._(id: 68, name: 'محمدیه', stateId: 18);
final _p_18_c0069 = City._(id: 69, name: 'آبیک', stateId: 18);
final _p_18_c0070 = City._(id: 70, name: 'ارداق', stateId: 18);
final _p_18_c0071 = City._(id: 71, name: 'آبگرم', stateId: 18);
final _p_18_c0072 = City._(id: 72, name: 'آوج', stateId: 18);
final _p_18_c0073 = City._(id: 73, name: 'بویین زهرا', stateId: 18);
final _p_18_c0074 = City._(id: 74, name: 'دانسفهان', stateId: 18);
final _p_18_c0075 = City._(id: 75, name: 'اسفرورین', stateId: 18);
final _p_18_c0076 = City._(id: 76, name: 'تاکستان', stateId: 18);
final _p_18_c0077 = City._(id: 77, name: 'ضیاءآباد', stateId: 18);
final _p_18_c0078 = City._(id: 78, name: 'سیردان', stateId: 18);
final _p_18_c0079 = City._(id: 79, name: 'قزوین', stateId: 18);
final _p_18_c0080 = City._(id: 80, name: 'کوهین', stateId: 18);
final _p_18_c0081 = City._(id: 81, name: 'معلم کلایه', stateId: 18);
final _p_18_c0097 = City._(id: 97, name: 'خاکعلی', stateId: 18);
final _p_18_c0098 = City._(id: 98, name: 'نرجه', stateId: 18);
final _p_18_c0647 = City._(id: 647, name: 'اقبالیه', stateId: 18);
final _p_18_c0754 = City._(id: 754, name: 'شال', stateId: 18);
final _p_18_c1124 = City._(id: 1124, name: 'خرمدشت', stateId: 18);
final _p_18_c1125 = City._(id: 1125, name: 'رازمیان', stateId: 18);
final _p_18_c1126 = City._(id: 1126, name: 'محمودآبادنمونه', stateId: 18);
final _p_18_c1134 = City._(id: 1134, name: 'سگزآباد', stateId: 18);
final _prov_18 = Province._(id: 18, name: 'قزوین', cities: [
  _p_18_c0065,
  _p_18_c0066,
  _p_18_c0067,
  _p_18_c0068,
  _p_18_c0069,
  _p_18_c0070,
  _p_18_c0071,
  _p_18_c0072,
  _p_18_c0073,
  _p_18_c0074,
  _p_18_c0075,
  _p_18_c0076,
  _p_18_c0077,
  _p_18_c0078,
  _p_18_c0079,
  _p_18_c0080,
  _p_18_c0081,
  _p_18_c0097,
  _p_18_c0098,
  _p_18_c0647,
  _p_18_c0754,
  _p_18_c1124,
  _p_18_c1125,
  _p_18_c1126,
  _p_18_c1134
]);
final _p_19_c0082 = City._(id: 82, name: 'سلفچگان', stateId: 19);
final _p_19_c0083 = City._(id: 83, name: 'قم', stateId: 19);
final _p_19_c0084 = City._(id: 84, name: 'کهک', stateId: 19);
final _p_19_c0099 = City._(id: 99, name: 'قنوات', stateId: 19);
final _p_19_c0681 = City._(id: 681, name: 'جعفریه', stateId: 19);
final _p_19_c0712 = City._(id: 712, name: 'دستجرد', stateId: 19);
final _prov_19 = Province._(id: 19, name: 'قم', cities: [
  _p_19_c0082,
  _p_19_c0083,
  _p_19_c0084,
  _p_19_c0099,
  _p_19_c0681,
  _p_19_c0712
]);
final _p_20_c0085 = City._(id: 85, name: 'بانه', stateId: 20);
final _p_20_c0086 = City._(id: 86, name: 'بویین سفلی', stateId: 20);
final _p_20_c0087 = City._(id: 87, name: 'کانی سور', stateId: 20);
final _p_20_c0088 = City._(id: 88, name: 'یاسوکند', stateId: 20);
final _p_20_c0119 = City._(id: 119, name: 'بلبان آباد', stateId: 20);
final _p_20_c0120 = City._(id: 120, name: 'دهگلان', stateId: 20);
final _p_20_c0121 = City._(id: 121, name: 'زرینه', stateId: 20);
final _p_20_c0122 = City._(id: 122, name: 'سقز', stateId: 20);
final _p_20_c0123 = City._(id: 123, name: 'صاحب', stateId: 20);
final _p_20_c0124 = City._(id: 124, name: 'سنندج', stateId: 20);
final _p_20_c0125 = City._(id: 125, name: 'شویشه', stateId: 20);
final _p_20_c0126 = City._(id: 126, name: 'دلبران', stateId: 20);
final _p_20_c0127 = City._(id: 127, name: 'سریش آباد', stateId: 20);
final _p_20_c0128 = City._(id: 128, name: 'قروه', stateId: 20);
final _p_20_c0129 = City._(id: 129, name: 'موچش', stateId: 20);
final _p_20_c0130 = City._(id: 130, name: 'کانی دینار', stateId: 20);
final _p_20_c0131 = City._(id: 131, name: 'مریوان', stateId: 20);
final _p_20_c0557 = City._(id: 557, name: 'دزج', stateId: 20);
final _p_20_c0656 = City._(id: 656, name: 'آرمرده', stateId: 20);
final _p_20_c0662 = City._(id: 662, name: 'بابارشانی', stateId: 20);
final _p_20_c0679 = City._(id: 679, name: 'بیجار', stateId: 20);
final _p_20_c0693 = City._(id: 693, name: 'چناره', stateId: 20);
final _p_20_c0723 = City._(id: 723, name: 'دیواندره', stateId: 20);
final _p_20_c0749 = City._(id: 749, name: 'سروآباد', stateId: 20);
final _p_20_c0785 = City._(id: 785, name: 'کامیاران', stateId: 20);
final _prov_20 = Province._(id: 20, name: 'کردستان', cities: [
  _p_20_c0085,
  _p_20_c0086,
  _p_20_c0087,
  _p_20_c0088,
  _p_20_c0119,
  _p_20_c0120,
  _p_20_c0121,
  _p_20_c0122,
  _p_20_c0123,
  _p_20_c0124,
  _p_20_c0125,
  _p_20_c0126,
  _p_20_c0127,
  _p_20_c0128,
  _p_20_c0129,
  _p_20_c0130,
  _p_20_c0131,
  _p_20_c0557,
  _p_20_c0656,
  _p_20_c0662,
  _p_20_c0679,
  _p_20_c0693,
  _p_20_c0723,
  _p_20_c0749,
  _p_20_c0785
]);
final _p_21_c0132 = City._(id: 132, name: 'ارزوییه', stateId: 21);
final _p_21_c0133 = City._(id: 133, name: 'امین شهر', stateId: 21);
final _p_21_c0134 = City._(id: 134, name: 'انار', stateId: 21);
final _p_21_c0135 = City._(id: 135, name: 'بافت', stateId: 21);
final _p_21_c0136 = City._(id: 136, name: 'بردسیر', stateId: 21);
final _p_21_c0137 = City._(id: 137, name: 'گلزار', stateId: 21);
final _p_21_c0138 = City._(id: 138, name: 'لاله زار', stateId: 21);
final _p_21_c0139 = City._(id: 139, name: 'نگار', stateId: 21);
final _p_21_c0140 = City._(id: 140, name: 'بروات', stateId: 21);
final _p_21_c0141 = City._(id: 141, name: 'بم', stateId: 21);
final _p_21_c0142 = City._(id: 142, name: 'جیرفت', stateId: 21);
final _p_21_c0143 = City._(id: 143, name: 'درب بهشت', stateId: 21);
final _p_21_c0144 = City._(id: 144, name: 'رابر', stateId: 21);
final _p_21_c0145 = City._(id: 145, name: 'راور', stateId: 21);
final _p_21_c0146 = City._(id: 146, name: 'هجدک', stateId: 21);
final _p_21_c0147 = City._(id: 147, name: 'بهرمان', stateId: 21);
final _p_21_c0148 = City._(id: 148, name: 'رفسنجان', stateId: 21);
final _p_21_c0149 = City._(id: 149, name: 'کشکوییه', stateId: 21);
final _p_21_c0150 = City._(id: 150, name: 'رودبار', stateId: 21);
final _p_21_c0151 = City._(id: 151, name: 'محمدآباد', stateId: 21);
final _p_21_c0152 = City._(id: 152, name: 'خانوک', stateId: 21);
final _p_21_c0153 = City._(id: 153, name: 'ریحان', stateId: 21);
final _p_21_c0154 = City._(id: 154, name: 'زرند', stateId: 21);
final _p_21_c0155 = City._(id: 155, name: 'یزدان شهر', stateId: 21);
final _p_21_c0156 = City._(id: 156, name: 'زیدآباد', stateId: 21);
final _p_21_c0157 = City._(id: 157, name: 'سیرجان', stateId: 21);
final _p_21_c0158 = City._(id: 158, name: 'نجف شهر', stateId: 21);
final _p_21_c0159 = City._(id: 159, name: 'هماشهر', stateId: 21);
final _p_21_c0160 = City._(id: 160, name: 'جوزم', stateId: 21);
final _p_21_c0161 = City._(id: 161, name: 'خاتون آباد', stateId: 21);
final _p_21_c0162 = City._(id: 162, name: 'مردهک', stateId: 21);
final _p_21_c0163 = City._(id: 163, name: 'فاریاب', stateId: 21);
final _p_21_c0164 = City._(id: 164, name: 'قلعه گنج', stateId: 21);
final _p_21_c0165 = City._(id: 165, name: 'اختیارآباد', stateId: 21);
final _p_21_c0166 = City._(id: 166, name: 'اندوهجرد', stateId: 21);
final _p_21_c0167 = City._(id: 167, name: 'راین', stateId: 21);
final _p_21_c0168 = City._(id: 168, name: 'شهداد', stateId: 21);
final _p_21_c0169 = City._(id: 169, name: 'کاظم آباد', stateId: 21);
final _p_21_c0170 = City._(id: 170, name: 'کرمان', stateId: 21);
final _p_21_c0171 = City._(id: 171, name: 'ماهان', stateId: 21);
final _p_21_c0172 = City._(id: 172, name: 'کهنوج', stateId: 21);
final _p_21_c0173 = City._(id: 173, name: 'کوهبنان', stateId: 21);
final _p_21_c0174 = City._(id: 174, name: 'منوجان', stateId: 21);
final _p_21_c0175 = City._(id: 175, name: 'نرماشیر', stateId: 21);
final _p_21_c0538 = City._(id: 538, name: 'پاریز', stateId: 21);
final _p_21_c0552 = City._(id: 552, name: 'جبالبارز', stateId: 21);
final _p_21_c0567 = City._(id: 567, name: 'صفاییه', stateId: 21);
final _p_21_c0570 = City._(id: 570, name: 'عنبرآباد', stateId: 21);
final _p_21_c0597 = City._(id: 597, name: 'نظام شهر', stateId: 21);
final _p_21_c0664 = City._(id: 664, name: 'باغین', stateId: 21);
final _p_21_c0670 = City._(id: 670, name: 'بزنجان', stateId: 21);
final _p_21_c0684 = City._(id: 684, name: 'جوپار', stateId: 21);
final _p_21_c0690 = City._(id: 690, name: 'چترود', stateId: 21);
final _p_21_c0705 = City._(id: 705, name: 'خورسند', stateId: 21);
final _p_21_c0716 = City._(id: 716, name: 'دهج', stateId: 21);
final _p_21_c0721 = City._(id: 721, name: 'دوساری', stateId: 21);
final _p_21_c0760 = City._(id: 760, name: 'شهربابک', stateId: 21);
final _p_21_c0774 = City._(id: 774, name: 'فهرج', stateId: 21);
final _p_21_c0804 = City._(id: 804, name: 'کیانشهر', stateId: 21);
final _p_21_c1080 = City._(id: 1080, name: 'مس سرچشمه', stateId: 21);
final _p_21_c1096 = City._(id: 1096, name: 'نودژ', stateId: 21);
final _p_21_c1131 = City._(id: 1131, name: 'زنگی آباد', stateId: 21);
final _p_21_c1137 = City._(id: 1137, name: 'گلباف', stateId: 21);
final _p_21_c1140 = City._(id: 1140, name: 'محی آباد', stateId: 21);
final _prov_21 = Province._(id: 21, name: 'کرمان', cities: [
  _p_21_c0132,
  _p_21_c0133,
  _p_21_c0134,
  _p_21_c0135,
  _p_21_c0136,
  _p_21_c0137,
  _p_21_c0138,
  _p_21_c0139,
  _p_21_c0140,
  _p_21_c0141,
  _p_21_c0142,
  _p_21_c0143,
  _p_21_c0144,
  _p_21_c0145,
  _p_21_c0146,
  _p_21_c0147,
  _p_21_c0148,
  _p_21_c0149,
  _p_21_c0150,
  _p_21_c0151,
  _p_21_c0152,
  _p_21_c0153,
  _p_21_c0154,
  _p_21_c0155,
  _p_21_c0156,
  _p_21_c0157,
  _p_21_c0158,
  _p_21_c0159,
  _p_21_c0160,
  _p_21_c0161,
  _p_21_c0162,
  _p_21_c0163,
  _p_21_c0164,
  _p_21_c0165,
  _p_21_c0166,
  _p_21_c0167,
  _p_21_c0168,
  _p_21_c0169,
  _p_21_c0170,
  _p_21_c0171,
  _p_21_c0172,
  _p_21_c0173,
  _p_21_c0174,
  _p_21_c0175,
  _p_21_c0538,
  _p_21_c0552,
  _p_21_c0567,
  _p_21_c0570,
  _p_21_c0597,
  _p_21_c0664,
  _p_21_c0670,
  _p_21_c0684,
  _p_21_c0690,
  _p_21_c0705,
  _p_21_c0716,
  _p_21_c0721,
  _p_21_c0760,
  _p_21_c0774,
  _p_21_c0804,
  _p_21_c1080,
  _p_21_c1096,
  _p_21_c1131,
  _p_21_c1137,
  _p_21_c1140
]);
final _p_22_c0100 = City._(id: 100, name: 'ازگله', stateId: 22);
final _p_22_c0101 = City._(id: 101, name: 'قصرشیرین', stateId: 22);
final _p_22_c0176 = City._(id: 176, name: 'اسلام آبادغرب', stateId: 22);
final _p_22_c0177 = City._(id: 177, name: 'پاوه', stateId: 22);
final _p_22_c0178 = City._(id: 178, name: 'نودشه', stateId: 22);
final _p_22_c0179 = City._(id: 179, name: 'نوسود', stateId: 22);
final _p_22_c0180 = City._(id: 180, name: 'تازه آباد', stateId: 22);
final _p_22_c0181 = City._(id: 181, name: 'جوانرود', stateId: 22);
final _p_22_c0182 = City._(id: 182, name: 'گهواره', stateId: 22);
final _p_22_c0183 = City._(id: 183, name: 'شاهو', stateId: 22);
final _p_22_c0184 = City._(id: 184, name: 'سرپل ذهاب', stateId: 22);
final _p_22_c0185 = City._(id: 185, name: 'سطر', stateId: 22);
final _p_22_c0186 = City._(id: 186, name: 'سنقر', stateId: 22);
final _p_22_c0187 = City._(id: 187, name: 'صحنه', stateId: 22);
final _p_22_c0188 = City._(id: 188, name: 'کرمانشاه', stateId: 22);
final _p_22_c0189 = City._(id: 189, name: 'سرمست', stateId: 22);
final _p_22_c0190 = City._(id: 190, name: 'بیستون', stateId: 22);
final _p_22_c0191 = City._(id: 191, name: 'هرسین', stateId: 22);
final _p_22_c0560 = City._(id: 560, name: 'سومار', stateId: 22);
final _p_22_c0581 = City._(id: 581, name: 'گیلانغرب', stateId: 22);
final _p_22_c0666 = City._(id: 666, name: 'باینگان', stateId: 22);
final _p_22_c0698 = City._(id: 698, name: 'حمیل', stateId: 22);
final _p_22_c0728 = City._(id: 728, name: 'رباط', stateId: 22);
final _p_22_c0733 = City._(id: 733, name: 'روانسر', stateId: 22);
final _p_22_c0788 = City._(id: 788, name: 'کرند', stateId: 22);
final _p_22_c0796 = City._(id: 796, name: 'کنگاور', stateId: 22);
final _p_22_c0798 = City._(id: 798, name: 'کوزران', stateId: 22);
final _p_22_c1086 = City._(id: 1086, name: 'میان راهان', stateId: 22);
final _p_22_c1106 = City._(id: 1106, name: 'هلشی', stateId: 22);
final _prov_22 = Province._(id: 22, name: 'کرمانشاه', cities: [
  _p_22_c0100,
  _p_22_c0101,
  _p_22_c0176,
  _p_22_c0177,
  _p_22_c0178,
  _p_22_c0179,
  _p_22_c0180,
  _p_22_c0181,
  _p_22_c0182,
  _p_22_c0183,
  _p_22_c0184,
  _p_22_c0185,
  _p_22_c0186,
  _p_22_c0187,
  _p_22_c0188,
  _p_22_c0189,
  _p_22_c0190,
  _p_22_c0191,
  _p_22_c0560,
  _p_22_c0581,
  _p_22_c0666,
  _p_22_c0698,
  _p_22_c0728,
  _p_22_c0733,
  _p_22_c0788,
  _p_22_c0796,
  _p_22_c0798,
  _p_22_c1086,
  _p_22_c1106
]);
final _p_23_c0102 = City._(id: 102, name: 'پاتاوه', stateId: 23);
final _p_23_c0192 = City._(id: 192, name: 'باشت', stateId: 23);
final _p_23_c0193 = City._(id: 193, name: 'لیکک', stateId: 23);
final _p_23_c0194 = City._(id: 194, name: 'گراب سفلی', stateId: 23);
final _p_23_c0195 = City._(id: 195, name: 'مادوان', stateId: 23);
final _p_23_c0196 = City._(id: 196, name: 'یاسوج', stateId: 23);
final _p_23_c0197 = City._(id: 197, name: 'چرام', stateId: 23);
final _p_23_c0198 = City._(id: 198, name: 'چیتاب', stateId: 23);
final _p_23_c0199 = City._(id: 199, name: 'سی سخت', stateId: 23);
final _p_23_c0200 = City._(id: 200, name: 'دیشموک', stateId: 23);
final _p_23_c0201 = City._(id: 201, name: 'سوق', stateId: 23);
final _p_23_c0202 = City._(id: 202, name: 'دوگنبدان', stateId: 23);
final _p_23_c0586 = City._(id: 586, name: 'لنده', stateId: 23);
final _p_23_c0589 = City._(id: 589, name: 'مارگون', stateId: 23);
final _p_23_c0717 = City._(id: 717, name: 'دهدشت', stateId: 23);
final _p_23_c0782 = City._(id: 782, name: 'قلعه رییسی', stateId: 23);
final _prov_23 = Province._(id: 23, name: 'کهگیلویه وبویراحمد', cities: [
  _p_23_c0102,
  _p_23_c0192,
  _p_23_c0193,
  _p_23_c0194,
  _p_23_c0195,
  _p_23_c0196,
  _p_23_c0197,
  _p_23_c0198,
  _p_23_c0199,
  _p_23_c0200,
  _p_23_c0201,
  _p_23_c0202,
  _p_23_c0586,
  _p_23_c0589,
  _p_23_c0717,
  _p_23_c0782
]);
final _p_24_c0103 = City._(id: 103, name: 'نوده خاندوز', stateId: 24);
final _p_24_c0203 = City._(id: 203, name: 'آزادشهر', stateId: 24);
final _p_24_c0204 = City._(id: 204, name: 'نگین شهر', stateId: 24);
final _p_24_c0205 = City._(id: 205, name: 'انبارآلوم', stateId: 24);
final _p_24_c0206 = City._(id: 206, name: 'بندرترکمن', stateId: 24);
final _p_24_c0207 = City._(id: 207, name: 'خان ببین', stateId: 24);
final _p_24_c0208 = City._(id: 208, name: 'دلند', stateId: 24);
final _p_24_c0209 = City._(id: 209, name: 'رامیان', stateId: 24);
final _p_24_c0210 = City._(id: 210, name: 'علی آباد', stateId: 24);
final _p_24_c0211 = City._(id: 211, name: 'فاضل آباد', stateId: 24);
final _p_24_c0212 = City._(id: 212, name: 'کردکوی', stateId: 24);
final _p_24_c0213 = City._(id: 213, name: 'کلاله', stateId: 24);
final _p_24_c0214 = City._(id: 214, name: 'گالیکش', stateId: 24);
final _p_24_c0215 = City._(id: 215, name: 'جلین', stateId: 24);
final _p_24_c0216 = City._(id: 216, name: 'گرگان', stateId: 24);
final _p_24_c0217 = City._(id: 217, name: 'سیمین شهر', stateId: 24);
final _p_24_c0218 = City._(id: 218, name: 'اینچه برون', stateId: 24);
final _p_24_c0219 = City._(id: 219, name: 'گنبدکاووس', stateId: 24);
final _p_24_c0220 = City._(id: 220, name: 'مراوه', stateId: 24);
final _p_24_c0221 = City._(id: 221, name: 'مینودشت', stateId: 24);
final _p_24_c0577 = City._(id: 577, name: 'گمیش تپه', stateId: 24);
final _p_24_c0603 = City._(id: 603, name: 'نوکنده', stateId: 24);
final _p_24_c0658 = City._(id: 658, name: 'آق قلا', stateId: 24);
final _p_24_c0676 = City._(id: 676, name: 'بندرگز', stateId: 24);
final _p_24_c0746 = City._(id: 746, name: 'سرخنکلاته', stateId: 24);
final _prov_24 = Province._(id: 24, name: 'گلستان', cities: [
  _p_24_c0103,
  _p_24_c0203,
  _p_24_c0204,
  _p_24_c0205,
  _p_24_c0206,
  _p_24_c0207,
  _p_24_c0208,
  _p_24_c0209,
  _p_24_c0210,
  _p_24_c0211,
  _p_24_c0212,
  _p_24_c0213,
  _p_24_c0214,
  _p_24_c0215,
  _p_24_c0216,
  _p_24_c0217,
  _p_24_c0218,
  _p_24_c0219,
  _p_24_c0220,
  _p_24_c0221,
  _p_24_c0577,
  _p_24_c0603,
  _p_24_c0658,
  _p_24_c0676,
  _p_24_c0746
]);
final _p_25_c0222 = City._(id: 222, name: 'املش', stateId: 25);
final _p_25_c0223 = City._(id: 223, name: 'آستارا', stateId: 25);
final _p_25_c0224 = City._(id: 224, name: 'لوندویل', stateId: 25);
final _p_25_c0225 = City._(id: 225, name: 'آستانه اشرفیه', stateId: 25);
final _p_25_c0226 = City._(id: 226, name: 'بندرانزلی', stateId: 25);
final _p_25_c0227 = City._(id: 227, name: 'تالش', stateId: 25);
final _p_25_c0228 = City._(id: 228, name: 'حویق', stateId: 25);
final _p_25_c0229 = City._(id: 229, name: 'لیسار', stateId: 25);
final _p_25_c0230 = City._(id: 230, name: 'خشکبیجار', stateId: 25);
final _p_25_c0231 = City._(id: 231, name: 'خمام', stateId: 25);
final _p_25_c0232 = City._(id: 232, name: 'رشت', stateId: 25);
final _p_25_c0233 = City._(id: 233, name: 'سنگر', stateId: 25);
final _p_25_c0234 = City._(id: 234, name: 'کوچصفهان', stateId: 25);
final _p_25_c0235 = City._(id: 235, name: 'لشت نشا', stateId: 25);
final _p_25_c0236 = City._(id: 236, name: 'پره سر', stateId: 25);
final _p_25_c0237 = City._(id: 237, name: 'بره سر', stateId: 25);
final _p_25_c0238 = City._(id: 238, name: 'رودبار', stateId: 25);
final _p_25_c0239 = City._(id: 239, name: 'لوشان', stateId: 25);
final _p_25_c0240 = City._(id: 240, name: 'منجیل', stateId: 25);
final _p_25_c0241 = City._(id: 241, name: 'چابکسر', stateId: 25);
final _p_25_c0242 = City._(id: 242, name: 'رحیم آباد', stateId: 25);
final _p_25_c0243 = City._(id: 243, name: 'رودسر', stateId: 25);
final _p_25_c0244 = City._(id: 244, name: 'دیلمان', stateId: 25);
final _p_25_c0245 = City._(id: 245, name: 'سیاهکل', stateId: 25);
final _p_25_c0246 = City._(id: 246, name: 'احمدسرگوراب', stateId: 25);
final _p_25_c0247 = City._(id: 247, name: 'شفت', stateId: 25);
final _p_25_c0248 = City._(id: 248, name: 'صومعه سرا', stateId: 25);
final _p_25_c0249 = City._(id: 249, name: 'گوراب زرمیخ', stateId: 25);
final _p_25_c0250 = City._(id: 250, name: 'فومن', stateId: 25);
final _p_25_c0251 = City._(id: 251, name: 'ماسوله', stateId: 25);
final _p_25_c0252 = City._(id: 252, name: 'رودبنه', stateId: 25);
final _p_25_c0253 = City._(id: 253, name: 'لاهیجان', stateId: 25);
final _p_25_c0254 = City._(id: 254, name: 'چاف و چمخاله', stateId: 25);
final _p_25_c0255 = City._(id: 255, name: 'لنگرود', stateId: 25);
final _p_25_c0256 = City._(id: 256, name: 'بازارجمعه', stateId: 25);
final _p_25_c0530 = City._(id: 530, name: 'اسالم', stateId: 25);
final _p_25_c0546 = City._(id: 546, name: 'توتکابن', stateId: 25);
final _p_25_c0588 = City._(id: 588, name: 'لولمان', stateId: 25);
final _p_25_c0590 = City._(id: 590, name: 'ماسال', stateId: 25);
final _p_25_c0613 = City._(id: 613, name: 'کیاشهر', stateId: 25);
final _p_25_c0614 = City._(id: 614, name: 'کلاچای', stateId: 25);
final _p_25_c0615 = City._(id: 615, name: 'کومله', stateId: 25);
final _p_25_c0633 = City._(id: 633, name: 'شلمان', stateId: 25);
final _p_25_c0687 = City._(id: 687, name: 'جیرنده', stateId: 25);
final _p_25_c0727 = City._(id: 727, name: 'رانکوه', stateId: 25);
final _p_25_c0729 = City._(id: 729, name: 'رستم آباد', stateId: 25);
final _p_25_c0731 = City._(id: 731, name: 'رضوانشهر', stateId: 25);
final _p_25_c1079 = City._(id: 1079, name: 'مرجقل', stateId: 25);
final _p_25_c1108 = City._(id: 1108, name: 'واجارگاه', stateId: 25);
final _p_25_c1127 = City._(id: 1127, name: 'اطاقور', stateId: 25);
final _p_25_c1128 = City._(id: 1128, name: 'چوبر', stateId: 25);
final _p_25_c1142 = City._(id: 1142, name: 'هشتپر', stateId: 25);
final _prov_25 = Province._(id: 25, name: 'گیلان', cities: [
  _p_25_c0222,
  _p_25_c0223,
  _p_25_c0224,
  _p_25_c0225,
  _p_25_c0226,
  _p_25_c0227,
  _p_25_c0228,
  _p_25_c0229,
  _p_25_c0230,
  _p_25_c0231,
  _p_25_c0232,
  _p_25_c0233,
  _p_25_c0234,
  _p_25_c0235,
  _p_25_c0236,
  _p_25_c0237,
  _p_25_c0238,
  _p_25_c0239,
  _p_25_c0240,
  _p_25_c0241,
  _p_25_c0242,
  _p_25_c0243,
  _p_25_c0244,
  _p_25_c0245,
  _p_25_c0246,
  _p_25_c0247,
  _p_25_c0248,
  _p_25_c0249,
  _p_25_c0250,
  _p_25_c0251,
  _p_25_c0252,
  _p_25_c0253,
  _p_25_c0254,
  _p_25_c0255,
  _p_25_c0256,
  _p_25_c0530,
  _p_25_c0546,
  _p_25_c0588,
  _p_25_c0590,
  _p_25_c0613,
  _p_25_c0614,
  _p_25_c0615,
  _p_25_c0633,
  _p_25_c0687,
  _p_25_c0727,
  _p_25_c0729,
  _p_25_c0731,
  _p_25_c1079,
  _p_25_c1108,
  _p_25_c1127,
  _p_25_c1128,
  _p_25_c1142
]);
final _p_26_c0257 = City._(id: 257, name: 'ازنا', stateId: 26);
final _p_26_c0258 = City._(id: 258, name: 'مومن آباد', stateId: 26);
final _p_26_c0259 = City._(id: 259, name: 'اشترینان', stateId: 26);
final _p_26_c0260 = City._(id: 260, name: 'بروجرد', stateId: 26);
final _p_26_c0261 = City._(id: 261, name: 'چغلوندی', stateId: 26);
final _p_26_c0262 = City._(id: 262, name: 'خرم آباد', stateId: 26);
final _p_26_c0263 = City._(id: 263, name: 'نورآباد', stateId: 26);
final _p_26_c0264 = City._(id: 264, name: 'هفت چشمه', stateId: 26);
final _p_26_c0265 = City._(id: 265, name: 'سراب دوره', stateId: 26);
final _p_26_c0266 = City._(id: 266, name: 'ویسیان', stateId: 26);
final _p_26_c0267 = City._(id: 267, name: 'دورود', stateId: 26);
final _p_26_c0268 = City._(id: 268, name: 'الشتر', stateId: 26);
final _p_26_c0269 = City._(id: 269, name: 'فیروزآباد', stateId: 26);
final _p_26_c0270 = City._(id: 270, name: 'چقابل', stateId: 26);
final _p_26_c0271 = City._(id: 271, name: 'کوهدشت', stateId: 26);
final _p_26_c0539 = City._(id: 539, name: 'پلدختر', stateId: 26);
final _p_26_c0558 = City._(id: 558, name: 'زاغه', stateId: 26);
final _p_26_c0593 = City._(id: 593, name: 'معمولان', stateId: 26);
final _p_26_c0634 = City._(id: 634, name: 'الیگودرز', stateId: 26);
final _p_26_c0689 = City._(id: 689, name: 'چالانچولان', stateId: 26);
final _p_26_c0711 = City._(id: 711, name: 'درب گنبد', stateId: 26);
final _p_26_c0742 = City._(id: 742, name: 'سپیددشت', stateId: 26);
final _p_26_c0763 = City._(id: 763, name: 'شول آباد', stateId: 26);
final _p_26_c0802 = City._(id: 802, name: 'کونانی', stateId: 26);
final _p_26_c0805 = City._(id: 805, name: 'گراب', stateId: 26);
final _prov_26 = Province._(id: 26, name: 'لرستان', cities: [
  _p_26_c0257,
  _p_26_c0258,
  _p_26_c0259,
  _p_26_c0260,
  _p_26_c0261,
  _p_26_c0262,
  _p_26_c0263,
  _p_26_c0264,
  _p_26_c0265,
  _p_26_c0266,
  _p_26_c0267,
  _p_26_c0268,
  _p_26_c0269,
  _p_26_c0270,
  _p_26_c0271,
  _p_26_c0539,
  _p_26_c0558,
  _p_26_c0593,
  _p_26_c0634,
  _p_26_c0689,
  _p_26_c0711,
  _p_26_c0742,
  _p_26_c0763,
  _p_26_c0802,
  _p_26_c0805
]);
final _p_27_c0104 = City._(id: 104, name: 'گتاب', stateId: 27);
final _p_27_c0105 = City._(id: 105, name: 'نشتارود', stateId: 27);
final _p_27_c0106 = City._(id: 106, name: 'سورک', stateId: 27);
final _p_27_c0272 = City._(id: 272, name: 'آمل', stateId: 27);
final _p_27_c0273 = City._(id: 273, name: 'دابودشت', stateId: 27);
final _p_27_c0274 = City._(id: 274, name: 'رینه', stateId: 27);
final _p_27_c0275 = City._(id: 275, name: 'گزنک', stateId: 27);
final _p_27_c0276 = City._(id: 276, name: 'امیرکلا', stateId: 27);
final _p_27_c0277 = City._(id: 277, name: 'بابل', stateId: 27);
final _p_27_c0278 = City._(id: 278, name: 'زرگرمحله', stateId: 27);
final _p_27_c0279 = City._(id: 279, name: 'مرزیکلا', stateId: 27);
final _p_27_c0280 = City._(id: 280, name: 'بابلسر', stateId: 27);
final _p_27_c0281 = City._(id: 281, name: 'کله بست', stateId: 27);
final _p_27_c0282 = City._(id: 282, name: 'بهشهر', stateId: 27);
final _p_27_c0283 = City._(id: 283, name: 'رستمکلا', stateId: 27);
final _p_27_c0284 = City._(id: 284, name: 'خرم آباد', stateId: 27);
final _p_27_c0285 = City._(id: 285, name: 'شیرود', stateId: 27);
final _p_27_c0286 = City._(id: 286, name: 'کوهی خیل', stateId: 27);
final _p_27_c0287 = City._(id: 287, name: 'چالوس', stateId: 27);
final _p_27_c0288 = City._(id: 288, name: 'کلاردشت', stateId: 27);
final _p_27_c0289 = City._(id: 289, name: 'مرزن آباد', stateId: 27);
final _p_27_c0290 = City._(id: 290, name: 'کتالم وسادات شهر', stateId: 27);
final _p_27_c0291 = City._(id: 291, name: 'کیاسر', stateId: 27);
final _p_27_c0292 = City._(id: 292, name: 'پل سفید', stateId: 27);
final _p_27_c0293 = City._(id: 293, name: 'شیرگاه', stateId: 27);
final _p_27_c0294 = City._(id: 294, name: 'فریدونکنار', stateId: 27);
final _p_27_c0295 = City._(id: 295, name: 'کیاکلا', stateId: 27);
final _p_27_c0296 = City._(id: 296, name: 'سرخرود', stateId: 27);
final _p_27_c0297 = City._(id: 297, name: 'نکا', stateId: 27);
final _p_27_c0298 = City._(id: 298, name: 'بلده', stateId: 27);
final _p_27_c0299 = City._(id: 299, name: 'چمستان', stateId: 27);
final _p_27_c0300 = City._(id: 300, name: 'رویان', stateId: 27);
final _p_27_c0301 = City._(id: 301, name: 'نور', stateId: 27);
final _p_27_c0302 = City._(id: 302, name: 'پول', stateId: 27);
final _p_27_c0303 = City._(id: 303, name: 'نوشهر', stateId: 27);
final _p_27_c0532 = City._(id: 532, name: 'ایزدشهر', stateId: 27);
final _p_27_c0536 = City._(id: 536, name: 'بهنمیر', stateId: 27);
final _p_27_c0554 = City._(id: 554, name: 'خلیل شهر', stateId: 27);
final _p_27_c0605 = City._(id: 605, name: 'جویبار', stateId: 27);
final _p_27_c0606 = City._(id: 606, name: 'رامسر', stateId: 27);
final _p_27_c0607 = City._(id: 607, name: 'ساری', stateId: 27);
final _p_27_c0608 = City._(id: 608, name: 'عباس آباد', stateId: 27);
final _p_27_c0609 = City._(id: 609, name: 'قائم شهر', stateId: 27);
final _p_27_c0610 = City._(id: 610, name: 'محمودآباد', stateId: 27);
final _p_27_c0616 = City._(id: 616, name: 'تنکابن', stateId: 27);
final _p_27_c0617 = City._(id: 617, name: 'سلمان شهر', stateId: 27);
final _p_27_c0639 = City._(id: 639, name: 'گلوگاه', stateId: 27);
final _p_27_c0659 = City._(id: 659, name: 'آلاشت', stateId: 27);
final _p_27_c0707 = City._(id: 707, name: 'خوش رودپی', stateId: 27);
final _p_27_c0772 = City._(id: 772, name: 'فریم', stateId: 27);
final _p_27_c0791 = City._(id: 791, name: 'کلارآباد', stateId: 27);
final _p_27_c1133 = City._(id: 1133, name: 'زیرآب', stateId: 27);
final _prov_27 = Province._(id: 27, name: 'مازندران', cities: [
  _p_27_c0104,
  _p_27_c0105,
  _p_27_c0106,
  _p_27_c0272,
  _p_27_c0273,
  _p_27_c0274,
  _p_27_c0275,
  _p_27_c0276,
  _p_27_c0277,
  _p_27_c0278,
  _p_27_c0279,
  _p_27_c0280,
  _p_27_c0281,
  _p_27_c0282,
  _p_27_c0283,
  _p_27_c0284,
  _p_27_c0285,
  _p_27_c0286,
  _p_27_c0287,
  _p_27_c0288,
  _p_27_c0289,
  _p_27_c0290,
  _p_27_c0291,
  _p_27_c0292,
  _p_27_c0293,
  _p_27_c0294,
  _p_27_c0295,
  _p_27_c0296,
  _p_27_c0297,
  _p_27_c0298,
  _p_27_c0299,
  _p_27_c0300,
  _p_27_c0301,
  _p_27_c0302,
  _p_27_c0303,
  _p_27_c0532,
  _p_27_c0536,
  _p_27_c0554,
  _p_27_c0605,
  _p_27_c0606,
  _p_27_c0607,
  _p_27_c0608,
  _p_27_c0609,
  _p_27_c0610,
  _p_27_c0616,
  _p_27_c0617,
  _p_27_c0639,
  _p_27_c0659,
  _p_27_c0707,
  _p_27_c0772,
  _p_27_c0791,
  _p_27_c1133
]);
final _p_28_c0107 = City._(id: 107, name: 'تفرش', stateId: 28);
final _p_28_c0304 = City._(id: 304, name: 'داودآباد', stateId: 28);
final _p_28_c0305 = City._(id: 305, name: 'ساروق', stateId: 28);
final _p_28_c0306 = City._(id: 306, name: 'سنجان', stateId: 28);
final _p_28_c0307 = City._(id: 307, name: 'کارچان', stateId: 28);
final _p_28_c0308 = City._(id: 308, name: 'کرهرود', stateId: 28);
final _p_28_c0309 = City._(id: 309, name: 'آشتیان', stateId: 28);
final _p_28_c0310 = City._(id: 310, name: 'جاورسیان', stateId: 28);
final _p_28_c0311 = City._(id: 311, name: 'خنداب', stateId: 28);
final _p_28_c0312 = City._(id: 312, name: 'پرندک/رود شور', stateId: 28);
final _p_28_c0313 = City._(id: 313, name: 'خشکرود', stateId: 28);
final _p_28_c0314 = City._(id: 314, name: 'رازقان', stateId: 28);
final _p_28_c0315 = City._(id: 315, name: 'زاویه', stateId: 28);
final _p_28_c0316 = City._(id: 316, name: 'مامونیه', stateId: 28);
final _p_28_c0317 = City._(id: 317, name: 'ساوه', stateId: 28);
final _p_28_c0318 = City._(id: 318, name: 'نوبران', stateId: 28);
final _p_28_c0319 = City._(id: 319, name: 'آستانه سربند', stateId: 28);
final _p_28_c0320 = City._(id: 320, name: 'مهاجران', stateId: 28);
final _p_28_c0321 = City._(id: 321, name: 'هندودر', stateId: 28);
final _p_28_c0322 = City._(id: 322, name: 'خنجین', stateId: 28);
final _p_28_c0323 = City._(id: 323, name: 'کمیجان', stateId: 28);
final _p_28_c0324 = City._(id: 324, name: 'میلاجرد', stateId: 28);
final _p_28_c0325 = City._(id: 325, name: 'نیمور', stateId: 28);
final _p_28_c0548 = City._(id: 548, name: 'توره', stateId: 28);
final _p_28_c0566 = City._(id: 566, name: 'شازند', stateId: 28);
final _p_28_c0571 = City._(id: 571, name: 'غرق آباد', stateId: 28);
final _p_28_c0576 = City._(id: 576, name: 'قورچی باشی', stateId: 28);
final _p_28_c0611 = City._(id: 611, name: 'اراک', stateId: 28);
final _p_28_c0612 = City._(id: 612, name: 'دلیجان', stateId: 28);
final _p_28_c0629 = City._(id: 629, name: 'خمین', stateId: 28);
final _p_28_c0759 = City._(id: 759, name: 'شهباز', stateId: 28);
final _p_28_c0769 = City._(id: 769, name: 'فرمهین', stateId: 28);
final _p_28_c1075 = City._(id: 1075, name: 'محلات', stateId: 28);
final _p_28_c1094 = City._(id: 1094, name: 'نراق', stateId: 28);
final _prov_28 = Province._(id: 28, name: 'مرکزی', cities: [
  _p_28_c0107,
  _p_28_c0304,
  _p_28_c0305,
  _p_28_c0306,
  _p_28_c0307,
  _p_28_c0308,
  _p_28_c0309,
  _p_28_c0310,
  _p_28_c0311,
  _p_28_c0312,
  _p_28_c0313,
  _p_28_c0314,
  _p_28_c0315,
  _p_28_c0316,
  _p_28_c0317,
  _p_28_c0318,
  _p_28_c0319,
  _p_28_c0320,
  _p_28_c0321,
  _p_28_c0322,
  _p_28_c0323,
  _p_28_c0324,
  _p_28_c0325,
  _p_28_c0548,
  _p_28_c0566,
  _p_28_c0571,
  _p_28_c0576,
  _p_28_c0611,
  _p_28_c0612,
  _p_28_c0629,
  _p_28_c0759,
  _p_28_c0769,
  _p_28_c1075,
  _p_28_c1094
]);
final _p_29_c0326 = City._(id: 326, name: 'جناح', stateId: 29);
final _p_29_c0327 = City._(id: 327, name: 'سردشت', stateId: 29);
final _p_29_c0328 = City._(id: 328, name: 'بندرعباس', stateId: 29);
final _p_29_c0329 = City._(id: 329, name: 'فین', stateId: 29);
final _p_29_c0330 = City._(id: 330, name: 'قلعه قاضی', stateId: 29);
final _p_29_c0331 = City._(id: 331, name: 'بندرلنگه', stateId: 29);
final _p_29_c0332 = City._(id: 332, name: 'کیش', stateId: 29);
final _p_29_c0333 = City._(id: 333, name: 'بندرجاسک', stateId: 29);
final _p_29_c0334 = City._(id: 334, name: 'فارغان', stateId: 29);
final _p_29_c0335 = City._(id: 335, name: 'خمیر', stateId: 29);
final _p_29_c0336 = City._(id: 336, name: 'رویدر', stateId: 29);
final _p_29_c0337 = City._(id: 337, name: 'دهبارز', stateId: 29);
final _p_29_c0338 = City._(id: 338, name: 'زیارتعلی', stateId: 29);
final _p_29_c0339 = City._(id: 339, name: 'درگهان', stateId: 29);
final _p_29_c0340 = City._(id: 340, name: 'سوزا', stateId: 29);
final _p_29_c0341 = City._(id: 341, name: 'قشم', stateId: 29);
final _p_29_c0342 = City._(id: 342, name: 'سندرک', stateId: 29);
final _p_29_c0343 = City._(id: 343, name: 'میناب', stateId: 29);
final _p_29_c0537 = City._(id: 537, name: 'پارسیان', stateId: 29);
final _p_29_c0543 = City._(id: 543, name: 'تخت', stateId: 29);
final _p_29_c0562 = City._(id: 562, name: 'سیریک', stateId: 29);
final _p_29_c0580 = City._(id: 580, name: 'گوهران', stateId: 29);
final _p_29_c0630 = City._(id: 630, name: 'بستک', stateId: 29);
final _p_29_c0642 = City._(id: 642, name: 'ابوموسی', stateId: 29);
final _p_29_c0680 = City._(id: 680, name: 'بیکا', stateId: 29);
final _p_29_c0688 = City._(id: 688, name: 'چارک', stateId: 29);
final _p_29_c0695 = City._(id: 695, name: 'حاجی آباد', stateId: 29);
final _p_29_c0748 = City._(id: 748, name: 'سرگز', stateId: 29);
final _p_29_c0795 = City._(id: 795, name: 'کنگ', stateId: 29);
final _p_29_c0801 = City._(id: 801, name: 'کوشکنار', stateId: 29);
final _p_29_c1102 = City._(id: 1102, name: 'هرمز', stateId: 29);
final _p_29_c1103 = City._(id: 1103, name: 'هشتبندی', stateId: 29);
final _prov_29 = Province._(id: 29, name: 'هرمزگان', cities: [
  _p_29_c0326,
  _p_29_c0327,
  _p_29_c0328,
  _p_29_c0329,
  _p_29_c0330,
  _p_29_c0331,
  _p_29_c0332,
  _p_29_c0333,
  _p_29_c0334,
  _p_29_c0335,
  _p_29_c0336,
  _p_29_c0337,
  _p_29_c0338,
  _p_29_c0339,
  _p_29_c0340,
  _p_29_c0341,
  _p_29_c0342,
  _p_29_c0343,
  _p_29_c0537,
  _p_29_c0543,
  _p_29_c0562,
  _p_29_c0580,
  _p_29_c0630,
  _p_29_c0642,
  _p_29_c0680,
  _p_29_c0688,
  _p_29_c0695,
  _p_29_c0748,
  _p_29_c0795,
  _p_29_c0801,
  _p_29_c1102,
  _p_29_c1103
]);
final _p_30_c0344 = City._(id: 344, name: 'بهار', stateId: 30);
final _p_30_c0345 = City._(id: 345, name: 'صالح آباد', stateId: 30);
final _p_30_c0346 = City._(id: 346, name: 'سرکان', stateId: 30);
final _p_30_c0347 = City._(id: 347, name: 'فرسفج', stateId: 30);
final _p_30_c0348 = City._(id: 348, name: 'رزن', stateId: 30);
final _p_30_c0349 = City._(id: 349, name: 'فامنین', stateId: 30);
final _p_30_c0350 = City._(id: 350, name: 'شیرین سو', stateId: 30);
final _p_30_c0351 = City._(id: 351, name: 'گل تپه', stateId: 30);
final _p_30_c0352 = City._(id: 352, name: 'ازندریان', stateId: 30);
final _p_30_c0353 = City._(id: 353, name: 'جوکار', stateId: 30);
final _p_30_c0354 = City._(id: 354, name: 'زنگنه', stateId: 30);
final _p_30_c0355 = City._(id: 355, name: 'برزول', stateId: 30);
final _p_30_c0356 = City._(id: 356, name: 'فیروزان', stateId: 30);
final _p_30_c0357 = City._(id: 357, name: 'گیان', stateId: 30);
final _p_30_c0358 = City._(id: 358, name: 'جورقان', stateId: 30);
final _p_30_c0359 = City._(id: 359, name: 'مریانج', stateId: 30);
final _p_30_c0360 = City._(id: 360, name: 'همدان', stateId: 30);
final _p_30_c0549 = City._(id: 549, name: 'تویسرکان', stateId: 30);
final _p_30_c0574 = City._(id: 574, name: 'قهاوند', stateId: 30);
final _p_30_c0582 = City._(id: 582, name: 'لالجین', stateId: 30);
final _p_30_c0595 = City._(id: 595, name: 'ملایر', stateId: 30);
final _p_30_c0601 = City._(id: 601, name: 'نهاوند', stateId: 30);
final _p_30_c0645 = City._(id: 645, name: 'اسدآباد', stateId: 30);
final _p_30_c0715 = City._(id: 715, name: 'دمق', stateId: 30);
final _p_30_c0741 = City._(id: 741, name: 'سامن', stateId: 30);
final _p_30_c0780 = City._(id: 780, name: 'قروه درجزین', stateId: 30);
final _p_30_c0786 = City._(id: 786, name: 'کبودرآهنگ', stateId: 30);
final _prov_30 = Province._(id: 30, name: 'همدان', cities: [
  _p_30_c0344,
  _p_30_c0345,
  _p_30_c0346,
  _p_30_c0347,
  _p_30_c0348,
  _p_30_c0349,
  _p_30_c0350,
  _p_30_c0351,
  _p_30_c0352,
  _p_30_c0353,
  _p_30_c0354,
  _p_30_c0355,
  _p_30_c0356,
  _p_30_c0357,
  _p_30_c0358,
  _p_30_c0359,
  _p_30_c0360,
  _p_30_c0549,
  _p_30_c0574,
  _p_30_c0582,
  _p_30_c0595,
  _p_30_c0601,
  _p_30_c0645,
  _p_30_c0715,
  _p_30_c0741,
  _p_30_c0780,
  _p_30_c0786
]);
final _p_31_c0361 = City._(id: 361, name: 'احمدآباد', stateId: 31);
final _p_31_c0362 = City._(id: 362, name: 'اردکان', stateId: 31);
final _p_31_c0363 = City._(id: 363, name: 'عقدا', stateId: 31);
final _p_31_c0364 = City._(id: 364, name: 'بافق', stateId: 31);
final _p_31_c0365 = City._(id: 365, name: 'بهاباد', stateId: 31);
final _p_31_c0366 = City._(id: 366, name: 'تفت', stateId: 31);
final _p_31_c0367 = City._(id: 367, name: 'مروست', stateId: 31);
final _p_31_c0368 = City._(id: 368, name: 'هرات', stateId: 31);
final _p_31_c0369 = City._(id: 369, name: 'اشکذر', stateId: 31);
final _p_31_c0370 = City._(id: 370, name: 'دیهوک', stateId: 31);
final _p_31_c0372 = City._(id: 372, name: 'عشق آباد', stateId: 31);
final _p_31_c0373 = City._(id: 373, name: 'مهریز', stateId: 31);
final _p_31_c0374 = City._(id: 374, name: 'میبد', stateId: 31);
final _p_31_c0375 = City._(id: 375, name: 'حمیدیا', stateId: 31);
final _p_31_c0376 = City._(id: 376, name: 'زارچ', stateId: 31);
final _p_31_c0377 = City._(id: 377, name: 'شاهدیه', stateId: 31);
final _p_31_c0378 = City._(id: 378, name: 'یزد', stateId: 31);
final _p_31_c0553 = City._(id: 553, name: 'خضرآباد', stateId: 31);
final _p_31_c0631 = City._(id: 631, name: 'ابرکوه', stateId: 31);
final _p_31_c0672 = City._(id: 672, name: 'بفروییه', stateId: 31);
final _p_31_c1084 = City._(id: 1084, name: 'مهردشت', stateId: 31);
final _p_31_c1093 = City._(id: 1093, name: 'ندوشن', stateId: 31);
final _p_31_c1099 = City._(id: 1099, name: 'نیر', stateId: 31);
final _prov_31 = Province._(id: 31, name: 'یزد', cities: [
  _p_31_c0361,
  _p_31_c0362,
  _p_31_c0363,
  _p_31_c0364,
  _p_31_c0365,
  _p_31_c0366,
  _p_31_c0367,
  _p_31_c0368,
  _p_31_c0369,
  _p_31_c0370,
  _p_31_c0372,
  _p_31_c0373,
  _p_31_c0374,
  _p_31_c0375,
  _p_31_c0376,
  _p_31_c0377,
  _p_31_c0378,
  _p_31_c0553,
  _p_31_c0631,
  _p_31_c0672,
  _p_31_c1084,
  _p_31_c1093,
  _p_31_c1099
]);
final provinces = [
  _prov_01,
  _prov_02,
  _prov_03,
  _prov_04,
  _prov_05,
  _prov_06,
  _prov_07,
  _prov_08,
  _prov_09,
  _prov_10,
  _prov_11,
  _prov_12,
  _prov_13,
  _prov_14,
  _prov_15,
  _prov_16,
  _prov_17,
  _prov_18,
  _prov_19,
  _prov_20,
  _prov_21,
  _prov_22,
  _prov_23,
  _prov_24,
  _prov_25,
  _prov_26,
  _prov_27,
  _prov_28,
  _prov_29,
  _prov_30,
  _prov_31
];
