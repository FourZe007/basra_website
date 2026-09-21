import 'package:flutter/material.dart';

class GlobalFontFamily {
  static String fontCeraGR = 'Poppins';
  static String fontCourier = 'Poppins';
  static String fontRubik = 'Poppins';
  static String fontMontserrat = 'Poppins';
  static String fontPoppins = 'Poppins';
}

class GlobalSize {
  static double mediumfont = 12;
  static double mediumbigfont = 14;
  static double bigfont = 16;
  static double mediumgiantfont = 18;
  static double giantfont = 20;
  static double mediumgigafont1 = 24;
  static double mediumgigafont2 = 26;
  static double gigafont = 28;
  static double terafont = 30;
  static double petafont = 32;
  static double titleMenuFont1 = 32;
  static double titleMenuFont2 = 36;
  static double dateFont1 = 40;
  static double dateFont2 = 45;
}

class GlobalFont {
  // Courier
  static TextStyle mediumfontC = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumfontCWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle bigfontC = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontCBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontCWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontCWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumgiantfontCBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgiantfontCWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontCBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontCWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontCBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleLoginFontW2Bold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontCourier,
    fontSize: GlobalSize.titleMenuFont1,
    fontWeight: FontWeight.bold,
  );

  // Montserrat
  static TextStyle mediumfontM = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumbigfontMBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumbigfontMbuttonRedBoldItalic = TextStyle(
    color: Colors.red[700],
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  );

  static TextStyle mediumbigfontM = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumbigfontMWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumbigfontMWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumbigfontMItalic = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumbigfont,
    fontStyle: FontStyle.italic,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontMBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontMWhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontM = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumgiantfontM = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontMBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontM = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.giantfont,
  );

  static TextStyle giantfontMBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontCMhiteBold = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontMBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontMBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gigafontMBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontMontserrat,
    fontSize: GlobalSize.gigafont,
    fontWeight: FontWeight.bold,
  );

  // Rubik
  static TextStyle smallfontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: 11,
  );

  static TextStyle smallfontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumfontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
  );

  static TextStyle mediumfontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.w600,
  );

  static TextStyle mediumbigfontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumbigfontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
  );

  static TextStyle mediumbigfontRBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
  );

  static TextStyle mediumbigfontRUnderlinedBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    decoration: TextDecoration.underline,
  );

  static TextStyle mediumbigfontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
  );

  // bigfontRBlue
  static TextStyle mediumbigfontRBoldBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumbigfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
  );

  static TextStyle mediumBigfontRTextButtonBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumbigfont,
    backgroundColor: Colors.transparent,
    decoration: TextDecoration.underline,
  );

  static TextStyle bigfontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontRWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontRBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
  );

  static TextStyle bigfontRUnderlinedBlue = TextStyle(
    color: Colors.blue,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    backgroundColor: Colors.transparent,
    decoration: TextDecoration.underline,
  );

  static TextStyle bigfontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.bigfont,
    fontWeight: FontWeight.bold,
    backgroundColor: Colors.transparent,
  );

  static TextStyle mediumgiantfontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRYellow = TextStyle(
    color: Colors.yellow,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRGrey = TextStyle(
    color: Colors.grey,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
  );

  static TextStyle mediumgiantfontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgiantfontRBoldBlue = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgiantfontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgiantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
  );

  static TextStyle giantfontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontRBoldRed = TextStyle(
    color: Colors.red,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle giantfontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.giantfont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle datefont1 = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.dateFont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgigafont1,
  );

  static TextStyle mediumgigafontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle mediumgigafontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.mediumgigafont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gigafontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.gigafont,
  );

  static TextStyle gigafontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.gigafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle gigafontRBoldWhite = TextStyle(
    color: Colors.white,
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.gigafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle terafontR = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.terafont,
  );

  static TextStyle terafontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.terafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle petafontRBold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.petafont,
    fontWeight: FontWeight.bold,
  );

  static TextStyle titleLoginFontR2Bold = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.titleMenuFont1,
    fontWeight: FontWeight.bold,
  );

  static TextStyle datefont2 = TextStyle(
    color: const Color(0xFF0F172A),
    fontFamily: GlobalFontFamily.fontRubik,
    fontSize: GlobalSize.dateFont2,
    fontWeight: FontWeight.bold,
  );
}
