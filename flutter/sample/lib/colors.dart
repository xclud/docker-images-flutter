import 'package:flutter/material.dart';

const MaterialColor primaryColor = MaterialColor(0xFF6C55A4, {
  50: Color(0xFFF0E9F6),
  100: Color(0xFFE2DDED),
  200: Color(0xFFC4BBDB),
  300: Color(0xFFA799C8),
  400: Color(0xFF8977B6),
  500: Color(0xFF6C55A4),
  600: Color(0xFF51407B),
  700: Color(0xFF362B52),
  800: Color(0xFF1B1529),
  900: Color(0xFF000000),
});

const MaterialColor accentColor = MaterialColor(0xFF2FBC9E, {
  50: Color(0xFF8BD9C9),
  100: Color(0xFF8BD9C9),
  200: Color(0xFF74D2BE),
  300: Color(0xFF5DCAB3),
  400: Color(0xFF46C3A8),
  500: Color(0xFF2FBC9E),
  600: Color(0xFF29A78C),
  700: Color(0xFF24927A),
  800: Color(0xFF1F7D69),
  900: Color(0xFF1A6857),
});

const MaterialColor ternaryColor = MaterialColor(0xFFFA9600, {
  50: Color(0xFFFCC471),
  100: Color(0xFFFCC471),
  200: Color(0xFFFBB955),
  300: Color(0xFFFBAD38),
  400: Color(0xFFFAA11C),
  500: Color(0xFFFA9600),
  600: Color(0xFFDE8500),
  700: Color(0xFFC27400),
  800: Color(0xFFA66400),
  900: Color(0xFF8A5300),
});

const MaterialColor greyColor = MaterialColor(0xFFF1F1F1, {
  50: Color(0xFFFAFAFA), //Scaffold/Page Background.
  100: Color(0xFFF8F8F8),
  200: Color(0xFFF6F6F6),
  300: Color(0xFFF5F5F5),
  400: Color(0xFFF3F3F3),
  500: Color(0xFFF1F1F1),
  600: Color(0xFFF0F0F0), // Input Background.
  700: Color(0xFFD5D5D5),
  800: Color(0xFFBABABA),
  900: Color(0xFFA0A0A0), // Placeholder.
});

final theme = ThemeData(
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(
      color: primaryColor,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(),
    isDense: true,
    hintStyle: TextStyle(color: Colors.grey.shade400),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.transparent,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  snackBarTheme: SnackBarThemeData(
    contentTextStyle: TextStyle(fontFamily: 'Shabnam'),
    actionTextColor: Colors.white,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: accentColor,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: accentColor,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  fontFamily: 'Shabnam',
  primarySwatch: primaryColor,
  accentColor: accentColor,
);

const Color rightel_inactive = Color(0xFFF4E4EF);
const Color rightel_active = Color(0xFFDEAED0);
const Color rightel_card = Color(0xFF9C0E74);
const Color rightel_text = Color(0xFF9C0E74);

const Color irancell_inactive = Color(0xFFFFF1C6);
const Color irancell_active = Color(0xFFFFE693);
const Color irancell_card = Color(0xFFFECB2E);
const Color irancell_text = Color(0xFF0C688F);

const Color mci_inactive = Color(0xFFD8F2F3);
const Color mci_active = Color(0xFF9EDEE2);
const Color mci_card = Color(0xFF52C5CC);
const Color mci_text = Color(0xFFFF7F00);

Color red = Color(0xFFFF1744);

TextStyle boldStyle(BuildContext context) {
  return Theme.of(context)
      .textTheme
      .bodyText1
      .copyWith(fontSize: 14, fontWeight: FontWeight.bold);
}

TextStyle keypadStyle(BuildContext context) {
  return Theme.of(context)
      .textTheme
      .bodyText1
      .copyWith(fontSize: 20, fontWeight: FontWeight.bold,color: primaryColor);
}

TextStyle regularStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14);
}

TextStyle tabStyle(BuildContext context) {
  return Theme.of(context)
      .textTheme
      .button
      .copyWith(fontSize: 12, fontWeight: FontWeight.bold);
}

TextStyle bodyStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 12);
}
